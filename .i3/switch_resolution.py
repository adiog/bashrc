import subprocess
import json
import sys
import os

config_file_name = "/home/adiog/.i3/monitor.cfg"
available_rosolutions = ["1920x1080", "2560x1440", "3840x2160"]

def min_res(lhs, rhs):
    if lhs < rhs:
        return lhs
    else:
        return rhs

def max_res(lhs, rhs):
    if lhs < rhs:
        return rhs
    else:
        return lhs

def next_res(res):
    return available_rosolutions[(available_rosolutions.index(res) + 1) % len(available_rosolutions)]

def prev_res(res):
    return available_rosolutions[(available_rosolutions.index(res) + len(available_rosolutions) - 1) % len(available_rosolutions)]

default_config = {
 "HDMI-1": "1920x1080",
 "DVI-D-1": "1920x1080"
}


L = "DVI-D-1"
R = "HDMI-1"

try:
    with open(config_file_name, "r") as config_file:
        config = json.load(config_file)
except:
    config = default_config

def update_config(config, foo):
    if config[L] == config[R]:
        config[L] = foo(config[L])
        config[R] = foo(config[R])
    elif config[L] < config[R]:
        config[L] = foo(config[L])
    else:
        config[R] = foo(config[R])


if sys.argv[1] == 'up':
    update_config(config, next_res)
elif sys.argv[1] == 'down':
    update_config(config, prev_res)
elif sys.argv[1] == 'left':
        config[L] = next_res(config[L])
elif sys.argv[1] == 'right':
        config[R] = next_res(config[R])

is_left_connected = (int(os.system(f'xrandr | grep "{L} connected"')) == 0)
is_right_connected = (int(os.system(f'xrandr | grep "{R} connected"')) == 0)

command = f'xrandr '
if is_left_connected:
    command += f'--output {L} --mode {config[L]} '
if is_right_connected:
    command += f'--output {R} --mode {config[R]} '
if is_left_connected and is_left_connected:
    command += f'--right-of {L}'

print(command)

with open(config_file_name, "w") as config_file:
    json.dump(config, config_file)

subprocess.check_output(command.split())

