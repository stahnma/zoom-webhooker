#!/bin/bash
#

#TODO verify the download and such
curl -s -O -L https://downloads.apache.org/kafka/3.4.0/kafka_2.13-3.4.0.tgz
curl -s -O -L https://downloads.apache.org/kafka/3.4.0/kafka_2.13-3.4.0.tgz.sha512
curl -s -O -L https://downloads.apache.org/kafka/3.4.0/kafka_2.13-3.4.0.tgz.asc

tar zxf kafka*tgz
