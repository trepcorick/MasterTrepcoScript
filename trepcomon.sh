#!/bin/bash
# Chonosmon 1.0 - Trepco Masternode Monitoring 

#Processing command line params
if [ -z $1 ]; then dly=1; else dly=$1; fi   # Default refresh time is 1 sec

datadir="/$USER/.trepco$2"   # Default datadir is /root/.trepco
 
# Install jq if it's not present
dpkg -s jq 2>/dev/null >/dev/null || sudo apt-get -y install jq

#It is a one-liner script for now
watch -ptn $dly "echo '===========================================================================
Outbound connections to other Trepco nodes [trepco datadir: $datadir]
===========================================================================
Node IP               Ping    Rx/Tx     Since  Hdrs   Height  Time   Ban
Address               (ms)   (KBytes)   Block  Syncd  Blocks  (min)  Score
==========================================================================='
trepco-cli -datadir=$datadir getpeerinfo | jq -r '.[] | select(.inbound==false) | \"\(.addr),\(.pingtime*1000|floor) ,\
\(.bytesrecv/1024|floor)/\(.bytessent/1024|floor),\(.startingheight) ,\(.synced_headers) ,\(.synced_blocks)  ,\
\((now-.conntime)/60|floor) ,\(.banscore)\"' | column -t -s ',' && 
echo '==========================================================================='
uptime
echo '==========================================================================='
echo 'Masternode Status: \n# trepco-cli masternode status' && trepco-cli -datadir=$datadir masternode status
echo '==========================================================================='
echo 'Sync Status: \n# trepco-cli mnsync status' &&  trepco-cli -datadir=$datadir mnsync status
echo '==========================================================================='
echo 'Masternode Information: \n# trepco-cli getinfo' && trepco-cli -datadir=$datadir getinfo
echo '==========================================================================='
echo 'Usage: trepcomon.sh [refresh delay] [datadir index]'
echo 'Example: trepcomon.sh 10 22 will run every 10 seconds and query trepcod in /$USER/.trepco22'
echo '\n\nPress Ctrl-C to Exit...'"
