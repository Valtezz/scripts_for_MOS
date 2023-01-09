#!/bin/sh
echo "add rsa to admin"
ssh-copy-id admin@$i
sleep 5
echo "cloning rsa from admin to root"
sleep 5
for i in $(cat host.txt);do (cat script) | while read line; do echo $line; sleep 1; done | ssh -tt admin@$i; done 
