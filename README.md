docker-transmission
===================

Docker container for Transmission Daemon.

[![](https://badge.imagelayers.io/phlak/transmission:latest.svg)](https://imagelayers.io/?images=phlak/transmission:latest 'Get your own badge on imagelayers.io')


### Running the container

    docker run -d -e RPC_USER=[USERNAME] -e RPC_PASS=[PASSWORD] -p 9091:9091 -p 51413:51413/udp -v /local/downloads:/srv/downloads --name transmission-daemon phlak/transmission

**NOTE:** Replace `[USERNAME]` and `[PASSWORD]` with the username and password you'd like to set for
accessing the web interface. Default username/password is `transmission`/`transmission`.


##### Optional Arguments

`-v /local/watchdir:/srv/watchdir` - Map a directory (i.e. /local/watchdir) on the host OS that
                                     Transmission will monitor for .torrent files


### Running the container over an OpenVPN connection

Create an OpenVPN client configuration file named `openvpn.conf` in a directory anywhere on your
host system. You should also place your client certs/keys in this directory. Then run the OpenVPN
container and map your local OpenVPN directory to the container volume:

    docker run -d -v /local/dir:/etc/openvpn -p 9091:9091 --privileged --restart=always --name tranmission-vpn phlak/openvpn

Once your OpenVPN container is running, start the Transmission Daemon container with a shared
network stack:

    docker run -d -e RPC_USER=[USERNAME] -e RPC_PASS=[PASSWORD] -v /local/downloads:/srv/downloads --net container:tranmission-vpn --name transmission-daemon phlak/transmission


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
