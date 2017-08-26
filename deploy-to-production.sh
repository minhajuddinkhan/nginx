#/bin/bash

if [ $(dpkg-query -W -f='${Status}' ansible 2>/dev/null | grep -c "ok installed") = 0 ]
then
    sudo apt-get update -y && \
    sudo apt-get install software-properties-common -y && \
    sudo apt-add-repository ppa:ansible/ansible -y && \
    sudo apt-get update -y && \
    sudo apt-get install ansible -y
fi


sudo ansible-playbook -v playbooks/setup.yml
