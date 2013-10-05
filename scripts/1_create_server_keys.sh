#! /bin/bash

set -e
set -x

. config

# генерим серверный ключ
openssl genrsa -out $aws_key $len
openssl req -new -subj "$subj_srv" -key $aws_key -out $aws_csr
# openssl ca -in $aws_csr -cert $root_crt -keyfile $root_key -out $aws_crt
openssl x509 -req -in $aws_csr -CA $root_crt -CAkey $root_key -CAcreateserial -days $days -out $aws_crt
cat $aws_key $aws_crt > $aws_pem
