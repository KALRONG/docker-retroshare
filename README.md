Retroshare for Docker
=
This image provides a fully working Retroshare installation that can be executed in three different modes as needed.

This image is intended for those who don't want to install all the dependencies or have issue like the current one with libcrypto versions causing segfaults.

Important considerations:
-
For Retroshare to work propertly you may need to map more ports than the ones expecified here, this instructions are just a guide of how to execute and connect to the application.

Usage:
-
This image can run in three different modes:

* nogui: Will run just Retroshare in nogui mode. [Not tested]
* nogui-web: Will run Retroshare in nogui mode with web interface enabled on port 9090. Default. [Not tested]
* gui: Will run Retroshare in gui mode using xpra to map the user interface to the port 14500.

This mode should be specified when creating the container using the env variable MODE.

nogui:
-
```
docker run -it --env="MODE=nogui" kalrong/docker-retroshare
```

The -it option will make the interface interactive so you can interact with Retroshare as if you were running the application directly.

nogui-web:
-
```
docker run -d --env="MODE=nogui-web" [-p 9090:9090] kalrong/docker-retroshare
```

This will make the container run in the background and you will be able to access the web interface using the port 9090 of the container or, if you pass the optional option above mentioned, on the localhost port 9090.

gui
-
```
docker run -d --env="MODE=gui" [-p 14500:14500] kalrong/docker-retroshare
```

This will make the container run in the background and the gui will be handled by xpra in the port 10000 o the container or, if you pass the optional option above mentioned, on the localhost port 10000-

To connect to the gui you need to have xpra installed and run the following command:

```
xpra attach tcp:<localhost or container ip>:10000
```

In this case, if you close the interface it will also close the container.

I2P and TOR support [Temporaly disabled]:
-

This image comes with i2p and tor preinstalled but disabled by default, to enable them you should set the variables I2P and TOR to yes as follows:

For TOR:
```
docker run -it --env="TOR=yes" kalrong/docker-retroshare
```
For I2P:
```
docker run -it --env="I2P=yes" kalrong/docker-retroshare
```

You can enable both without problems.

I2P notes:
-

While tor doesn't really need any more configuration to work as an outgoing proxy in the case of I2P you need to create the proper tunnel, you can find a guide on how to create both the outbound and inbound tunnel in my blog:

https://blog.kalrong.net/en/2016/09/23/retroshare-over-i2p/

To do this you need to access the port 7567 to be able to reach the web console, I recommend you to map it to the host for easier access. 

TOR notes:
-

This image comes with a basic tor configuration, if you want to do any changes or user your own configuration you can either execute a bash console in the container to do the changes or map your own config folder to the container.

Updates:
-

I will try to keep the build as updated as possible, if you want me to update it sooner just open an issue on the github repository and I will run the build asap.
