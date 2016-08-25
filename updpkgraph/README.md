# Update packages on roles (FUEL LCM Approach)

### About
It is possible to update/install any package(s) on any node(s) inside the cloud by using Fuel client. Automation script in this repo creates a Fuel graph, uploads it to nailgun and forms up fuel-cli command ready to execute. 

### Requirements
Deployed Fuel 9.0 (Mitaka) Master Node

###Use cases to apply:
	packages/1-role,
	packages/multi-roles,
	packages/all-roles,
	packages/1-node,
	packages/bunch-of-nodes,
	packages/all-nodes
	packages/combination of roles and nodes

###common.yaml
The file contains two hashes: versions for specific packages and versions for bunch of packages (regular expressions). 

####Example:
```
static_versions:
  openssh-client: '1:6.6p1-2ubuntu2.8'
  libcurl3 : '7.35.0-1ubuntu2.8'
  mc : latest
group_versions:
  ^apache2.*$ : '2.4.7-1ubuntu4.13'
  ^grub.*$ : latest
```

##Usage
`git clone https://github.com/vmaliaev/LCMFuel && cd ./LCMFuel/updpkgraph`

Make all the needed changes in `common.yaml`

Run the script: 
```
        ./packages_update.sh [-d] -e ENV [-t GRAPH_TYPE]  [-r ROLE [ROLE ...]] [-n NODE [NODE ...]] [--reboot]
  	-e - environment id, choose the id from output of 'fuel2 env list'; mandatory
  	-d - debug mode
  	-t - graph type, point it only if you want to use particular graph_type
  	-r - role(s)
  	-n - node(s)
  	--reboot - reboot nodes after package update
```

It is possible to use only roles or nodes, or combination of roles and nodes.
If no roles and nodes are pointed then all nodes will be updated

####Example: 
```
./packages_update.sh -d -e 36 -t upd_test -r compute swift -n 103 --reboot
```

###How to check results
Check tasks status:
```
fuel2 task list
fuel2 task history show <id>
```

While custom graph is running it is convenient to monitor astute log and obtain status and info about tasks on target nodes

For example astute.log (during target node reboot):
```
2016-08-25 12:07:23 WARNING [6000] 06b30a47-b4de-4108-ade8-c3c445f44131: Failed to run shell stat --printf='%Y' /proc/1 on node 129. Error will not raise because shell was run without check
2016-08-25 12:07:23 DEBUG [6000] Cluster[]: Process node: Node[virtual_sync_node]
2016-08-25 12:07:23 DEBUG [6000] Cluster[]: Start processing all nodes
2016-08-25 12:07:23 DEBUG [6000] Cluster[]: Process node: Node[129]
2016-08-25 12:07:23 DEBUG [6000] Node[129]: Node 129: task reboot_nodes, task status running
```
Regarding puppet errors it is useful to check puppet logs on remotely or on target nodes:

```tailf /var/log/remote/node-XX.domain.tld/puppet-apply.log or /var/log/puppet.log on a node```

All the changes in versions of packets are placed in dpkg.log
```
tailf /var/log/dpkg.log
```
