#!/bin/sh

export PATH=$PATH:/usr/local/bin
source $HOME/.private

if [[ -z $TOKEN_TYPE ]]; then
  TOKEN_TYPE=totp
fi

TOKEN=$(oathtool --$TOKEN_TYPE $TOKEN_SEED)

echo "${TOKEN_PIN}${TOKEN}"
