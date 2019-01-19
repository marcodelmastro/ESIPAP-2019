FROM rootproject/root-ubuntu16

USER root

RUN apt-get update
RUN apt-get install -y python-pip
RUN which root
RUN pip install --upgrade pip
RUN pip install jupyter \
                metakernel \
                zmq
