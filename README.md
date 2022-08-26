# build_monitor

## Mac OS - Dev Prerequisites
- brew is installed

# Commands
build and deploy
`flyctl deploy`

build docker release locally (not working rn)
`./build_docker_release`

stop & kill locally running docker container
`docker container stop build_monitor && docker container prune -f`

list all containers (even no-longer-running ones)
`docker ps -a`

see fly.io config file at
`fly.toml`
