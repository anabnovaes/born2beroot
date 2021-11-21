ARCHITECTURE=$(uname -a)
echo "#Architecture : ${ARCHITECTURE}" 

CPUS=$(lscpu | grep "^CPU(s)"| grep -Eo "[0-9]+")  
echo "#CPU physical : ${CPUS} "

VCPUS=$(cat /proc/cpuinfo |grep processor | wc -l )
echo "#vCPU : ${VCPUS}" 

TOTAL_MEMORY=$(free -m | grep -Eo "^Mem:\s+[0-9]+" | grep -Eo "[0-9]+" )
USED_MEMORY=$(free -m | grep -Eo "^Mem:\s+[0-9]+\s+[0-9]+"| grep -Eo "[0-9]+"| tail -n 1)
PERCENTAGE=$(free -m |awk 'NR == 2 {printf "%.2f", $3*100/$2}')
echo "#Memory Usage : ${USED_MEMORY}/${TOTAL_MEMORY}MB (${PERCENTAGE})%"

TOTAL_DISK_MEMORY=$(df -H --total | awk 'END{printf "%dGb", $2}')
USED_DISK_MEMORY=$(df -m --total | awk 'END{printf "%d", $3}')
PERCENTAGE_DISK_MEMORY=$(df -m --total | awk 'END{printf "%.2f", $3*100/$2}')
echo "#Disk Usage : ${USED_DISK_MEMORY}/${TOTAL_DISK_MEMORY} (${PERCENTAGE_DISK_MEMORY})%"

CPU_LOAD=$(mpstat | grep -Eo ".[0-9]+.[0-9]+" | tail -1 | awk '{print (100 - $1)}')
echo "#CPU load : ${CPU_LOAD}%"

LAST_BOOT=$(uptime --since)
echo "#Last boot : ${LAST_BOOT} "

LVM_USE=$(cat /etc/fstab | grep "^/dev/mapper" | wc -l)
if [${LVM_USE} -eq 0]
then echo '#LVM usage : no';
else echo '#LVM usage : yes' ;
fi

CONNECTIONS_TCP=$(ss -s | grep -Eo "^TCP\s+[0-9]+" | grep -Eo ".[0-9]+")
echo "#Connections TCP: ${CONNECTIONS_TCP}"
