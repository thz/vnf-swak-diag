FROM golang:1.8 as buildstage

ENV GOPATH /go
WORKDIR /go
RUN go get github.com/osrg/gobgp/gobgp
RUN go get github.com/osrg/gobgp/gobgpd

FROM ubuntu:latest as runstage

COPY --from=buildstage /go/bin/gobgp /usr/bin
COPY --from=buildstage /go/bin/gobgpd /usr/bin

RUN apt-get update -y
RUN apt-get install -y \
	htop \
	iftop \
	iperf \
	iperf3 \
	iproute2 \
	iputils-ping \
	keepalived \
	mtr \
	openssh-client \
	python \
	socat \
	strace \
	tcpdump \
	vim

ENTRYPOINT [ "bash" ]
