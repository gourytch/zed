#! /bin/bash

set -e
set -x

. config

test $k && rm -rf $k
mkdir -p $k

# генерим главный сертификат
openssl genrsa -out $root_key $len
openssl req -new -subj "$subj_ca" -key $root_key -out $root_csr
openssl x509 -req -days $days -in $root_csr -signkey $root_key -out $root_crt

