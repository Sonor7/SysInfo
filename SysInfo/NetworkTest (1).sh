#! /bin/bash
logfile=/scripts/NetworkTestLog.txt
tempfile1=/scripts/temp1.txt
tempfile2=/scripts/temp2.txt
tempipfile=/scripts/tempipfile.txt
tempdnsfile=/scripts/tempdnsfile.txt
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
ifconfig | grep -w "inet" | tee $tempfile1 $logfile
awk '{print $2}' $tempfile1 > $tempipfile
}
function DnsTestPrep() 
{
cat /etc/resolv.conf | grep -w "nameserver" | tee $tempfile2 $logfile
awk '{print $2}' $tempfile2 > $tempdnsfile
}
function IpTest()
{
while read line 
do
echo "Pinging $line" >> $logfile
ping -c 4 -D $line   >> $logfile &
done < $tempipfile
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
export $logfile
#test if the logfile exists
LogTest &
#gets the information from relevant places, and uses awk to create a file that is usable for piping into the commans(ping and nslookup)
IpTestPrep &
DnsTestPrep &
#Runs the ip test. Not multithreaded, because we want to wait for it to properly write to the log.
IpTest
#waiting for it to run
/bin/sleep 5
#tests the dns server
DnsTest 
#adds date for convenience
date >> $logfile
#removes the temporary files
CleanUp
exit
