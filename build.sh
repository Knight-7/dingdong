#!/usr/bin/env bash

string=${1}

array=(${string//,/ })

for var in ${array[@]}
do
  go build -ldflags "-X main.VERSION=${2} -X main.COMMIT=${3}" \
		-o ./build/${var} ./cmd/${var}/*.go && \
	echo build ${var} Successfully
done
