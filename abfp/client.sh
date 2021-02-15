#!/bin/bash

PORT=2021

IP_CLIENT="127.0.0.1"
IP_SERVER="127.0.0.1"

FILE_NAME="archivo_salida.vaca"

echo "Cliente de ABFP"

echo "(2) SENDING HEADERS"

echo "ABFP $IP_CLIENT" | nc -q 1 $IP_SERVER $PORT

echo "(3) LISTEN CONNECTION RESPONSE"

RESPONSE=`nc -l -p $PORT`

if [ "$RESPONSE" != "OK_CONN" ]; then
	echo "No se ha podido conectar con el servidor"
	exit 1
fi

echo "(6) SENDING HANDSHAKE" 

sleep 1
echo "THIS_IS_MY_CLASSROOM" | nc -q 1 $IP_SERVER $PORT


echo "(7) LISTEN HANDSHAKE"

RESPONSE=`nc -l -p $PORT`

if [ "$RESPONSE" != "YES_IT_IS" ]; then
	echo "No se ha recibido correctamente el Handshake"

	exit 2
fi


echo "(10) SENDING FILE_NAME"


sleep 1
echo "FILE_NAME $FILE_NAME" | nc -q 1 $IP_SERVER $PORT

sleep 1 

FILE_MD5=`echo -n $FILE_NAME | md5sum`
echo "FILE_MD5 $FILE_MD5" | nc -q 1 $IP_SERVER $PORT

echo "(11) LISTEN FILE_NAME RESPONSE"

RESPONSE=`nc -l -p $PORT`

echo "TEST FILE_NAME RESPONSE"

if [ "$RESPONSE" != "OK_FILE_NAME" ]; then
# echo "Error al enviar el nombre del archivo"

	exit 3
fi

echo "TEST FILE_MD5 RESPONSE"

if [ "$RESPONSE" != "OK" ]; then
	echo "Error al enviar el MD5 del archivo"

	exit 4
fi

echo "(14) SENDING DATA"

sleep 1
cat $FILE_NAME | nc -q l $IP_SERVER $PORT

sleep 1
cat $FILE_MD5 | nc -q 1 $IP_SERVER $PORT 

exit 0
