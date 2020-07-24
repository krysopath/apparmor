FROM alpine
COPY app.sh /code/bin/app.sh
WORKDIR /code
RUN chown -R 1000:1000 /code
USER 1000:1000
ENTRYPOINT ["/code/bin/app.sh"]

