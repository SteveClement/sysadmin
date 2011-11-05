FQDN=dummy.ion.lu
FQDN=$1
  openssl req -new > $FQDN.CA.csr
  openssl rsa -in privkey.pem -out $FQDN.CA.key
  openssl x509 -in $FQDN.CA.csr -out $FQDN.CA.cert -req -signkey $FQDN.CA.key -days 365
  openssl x509 -req -in $FQDN.CA.csr -out $FQDN.client.CA.cert -signkey $FQDN.CA.key -CA $FQDN.CA.cert -CAkey $FQDN.CA.key -CAcreateserial -days 365
