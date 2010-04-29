#!/usr/bin/env python

'''
Watch for changes in all .py files. If changes, run nosetests. 
'''

# By Gary Bernhardt, http://extracheese.org
# Based on original nosy.py by Jeff Winkler, http://jeffwinkler.net


import sys, glob, os, stat, time
import subprocess
import re


FILE_REGEX = re.compile(r'(py|txt|html|rb|feature|README)$')
STAT_INTERVAL = .25 # seconds
CRAWL_INTERVAL = 10 # seconds


class Crawler:
    def __init__(self):
        self.last_crawl = 0
        self.filenames = []

    def crawl(self):
        # Only crawl if enough time has passed since the last crawl
        if time.time() - self.last_crawl < CRAWL_INTERVAL:
            return self.filenames

        self.last_crawl = time.time()

        # Build a list of all directories that are children of this one
        paths = ['.']
        for dirpath, _, filenames in os.walk('.'):
            paths += [os.path.join(dirpath, filename)
                      for filename in filenames]

        # Return all files in one of those directories that match the regex
        filenames = set([path
                         for path in paths
                         if re.search(FILE_REGEX, path)])
        self.filenames = filenames
        return self.filenames

    def checksum(self):
        """
        Return a dictionary that represents the current state of this
        directory
        """
        def stat_string(path):
            stat = os.stat(path)
            return '%s,%s' % (str(stat.st_size), str(stat.st_mtime))

        return dict((path, stat_string(path))
                    for path in self.crawl()
                    if os.path.exists(path))


iterations = 0


def print_changes(changed_paths):
    global iterations
    iterations += 1

    print
    print
    print
    print '----- Iteration', iterations, '(%s)' % time.ctime()

    if changed_paths:
        print '      Changes:', ', '.join(sorted(changed_paths))


def change_generator():
    yield []
    crawler = Crawler()
    old_checksum = crawler.checksum()

    while True:
        time.sleep(STAT_INTERVAL)
        new_checksum = crawler.checksum()

        if new_checksum != old_checksum:
            # Wait and recaculate the checksum, so if multiple files are being
            # written we get them all in one iteration
            time.sleep(0.2)
            new_checksum = crawler.checksum()

            old_keys = set(old_checksum.keys())
            new_keys = set(new_checksum.keys())
            common_keys = old_keys.intersection(new_keys)

            # Add any files that exist in only one checksum
            changes = old_keys.symmetric_difference(new_keys)
            # Add any files that exist in both but changed
            changes.update([key for key in common_keys
                            if new_checksum[key] != old_checksum[key]])

            old_checksum = new_checksum
            yield changes


def main():
    old_checksum = None

    for changed_paths in change_generator():
        print_changes(changed_paths)
        os.system(' '.join(sys.argv[1:]))

if __name__ == '__main__':
    main()

