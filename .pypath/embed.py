#!/usr/bin/env python

import sys
import re


def embed_region_by_placeholders(begin_placeholder, end_placeholder, into_content, embed_content):
    regex = re.compile((r'(?<=%s\n)' % begin_placeholder) +
                       r'(.*)' +
                       (r'(?=\n%s)' % end_placeholder), re.DOTALL)

    output_content = regex.sub(embed_content, into_content)

    return output_content


def main():
    try:
        begin_placeholder = sys.argv[1]
        end_placeholder = sys.argv[2]
        embed_into_filename = sys.argv[3]
    except IndexError as index_error:
        print(index_error)
        print('Usage:')
        print('    python -m extract begin_placeholder end_placeholder embed_into_filename [content_filename]')
        print('If no filename provided content will be extracted from standard input.')
        sys.exit(1)
    try:
        with open(embed_into_filename, 'r') as embed_into_file:
            into_content = embed_into_file.read()
    except IOError as io_error:
        print(io_error)
        sys.exit(1)
    try:
        input_filename = sys.argv[4]
        with open(input_filename, 'r') as input_file:
            embed_content = input_file.read()
    except IndexError:
        embed_content = ''.join(sys.stdin.readlines())
    except IOError as io_error:
        print(io_error)
        sys.exit(1)
    print(embed_region_by_placeholders(begin_placeholder, end_placeholder, into_content, embed_content))

if __name__ == "__main__":
    main()
