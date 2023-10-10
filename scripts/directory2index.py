#!/usr/bin/env python3

import sys

def main():
    for line in sys.stdin:
        dirname = line.rstrip().lstrip()
        title = dirname.replace('-', ' ')
        sys.stdout.write(f'### [{title}]')
        sys.stdout.write(f'({dirname}/index.html)')
        sys.stdout.write('\n')

if __name__=='__main__':
    main()
