# Rabbitmq Playbook

HelloFresh extension of the RabbitMQ playbook which allows clustering. Originally written by [Mayeu](https://github.com/Mayeu/ansible-playbook-rabbitmq).

Playbook to install and configure rabbitmq. Will come with various
configuration tweaking later on.

If you wish to discuss modifications, or help to support more platforms, open
an issue.

### Environment

|Name|Type|Description|Default|
|----|----|-----------|-------|
`rabbitmq_conf_env`|Hash|Set environment variable|undef|

Example:

```yaml
rabbitmq_conf_env:
  RABBITMQ_ROCKS: correct
```

Will generate:

```
RABBITMQ_ROCKS="correct"
```

### Certificate

|Name|Type|Description|Default|
|----|----|-----------|-------|
`rabbitmq_cacert`|String|Path of the CA certificate file.|`files/rabbitmq_cacert.pem`
`rabbitmq_server_key`|String|Path of the SSL key file.|`files/rabbitmq_server_key.pem`
`rabbitmq_server_cert`|String|Path of the SSL certificate file.|`files/rabbitmq_server_cert.pem`
`rabbitmq_ssl`|Boolean|Define if we need to use SSL|`true`

### Default configuration file

|Name|Type|Description|Default|
|----|----|-----------|-------|
`rabbitmq_conf_tcp_listeners_address`|String|listening address for the tcp interface|`''`
`rabbitmq_conf_tcp_listeners_port`|Integer|listening port for the tcp interface|`5672`
`rabbitmq_conf_ssl_listeners_address`|String|listening address for the ssl interface|`'0.0.0.0'`
`rabbitmq_conf_ssl_listeners_port`|Integer|listening port for the ssl interface|`5671`
`rabbitmq_conf_ssl_options_cacertfile`|String|Path the CA certificate|`"/etc/rabbitmq/ssl/cacert.pem"`
`rabbitmq_conf_ssl_options_certfile`|String|Path to the server certificate|`"/etc/rabbitmq/ssl/server_cert.pem"`
`rabbitmq_conf_ssl_options_keyfile`|String|Path to the private key file|`"/etc/rabbitmq/ssl/server_key.pem"`
`rabbitmq_conf_ssl_options_fail_if_no_peer_cert`|Boolean|Value of the `fail_if_no_peer_cert` SSL option|`"true"`

### Plugins

|Name|Type|Description|Default|
|----|----|-----------|-------|
`rabbitmq_new_only`|String|Add plugins as new, without deactivating other plugins|`'no'`
`rabbitmq_plugins`|String|List|List of plugins to activate|`[]`

### Vhost

|Name|Type|Description|Default|
|----|----|-----------|-------|
`rabbitmq_vhost_definitions`|List|Define the list of vhost to create|`[]`
`rabbitmq_users_definitions`|List of hash|Define the users, and associated vhost and password (see below)|`[]`

Defining the vhosts configuration

```yaml
rabbitmq_vhost_definitions:
  - name:    vhost1
    node:    node_name #Optional, defaults to "rabbit"
    tracing: yes       #Optional, defaults to "no"
```

Defining the users configuration:

```yaml
rabbitmq_users_definitions:
  - vhost:    vhost1
    user:     user1
    password: password1
    node:     node_name  # Optional, defaults to "rabbit"
    configure_priv: "^resource.*" # Optional, defaults to ".*"
    read_priv: "^$" # Disallow reading.
    write_priv: "^$" # Disallow writing.
  - vhost:    vhost1
    user:     user2
    password: password2
    force:    no
    tags:                # Optional, user tags
    - administrator
```

## Cluster

# Limitations
If you remove a node from inventory and node is still running it will not be removed

### Federation

|Name|Type|Description|Default|
|----|----|-----------|-------|
`rabbitmq_federation`|Boolean|Define if we need to setup federation|`false`
`rabbitmq_federation_configuration`|List of hashes|Define all the federation we need to setup|Not defined
`rabbitmq_policy_configuration`|List of hashes|Define all the federation we need to setup|Not defined

Defining the federation upstream configuration:

```yaml
rabbitmq_federation_upstream:
  - name: upstream name
    vhost: local vhost to federate
    value: json description of the federation
    local_username: the local username for the federation
```

See the [RabbitMQ documentation](http://www.rabbitmq.com/federation.html) for
the possible JSON value.

Defining the policy configuration:

```yaml
rabbitmq_policy_configuration:
  - name: name of the policy
    vhost: vhost where the policy will be applied
    pattern: pattern of the policy
    tags: description of the policy in dict form # exemple: "ha-mode=all"
```

## Files required

You have to put the needed certificates in your `files/` folder, for example:

    files/
     |- cacert.crt
     |- myserver_key.key
     |- myserver_cert.crt

And then configure the role:

```yaml
    rabbitmq_cacert: files/cacert.crt
    rabbitmq_server_key: files/myserver_key.key
    rabbitmq_server_cert: files/myserver_cert.crt
```

## Variables

```yaml
# Take the package given by the OS/distrib
rabbitmq_os_package                           : false

# Plugins
rabbitmq_plugins                              : []
rabbitmq_new_only                             : 'no'

# VHOST
rabbitmq_vhost_definitions                    : []
rabbitmq_users_definitions                    : []

# Avoid setting up federation
rabbitmq_federation                           : false

# defaults file for rabbitmq
rabbitmq_cacert                               : "files/rabbitmq_cacert.pem"
rabbitmq_server_key                           : "files/rabbitmq_server_key.pem"
rabbitmq_server_cert                          : "files/rabbitmq_server_cert.pem"
rabbitmq_ssl                                  : true

## Optional logging
##  none, error, warnings, info, debug
# rabbitmq_log_level                           :
#                                                  channel    : error
#                                                  connection : error
#                                                  federation : error
#                                                  mirroring  : error

# ######################
# RabbitMQ Configuration
# ######################

# rabbitmq TCP configuration
rabbitmq_conf_tcp_listeners_address           : '0.0.0.0'
rabbitmq_conf_tcp_listeners_port              : 5672

# rabbitmq SSL configuration
rabbitmq_conf_ssl_listeners_address           : '0.0.0.0'
rabbitmq_conf_ssl_listeners_port              : 5671
rabbitmq_conf_ssl_options_cacertfile          : "/etc/rabbitmq/ssl/{{ rabbitmq_cacert | basename }}"
rabbitmq_conf_ssl_options_certfile            : "/etc/rabbitmq/ssl/{{ rabbitmq_server_cert | basename }}"
rabbitmq_conf_ssl_options_keyfile             : "/etc/rabbitmq/ssl/{{ rabbitmq_server_key | basename }}"
rabbitmq_conf_ssl_options_fail_if_no_peer_cert: "true"

rabbitmq_env                                  : false
# Guest options
remove_guest_user                             : true

# Enable cluster
rabbitmq_clustering                           : false
## Erlang cookie
rabbitmq_erlang_cookie_path                   : "/var/lib/rabbitmq/.erlang.cookie"
rabbitmq_erlang_cookie                        : beKSqkmoLrtvVfjOytLOQpATbGVEGbVA #test cookie, override for production
## Cluster options
rabbitmq_cluster_instance_to_join_index       : 0
rabbitmq_cluster_instance_to_join             : "{{ groups[rabbitmq_cluster_group][rabbitmq_cluster_instance_to_join_index].split('.')[0] }}"
rabbitmq_cluster_group                        : rabbit_cluster
rabbitmq_cluster_post_fix_domain              : "production.example.com"
# Automation user for cluster. You should encrypt
rabbitmq_cluster_api_user                     : "api-automation"
rabbitmq_cluster_api_password                 : "api-password"

# How to get the IPs of cluster
rabbitmq_clustering_resolve_names             : "ansible" # ['ansible', dns]

## Probably dont need to change that stuff
### Construct a regex to match group before .
rabbitmq_cluster_post_fix_domain_regex_replace: "([^.]*).*"
# Print extra message related to inventory
rabbitmq_cluster_debug                        : false
```

## Testing

License
-------

    Copyright (C) 2016 HelloFresh SE

    Licensed under the Apache License, Version 2.0 (the "License");
    you may not use this file except in compliance with the License.
    You may obtain a copy of the License at

       http://www.apache.org/licenses/LICENSE-2.0

    Unless required by applicable law or agreed to in writing, software
    distributed under the License is distributed on an "AS IS" BASIS,
    WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
    See the License for the specific language governing permissions and
    limitations under the License.


<p align="center">
  <a href="https://hellofresh.com">
    <img width="120" src="https://www.hellofresh.de/images/hellofresh/press/HelloFresh_Logo.png">
  </a>
</p>
