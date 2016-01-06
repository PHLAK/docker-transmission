docker-transmission
===================

Docker container for Transmission Daemon.

[![](https://badge.imagelayers.io/phlak/transmission:latest.svg)](https://imagelayers.io/?images=phlak/transmission:latest 'Get your own badge on imagelayers.io')

### Running the container

    docker run -d -v /local/downloads:/srv/downloads -p 9091:9091 -p 51413:51413/udp --name transmission-daemon phlak/transmission

**NOTE:** The default RPC web interface username/password is `transmission`/`transmission`, however
this can be overridden with optional environment variabe arguments (see below).


### [RECOMMENDED] Running with a data-only container

In order to persist configuration data after deleting a container you may create a data-only
container before running the container.

    docker create --name transmission-data phlak/transmission echo "Data-only container for transmission-daemon"

After the data-only container has been created run the Transmission Daemon container with mounted
volumes from the data-only container:

    docker run -d -v /local/downloads:/srv/downloads -p 9091:9091 -p 51413:51413/udp --volumes-from transmission-data --name transmission-daemon phlak/transmission


### [ADVANCED] Running the container over an OpenVPN tunnel

Place your OpenVPN client configuration file in a directory anywhere on your host system with the
name `openvpn.conf`. You should also place your client certs/keys in this directory. Then run the
OpenVPN container and map your local OpenVPN directory to the container volume:

    docker run -d -v /local/dir:/etc/openvpn -p 9091:9091 --privileged --restart=always --name tranmission-vpn phlak/openvpn

Once your OpenVPN container is running, start the Transmission Daemon container with a shared
network stack:

    docker run -d -v /local/downloads:/srv/downloads --net container:tranmission-vpn --name transmission-daemon phlak/transmission

**NOTE:** You can (should) combine this method with the data-only container method above. Just
create the data-only contaner first and be sure to run the daemon container with the
`--volumes-from` parameter as above.


##### Set the timezone

In order for alternative speeds schedules to work you may need to set the timezone of your
container. You can do this by [lookin up your timezone](https://goo.gl/uy1J6q) and passing the value
 of the `TZ` column to the set timezone script in your running container.

Here's an example for the `America/Phoenix` timezone:

    docker exec transmission-daemon /srv/scripts/timezone America/Phoenix


##### Optional Arguments

`-e RPC_USER=[USERNAME]` - Set the RPC web interface username (Default: transmission)

`-e RPC_PASS=[PASSWORD]` - Set the RPC web interface password (Default: transmission)

`-v /local/watchdir:/srv/watchdir` - Map a directory (i.e. /local/watchdir) on the host OS that
                                     Transmission will monitor for .torrent files


-----

**Copyright (c) 2015 Chris Kankewicz <Chris@ChrisKankiewicz.com>**

Permission is hereby granted, free of charge, to any person obtaining a copy
of this software and associated documentation files (the "Software"), to deal
in the Software without restriction, including without limitation the rights
to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
copies of the Software, and to permit persons to whom the Software is
furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in
all copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
THE SOFTWARE.
