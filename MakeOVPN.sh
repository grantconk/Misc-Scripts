#!/bin/bash

DEFAULT="Default.txt"
FILEEXT=".ovpn"
CRT=".crt"
KEY=".3des.key"
CA="ca.crt"
TA="ta.key"

# Check if argument was provided for NAME
if [ ! $1 ]; then
  echo "Usage: MakeOPVN.sh <name> [<name>]..."
  exit
fi

while [[ $# > 0 ]]
do
  NAME=$1

# Verify that client's public key exists
if [ ! -f $NAME$CRT ]; then
  echo "[ERROR]: Client public key certificate not found: $NAME$CRT"
  exit
fi
echo "Client's cert found: $NAME$CRT"

# Verify that there is a private key for that client
if [ ! -f $NAME$KEY ]; then
  echo "[ERROR]: Client 3des private key not found: $NAME$KEY"
  exit
fi
echo "Client's private key found: $NAME$KEY"

# Confirm the CA public key exists
if [ ! -f $CA ]; then
  echo "[ERROR]: CA public key not found: $CA"
  exit
fi
echo "CA public key found: $CA"

# Confirm the tls-auth ta key file exists
if [ ! -f $TA ]; then
  echo "[ERROR]: tls-auth key not found: $TA"
  exit
fi
echo "tls-auth private key found: $TA"

# Ready to make a new .opvn file
cat $DEFAULT > $NAME$FILEEXT

# Append the CA public cert
echo "<ca>" >> $NAME$FILEEXT
cat $CA >> $NAME$FILEEXT
echo "</ca>" >> $NAME$FILEEXT

# Append the client public cert
echo "<cert>" >> $NAME$FILEEXT
cat $NAME$CRT | sed -ne '/-BEGIN CERTIFICATE-/,/-END CERTIFICATE-/p' >> $NAME$FILEEXT
echo "</cert>" >> $NAME$FILEEXT

# Append the client private key
echo "<key>" >> $NAME$FILEEXT
cat $NAME$KEY >> $NAME$FILEEXT
echo "</key>" >> $NAME$FILEEXT

# Append the TA private key
echo "<tls-auth>" >> $NAME$FILEEXT
cat $TA >> $NAME$FILEEXT
echo "</tls-auth>" >> $NAME$FILEEXT
echo "Done! $NAME$FILEEXT successfully created."

  echo "$1 completed"
  shift
done
