# Graylog-content-pack-puppet
Automatically uploads and installas specified graylog content pack, made for cosmos-puppet-ops

## Requirements
* graylog versions >=4.3.5 because of a bug on older versions. Link to issue: https://github.com/Graylog2/graylog-plugin-integrations/issues/1113
* mongodb > 4
* elasticsearch 7.10.2 (Since graylog won't be using any newer versions of elasticsearch i recommend looking into changing to opensearch)

Note: The verisons of graylog, mongodb and elasticsearch that i used can be found under templates in this repo.

## How to use:

### 1 - Files
First you need to put the content pack json file inside the directory: 
```
/etc/puppet/modules/cnaas/files/graylog_content_import/
```

### 2 - Secrets
Make sure that the device has all the required secrets. To get access to the graylog api a plain-text version of the admin password needs to be added using ```$./edit-secrets```. When done the local.eyaml file for the device should look somthing like:
````yaml
HTTP_EXTERNAL_URI: ENC[PKCS7....]
PASSWORD_SECRET: ENC[PKCS7,....]
ROOT_PASSWORD_SHA2: ENC[PKCS7,....]
GRAYLOG_ADMIN_PASSWORD: ENC[PKCS7,....]
````

### 3 - cosmos rules
Make add the ```cnaas::graylog_content_import:``` class, then specifie 2 values:
* content_pack: This is where you put the name of the content pack you want to install
* revision: The version of the pack you are installing.
````yaml
norpan-graylog.cnaas.io:
  sunet::dockerhost:
    docker_version: '5:19.03.12~3-0~ubuntu-focal'
    docker_package_name: 'docker-ce'
    compose_version: '1.23.2'
    manage_dockerhost_unbound: true
  cnaas::graylog:
  cnaas::graylog_content_import:
    content_pack: 'graylog-content-pack-suexport2022'
    revision: '1'
````
