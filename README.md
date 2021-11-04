This is [Satisfactory](https://www.satisfactorygame.com/) [Dedicated Server](https://satisfactory.fandom.com/wiki/Dedicated_servers) containerized.


## Usage

Here are some example snippets to help you get started creating a container.

### docker-compose (recommended)

```yaml
version: "3.4"

services:
    app:
        image: unafraid/satisfactory:latest
        container_name: satisfactory
        restart: unless-stopped
        environment:
          - PUID=1000
          - PGID=1000
          - TZ=Europe/Sofia
        ports:
          - "15777:15777/udp"
          - "15000:15000/udp"
          - "7777:7777/udp"
        volumes:
            - ./save:/config/.config/Epic
            - ./server:/app/SatisfactoryDedicatedServer
```

### docker cli ([click here for more info](https://docs.docker.com/engine/reference/commandline/cli/))

```bash
docker run -d \
  --name=satisfactory \
  -e PUID=1000 \
  -e PGID=1000 \
  -e TZ=Europe/Sofia \
  -p 15777:15777/udp \
  -p 15000:15000/udp \
  -p 7777:7777/udp \
  -v </path/to/save>:/config/.config/Epic \
  -v </path/to/server>:/app/SatisfactoryDedicatedServer \
  --restart unless-stopped \
  unafraid/satisfactory
```
