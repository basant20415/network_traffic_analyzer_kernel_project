#!/bin/bash
# ifconfig shows me the interfaces

analize_function(){
  # number of total packets
total_packets=$(tshark -r "$1" | wc -l) 
# number of http packets
# -Y "http"
http_packets=$(tshark -r "$1" -Y "http"  | wc -l)
# number of tls packets
tls_packets=$(tshark -r "$1"  -Y "tls" | wc -l)
 Top 5 source IP addresses
top_source_ips=$(tshark -r "$1" -T fields -e ip.src | sort | uniq -c | sort -nr | head -n 5)
   
    # Top 5 destination IP addresses
    # tshark :network protocol analyzer
    # -T fields :tells t-shark to get specific fields not the entire packet
    # -e ip.dest specifies that only destination ips should be extracted
    # sort :sort lines in alphabetic order
    # uniq -c :It effectively counts how many times each destination IP address appears in the sorted list.
    # sort -nr :sorts lines numerically (-n) and in reverse order (-r). It sorts the IP addresses by their frequency of occurrence in descending order.
    # head -n 5 :outputs the first 5 lines of the input, which corresponds to the top 5 most frequent destination IP addresses.
top_dest_ips=$(tshark -r "$1" -T fields -e ip.dst | sort | uniq -c | sort -nr | head -n 5)


  echo "----- Network Traffic Analysis Report -----"
    echo "1. Total Packets: $total_packets"
    echo "2. Protocols:"
    echo "   - HTTP: $http_packets packets"
    echo "   - HTTPS/TLS: $tls_packets packets"
    echo ""
    echo "3. Top 5 Source IP Addresses:"
        while read count ip; do
        echo "  - $ip: $count packets"
        done <<< "$top_source_ips"
    echo ""
    echo "4. Top 5 Destination IP Addresses:"
        while read count ip; do
    echo "  - $ip: $count packets"
        done <<< "$top_dest_ips"
    echo ""


}
read http__tls_file

analize_function "$http__tls_file"