FROM ubuntu:22.04

# for TZ ignore
ENV DEBIAN_FRONTEND=noninteractive 

WORKDIR /darknet

# install dependencies
RUN apt-get update && apt-get install -y \
    git \
    gcc \
    g++ \
    make \ 
    wget && \
    apt-get clean

# clone darknet repository
RUN git clone https://github.com/pjreddie/darknet.git .

RUN make

RUN wget https://pjreddie.com/media/files/yolov3.weights

RUN mkdir -p /darknet/output

# add darknet to the PATH
ENV PATH="/darknet:${PATH}"

# Copy the script into the container
COPY run_darknet.sh /darknet/run_darknet.sh

# Ensure the script is executable
RUN chmod +x /darknet/run_darknet.sh

CMD ["/bin/bash", "/darknet/run_darknet.sh"]

