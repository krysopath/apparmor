install: jailed
	sudo cp jailed /usr/bin/jailed

jailed: jailed.c
	gcc -o jailed jailed.c

docker/build:
	docker build -t jailed .

docker/run: docker/build
	docker run -it --rm  --security-opt 'apparmor=/usr/bin/jailed'  jailed


