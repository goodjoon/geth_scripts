#!/bin/sh

export ETH_HOME=$HOME/blockchain/ethereum/go-ethereum
export ETH_DBROOT=$ETH_HOME/db
export BIN=$ETH_HOME/bin/geth

export DBNAME=ropsten_light
#export NETWORK_ID=1
#export PORT=30303
export RPC_PORT=8545
export IPC_PATH=geth.ipc
export DATADIR=${ETH_DBROOT}/${DBNAME}

export RPC_API=eth,web3,net,personal,db,debug,admin,miner
#CURDATETIME=`date +"%Y%m%d_%H%M%S"`
CURDATETIME=`date +"%Y%m%d"`

BOOTNODES="enode://20c9ad97c081d63397d7b685a412227a40e23c8bdc6688c6f37e97cfbc22d2b4d1db1510d8f61e6a8866ad7f0e17c02b14182d37ea7c3c8b9c2683aeb6b733a1@52.169.14.227:30303,enode://6ce05930c72abc632c58e2e4324f7c7ea478cec0ed4fa2528982cf34483094e9cbc9216e7aa349691242576d552a2a56aaeae426c5303ded677ce455ba1acd9d@13.84.180.240:30303"

CMD=$1

#if [ "$CMD" = "miner" ] || [ "$CMD" = "mine" ] || [ "$CMD" = "--mine" ]
if [ "$CMD" = "mine" ]
then
	echo Running Miner...
	OPTS="--datadir ${DATADIR} --rpc --rpcaddr 0.0.0.0 --rpcport ${RPC_PORT} --rpcapi ${RPC_API} --rpccorsdomain \"*\" --ipcpath ${IPC_PATH} --testnet --etherbase 0 --cache 64 --syncmode light"
	shift
	echo Options : $OPTS
	nohup $BIN $OPTS $* > ${ETH_HOME}/logs/${DBNAME}.log &
#tail -f ${ETH_HOME}/logs/${CURDATETIME}.log 
elif [ "$CMD" = "attach" ]
then
	OPTS="--datadir ${DATADIR} attach ipc:${DATADIR}/${IPC_PATH}"
	shift
	$BIN $OPTS $*
elif [ "$CMD" = "client" ]
then
	echo Running Client
	OPTS="--datadir ${DATADIR} --rpc --rpcaddr 0.0.0.0 --rpcport ${RPC_PORT} --rpcapi ${RPC_API} --rpccorsdomain \"*\" --ipcpath ${IPC_PATH} --testnet --syncmode fast"
	shift
	echo Options : $OPTS
	nohup $BIN $OPTS --bootnodes $BOOTNODES $* > ${ETH_HOME}/logs/${DBNAME}.log &
else
	OPTS="--datadir ${DATADIR} "
	$BIN $OPTS $*
fi

