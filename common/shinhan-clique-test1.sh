#!/bin/sh

export ETH_HOME=$HOME/blockchain/ethereum/go-ethereum
export ETH_DBROOT=$ETH_HOME/db
export BIN=$ETH_HOME/bin/geth

export DBNAME=shinhan-clique1
export NETWORK_ID=39
export PORT=30303
export RPC_PORT=8545
export IPC_PATH=geth.ipc
export DATADIR=${ETH_DBROOT}/${DBNAME}
export RPCCORSDOMAIN="*"

export RPC_API=eth,web3,net,personal,db,debug,admin,miner
#CURDATETIME=`date +"%Y%m%d_%H%M%S"`
CURDATETIME=`date +"%Y%m%d"`

CMD=$1

#if [ "$CMD" = "miner" ] || [ "$CMD" = "mine" ] || [ "$CMD" = "--mine" ]
if [ "$CMD" = "mine" ]
then
	echo Running Miner...
	OPTS="--datadir ${DATADIR} --rpc --rpcaddr 0.0.0.0 --port ${PORT} --rpcport ${RPC_PORT} --rpcapi ${RPC_API} --ipcpath ${IPC_PATH} --mine --minerthreads 1 --etherbase 0 --cache 1024 --networkid ${NETWORK_ID} --password ${ETH_DBROOT}/${DBNAME}/passwd --unlock 0,1,2,3,4,5,6 --targetgaslimit 8000000 --syncmode full --nodiscover "
	shift
	echo Options : $OPTS
	nohup $BIN $OPTS --rpccorsdomain "*" $* > ${ETH_HOME}/logs/${DBNAME}.log &
#$BIN $OPTS --rpccorsdomain "*" $* 
#tail -f ${ETH_HOME}/logs/${CURDATETIME}.log 
elif [ "$CMD" = "attach" ]
then
	OPTS="--datadir ${DATADIR} attach ipc:${DATADIR}/${IPC_PATH}"
	shift
	$BIN $OPTS $*
elif [ "$CMD" = "client" ]
then
	echo Running Client
	OPTS="--datadir ${DATADIR} --rpc --rpcaddr 0.0.0.0 --port ${PORT} --rpcport ${RPC_PORT} --rpcapi ${RPC_API} --rpccorsdomain \"*\" --ipcpath ${IPC_PATH} --networkid ${NETWORK_ID}"
	shift
	echo Options : $OPTS
	nohup $BIN $OPTS $* > ${ETH_HOME}/logs/${DBNAME}.log &
else
	OPTS="--datadir ${DATADIR} "
	$BIN $OPTS $*
fi

