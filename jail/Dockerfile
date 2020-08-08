FROM ubuntu
WORKDIR /code

RUN apt update
RUN apt install --no-install-recommends -y bash build-essential openssh-client tmux

COPY jailed.c /code/
RUN gcc -o /usr/bin/jailed jailed.c
RUN useradd -d /code/jailed -u 1000 -s /usr/bin/jailed jailed

USER 1000:1000

#ENTRYPOINT ["/usr/bin/jailed"]

