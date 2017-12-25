# This file is a part of pybash project.
# Copyright (c) 2017 Aleksander Gajewski <adiog@brainfuck.pl>.

import json
import os
import re
import shutil
import subprocess
import sys
from pathlib import Path
from bs4 import BeautifulSoup
import requests


class BashText(object):
    def __init__(self, text=None, lines=None):
        if lines:
            self.lines = lines
        elif text:
            self.lines = text.split('\n')
        else:
            self.lines = []

    def append(self, lines):
        self.lines = self.lines + lines

    def empty(self):
        return self.lines == []

    def show(self):
        for line in self.lines:
            print(line)

    def save(self, filepath, append=False):
        if append:
            flag = 'a'
        else:
            flag = 'w'
        with open(filepath, flag) as f:
            for line in self.lines:
                f.write(line)

    def tee(self, filepath, append=False):
        self.save(filepath, append)
        return self

    def head(self, n=10):
        return BashText(lines=self.lines[:n])

    def tail(self, n=10):
        return BashText(lines=self.lines[-n:])

    def each(self, foo, *args, **kwargs):
        [foo(line, *args, **kwargs) for line in self.lines]
        return self

    def map(self, foo, *args, **kwargs):
        return BashText(lines=[foo(line, *args, **kwargs) for line in self.lines])

    def filter(self, foo, *args, **kwargs):
        return BashText(lines=[line for line in self.lines if foo(line, *args, **kwargs)])

    def cut(self, *args, **kwargs):
        return self.map(cut, *args, **kwargs)

    def sed(self, *args, **kwargs):
        return self.map(sed, *args, **kwargs)

    def sub(self, *args, **kwargs):
        return self.map(sub, *args, **kwargs)

    def strip(self, *args, **kwargs):
        return self.map(strip, *args, **kwargs)

    def strip_front(self, *args, **kwargs):
        return self.map(strip_front, *args, **kwargs)

    def strip_back(self, *args, **kwargs):
        return self.map(strip_back, *args, **kwargs)

    def grep(self, pattern):
        return BashText(lines=grep(self.lines, pattern))

    def vgrep(self, pattern):
        return BashText(lines=vgrep(self.lines, pattern))

    def egrep(self, pattern):
        return BashText(lines=egrep(self.lines, pattern))

    def calculate_range_index(self, n, r, s, d):
        if r:
            n = [i for (i,line) in enumerate(self.lines) if re.search(re.compile(r),line)][0] + 1

        if n is None:
            n = d

        if s:
            n += s

        return n

    def range(self, nbegin=None, rbegin=None, sbegin=None, nend=None, rend=None, send=None):
        """
        Returns inclusive lines range [nbegin, nend] starting from 1.
        Returns inclusive lines range matching regex [rbegin, rend] (with additional shift [sbegin, send]).
        """
        return BashText(lines=self.lines[(self.calculate_range_index(nbegin, rbegin, sbegin, 1) - 1) :
                                         (self.calculate_range_index(nend, rend, send, len(self.lines)))])


def pwd():
    return os.getcwd()


def cd(directory):
    os.chdir(directory)


def cp(source, target):
    shutil.copy(source, target)


def mv(source, target):
    shutil.move(source, target)


def mkdir(path):
    os.makedirs(path, exist_ok=True)


def ln(source, target):
    os.symlink(source, target)


def do_find_recursive(directory):
    for root, dirs, files in os.walk(directory):
        for basename in files + dirs:
            filename = os.path.join(root, basename)
            yield filename


def is_path_matching(path, type, name, exts):
    if exts:
        if not any([re.match(re.compile(f'.*\.{ext}'), path) for ext in exts]):
            return False

    if name:
        if not re.match(name, path):
            return False

    if type:
        if type == 'f' and not os.path.isfile(path):
            return False
        if type == 'd' and not os.path.isdir(path):
            return False
        if type == 'l' and not os.path.islink(path):
            return False

    return True


