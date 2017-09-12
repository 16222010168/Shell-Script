#!/usr/bin/ksh 
#
#AUTHOR: CaoYuchi
#FUNCTIONS: system patrol
#CREATE_DATE:2016/12/30
#
#patrol.sh
#

check_errpt()
{
#check the error log today
MD=`date +%m%d`
YEAR=`date +%y`
echo "\n"
echo "-----------Error Information-------------"
ERRPT=$(errpt|grep "$MD....$YEAR")
if [ -n "$ERRPT" ];then
  echo "System call out errorlog, pls pay attention!\n\n"
  echo "$ERRPT"
  echo "-------------------------------- \n"
else
  echo "There's no error log today.\n"
  echo "-------------------------------- \n\n\n"
fi

}

check_fs()
{
#check the usage of the filesystem, each filesystem should not larger than 80%
echo "---------------File system Information-----------------"
FILE=`df -g|grep -Ev "Filesystem"|sed 's/%//'|awk '{ if ($4 > 80) print $0 }'`
if [ -z "$FILE" ];then
  echo "There's no FS larger than 80%."
  echo "-------------------------------- \n"
else
  echo "Filesystem larger than 80%, pls pay attention!"
  echo "$FILE"
  echo "-------------------------------- \n"
fi

}

check_disk()
{
#check the availability of the disk.
echo "----------------Disk Information----------------"
DISK=`lsdev -Cc disk|awk '{if ($2 !="Available") print $0}'`
if [ -z "$DISK" ];then
  echo "The disk system is normal"
  echo "-------------------------------- \n"
else
  echo "Disk system abnormal, pls pay attention!"
  echo "$DISK"
  echo "-------------------------------- \n\n\n"
fi

}

check_adapter()
{
#check the adapter status.
echo "------------------Adapter Information--------------------"
ADAPTER=`lsdev -Cc adapter|awk '{if ($2 !="Available") print $0}'`
if [ -z "$ADAPTER" ];then
  echo "The adapters in this system are normal"
  echo "-------------------------------- \n"
else
  echo "There are abnormal adapter, pls pay attention!"
  echo "$ADAPTER"
  echo "-------------------------------- \n\n\n"
fi

}

check_processor()
{
#check the processor status.
echo "-------------------Processor Information-------------------"
PROCESSOR=`lsdev -Cc processor|awk '{if ($2 !="Available") print $0}'`
if [ -z "$PROCESSOR" ];then
  echo "The processor is normal."
  echo "-------------------------------- \n"
else
  echo "The processor is abnormal"
  echo "$PROCESSOR"
  echo "-------------------------------- \n\n\n"
fi

}

check_vgmirror()
{
#check the mirror of the lv
echo "-------------------VG Mirror Information-------------  "
MIRRORVG=`lsvg -l rootvg|grep -Ev "rootvg:"|grep -Ev "LV NAME" |awk '{ if ( $5 == 1 ) print $0}'`
if [ -z "$MIRRORVG" ];then
  echo "There's no unmirror lv in rootvg."
  echo "-------------------------------- \n"
else
  echo "There're unmirror lv in the rootvg, pls pay attention!"
  echo "$MIRRORVG"
  echo "-------------------------------- \n\n\n"
fi

}

check_ps()
{
echo "--------------------------Paging Space Information-------------------------"
PS=`lsps -s|grep -Ev Total|sed 's/%//'|awk '{if ($2 > 70) print $0}'`
if [ -z "$PS" ];then
  echo "There's no PS larger than 70%."
  echo "-------------------------------- \n"
else
  echo "Paging space larger than 70%, pls pay attention!"
  echo "$PS"
  echo "-------------------------------- \n"
fi

}

################################################MAIN##################################################################
echo "\n"
echo "CHECKING, PLS WAIT... "
check_errpt|tee -a /tmp/Patrolog/`date +%m%d%H%M%y`.log
check_disk|tee -a /tmp/Patrolog/`date +%m%d%H%M%y`.log
check_adapter|tee -a /tmp/Patrolog/`date +%m%d%H%M%y`.log
check_fs|tee -a /tmp/Patrolog/`date +%m%d%H%M%y`.log
check_processor|tee -a /tmp/Patrolog/`date +%m%d%H%M%y`.log
check_vgmirror|tee -a /tmp/Patrolog/`date +%m%d%H%M%y`.log
check_ps|tee -a /tmp/Patrolog/`date +%m%d%H%M%y`.log
#       /usr/sbin/cluster/clstat -o     #Check the POWERHA status.
