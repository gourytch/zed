#!/bin/sh
#
# usage: install_root_crt.sh filename [filename ...]
# see: http://xgu.ru/wiki/OpenSSL

for CERTFILE in "$@"; do
  # Убедиться, что файл существует и это сертификат
  test -f "$CERTFILE" || continue
  HASH=$(openssl x509 -noout -hash -in "$CERTFILE")
  test -n "$HASH" || continue
  dst="/etc/ssl/certs/$CERTFILE"
  test -f "$dst" && continue
  sudo cp "$CERTFILE" "$dst"

  # использовать для ссылки наименьший итератор
  for ITER in 0 1 2 3 4 5 6 7 8 9; do
    test -f "/etc/ssl/certs/${HASH}.${ITER}" && continue
    sudo ln -s "$CERTFILE" "/etc/ssl/certs/${HASH}.${ITER}"
    test -L "/etc/ssl/certs/${HASH}.${ITER}" && break
  done
done
