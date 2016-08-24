#!/bin/bash
#
#This script  matches node_ids for given roles
#Output: A string which can be used to run a custom graph on different nodes


help_usage()
{
    echo "This script matches node_ids for given roles"
    echo "USAGE:"
    echo "$0 -e ENV [-t GRAPH_TYPE]  [-r ROLES [ROLES ...]] [-n NODES [NODES ...]]"
    echo "Ex: $0 -e 36 -t update_custom_graph -r compute swift -n 129 130"
}


if [ "$#" -eq 0 ] ;  then help_usage $@ ; exit 1; fi
 
roles=""
nodes=""
while [ "$#" -gt 0 ]; do
  case "$1" in
    -e) env="$2"; shift 2;;
    -t) graph="$2"; shift 2;;
    -r) shift 1; while [ x${1:0:1} != x'-' ] && [ "$#" -gt 0 ] ;do roles=${roles}" -e "$1; shift 1   ;done   ;;
    -n) shift 1; while [ x${1:0:1} != x'-' ] && [ "$#" -gt 0 ] ;do nodes=${nodes}" "$1;    shift 1   ;done   ;;
    *)  help_usage $@; exit 1;;
  esac
done

echo "Role list in arguments="$roles
echo "Node list in arguments="$nodes

if [ "x${roles}" != 'x' ] ; then rolenodes=`fuel2 node list | grep -w $roles | awk -F"|" '{print $2}'` ; fi

rolenodes=`echo $rolenodes | tr -s '\n' ' '`
echo "Node list matched by roles="$rolenodes

echo "fuel2 graph execute --env $env --type $graph -n $rolenodes$nodes"
