#!/bin/bash

source $HOME/.private

wget --timeout=30 -q -O- "http://ddns.corp.redhat.com/redhat-ddns/updater.php?name=$DDNS_HOSTNAME&domain=usersys.redhat.com&hash=$DDNS_HASH"
