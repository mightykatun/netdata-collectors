# Netdata-collectors
Collectors for netdata agent

Add the .charts.d files in `/usr/libexec/netdata/charts.d/` then enable them in `/etc/netdata/charts.d.conf` by adding a `sensor_name = yes` at the bottom of the file.

The example provided is a collector mitigating the buggyness of `lm-sensors` which returned temperatures of over 100 degrees Celsius. It uses native command `landscape-syinfo` as well as `nvidia-smi` to monitor actual temperatures directly.
