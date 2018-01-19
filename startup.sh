getent passwd retrouser > /dev/null
if [ $? -ne 0 ]; then
    # User does not exist
    # Create a user for retroshare
    mkdir /home/retrouser
    useradd -s /bin/bash -d /home/retrouser -p "tmp" retrouser
    PASSWD=`gpg --gen-random --armor 0 8`
    echo "retrouser password: $PASSWD"
    echo "retrouser:$PASSWD" | chpasswd
    chown -R retrouser:retrouser /home/retrouser
    chmod -R ug+rwX /home/retrouser
    chmod -R o-rwx /home/retrouser
    #su - retrouser -c "ssh-keygen -t rsa -f rs_ssh_host_rsa_key"
fi

if [[ $TOR == "yes" ]]
then
	/etc/init.d/tor start
fi

if [[ $I2P == "yes" ]]
then
	i2prouter-nowrapper
fi

if [[ $MODE == "nogui" ]]
then
	su - retrouser -c "retroshare"
elif [[ $MODE == "nogui-web" ]]
then
	su - retrouser -c "retroshare-nogui --webinterface 9090 --docroot /usr/share/retroshare/webui/ --http-allow-all"
elif [[ $MODE == "gui" ]]
then
	#su - retrouser -c "RetroShare06"
	su - retrouser -c "xpra start :100 --bind-tcp=0.0.0.0:10000 --no-mdns --no-notifications --no-pulseaudio"

	# start RetroShare GUI in a screen session with xpra display
	su - retrouser -c "DISPLAY=:100 retroshare"
else
	echo "Wrong mode selected"
fi
