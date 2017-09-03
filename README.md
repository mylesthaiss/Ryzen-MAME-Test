# Ryzen-MAME-Test
A simple script that is aimed to reproduce GCC segfaults under Linux by compiling MAME.

# Features
- Looped compiles of MAME.
- Logs dates for start and completed compiles
- Dumps 'free' and 'sensors' outputs onto log file after each successful or failed build.

# Usage
Default run with maximum threads in use:

> ./RyzenTestMAME.sh

Use only 4 threads:

> ./RyzenTestMAME.sh 4

# Requirements
* Software dependices such as build-essentials, GCC and SDL2 devlopment headers are required to compile MAME.
* unzip and wget is required for downloading and extracting MAME sources.
* lm_sensors with it87 module is an optional requirement for temperture and voltage logs.
