#!/bin/sh

echo "Sleeping for 30 seconds for kafka to setup"
sleep 30
echo "Consuming pcap data stored in /root/data/stream.pcap"

zeek local -C -r /root/data/stream.pcap 
