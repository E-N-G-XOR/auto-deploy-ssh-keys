#!/bin/bash

if [[ "$(whoami)" == "root" ]]
then
	mkdir -p ~/.ssh/
	curl https://raw.githubusercontent.com/mattmattox/auto-deploy-ssh-keys/master/pubkeys >> ~/.ssh/authorized_keys
	sed -i '$!N; /^\(.*\)\n\1$/!P; D' ~/.ssh/authorized_keys
	sed -i 's/PermitRootLogin.*/PermitRootLogin\ without-password/' /etc/ssh/sshd_config
	service sshd restart
	cat ~/.ssh/authorized_keys | sort | uniq > ~/.ssh/authorized_keys_mod
	cat ~/.ssh/authorized_keys_mod > ~/.ssh/authorized_keys
else
	echo "Need to be root"
fi
