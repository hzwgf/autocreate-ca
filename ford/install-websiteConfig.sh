#!/usr/bin/env bash
echo -n 'plean input your domain:'
read domain
cd /root/ca;

##生成秘钥
openssl genrsa -aes256 \
      -out intermediate/private/$domain.key.pem 2048;
chmod 400 intermediate/private/$domain.key.pem;
##生成证书请求
openssl req -config intermediate/openssl.cnf \
      -key intermediate/private/$domain.key.pem \
      -new -sha256 -out intermediate/csr/$domain.csr.pem;
##ca自签名证书
openssl ca -config intermediate/openssl.cnf \
      -extensions server_cert -days 375 -notext -md sha256 \
      -in intermediate/csr/$domain.csr.pem \
      -out intermediate/certs/$domain.cert.pem;
chmod 444 intermediate/certs/$domain.cert.pem;
openssl x509 -noout -text \
      -in intermediate/certs/$domain.cert.pem;
##证书链验证证书
openssl verify -CAfile intermediate/certs/ca-chain.cert.pem \
      intermediate/certs/$domain.cert.pem;
