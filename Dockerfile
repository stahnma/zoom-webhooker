

from ruby
RUN apt-get update && apt-get -y install vim git ack-grep && rm -rf /var/lib/apt/lists/*
WORKDIR "/app"
RUN /usr/local/bin/bundle config set --local path 'vendor/bundle'
COPY .bashrc /root/.bashrc
CMD [ "/bin/bash" ]
EXPOSE 4567
