# fastdbl

ffrl fastd Blacklist

Public keys listed are no longer accepted for connecting to our Networks, as a result of abuse, faulty interconnecting different Networks, and so on

Installation:

1 - cron-wget the blacklist to your fastd directory:

    crontab -e

then add 

    */5 * * * * wget -q -O /etc/fastd/fastd-blacklist.json https://raw.githubusercontent.com/ffruhr/fastdbl/master/fastd-blacklist.json

2 - download the Scipt and make it Xecutable:

    wget -O /etc/fastd/fastd-blacklist.sh https://raw.githubusercontent.com/ffruhr/fastdbl/master/fastd-blacklist.sh
    chmod +x /etc/fastd/fastd-blacklist.sh

3 - build local blacklist:
    
    touch /etc/fastd/fastd-blacklist.local 
    
4 - Add the following to your fastd.conf:

    on verify "
      /etc/fastd/fastd-blacklist.sh $PEER_KEY
    ";

5 - restart your fastd and you are ready to go:

    /etc/init.d/fastd restart
    

This Branch comes with findpontifex.sh
This script searches for nodes with wrong community-string
The script needs jq. It needs some modifications for your community:
- change the communitystring
- change fastd.sock as needed
- change url of nodes.json

findpontifex.sh prints nodeinformation to console. you could run it with > fastd-blacklist.local to add output to your local blacklist.

