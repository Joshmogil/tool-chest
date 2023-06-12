#!/bin/bash

docker pull quay.io/goswagger/swagger

if grep -Fxq "alias swagger" ~/.bashrc
then
    echo "swagger alias already set up"
else
    echo 'alias swagger="docker run --rm -it  --user $(id -u):$(id -g) -e GOPATH=$(go env GOPATH):/go -v $HOME:$HOME -w $(pwd) quay.io/goswagger/swagger"' >> ~/.bashrc
fi
alias swagger='docker run --rm -it  --user $(id -u):$(id -g) -e GOPATH=$(go env GOPATH):/go -v $HOME:$HOME -w $(pwd) quay.io/goswagger/swagger'
swagger version
