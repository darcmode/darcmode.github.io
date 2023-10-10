#!/usr/bin/env python3

import sys
import re

def main():
    for line in sys.stdin:
        dirname = line.rstrip().lstrip()
        (rawtitle,) = re.search(r'^.*\/([^\/]+)\/?$', dirname).groups()
        title = rawtitle.replace('-', ' ')
        sys.stdout.write(title)
        sys.stdout.write('\n')

if __name__=='__main__':
    main()
