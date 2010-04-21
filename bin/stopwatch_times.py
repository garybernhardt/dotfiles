#!/usr/bin/env python

import pickle


stopwatch_dict = pickle.load(file('.nose-stopwatch-times'))
tests = stopwatch_dict.items()
sorted_tests = sorted(tests, key=lambda (name, time): -time)
for name, time in sorted_tests:
    print "%.3fs: %s" % (time, name)

