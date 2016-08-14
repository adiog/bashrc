#!/usr/bin/env python

import sys
import re


def extract_region_by_placeholders(begin_placeholder, end_placeholder, input):
    content_before_begin_placeholder_regex = re.compile(
        '(.*)' + ('(%s\n)' % begin_placeholder), re.DOTALL)

    content_after_end_placeholder_regex = re.compile(
        ('(\n[^\n]*%s)' % end_placeholder) + '(.*)', re.DOTALL)

    begin_extracted_output_content = content_before_begin_placeholder_regex.sub('', input)
    output_content = content_after_end_placeholder_regex.sub('', begin_extracted_output_content)

    return output_content


def main():
    try:
        begin_placeholder = sys.argv[1]
        end_placeholder = sys.argv[2]
    except IndexError as index_error:
        print(index_error)
        print('Usage:')
        print('    python -m extract begin_placeholder end_placeholder [filename]')
        print('If no filename provided content will be extracted from standard input.')
        sys.exit(1)
    try:
        input_filename = sys.argv[3]
        with open(input_filename, 'r') as input_file:
            input_content = input_file.read()
    except IOError as io_error:
        print(io_error)
        sys.exit(1)
    except IndexError:
        input_content = ''.join(sys.stdin.readlines())
    print(extract_region_by_placeholders(begin_placeholder, end_placeholder, input_content))


if __name__ == "__main__":
    main()
