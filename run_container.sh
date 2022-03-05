
function run_container()  {
  image_name="latex_template"
  xhost +local:root
  XSOCK=/tmp/.X11-unix
  docker run -it --rm \
     -e DISPLAY=$DISPLAY \
     --name latex_template \
     --privileged \
     -v $(pwd)/:/root/code \
     -v $XSOCK:$XSOCK \
     -v $HOME/.ssh:/root/.ssh \
     -v $HOME/.Xauthority:/root/.Xauthority \
     $image_name "$@"
}


run_container
