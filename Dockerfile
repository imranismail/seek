FROM asia.gcr.io/labs-127/seek:base

ADD . .

RUN make setup

CMD ["make"]
