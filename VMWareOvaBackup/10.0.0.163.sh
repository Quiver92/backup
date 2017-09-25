#!/bin/bash
#copy vmx files
VMX_LIST=$(ssh 10.0.0.163 "find -name "*.vmx"")
VM_LIST=$(ssh 10.0.0.163 'vim-cmd vmsvc/getallvms' | awk '{print $2}' | sed -e '1d')
ROOT=/vmfs/volumes/5927b73e-4a7bac54-05c9-f8b156ce1829/ 
#for VM in $VMX_LIST; do
#	scp 10.0.0.163:$VM /mnt
#done

for VM in $VM_LIST;do
	ssh 10.0.0.163 "mkdir $ROOT$VM`date +%F`"
	ssh 10.0.0.163 "find -name "$VM.vmx" | xargs grep -r vmdk >/vmkd.list | find -name "$VM*.vmdk" | while read list; do echo $list >> listofvmdk ;done"
done










#print list of VM's
#cd /mnt/
########################################

#VM_LIST=$(ssh 10.0.0.163 'vim-cmd vmsvc/getallvms' | awk '{print $2}' | sed -e '1d')
#VMX_FIND=$(ssh 10.0.0.163 "find -name "*.vmx"")
#for VM in ${VM_LIST}; do 
#	scp root@10.0.0.163:"${VMX_FIND}" /mnt
#done
#######################################
#echo $VM_LIST>/root/lol.ini
#while read -r line
#do	
#	echo $line
#	ssh root@10.0.0.163 'find -name '$line.vmx'' 

#	echo "$line" 

#	vmkfstools --server 10.0.0.163 -i /vmfs/volumes/5927b73e-4a7bac54-05c9-f8b156ce1829/Print_server/Print_server.vmdk /vmfs/volumes/5927b73e-4a7bac54-05c9-f8b156ce1829/Print_server/Print_server_clone.vmdk -d thin

#done</root/lol.ini
