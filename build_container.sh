
function build_container()  {
  image_name="latex_template"
  docker build . -t $image_name
}

build_container

