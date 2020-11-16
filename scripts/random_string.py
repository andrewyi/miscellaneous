#!/usr/bin/env python3
'''
generate random str
no seed provided, use system time
'''

import re
import sys
import random
import string


source_str_map = {
        'u': string.ascii_uppercase,
        'l': string.ascii_lowercase,
        'n': string.digits,
        }


def help(code=-1):
    print('usage: ./tool.py (token|pay|key)')
    print('or:    ./tool.py /[uln]+/ ${length}')
    sys.exit(code)


def _make_str(src_str, length):
    return ''.join(tuple(random.choice(src_str) for _ in range(length)))


def make_token():
    src_str = string.ascii_lowercase + string.digits
    return _make_str(src_str, 32)


def make_pay_secret():
    src_str = string.ascii_lowercase + string.digits
    return _make_str(src_str, 32)


def make_key():
    src_str = string.ascii_uppercase + string.ascii_lowercase + string.digits
    return _make_str(src_str, 43)


def make_random_str_with_options(action, length):
    source_str = ''.join(tuple(source_str_map[k] for k in set(action)))
    return _make_str(source_str, length)


if __name__ == '__main__':

    if len(sys.argv) <= 1:
        help()

    action = sys.argv[1]

    if action == 'token':
        print(make_token())

    elif action == 'pay':
        print(make_pay_secret())

    elif action == 'key':
        print(make_key())

    else:
        if re.match('^[uln]+$', action) is None:
            help()
        try:
            length = int(sys.argv[2])
        except:
            help()

        print(make_random_str_with_options(action, length))
