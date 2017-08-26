# nginx - circle ci

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

