# nc-client
netcat client for iOS

## Description
Connect to a server on a port and send/receive bytes over the network.

This app was developed to be an on-device solution for connecting to the iOS [kernel exploit](https://bugs.chromium.org/p/project-zero/issues/detail?id=965#c2) published by Google's Project Zero. In particular, the exploit provides access to a root shell on port 4141, and with this app it can be connected to at ```localhost:4141``` from the device itself.

## License
[![cc by-nc-sa](https://i.creativecommons.org/l/by-nc-sa/4.0/88x31.png)](http://creativecommons.org/licenses/by-nc-sa/4.0/)

This work is licensed under a [Creative Commons Attribution-NonCommercial-ShareAlike 4.0 International License](http://creativecommons.org/licenses/by-nc-sa/4.0/).

Based on BSD's [netcat](http://man.openbsd.org/OpenBSD-current/man1/nc.1).

## Screenshots
![terminal](https://i.imgur.com/PAB1mLn.png) ![prompt](https://i.imgur.com/H1Nzure.png)
