#!/bin/bash

PORT=2021

echo "(0) Server ABFP"

echo "(1) Listen $PORT"

HEADER=`nc -l -p $PORT`

echo "Test! $HEADER"

PREFIX=`echo $HEADER | cut -d " " -f 1`
IP_CLIENT=`echo $HEADER | cut -d " " -f 2`

echo "(4) Response"

if [ "$PREFIX" != "ABFP" ]; then

	echo "Error en la cabecera"
	
	sleep 1
	echo "KO_CONN" | nc -q 1 $IP_CLIENT $PORT

	exit 1
fi

sleep 1
echo "OK_CONN" | nc -q 1 $IP_CLIENT $PORT

echo "(5) Listening $PORT"

HANDSHAKE=`nc -l -p $PORT`

echo "(8) Response"

if [ "$PREFIX" != "ABFP" ]; then

	echo "Error en la cabecera"
	
	sleep 1
	echo "KO_HANDSHAKE" | nc -q 1 $IP_CLIENT $PORT

	exit 1
fi

sleep 1
echo "YES_IT_IS" | nc -q 1 $IP_CLIENT $PORT

echo "(9) Listening $PORT"

exit 0