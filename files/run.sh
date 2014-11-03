#!/usr/bin/env bash


## SCRIPT VARIABLES
########################################

## Set path to config dir
CONFIG_DIR="/etc/transmission-daemon"

## Set path to settings file
SETTINGS="${CONFIG_DIR}/settings.json"

## Set path to blocklist directory
BLOCKLIST_DIR="${CONFIG_DIR}/blocklists"

## Set blocklist URL
BLOCKLIST_URL="http://list.iblocklist.com/?list=bt_level1&fileformat=p2p&archiveformat=gz"


## PRE-RUN CONFIGURATION
########################################

## Set the RPC_USER variable if unset
if [[ ! -z "$(grep '{{RPC_USER}}' ${SETTINGS})" ]]; then

    ## Check for RPC_USER env var
    if [[ -z "${RPC_USER}" ]]; then
        echo "ERROR: RPC_USER environment variable not set"; exit 1
    fi

    ## Set rpc-user value
    sed -i -e "s/{{RPC_USER}}/${RPC_USER}/" ${SETTINGS} || exit 1

fi

## Set the RPC_PASS variable if unset
if [[ ! -z "$(grep '{{RPC_PASS}}' ${SETTINGS})" ]]; then

    ## Check for RPC_PASS env var
    if [[ -z "${RPC_PASS}" ]]; then
        echo "ERROR: RPC_PASS environment variable not set"; exit 1
    fi

    ## Set rpc-password value
    sed -i -e "s/{{RPC_PASS}}/${RPC_PASS}/" ${SETTINGS} || exit 1

fi


## SCRIPT ACTIONS
########################################

## Create the blocklist directory
if [[ ! -d "${BLOCKLIST_DIR}" ]]; then
    mkdir --verbose --parents ${BLOCKLIST_DIR}
fi

## Download updated blocklist
wget -qO- "${BLOCKLIST_URL}" | gunzip > ${BLOCKLIST_DIR}/bt_level1

## Run transmission-daemon
transmission-daemon --foreground --log-info --config-dir ${CONFIG_DIR} || exit 1
