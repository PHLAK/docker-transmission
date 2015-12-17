docker-transmission
===================

Docker container for Transmission Daemon.


### Running the container

    docker run -d -e RPC_USER=username -e RPC_PASS=password -p 9091:9091 -p 51413:51413/udp -v /local/downloads:/srv/downloads --name transmission phlak/transmission

##### Optional Arguments

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
