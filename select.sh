#!/bin/bash
# Program:
#   Select the right driver, then install or upgrade.
# Author: Lester
# History: 2017-02-10
PATH=/bin:/sbin:/usr/bin:/usr/sbin:/usr/local/bin:/usr/local/sbin:~/bin

machine=`dmidecode | grep "Product Name:" | awk 'NR==1 {print $3}|awk -F '.' '{print $1}'
os_type=`lsb_release -a | grep Distributor| cut -d':' -f2`
os_release=`lsb_release -a | grep Release | awk '{print $2}'`

echo $os_type | grep -i red
result=$?
if [ $? == 0 ]; then
    os=`echo -n rhel;echo -e os_release`

echo $os_type | grep -i centos
result=$?
if [ $? == 0 ]; then
    os=`echo -n centos;echo -e os_release`

echo $os_type | grep -i ubuntu
result=$?
if [ $? == 0 ]; then
    os=`echo -n ubuntu;echo -e os_release`

cd os
case $1 in
'igb')
    sh igb_install.sh
    ;;
'ixgb')
    sh ixgb_install.sh
    ;;
'megaraid_sas')
    sh megaraid_sas_install.sh
    ;;
'qla2xxx')
    sh qla2xxx_install.sh
    ;;
'lpfc')
    sh lpfc_install.sh
    ;;
*)
    echo "No such driver, please update your datebase"
    ;;
esac
