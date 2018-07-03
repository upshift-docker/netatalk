# Netatalk server

Docker image for Netatalk file server.

## Usage

This image does NOT provide automatic user creation or file server configuration. You need to manually add users/groups and configure afpd after creating the container. Configuration files are stored in a docker volume.

Start the container:

```console
# docker run -d --name netatalk \
  -v netatalk_config:/etc/netatalk \
  -v /data/timemachine:/share/timemachine \
  -v /data/files:/share/files \
  -p 548:548 \
  upshift/netatalk
```

Open a shell inside the container:

```console
# docker exec -it netatalk bash
```

Create users/groups and edit configuration file:

```console
# addgroup -g 1000 mygroup
# adduser -u 1001 -g mygroup user1
# adduser -u 1002 -g mygroup user2

# cat >/etc/netatalk/afp.conf <<-EOF
  [Global]
  log file = /dev/stdout

  [TimeMachine]
  path = /share/timemachine
  valid users = @mygroup
  vol size limit = 1000000
  time machine = yes

  [Files]
  path = /share/files
  valid users = user1
  EOF
```

Restart the container:

```console
# docker restart netatalk
```
