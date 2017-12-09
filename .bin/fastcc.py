#!/usr/bin/python3

import os
from re import search
from fileinput import input

stl = {
    'algorithm': ['max', 'min', 'sort'],
    'numeric': ['accumulate'],
    'array': ['array'],
    'bitset': ['bitset'],
    'iostream': ['cin', 'cout'],
    'map': ['map'],
    'memory': ['make_shared', 'make_unique', 'shared_ptr', 'unique_ptr'],
    'queue': ['queue', 'priority_queue'],
    'stack': ['stack'],
    'utility': ['move', 'pair'],
    'vector': ['vector'],
    'regex': ['regex'],
    'set': ['set'],
    'unordered_set': ['unordered_set'],
}

cinvector = """
template <typename T>
istream &operator>>(istream &is, vector<T> &v) {
    for (auto &e : v) {
        is >> e;
    }
    return is;
}"""

cinarray = """
template <typename T>
istream &operator>>(istream &is, array<T> &a) {
    for (auto &e : a) {
        is >> e;
    }
    return is;
}"""

if __name__ == '__main__':
    content = ''
    for line in input():
        content = content + line
    use_stl = {}
    for lib in stl:
        use_lib = False
        for keyword in stl[lib]:
            if search(keyword, content):
                use_lib = True
                break
        if use_lib:
            print("#include <{}>".format(lib))
        use_stl[lib] = use_lib
    print("using namespace std;")
    if use_stl['iostream'] and use_stl['vector']:
        print(cinvector)
    if use_stl['iostream'] and use_stl['array']:
        print(cinarray)
    print("int main() {")
    print(content)
    print("return 0;")
    print("}")

