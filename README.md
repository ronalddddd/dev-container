# dev-container

A multi-purpose Ubuntu base image with: 

- SSH server with password login and tunneling enabled
- Node.js version 6.x
- Docker 1.11.2

Note: default root password is `happymeal`.

## Sample usage:

```sh
docker run -d --name dev-container -e SSH_PASSWORD=foobar -p 1234:22 ronalddddd/dev-container
```

The above example will: 

- set SSH `root` user's password too `"foobar"`
- port map host `1234` to SSH container port `22`
