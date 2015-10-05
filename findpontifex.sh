#!/bin/bash

# Wie der Name sagt dient dieses Script dazu Brückenbauer zu finden, die mit falschem Community String eingeloggt sind.
# Die Ausgabe kann in der lokalen blacklist hinterlegt werden.
# hierzu mit > fastd-blacklist.local ausführen


## hier alle fastd.socks eintragen
socat - unix-connect:"/tmp/fastd1.sock" >abldb1.json
socat - unix-connect:"/tmp/fastd0.sock" >abldb0.json
jq -s '.[0] * .[1]' abldb1.json abldb0.json   > abldbf.json

# hier url zu nodes.json einfügen
curl -s "url.de/ffdata/nodes.json" > ./abldbn.json
jq -s '.[0] * .[1]' abldbf.json abldbn.json > abldb.json


(echo "Erstellt: " `date`
echo  "#########################################"
echo

for mac in $(
        for line in $(cat ./abldb.json\
                | jq '.["nodes"]?[]?["nodeinfo"]?| select(select(.system.site_code)|.["system"].site_code|contains("YOURSIDECODE")|not)'\
                | jq .network.mesh.bat0.interfaces.tunnel[] --raw-output); \
                        do      cat abldb.json |jq '.[][]?|select(.)|select(.connection?.mac_addresses[]?|contains('\"$line\"'))|.connection.mac_addresses[]' --raw-output \
                        ;done
        ); do   cat abldb.json |jq '.["nodes"]?[]?["nodeinfo"]?| select(.)|select(.network.mesh.bat0.interfaces.tunnel[]?|contains('\"$mac\"'))'| jq '"# \(.hostname) mit \(.network.mesh.bat0.interfaces.tunnel[]?) bridged in \(.system.site_code)."' --raw-output &&\
                cat abldb.json |jq '.["nodes"]?[]?["nodeinfo"]?| select(.)|select(.network.mesh.bat0.interfaces.tunnel[]?|contains('\"$mac\"'))'| jq '"# Ansprechpartner: \(.owner.contact)"' --raw-output &&\
                cat abldb.json |jq '.["nodes"]?[]?["nodeinfo"]?| select(.)|select(.network.mesh.bat0.interfaces.tunnel[]?|contains('\"$mac\"'))'| jq '"# IPv6: [\(.network.addresses[1])]"' --raw-output &&\
                cat abldb.json |jq '.["nodes"]?[]?| select(.)|select(.nodeinfo.network.mesh.bat0.interfaces.tunnel[]?|contains('\"$mac\"'))'| jq '"# Zuletzt gesehen: \(.lastseen)"' --raw-output &&\
                cat abldb.json |jq '.peers|select(.)|to_entries|.[]|select(.["value"]["connection"]["mac_addresses"][]?|contains('\"$mac\"'))|"\(.["key"])"' --raw-output &&echo;done)


rm ./abldb*.json
