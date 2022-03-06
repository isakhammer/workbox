
WORKBOX_DIR=$( cd -- "$( dirname -- "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )
function run_workbox()  {
  image_name="workbox"
  xhost +local:root
  XSOCK=/tmp/.X11-unix
  docker run -it --rm \
     -e DISPLAY=$DISPLAY \
     --name workbox \
     --privileged \
     -v $(pwd)/:/root/code \
     -v $WORKBOX_DIR/:/root/workbox \
     -v $XSOCK:$XSOCK \
     -v $HOME/.ssh:/root/.ssh \
     -v $HOME/.Xauthority:/root/.Xauthority \
     $image_name "$@"
}

run_workbox
