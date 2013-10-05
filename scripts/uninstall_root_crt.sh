#!/bin/sh
#
# usage: install_root_crt.sh filename [filename ...]
# see: http://xgu.ru/wiki/OpenSSL

certs="/etc/ssl/certs"

for CERTFILE in "$@"; do
  # Убедиться, что файл существует и это сертификат
  test -f "$CERTFILE" || continue
  HASH=$(openssl x509 -noout -hash -in "$CERTFILE")
  test -n "$HASH" || continue
  dst="$certs/$CERTFILE"
  test -f "$dst" && sudo rm -f "$dst"

  f0=`readlink -f $dst`
  # использовать для ссылки наименьший итератор
  for ITER in 0 1 2 3 4 5 6 7 8 9; do
    n="$certs/${HASH}.${ITER}"
    if [ -L "$n" ]; then
      f=`reaflink -f $n`
      if [ "x$f0" = "x$n" ]; then
        sudo rm -f "$n"
      fi
    fi
  done
  sudo rm -f "$f0"
done
