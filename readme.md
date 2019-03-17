# certbot-docker

This repository contains a Docker container for doing automatic certificate
renewal of LetsEncrypt certificates using the `certbot` utility.

**Why yet another certbot/letsencrypt container?** Existing containers I'm
aware of are either too simplistic (built for running individual certbot
commands) or too complex (include embedded reverse-proxies, etc.). This
container is designed to manage certificates for several domains, while
not requiring any particular reverse proxy.

Docker Hub: [jkz0/certbot](https://hub.docker.com/r/jkz0/certbot)

## Using the container

See the [configuring](#Configuring) section for more details on the example options.

To run via `docker run`:

```bash
$ docker run --rm -it \
    -e ACCOUNT_EMAIL='<your email>'
    -v <config file>:/conf
    -v <cert directory>:/certs
    jkz0/certbot:latest
```

Via `docker-compose.yml`:

```yaml
version: "3"
services:
    certbot:
        image: jkz0/certbot:latest
        environment:
            - ACCOUNT_EMAIL=<your email>
        volumes:
            - <config file>:/conf
            - <cert directory>:/certs
        restart: always
```

## Configuring 

During standard operation, the container will renew certificates for all
configured domains every 20d. The domains the container will try and renew
are configured via a json file, mounted in the container at `/conf`. The json
file should contain only a list of domain names:

```json
[
    "foo.example.com",
    "bar.example.com"
]
```

To renew certificates, the container will run a server on port 80. Either
expose this port on the host, or configure your reverse proxy to forward
requests to urls with the prefix `/.well-known/` to port 80 of this
container.

## First time setup

The container can be controlled with two additional environment variables that
may be useful during initial setup and/or debugging.

Variable | Description | Default
-------- | ----------- | -------
`RUN_ONCE` | If `RUN_ONCE=true`, the instead of running a cron-job to regularly renew the certificates, the renewal script will be run once. | `RUN_ONCE=false`
`DRY_RUN` | If `DRY_RUN=true`, the `--dry-run` flag will be passed to `certbot`. This can be useful during testing. | `DRY_RUN=false`
