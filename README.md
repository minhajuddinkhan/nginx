# nginx - circle ci - ansible playbooks

trying to run shit with nginx and cirlceCi

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

### configure the template for ngnix server
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


### setup task for creating an nginx server
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

##### run the setup bash file
```sudo chmod +x deploy-to-production.sh && ./deploy-to-production.sh ```
