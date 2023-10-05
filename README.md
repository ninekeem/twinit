# twinit
Init scripts for teeworlds servers

## Capabilities
+ Generate configs
  - ec
  - sv
  - mod_command
  - access_level
+ Generate votes
  - ads
  - misc
  - scorelimits
  - spectator_slots
  - maps
+ Regenerate config from scratch, rewrite some values, append new
  
You can see default environment values in Dockerfile

## How to use this scripts
### Building container image
` docker build -t twinit . `

### Executing
#### With docker
+ `touch autoexec.cfg `
+ `docker run -e SV_PORT=8303 -e SV_REGISTER=1 -e SV_NAME='My Teeworlds Server' -v "$(pwd)/autoexec.cfg:/config`
+ If you need to change config path, pass `-e CONFIG_PATH` and change docker volumes if needed:
  - `docker run ... -e CONFIG_PATH='/config/autoexec.cfg' -v "$(pwd)"/config:/config`
  - `docker run ... -e CONFIG_PATH='/config/cfg' -v "$(pwd)"/config/cfg`
+ Place config in your server directory or pass in docker as volume

#### Without docker
+ Just pass all needed environment variables to `init.sh`, including `CONFIG_PATH`
  - `SV_PORT=8303 SV_REGISTER=1 SV_NAME='My Teeworlds Server' CONFIG_PATH='./autoexec.cfg' ./init.sh`
+ Place config in your server directory or pass in docker as volume

#### With Kubernetes
+ Works as `initContainer`
  - Not sure it works with `Job` or `CronJob`, try on your own risk
+ Works with `ConfigMap`
  - Not sure it works with `Secret`, but you can try to use `Secret` as environment variables
+ Works with `emptyDir` as volume

### Warnings and limitations
+ Please note that's single-use script, you don't need to pass `--restart` when you use docker/kubernetes etc.
+ Containers doesn't allow to **rewrite** config directly if it passed as file. So use directory like examples above
+ This scripts rewrite from scratch config as you defined in your environment variables. If you want to change this behavior, pass `REGERENATE_VG=0` and scripts will just append or rewrite existing config
+ If you use `REGENERATE_VG=0`, please note scripts doesn't delete config lines that didn't passes as environment variables
