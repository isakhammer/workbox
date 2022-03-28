IMAGE_NAME="isakhammer/workbox:latest"

GREEN='\033[0;32m'
NC='\033[0m' # No Color


function echo_color {
    printf "${GREEN}$@${NC}\n"
}

if [ $# -eq 0 ]; then
    echo_color "Using docker image: isakhammer/workbox:latest"
elif [[ $1 == "local" ]]; then
    echo_color "Using local docker image: workbox:latest"
    IMAGE_NAME="workbox:latest"
else
    echo_color "Uknown argument. Using docker image: isakhammer/workbox:latest"
fi


WORKBOX_DIR=$( cd -- "$( dirname -- "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )
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
     -p 8888:8888 \
     $image_name "$@"
}

run_workbox
