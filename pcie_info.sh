#!/bin/bash
# Program:
# 	This scripts collects the pcie info within your machine.
# Update: (compare to V1.0)
#   This time, scripts will detecte the relation between bus-number to PCIE-slot.

PATH=/bin:/sbin:/usr/bin:/usr/sbin:/usr/local/bin:/usr/local/sbin:/root/bin

echo
echo -e "\033[41;30m   #############################  \033[0m"
echo -e "\033[41;30m   ### PCI-E collection V2.0 ###  \033[0m"
echo -e "\033[41;30m   ######  Wrote By Lester #####  \033[0m"
echo -e "\033[41;30m   ########  2017-02-09  #######  \033[0m"
echo -e "\033[41;30m   #############################  \033[0m"
echo
echo "=================================="

function Link()
{
  line=`lspci|grep $1|wc -l`
  for i in $(seq 1 $line)
  do
    lspci|grep $1|awk "NR==$i"
  done  
  tmp=`lspci|grep $1`
  if [ "$tmp" != "" ]; then
    vendor_device=`lspci -n |grep $1 |awk 'NR==1 {print $3}'`
    Driver=`lspci -n -d $vendor_device -vvv | grep driver |awk 'NR==1' | cut -d':' -f2`
	driver_version_now=`modinfo $Driver | grep ^version | awk '{print $2}'`
	driver_version_latest=`python version $Driver`
    echo -e "\033[34m**********************************\033[0m"
    echo -e "\033[33mDriver:	   $Driver        \033[0m"
	echo -e "\033[33mVersion_now:    $driver_version_now	\033[0m"
	echo -e "\033[33mVersion_latest: $driver_version_latest"
	python update $Driver $driver_version_now $driver_version_latest
    echo -e "\033[34m**********************************\033[0m"
  fi
  sleep 1
}

function get_buslist()
{
  bus_list=`dmidecode -t 9|grep Address|cut -d':' -f3`
  for i in $bus_list
  do
    echo "$i:00"
  done
}

function pci2bus()
{    
  dmidecode -t 9|grep -E 'Designation|Address' > haha
  key=`echo $1 | awk -F':' '{print $1}'`
  nu=$((`cat -n haha |grep $key:|cut -f1`-1))
  value=`cat haha|awk "NR==$nu"|cut -d':' -f2`
  echo -e "\033[41m     >>>>>>$value <<<<<<    \033[0m"
  rm -rf haha
}

############ Main ###############

dmidecode -t 9|grep -E 'Designation|Address' > haha

for bus in `get_buslist`
do
  pci=`lspci | grep $bus`
  if [ "$pci" != "" ]; then
    pci2bus $bus
    Link $bus
  fi
  echo
done
echo "=================================="
echo

############ End ###############
