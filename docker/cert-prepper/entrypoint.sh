#!/bin/bash -ex

# Root
openssl genrsa \
    -out /server-secrets/ca.key 2048
openssl req \
    -x509 -new \
    -key /server-secrets/ca.key \
    -subj '/CN=Yoyodyne root CA' -days 7300 -sha256 -nodes \
    -addext 'basicConstraints = critical, CA:true' \
    -addext 'keyUsage = critical, cRLSign, keyCertSign' \
    -addext 'subjectKeyIdentifier = hash' \
    -addext 'authorityKeyIdentifier = keyid:always, issuer' \
    -out /server-secrets/ca.crt

# Intermediate
openssl genrsa \
    -out /server-secrets/intermediate-2026.key 2048
openssl req \
    -x509 -new \
    -CA /server-secrets/ca.crt -CAkey /server-secrets/ca.key -CAcreateserial \
    -key /server-secrets/intermediate-2026.key \
    -subj '/CN=Yoyodyne intermediate CA 2026' -days 3650 -sha256 -nodes \
    -addext 'basicConstraints = critical, CA:true, pathlen:0' \
    -addext 'keyUsage = critical, cRLSign, keyCertSign' \
    -addext 'subjectKeyIdentifier = hash' \
    -addext 'authorityKeyIdentifier = keyid:always, issuer' \
    -out /server-secrets/intermediate-2026.crt

# Client A
openssl genrsa \
    -out /client-a-secrets/client.key 2048
openssl req \
    -x509 -new \
    -CA /server-secrets/intermediate-2026.crt -CAkey /server-secrets/intermediate-2026.key -CAcreateserial \
    -key /client-a-secrets/client.key \
    -subj '/CN=client-a' -days 730 -sha256 -nodes \
    -addext 'basicConstraints = critical, CA:false' \
    -addext 'keyUsage = critical, digitalSignature, keyEncipherment' \
    -addext 'extendedKeyUsage = clientAuth' \
    -out /client-a-secrets/client.crt
cat /server-secrets/ca.crt /server-secrets/intermediate-2026.crt >/client-a-secrets/bundle.crt

# Client B
openssl genrsa \
    -out /client-b-secrets/client.key 2048
openssl req \
    -x509 -new \
    -CA /server-secrets/intermediate-2026.crt -CAkey /server-secrets/intermediate-2026.key -CAcreateserial \
    -key /client-b-secrets/client.key \
    -subj '/CN=client-b' -days 730 -sha256 -nodes \
    -addext 'basicConstraints = critical, CA:false' \
    -addext 'keyUsage = critical, digitalSignature, keyEncipherment' \
    -addext 'extendedKeyUsage = clientAuth' \
    -out /client-b-secrets/client.crt
cat /server-secrets/ca.crt /server-secrets/intermediate-2026.crt >/client-b-secrets/bundle.crt

# Server
openssl genrsa \
    -out /server-secrets/server.key 2048
openssl req \
    -x509 -new \
    -CA /server-secrets/intermediate-2026.crt -CAkey /server-secrets/intermediate-2026.key -CAcreateserial \
    -key /server-secrets/server.key \
    -subj '/CN=server' -days 730 -sha256 -nodes \
    -addext 'basicConstraints = critical, CA:false' \
    -addext 'keyUsage = critical, digitalSignature, keyEncipherment' \
    -addext 'extendedKeyUsage = serverAuth' \
    -out /server-secrets/server.crt

# To summarize
ls -alt /server-secrets
ls -alt /client-a-secrets
ls -alt /client-b-secrets
