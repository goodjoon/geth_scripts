#!/bin/sh

export ETH_HOME=$HOME/blockchain/ethereum/go-ethereum
export ETH_DBROOT=$ETH_HOME/db
export BIN=$ETH_HOME/bin/geth

export DBNAME=skt-pow-test1
export NETWORK_ID=66
export PORT=30323
export RPC_PORT=8565
export IPC_PATH=geth.ipc
export DATADIR=${ETH_DBROOT}/${DBNAME}

export RPC_API=eth,web3,net,personal,db,debug,admin,miner

#CURDATETIME=`date +"%Y%m%d_%H%M%S"`
CURDATETIME=`date +"%Y%m%d"`


CMD=$1

if [ "$CMD" = "mine" ]
then
	echo Running Miner...
	OPTS="--datadir ${DATADIR} --rpc --rpcaddr 0.0.0.0 --rpcport ${RPC_PORT} --rpcapi ${RPC_API} --rpccorsdomain \"*\" --ipcpath ${IPC_PATH} --mine --minerthreads 1 --networkid ${NETWORK_ID} --port ${PORT}"
	shift
	echo Options : $OPTS
	nohup $BIN $OPTS $* > ${ETH_HOME}/logs/${DBNAME}.log &
#tail -f ${ETH_HOME}/logs/${CURDATETIME}.log 
elif [ "$CMD" = "attach" ]
then
	OPTS="--datadir ${DATADIR} attach ipc:${DATADIR}/${IPC_PATH}"
	shift
	$BIN $OPTS $*
else
	OPTS="--datadir ${DATADIR} "
	$BIN $OPTS $*
fi

