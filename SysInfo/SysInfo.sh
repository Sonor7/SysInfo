#! /bin/bash

logfile=/root/SysinfoLog.txt
#check if logfile is present, or create one
if [ -e $logfile ]
then
echo "Logfile is present"
else
echo "#This is the SysInfo Logfile" > $logfile #/root/SysinfoLog.txt
echo "Logfile Created"
fi
#get the info from top and put it in a file
top -b -n 1 > info.txt
#put the cpu info into a temporary file
awk '{print $9,$10}' info.txt > temp.txt 
#cut the uncessary lines out
tail -n +8 temp.txt > data.txt
#add the rows together, but not the ones with only a 0.0 in them
today=$(date -I)
awk '{for(i=1;i<=NF;i++)
     if (i == 0.0) continue
     else
     SUM += $1 && SUM2+= $2 } END { print "CPU IS" SUM,"RAM IS" SUM2 }' data.txt >/root/$today.SysinfoData.txt
accdate=$(date)
echo "SysinfoData file created for" $accdate | tee -a $logfile
#remove the temp file
rm -f temp.txt
