#!/bin/bash

set -x

DIR1=`dirname $0`

EAP_TYPE=${EAP_TYPE:-"domain"}
#EAP_TYPE=${EAP_TYPE:-"standalone"}
SERVER_DIR=${1:-$DIR1/$EAP_TYPE}

HOST_CONFIG=${HOST_CONFIG:-"host.xml"}
#HOST_CONFIG=${HOST_CONFIG:-"host-master.xml"}
PORT_OFFSET=${PORT_OFFSET:-0}

BIND_ADDRESS=${BIND_ADDRESS:-127.0.0.1}
BIND_ADDRESS_MNGT=${BIND_ADDRESS_MNGT:-$BIND_ADDRESS}

if ! [ -d "$SERVER_DIR" ] ; then
    mkdir -p "$SERVER_DIR"
    tar -C $EAP_HOME/$EAP_TYPE -cf - . | tar -C $SERVER_DIR -xvf - || exit 1
fi

case "$EAP_TYPE" in
    domain)
	$EAP_HOME/bin/domain.sh \
	    --host-config=${HOST_CONFIG} \
	    -Djboss.domain.base.dir=${SERVER_DIR} \
	    -Djboss.bind.address=$BIND_ADDRESS \
	    -Djboss.bind.address.unsecure=$BIND_ADDRESS \
	    -Djboss.bind.address.management=$BIND_ADDRESS_MNGT \
	    -Djboss.socket.binding.port-offset=$PORT_OFFSET \

	;;
    standalone)
	$EAP_HOME/bin/standalone.sh \
	    -Djboss.server.base.dir=${1:-$SERVER_DIR} \
	    -Djboss.bind.address=$BIND_ADDRESS \
	    -Djboss.bind.address.unsecure=$BIND_ADDRESS \
	    -Djboss.bind.address.management=$BIND_ADDRESS_MNGT \
	    -Djboss.socket.binding.port-offset=$PORT_OFFSET \
	
	;;
esac
#
# -Djboss.default.multicast.address=230.0.0.12
#

