#!/usr/bin/env python3

import sys
import re

def main():
    for i, line in enumerate(sys.stdin):
        filename = line.rstrip().lstrip()
        (rawtitle,) = re.search(r'^(.+)\..*$', filename).groups()
        title = rawtitle.replace('-', ' ')
        sys.stdout.write(f'### [{i+1}. {title}]')
        sys.stdout.write(f'({re.sub(r'\..*$', '.html', filename)})')
        sys.stdout.write('\n')

if __name__=='__main__':
    main()
