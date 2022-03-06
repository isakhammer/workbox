
function build_container()  {
  image_name="workbox"
  docker build . -t $image_name
}

build_container

