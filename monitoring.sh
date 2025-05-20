#!/bin/bash
arch=$(uname -a)
pcpu=$(lscpu | grep "Socket(s)" | awk '{print $2}')
vcpu=$(nproc)
memused=$(free -m | grep "Mem:" | awk '{print $3}')
memtotal=$(free -m | grep "Mem:" | awk '{print $2}')
memp=$(free -m | grep "Mem:" | awk '{printf("%.2f"), $3/$2 * 100}')
diskused=$(df -h --block-size=G --total | tail -n 1 | awk '{print $3}' | cut -d G -f1)
diskfree=$(df -h --block-size=G --total | tail -n 1 | awk '{print $2}' | cut -d G -f1)
diskpercentage=$(df -h --block-size=G --total | tail -n 1 | awk '{print $5}' | cut -d % -f1)
cpuload=$(top -bn1 | grep "Cpu(s)" | awk '{print 100 - $8}')
lastreboot=$(who -b | awk '{print $3 " " $4}')
lvmtotal=$(lsblk | grep "lvm" | wc -l)
lvmused=$(if [$lvmtotal -eq 0]; then echo no; else echo yes; fi)
connections=$(ss -tun state established | wc -l)
est=$(if [$connections -eq 0]; then echo  NOT ESTABLIHED; else echo ESTABLISHED; fi)
userlog=$(who | wc -l)
ip=$(ip address | grep enp | grep inet | awk '{print $2}' | cut -d / -f1)
mac=$(ip address | grep enp -A 1 | grep ether | awk '{print $2}')
sudolog=$(journalctl _COMM=sudo | grep COMMAND | wc -l)
wall "
#Architecture: $arch
#CPU physical : $pcpu
#vCPU : $vcpu
#Memory Usage: $memused/${memtotal}MB ($memp%)
#Disk Usage: $diskused/${diskfree}Gb ($diskpercentage%)
#CPU load: $cpuload%
#Last boot: $lastreboot
#LVM use: $lvmused
#Connections TCP : $connections $est
#User log: $userlog
#Network: IP $ip ($mac)
#Sudo : $sudolog cmd"
