# NodeJS with NGINX

## Steps to get started :
### Install NGINX

```
  sudo apt-get update
  sudo apt-get install nginx
```

### Run the Deployment bash script

```
  sudo chmod +x deploy-to-production.sh && ./deploy-to-production.sh 
 ```

### Run your server

```javascript
  node server
```

And its done! go to ```localhost``` to verify. If its not working. delete the default service nginx is running.

``` path : /etc/nginx/sites-enabled/default ```


# Integrated with CircleCI and Ansible

### circle.yml

```yml
deployment:
  production: # just a label; label names are completely up to you
    branch: master
    commands:
      - ./deploy-to-production.sh
test:
  override:
    - echo "test"
```

### configation template for ngnix server
```bash
server {
    server_name  {{ api_host }};
    listen 80;
    listen 443 ssl;
    location / {
        proxy_pass http://127.0.0.1:{{ api_http_port }};
        proxy_set_header Host      $host;
        proxy_set_header X-Real-IP $remote_addr;
    }
}
```


### task for creating nginx server
```yml
---
- hosts: localhost
  name: nginx
  become: yes
  become_method: sudo
  tags:
    - gateway-nginx
  tasks:
    - name: configure nginx to enabled sites
      template: src=../templates/api/nginx.conf.j2 dest=/etc/nginx/sites-enabled/api.conf

    - name: configure nginx to available sites
      template: src=../templates/api/nginx.conf.j2 dest=/etc/nginx/sites-available/api.conf

    - name: reload nginx
      shell: |
        sudo service nginx restart
``` 
### executing the playbooks

##### ```deploy-to-production.sh```

```
#/bin/bash

if [ $(dpkg-query -W -f='${Status}' ansible 2>/dev/null | grep -c "ok installed") = 0 ]
then
    sudo apt-get update -y; \
    sudo apt-get install software-properties-common -y; \
    sudo apt-add-repository ppa:ansible/ansible -y; \
    sudo apt-get update -y; \
    sudo apt-get install ansible -y
fi


sudo ansible-playbook -v playbooks/setup.yml
```
