# Update packages on roles (FUEL LCM Approach)

### About
It is possible to update/install any package(s) on any node(s) inside the cloud by using Fuel client. Automation script in this repo forms up fuel-cli command ready to execute. 

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
The file contains two hashes: static versions and versions for bunch of packages (regular expressions). 

Example:
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
"git clone https://github.com/vmaliaev/LCMFuel/tree/master/updpkgraph && cd updpkgraph"

Make all the needed changes in `common.yaml`

Load custom graph in Fuel:
Example: 
`fuel2 graph upload --env 36 --type upd_test3 --file update_pkgs_fuel_graph.yaml`

Run packages_update.sh:
Example:
`./packages_update.sh -e 36  -t upd_test3 -r compute lcm -n 123 321 222`
