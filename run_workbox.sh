IMAGE_NAME="isakhammer/workbox:latest"
WORKBOX_DIR=$( cd -- "$( dirname -- "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )

GREEN='\033[0;32m'
NC='\033[0m' # No Color
function echo_color {
    printf "${GREEN}$@${NC}\n"
}

function run_workbox_jupyter()  {
  image_name=$IMAGE_NAME
  PORT=8800
  echo_color "Using docker image: isakhammer/workbox:latest with ports $PORT:$PORT"
  xhost +local:root
  XSOCK=/tmp/.X11-unix
  docker run -it --rm \
     -e DISPLAY=$DISPLAY \
     --privileged \
     -v $(pwd)/:/root/code \
     -v $WORKBOX_DIR/:/root/workbox \
     -v $XSOCK:$XSOCK \
     -v $HOME/.ssh:/root/.ssh \
     -v $HOME/.Xauthority:/root/.Xauthority \
     -v $HOME/.gitconfig:/root/.gitconfig \
     -p $PORT:$PORT \
     $image_name "$@" \
     /bin/bash -c "
        jupyter-lab --ip 0.0.0.0 --port $PORT --allow-root
       "
}


function run_workbox()  {
  image_name=$IMAGE_NAME
  xhost +local:root
  XSOCK=/tmp/.X11-unix
  docker run -it --rm \
     -e DISPLAY=$DISPLAY \
     --privileged \
     -v $(pwd)/:/root/code \
     -v $WORKBOX_DIR/:/root/workbox \
     -v $XSOCK:$XSOCK \
     -v $HOME/.ssh:/root/.ssh \
     -v $HOME/.Xauthority:/root/.Xauthority \
     -v $HOME/.gitconfig:/root/.gitconfig \
     $image_name "$@"
}



if [ $# -eq 0 ]; then
    echo_color "Using docker image: isakhammer/workbox:latest"
    run_workbox
elif [[ $1 == "local" ]]; then
    echo_color "Using local docker image: workbox:latest"
    IMAGE_NAME="workbox:latest"
    run_workbox
elif [[ $1 == "jupyter" ]]; then
    run_workbox_jupyter
else
    echo_color "Uknown argument."
fi


