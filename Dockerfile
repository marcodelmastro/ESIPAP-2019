FROM rootproject/root-ubuntu16

# Run the following commands as super user (root):
USER root

# Install required packages for notebooks
RUN apt-get update
RUN apt-get install -y python-pip
RUN pip install --upgrade pip
RUN pip install \
    	jupyter \
        metakernel \
        zmq \
RUN rm -rf /var/lib/apt/lists/*

USER main

# Create the configuration file for jupyter and set owner
#RUN echo "c.NotebookApp.ip = '*'" > jupyter_notebook_config.py && chown ${username} *

# Switch to our newly created user
#USER ${username}

# Allow incoming connections on port 8888
#EXPOSE 8888

# Start ROOT with the --notebook flag to fire up the container
#CMD ["root", "--notebook"]