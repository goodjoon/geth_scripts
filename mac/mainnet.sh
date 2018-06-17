#!/bin/sh

export ETH_HOME=$HOME/blockchain/ethereum/go-ethereum
export ETH_DBROOT=$ETH_HOME/db
export BIN=$ETH_HOME/bin/geth

export DBNAME=homestead
export NETWORK_ID=1
export PORT=30303
export RPC_PORT=8545
export IPC_PATH=geth.ipc
export DATADIR=${ETH_DBROOT}/${DBNAME}

export RPC_API=eth,web3,net,personal,db,debug,admin,miner
#CURDATETIME=`date +"%Y%m%d_%H%M%S"`
CURDATETIME=`date +"%Y%m%d"`


CMD=$1

if [ "$CMD" = "miner" ] || [ "$CMD" = "mine" ] || [ "$CMD" = "--mine" ]
then
	echo Running Miner...
	OPTS="--datadir ${DATADIR} --rpc --rpcaddr 0.0.0.0 --rpcport ${RPC_PORT} --rpcapi ${RPC_API} --rpccorsdomain \"*\" --networkid ${NETWORK_ID} --ipcpath ${IPC_PATH} --mine --minerthreads 1"
	shift
	echo Options : $OPTS
	nohup $BIN $OPTS $* > ${ETH_HOME}/logs/${CURDATETIME}.log &
#tail -f ${ETH_HOME}/logs/${CURDATETIME}.log 
elif [ "$CMD" = "attach" ]
then
	OPTS="--datadir ${DATADIR} attach ipc:${DATADIR}/${IPC_PATH}"
	shift
	$BIN $OPTS $*
elif [ "$CMD" = "client" ]
then
	echo Running Client
	OPTS="--datadir ${DATADIR} --rpc --rpcaddr 0.0.0.0 --rpcport ${RPC_PORT} --rpcapi ${RPC_API} --rpccorsdomain \"*\" --networkid ${NETWORK_ID} --ipcpath ${IPC_PATH} "
	shift
	echo Options : $OPTS
	nohup $BIN $OPTS $* > ${ETH_HOME}/logs/client.log &
else
	OPTS="--datadir ${DATADIR} "
	$BIN $OPTS $*
fi

