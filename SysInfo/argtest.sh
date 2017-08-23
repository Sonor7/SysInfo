#! /bin/bash

while [ "$#" -ne 0 ]
do
arg=$1
case $arg in
-[P,p] )
    read -p "Add meg az ip-t " IP
    #echo $IP
    export IP=$IP
    ping -c 4 $IP
    shift
    ;;
-[D,d] )
    nslookup $IP 
    shift
    ;;
-[T,t] )
    NetworkTest.sh -P
    shift
    ;;
esac
done
