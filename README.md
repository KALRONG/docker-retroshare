#Retroshare for Docker
#=====================

This image provides a fully working Retroshare installation that can be executed in three different modes as needed.

Important considerations:
-------------------------

For Retroshare to work propertly you may need to map more ports than the ones expecified here, this instructions are just a guide of how to execute and connect to the application.

##Usage:
##-----

This image can run in three different modes:

* nogui: Will run just Retroshare in nogui mode.
* nogui-web: Will run Retroshare in nogui mode with web interface enabled on port 9090. Default.
* gui: Will run Retroshare in gui mode using xpra to map the user interface to the port 10000.

This mode should be specified when creating the container using the env variable MODE.

###nogui:

```
docker run -it --env="MODE=nogui" kalrong/docker-retroshare
```

The -it option will make the interface interactive so you can interact with Retroshare as if you were running the application directly.

###nogui-web:

```
docker run -d --env="MODE=nogui-web" [-p 9090:9090] kalrong/docker-retroshare
```

This will make the container run in the background and you will be able to access the web interface using the port 9090 of the container or, if you pass the optional option above mentioned, on the localhost port 9090.

###gui

```
docker run -d --env="MODE=gui" [-p 10000:10000] kalrong/docker-retroshare
```

This will make the container run in the background and the gui will be handled by xpra in the port 10000 o the container or, if you pass the optional option above mentioned, on the localhost port 10000-

To connect to the gui you need to have xpra installed and run the following command:

```
xpra attach tcp:<localhost or container ip>:10000
```

In this case, if you close the interface it will also close the container.

##Updates:
##-------

I will try to keep the build as updated as possible, if you want me to update it sooner just open an issue on the github repository and I will run the build asap.
