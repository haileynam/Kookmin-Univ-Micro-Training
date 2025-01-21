# Darknet docker image

Docker image for darknet yolov3

## Base image
Ubuntu 20.04

## How to use 

``` $ git clone https://github.com/haileynam/Kookmin-Univ-Micro-Training.git ```

### Docker image pull

```$ docker pull haileynam/darknet```

move run_darknet.sh to target local directory

### Docker container run 

``` $ docker run -it -e FILE={INPUT FILE (url or image)} -v /mnt/c/Users/user/{LOCAL WORKING DIR}:/darknet/output haileynam/darknet``` 

