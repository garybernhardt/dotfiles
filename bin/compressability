#!/usr/bin/env python

import sys
import zlib
import bz2


def file_data():
    path = sys.argv[1]
    return file(path, 'rb').read()


def percent(part, whole):
    return int(100.0 * part / whole)


def main():
    data = file_data()
    size = len(data)
    print 'file size', size
    gzip_size = len(zlib.compress(data))
    print 'gzip size %i (%i%%)' % (gzip_size, percent(gzip_size, size))
    bz2_size = len(bz2.compress(data))
    print 'bz2 size %i (%i%%)' % (bz2_size, percent(bz2_size, size))

if __name__ == '__main__':
    main()

