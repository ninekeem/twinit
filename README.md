# twinit
Init scripts for teeworlds servers

## How to use this scripts
### Building dockerfile
` docker build -t twinit . `

### Executing
**Please note that's single-use script, you don't need to pass `--restart` when you use docker/kubernetes etc.**
#### With docker
+ `touch autoexec.cfg `
+ `docker run -e SV_PORT=8303 -e SV_REGISTER=1 -e SV_NAME='My Teeworlds Server' -v "$(pwd)/autoexec.cfg:/config`
+ If you need to change config path, pass `-e CONFIG_PATH` and change docker volumes if needed:
  - `docker run ... -e CONFIG_PATH='/config/autoexec.cfg' -v "$(pwd)"/config:/config`
  - `docker run ... -e CONFIG_PATH='/config/cfg' -v "$(pwd)"/config/cfg`

#### Without docker
+ Just pass all needed environment variables to `init.sh`, including `CONFIG_PATH`
  - `SV_PORT=8303 SV_REGISTER=1 SV_NAME='My Teeworlds Server' CONFIG_PATH='./autoexec.cfg' ./init.sh`
