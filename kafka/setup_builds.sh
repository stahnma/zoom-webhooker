#!/bin/bash
#

kafka_version='3.4.0'
scala_version='2.13'
target_filename="kafka_${scala_version}-${kafka_version}.tgz"

download_location="https://downloads.apache.org/kafka"

curl --silent --remote-name --location "${download_location}"/"${kafka_version}"/"${target_filename}"
curl --silent --remote-name --location "${download_location}"/"${kafka_version}"/"${target_filename}.sha512"
curl --silent --remote-name --location "${download_location}"/"${kafka_version}"/"${target_filename}.asc"

# TODO Better than nothing but we should also check the signature
if gpg --print-md SHA512 "${target_filename}" | diff - "${target_filename}.sha512" ; then
  tar zxf "${target_filename}"
else
  echo "ERROR: Checksum mismatch"
  exit 1
fi
