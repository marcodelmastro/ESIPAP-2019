FROM dockerfile/ubuntu

MAINTAINER Marco Delmastro <Marco.Delmastro@cern.ch>

USER root

# Install ROOT prerequisites
RUN apt-get update
RUN apt-get install -y \
    libx11-6 \
    libxext6 \
    libxft2 \
    libxpm4

# Download and install ROOT
WORKDIR /opt
RUN wget https://root.cern.ch/download/root_v6.14.06.Linux-ubuntu14-x86_64-gcc4.8.tar.gz
RUN tar xzf root_v6.14.06.Linux-ubuntu14-x86_64-gcc4.8.tar.gz
RUN rm root_v6.14.06.Linux-ubuntu14-x86_64-gcc4.8.tar.gz

USER main

# Set ROOT environment
ENV ROOTSYS         "/opt/root"
ENV PATH            "$ROOTSYS/bin:$ROOTSYS/bin/bin:$PATH"
ENV LD_LIBRARY_PATH "$ROOTSYS/lib:$LD_LIBRARY_PATH"
ENV PYTHONPATH      "$ROOTSYS/lib:PYTHONPATH"

# Install pip and dependencies to run notebooks
RUN pip install --upgrade pip
RUN pip install jupyter \
                metakernel \
                zmq
		## --ignore-installed

# Customize the local environement
RUN mkdir -p                                 $HOME/.ipython/kernels
RUN cp -r $ROOTSYS/etc/notebook/kernels/root $HOME/.ipython/kernels
RUN mkdir -p                                 $HOME/.ipython/profile_default/static
RUN cp -r $ROOTSYS/etc/notebook/custom       $HOME/.ipython/profile_default/static
