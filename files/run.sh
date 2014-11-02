#!/usr/bin/env bash


## SCRIPT VARIABLES
########################################

## Set path to config dir
CONFIG_DIR="/etc/transmission-daemon"

## Set path to settings file
SETTINGS="${CONFIG_DIR}/settings.json"


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

## Update the blocklist
transmission-remote -n ${RPC_USER}:${RPC_PASS} --blocklist-update

## Run transmission-daemon
transmission-daemon --foreground --log-info --no-portmap --config-dir ${CONFIG_DIR} || exit 1
