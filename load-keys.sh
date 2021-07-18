#!/usr/bin/env bash

# Simple script to load SSH keys into agent

set -e

# declare array of abbreviations
declare -a abbv=(gh gl bb)

clear ||:
echo '------------------------------'
echo 'Adding SSH Keys to SSH-Agent'
echo '------------------------------'
echo ''

# now loop through array
for i in "${abbv[@]}"
do
    KEY_NAME="id_ed25519_${i}_demo"
    KEY_PATH="/home/${USER}/.ssh/${KEY_NAME}"
    echo "Adding SSH Key: ${KEY_NAME}"
    ssh-add "$KEY_PATH"
    echo ''
done

echo "Finished"
echo

# end script