# MySQL on Ubuntu for Docker #

A powerful database server running on the best OS and the best container system
in the world.

## Why use this image
This image is built on [ghifari160/ubuntu], which comes with more useful
packages than the official image have to offer. Also, this image is designed
with data persistence in mind. If no metadata is found, the powerful init
script will initialize the MySQL installation _and_ store metadata files.
Redeployed containers would skip the initialization phase and immediately run
the MySQL daemon.

## Installation
By default, this image should be run as a daemon
```
docker run -d -e MYSQL_ROOT_PASSWORD=password ghifari160/mysql
```

However, this image can be run in the foreground for debug purposes
```
docker run -it -e MYSQL_ROOT_PASSWORD=password ghifari160/mysql
```

You must [set the `MYSQL_ROOT_PASSWORD` environment](#set-root-user-password)
variable.

### Further Configurations
#### Name the container
Use the parameter `--name=<name>` to name the container. Example:
```
docker run --name=mysql -d -e MYSQL_ROOT_PASSWORD=password ghifari160/mysql
```

#### Store/load MySQL databases
Use the parameter `-v /path/on/the/host/computer:/var/lib/mysql` to set the
container's MySQL data directory. Example:
```
docker run -d -v /d/workspace/project:/var/lib/mysql -e MYSQL_ROOT_PASSWORD=password ghifari160/mysql
```

#### Change the port on the container
Use the parameter `-p <port on the host>:3306` to map the container's port to
another port on the host computer. Example:
```
docker run -d -p 5000:3306 -e MYSQL_ROOT_PASSWORD=password ghifari160/mysql
```

#### Set root user password
The init script will set the password of the root user to be the value of
`MYSQL_ROOT_PASSWORD` environment variable. Use the parameter
`-e MYSQL_ROOT_PASSWORD=<password>` to set the password of the root user.
Example:
```
docker run -d -e MYSQL_ROOT_PASSWORD=password123 ghifari160/mysql
```

#### macOS permission fixes
On macOS, shared volumes remains owned by the host user and group. Permissions
on these shared volumes are also determined by the host, unchangeable from
guest. On the home directory, the default owner and permission are
`<user>:staff` and `755`. MySQL needs write access to its files and
directories. A workaround is to set the `mysql` UID and GID to `1000` and
`50`. The init script will do this if the value of `G16_MACOS` is `yes`. Use
the parameter `-e G16_MACOS=yes` to enable this workaround. Example:
```
docker run -d -e MYSQL_ROOT_PASSWORD=password -e G16_MACOS=yes ghifari160/mysql
```

## Tags
| Tags                      | Ubuntu Version | Size  |
|---------------------------|----------------|:-----:|
| `latest` `16.04` `xenial` | 16.04          | _TBA_ |
| `17.10`                   | 17.10          | _TBA_ |

[ghifari160/ubuntu]: https://github.com/ghifari160/docker-ubuntu