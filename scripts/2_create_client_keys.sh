#! /bin/bash

set -e
set -x

if [ "$#" != 1 ]; then
    echo "use $0 username"
    exit 1
fi

cli_name="$1"

. config

mkdir -p $cli_dir
# генерим клиентский ключ
openssl genrsa -out $cli_key $len
openssl req -new -subj "$subj_cli" -key $cli_key -out $cli_csr
#openssl req -new -x509 -days $days -subj "$subj_cli" -key $cli_key -out $cli_csr
#openssl req -new -x509 -days $days -key $cli_key -out $cli_crt
#openssl x509 -req -in $cli_csr -CA $aws_crt -CAkey $aws_key -CAcreateserial -days $days -out $cli_crt
openssl x509 -req -in $cli_csr -CA $root_crt -CAkey $root_key -CAcreateserial -days $days -out $cli_crt
openssl pkcs12 -export -clcerts -passout "$cli_pass" -in $cli_crt -inkey $cli_key -out $cli_p12
