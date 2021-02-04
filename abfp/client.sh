#!/bin/bash

PORT=2021

IP_CLIENT="127.0.0.1"
IP_SERVER="127.0.0.1"

echo "Cliente de ABFP"

echo "(2) Sending Headers"

echo "ABFP $IP_CLIENT" | nc -q 1 $IP_SERVER $PORT

echo "(3) Listening $PORT"

RESPONSE=`nc -l -p $PORT`
if [ "$RESPONSE" != "OK_CONN" ]; then
	echo "No se ha podido conectar con el servidor"
	exit 1
fi

echo "(6) Handshake" 

sleep 1
echo "THIS_IS_MY_CLASSROOM" | nc -q 1 $IP_SERVER $PORT

echo "(7) Listening $PORT"

RESPONSE2=`nc -l -p $PORT`
if [ "$RESPONSE2" != "YES_IT_IS" ]; then
	echo "No se ha podidio conectar con el servidor"
	exit 1
fi

exit 0