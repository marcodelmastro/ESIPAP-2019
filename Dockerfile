FROM rootproject/root-ubuntu16

MAINTAINER Marco Delmastro <Marco.Delmastro@cern.ch>

USER root

# Install ROOT prerequisites
RUN apt-get update

## Not needed for root-ubuntu16, already up to date
#RUN apt-get install -y \
#    libx11-6 \
#    libxext6 \
#    libxft2 \
#    libxpm4

# RUN gcc -v
## gcc version 5.4.0 20160609 (Ubuntu 5.4.0-6ubuntu1~16.04.9)

# Install Python and dependencies
RUN apt-get install -y python-pip

# Download and install ROOT in /opt/root
RUN apt-get install -y wget
WORKDIR /opt
ARG rootsrc=root_v6.14.06.Linux-ubuntu16-x86_64-gcc5.4.tar.gz
RUN wget https://root.cern.ch/download/${rootsrc}
RUN tar xzf ${rootsrc}
RUN rm ${rootsrc}

# Install dependencies to run notebooks
RUN pip install --upgrade pip
RUN pip install jupyter \
                metakernel \
                zmq

# Create a user that does not have root privileges
ARG username=physicist
RUN userdel builder && useradd --create-home --home-dir /home/${username} ${username}
ENV HOME /home/${username}

# Copy repository in user home
COPY . ${HOME}
RUN chown -R ${username} ${HOME}

# Switch to normal user
USER ${username}
WORKDIR ${HOME}

# Set ROOT environment
ENV ROOTSYS         "/opt/root"
ENV PATH            "$ROOTSYS/bin:$ROOTSYS/bin/bin:$PATH"
ENV LD_LIBRARY_PATH "$ROOTSYS/lib:$LD_LIBRARY_PATH"
ENV PYTHONPATH      "$ROOTSYS/lib:PYTHONPATH"

# Customize the local environement
RUN mkdir -p                                 $HOME/.ipython/kernels
RUN cp -r $ROOTSYS/etc/notebook/kernels/root $HOME/.ipython/kernels
RUN mkdir -p                                 $HOME/.ipython/profile_default/static
RUN cp -r $ROOTSYS/etc/notebook/custom       $HOME/.ipython/profile_default/static

