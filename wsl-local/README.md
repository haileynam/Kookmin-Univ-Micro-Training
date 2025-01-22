# Darknet docker image

Docker image for darknet yolov3

## Base image
Ubuntu 20.04

## How to use 

``` $ git clone https://github.com/haileynam/Kookmin-Univ-Micro-Training.git ```

### Docker image pull

```$ docker pull haileynam/darknet:one-image```
or
```$ docker pull haileynam/darknet:multiple-images```

### Docker image build

``` $ docker image build -t haileynam/darknet:one-image . ```
or
``` $ docker image build -t haileynam/darknet:multiple-images . ```

make sure run_darknet_one_image.sh or run_darknet_multiple_images.sh is in same directory with Dockerfile.


### Input image location

``` {LOCAL WORKING DIR}/input_images ``` 

### Docker container run 

``` $ docker run -it -e FILE={INPUT FILE (url or image)} -v /mnt/c/Users/user/{LOCAL WORKING DIR}:/darknet/output haileynam/darknet:{tag}``` 