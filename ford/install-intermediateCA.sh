#!/usr/bin/env bash
mkdir /root/ca/intermediate;
cp cnf/intermediate-ca /root/ca/intermediate/openssl.cnf
cd /root/ca/intermediate;
mkdir certs crl csr newcerts private;
chmod 700 private;
touch index.txt;
echo 1000 > serial;
echo 1000 > /root/ca/intermediate/crlnumber;
cd /root/ca;
#生成中间证书秘钥
openssl genrsa -aes256 \
      -out intermediate/private/intermediate.key.pem 4096;
chmod 400 intermediate/private/intermediate.key.pem;
##生成中间证书请求
openssl req -config intermediate/openssl.cnf -new -sha256 \
      -key intermediate/private/intermediate.key.pem \
      -out intermediate/csr/intermediate.csr.pem;
##生成中间证书
openssl ca -config openssl.cnf -extensions v3_intermediate_ca \
      -days 365 -notext -md sha256 \
      -in intermediate/csr/intermediate.csr.pem \
      -out intermediate/certs/intermediate.cert.pem;
chmod 444 intermediate/certs/intermediate.cert.pem;
##打印中间证书内容
openssl x509 -noout -text \
      -in intermediate/certs/intermediate.cert.pem;
##用根证书验证中间证书内容
openssl verify -CAfile certs/ca.cert.pem \
      intermediate/certs/intermediate.cert.pem;
##创建证书链
cat intermediate/certs/intermediate.cert.pem \
      certs/ca.cert.pem > intermediate/certs/ca-chain.cert.pem;
chmod 444 intermediate/certs/ca-chain.cert.pem;