#!/bin/sh
set -e

if [ "$1" == "run" ]; then
    echo ""
    echo "**** Running tests ****"
    echo "-> Docker creating userdefined network"
    docker network create --subnet 192.168.110.0/24 cluster_network

    echo "-> Create cluster1"
    bundle exec kitchen create cluster1

    echo "-> Create cluster2"
    bundle exec kitchen create cluster2

elif [ "$1" == "destroy" ]; then
    set +e
    echo ""
    echo "**** Running destroy ****"

    echo "-> Destroy cluster1 "
    bundle exec kitchen destroy cluster1
    docker rm cluster1

    echo "-> Destroy cluster2 "
    bundle exec kitchen destroy cluster2
    docker rm cluster2

    echo "-> Docker remove userdefined network"
    docker network rm cluster_network
else
    echo "unsupported option '$1'"
    echo "usage [ run | destroy ]"
    exit 1
fi