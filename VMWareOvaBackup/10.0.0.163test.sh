#!/bin/bash

ssh 10.0.0.163 "find /vmfs/volumes/5927b73e-4a7bac54-05c9-f8b156ce1829/* -type d | egrep "[0-9]{4}-[0-9]{2}-[0-9]{2}_[0-9]{2}[-,0-9]{2}"" > backup.list
while read list; do 
	scp -r root@10.0.0.163:$list /mnt/dane/vm-backup
done<backup.list

