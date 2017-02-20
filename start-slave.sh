#!/bin/bash

set -x

DIR1=`dirname $0`

EAP_TYPE=${EAP_TYPE:-"domain"}
SERVER_DIR=${1:-$DIR1/$EAP_TYPE}

HOST_CONFIG=${HOST_CONFIG:-"host-slave.xml"}
#PORT_OFFSET=${PORT_OFFSET:-100}

BIND_ADDRESS=${BIND_ADDRESS:-127.1.0.2}
BIND_ADDRESS_MNGT=${BIND_ADDRESS_MNGT:-$BIND_ADDRESS}

if ! [ -d "$SERVER_DIR" ] ; then
    mkdir -p "$SERVER_DIR"
    tar -C $EAP_HOME/$EAP_TYPE -cf - . | tar -C $SERVER_DIR -xvf - || exit 1
fi

HOST_NAME=${HOST_NAME:-`basename $SERVER_DIR`}

case "$EAP_TYPE" in
    domain)
	$EAP_HOME/bin/domain.sh \
	    --host-config=${HOST_CONFIG} \
	    -Djboss.host.name=${HOST_NAME} \
	    -Djboss.domain.master.address=${MASTER_ADDRESS:-127.0.0.1}  \
	    -Djboss.bind.address=$BIND_ADDRESS \
	    -Djboss.bind.address.unsecure=$BIND_ADDRESS \
	    -Djboss.bind.address.management=$BIND_ADDRESS_MNGT \
	    -Djboss.domain.base.dir=${SERVER_DIR} \

	;;
    standalone)
	echo "Standalone mode is not supported. Use start-eap.sh instead"
	exit 1
	;;
esac
