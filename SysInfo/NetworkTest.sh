#! /bin/bash
logfile=/scripts/NetworkTestLog.txt
tempfile1=/scripts/temp1.txt
tempfile2=/scripts/temp2.txt
tempipfile=/scripts/tempipfile.txt
tempdnsfile=/scripts/tempdnsfile.txt
echo "NetworkTest starts running" >> $logfile
date >> $logfile
arg=$1
function LogTest ()
{
if [ -e $logfile ]
then
echo "Logfile is present"
else
echo "#This is the NetworkTestLog Logfile" > $logfile #/scripts/NetworkTestLog.txt
echo "Logfile Created"
fi
}
function IpTestPrep() 
{
ifconfig | grep -w "inet" > $tempfile1
awk '{print $2}' $tempfile1 > $tempipfile
}
function DnsTestPrep() 
{
cat /etc/resolv.conf | grep -w "nameserver" > $tempfile2 
awk '{print $2}' $tempfile2 > $tempdnsfile
}
function IpTest()
{
echo "Entering IpTest" >> $logfile
echo $arg
case $arg in
    0 )
    echo "Working without provided ip" >> $logfile
    while read line 
    do
    ping -c 4 -D $line >> $logfile &
echo "Pinging $line" >> $logfile
ping -c 4 -D $line   >> $logfile &
    done < $tempipfile
;;
    -[P] )
    echo "Working with provided ip" >> $logfile
    echo $IP
    ping -c 4 -D $IP >> $logfile &
    shift
    ;;
*)
echo "Something is borked" >> $logfile
;;
esac
}
function DnsTest()
{
while read line 
do
echo "Testing DNS Server $line" >> $logfile
nslookup microsoft.com $line >> $logfile
done < $tempdnsfile
}
function CleanUp()
{
rm -f $temp1
rm -f $temp2
rm -f $tempdnsfile
rm -f $tempipfile
}
#export $logfile
LogTest &
IpTestPrep &
DnsTestPrep &
/bin/sleep 1
IpTest
/bin/sleep 5
DnsTest 
echo "NetworkTest stops running" >> $logfile
date >> $logfile
CleanUp
exit
