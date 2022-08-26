# build_monitor

## Mac OS - Dev Prerequisites
- brew is installed

# Commands
build docker release
`./build_docker_release`

stop & kill locally running docker container
`docker container stop build_monitor && docker container prune -f`

list all containers (even no-longer-running ones)
`docker ps -a`
