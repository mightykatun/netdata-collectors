# shellcheck shell=bash
# no need for shebang - this file is loaded from charts.d.plugin
# SPDX-License-Identifier: GPL-3.0-or-later

# temperature
# real-time temperature monitoring
# (C) 2024 Your Name <your.email@example.com>
#

# if this chart is called temperature.chart.sh, then all functions and global variables
# must start with temperature_

# _update_every is a special variable - it holds the number of seconds
# between the calls of the _update() function
temperature_update_every=5

# the priority is used to sort the charts on the dashboard
# 1 = the first chart
temperature_priority=70000

# global variables to store our collected data
# remember: they need to start with the module name temperature_
temperature_cpu_temp=
temperature_gpu_temp=

temperature_get() {
  # do all the work to collect / calculate the values
  # for each dimension
  #
  # Remember:
  # 1. KEEP IT SIMPLE AND SHORT
  # 2. AVOID FORKS (avoid piping commands)
  # 3. AVOID CALLING TOO MANY EXTERNAL PROGRAMS
  # 4. USE LOCAL VARIABLES (global variables may overlap with other modules)

  temperature_cpu_temp=$(landscape-sysinfo | grep Temperature | awk '{print $2}')
  temperature_gpu_temp=$(nvidia-smi --query-gpu=temperature.gpu --format=csv,noheader)

  # Check if values were successfully retrieved
  if [[ -z "$temperature_cpu_temp" || -z "$temperature_gpu_temp" ]]; then
    return 1
  fi

  return 0
}

# _check is called once, to find out if this chart should be enabled or not
temperature_check() {
  # this should return:
  #  - 0 to enable the chart
  #  - 1 to disable the chart

  # check that we can collect data
  temperature_get || return 1

  return 0
}

# _create is called once, to create the charts
temperature_create() {
  # create the chart with 2 dimensions
  cat << EOF
CHART temperature.all '' "Temperature" "Celsius" "temperature" "Temperature" line $((temperature_priority)) $temperature_update_every '' '' 'temperature'
DIMENSION cpu_temp '' absolute 1 1
DIMENSION gpu_temp '' absolute 1 1
EOF

  return 0
}

# _update is called continuously, to collect the values
temperature_update() {
  # the first argument to this function is the microseconds since last update
  # pass this parameter to the BEGIN statement (see below).

  temperature_get || return 1

  # write the result of the work.
  cat << VALUESEOF
BEGIN temperature.all $1
SET cpu_temp = $temperature_cpu_temp
SET gpu_temp = $temperature_gpu_temp
END
VALUESEOF

  return 0
}

