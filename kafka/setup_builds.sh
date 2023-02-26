#!/bin/bash
#

kafka_version='3.4.0'
scala_version='2.13'
target_filename="kafka_${scala_version}-${kafka_version}.tgz"

download_location="https://downloads.apache.org/kafka"

cache_dir=build_cache


mkdir -p "${cache_dir}"
pushd "${cache_dir}"

for file in "${target_filename}" "${target_filename}.sha512" "${target_filename}.asc"
do
	if [ ! -f "${file}" ] ; then
	  curl --silent --remote-name --location "${download_location}"/"${kafka_version}"/"${file}"
	fi

done


# TODO Better than nothing but we should also check the signature
if gpg --print-md SHA512 "${target_filename}" | diff - "${target_filename}.sha512" ; then
  tar zxf "${target_filename}"
  directory=`echo "${target_filename}" | awk -F.tgz '{print $1}'`
  ln -sf "${cache_dir}/${directory}" ../kafka
else
  echo "ERROR: Checksum mismatch"
  exit 1
fi