def find(directory=None, type=None, name=None, ext=None, exts=None):
    if not directory:
        directory = pwd()

    if ext:
        exts = [ext]

    return [path for path in do_find_recursive(directory) if is_path_matching(path, type, name, exts)]


def ls(directory=None, type=None, name=None, ext=None, exts=None):
    if not directory:
        directory = pwd()

    if ext:
        exts = [ext]

    return [path for path in os.listdir(directory) if is_path_matching(path, type, name, exts)]


def realpath(filename):
    return os.path.realpath(filename)


def basename(filename):
    return os.path.basename(filename)


def touch(filename):
    Path(filename).touch()


def cat(*args):
    result = BashText()
    for arg in args:
        if type(arg) == str:
            with open(arg, 'r') as f:
                result.append(f.read().split('\n'))
        else:
            result.append(arg.lines)
    return result


def echo(text):
    return BashText(text=text)


def cut_post(index, field, post):
    if index in post:
        return post[index](field)
    else:
        return field


def cut(line, field=None, fields=None, delimeter=None, joiner='', post=None):
    if post is None:
        post = {}

    split_line = line.split(delimeter)

    if field is None:
        if fields is None:
            fields = range(1, 1 + len(split_line))
    else:
        fields = [field]

    return joiner.join([cut_post(field, split_line[field-1], post) for field in fields])


def sed(line, expression=''):
    return subprocess.check_output('echo -n "{line}" | sed -e "{expression}"', shell=True)


def sub(line, re_from, re_to):
    return re.sub(re_from, re_to, line)


def grep(lines, pattern):
    return [line for line in lines if pattern in line]


def vgrep(lines, pattern):
    return [line for line in lines if pattern not in line]


def egrep(lines, pattern):
    return [line for line in lines if re.search(pattern, line)]


def bash(line):
    return subprocess.check_output(line, shell=True)


def strip(line, pattern):
    return re.sub(pattern, '', line)


def strip_front(line, pattern=''):
    return re.sub(re.compile(f'^\s*{pattern}'), '', line)


def strip_back(line, pattern=''):
    return re.sub(re.compile(f'{pattern}\s*$'), '', line)


def wrap(word, wrapper):
    if wrapper == '{':
        return '{' + word + '}'
    elif wrapper == '(':
        return '(' + word + ')'
    elif wrapper == '[':
        return '[' + word + ']'
    elif wrapper == '"':
        return '"' + word + '"'
    elif wrapper == '\'':
        return '\'' + word + '\''
    elif wrapper == '<':
        return '<' + word + '>'


def unwrap(word):
    return word[1:-1]


class HTML(object):
    @classmethod
    def picker(cls, url, selector):
        response = requests.get(url)
        html_content = response.text
        soup_document = BeautifulSoup(html_content, 'html.parser')
        return soup_document.select(selector)

    @classmethod
    def extract(cls, url, selector, attrs):
        lines = []
        for node in cls.picker(url, selector):
            line = {}
            if attrs:
                for attr in attrs:
                    if attr == 'text':
                        line['text'] = node.text
                    else:
                        try:
                            line[attr] = node[attr]
                        except KeyError:
                            line[attr] = None
            line['node'] = node
            lines.append(line)
        return lines

    def __init__(self, url, selector, attrs):
        self.elements = self.extract(url, selector, attrs)

    def map(self, foo, *args, **kwargs):
        self.elements = [foo(element, *args, **kwargs) for element in self.elements]
        return self

    def filter(self, foo, *args, **kwargs):
        self.elements = [element for element in self.elements if foo(element, *args, **kwargs) ]
        return self

    def each(self, foo, *args, **kwargs):
        [foo(element, *args, **kwargs) for element in self.elements]
        return self

    def file(self):
        return BashText(lines=[str(element) for element in self.elements])


def JSON(path=None, url=None):
    if path:
        with open(path, 'r') as f:
            return json.load(f)
    if url:
        return json.loads(requests.get(url=url).text)

