#!/bin/bash
#
#This script  matches node_ids for given roles
#Output: A string which can be used to run a custom graph on different nodes


help_usage()
{
    echo "This script matches node_ids for given roles"
    echo "USAGE:"
    echo "$0 [-d] -e ENV [-t GRAPH_TYPE]  [-r ROLES [ROLES ...]] [-n NODES [NODES ...]] [--reboot]"
    echo "Ex: $0 -d -e 36 -t update_custom_graph -r compute swift -n 129 130"
}

fill_template()
{
   PWD1=`echo ${PWD} | sed  's/[/]/\\\\&/g'`
   sed   "s/\${src_path}/${PWD1}/g" $FILE_GRAPH_TEMPL >$FILE_GRAPH_YAML

   [ $reboot -eq 0 ] && sed "s/\${reboot_task}//g" -i $FILE_GRAPH_YAML 

   sed -E 's/\$\{reboot_task\}/\
- id: reboot_nodes\
  type: reboot\
  version: 2.1.0\
  groups: ['"'\/.*\/'"']\
  required_for: [deploy_end]\
  requires:  [update-packages, deploy_start]\
  condition:\
  parameters:\
    timeout: 3600\
    strategy:\
      type: parallel\
      amount: 1/' -i $FILE_GRAPH_YAML
}


upload_custom_graph()
{
   [ `fuel2 graph list -e $env | grep -w $graph | wc -l` -gt 0 ] && echo "Graph name $graph id already in nailgun. Overwriting..." 
   [ $DEBUG -eq 1 ] && echo "Uploading custom graph: "$graph
   res=`fuel2 graph upload --env $env --type $graph --file $FILE_GRAPH_YAML` 
   [ $DEBUG -eq 1 ] && echo $?
   [ $DEBUG -eq 1 ] && echo $res
}

if [ "$#" -eq 0 ] ;  then help_usage $@ ; exit 1; fi

FILE_GRAPH_TEMPL="update_pkgs_fuel_graph.template"
FILE_GRAPH_YAML="update_pkgs_fuel_graph.yaml"
DEBUG=0 # Debug mode ON if 1
roles=""
nodes=""
reboot=0
while [ "$#" -gt 0 ]; do
  case "$1" in
    -d) DEBUG=1 ; shift 1;;
    -e) env="$2"; shift 2;;
    -t) graph="$2"; shift 2;;
    -r) shift 1; while [ x${1:0:1} != x'-' ] && [ "$#" -gt 0 ] ;do roles=${roles}" -e "$1; shift 1   ;done   ;;
    -n) shift 1; while [ x${1:0:1} != x'-' ] && [ "$#" -gt 0 ] ;do nodes=${nodes}" "$1;    shift 1   ;done   ;;
    --reboot) echo "Attention! Reboot requested!"; reboot=1; shift 1;;
    *)  help_usage $@; exit 1;;
  esac
done

fill_template $@

[ $graph ] || graph="upd_pkgs_graph"

upload_custom_graph $@

[ $DEBUG -eq 1 ] && echo "Role list in arguments="$roles
[ $DEBUG -eq 1 ] && echo "Node list in arguments="$nodes

if [ "x${roles}" != 'x' ] ; then rolenodes=`fuel2 node list | grep -w $roles | awk -F"|" '{print $2}'` ; fi

rolenodes=`echo $rolenodes | tr -s '\n' ' '`
[ $DEBUG -eq 1 ] && echo "Node list matched by roles="$rolenodes

echo "fuel2 graph execute --env $env --type $graph -n $rolenodes$nodes"
