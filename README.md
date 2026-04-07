# mTLS testbed

```console
docker compose build
docker compose up
```

These fail with `tlsv13 alert certificate required`:

```console
docker compose exec -it client-a curl -vvv \
	--cacert /secrets/bundle.crt \
	https://server

docker compose exec -it client-b curl -vvv \
	--cacert /secrets/bundle.crt \
	https://server
```

These work:

```console
docker compose exec -it client-a curl -vvv \
	--cacert /secrets/bundle.crt \
	--cert /secrets/client.crt \
	--key /secrets/client.key \
	https://server

docker compose exec -it client-b curl -vvv \
	--cacert /secrets/bundle.crt \
	--cert /secrets/client.crt \
	--key /secrets/client.key \
	https://server
```
