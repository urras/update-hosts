#!/bin/bash
 
temphosts1=$(mktemp)
temphosts2=$(mktemp)
 
wget -nv -O - http://someonewhocares.org/hosts/hosts >> $temphosts1
wget -nv -O - http://winhelp2002.mvps.org/hosts.txt >> $temphosts1
wget -nv -O - http://www.malwaredomainlist.com/hostslist/hosts.txt >> $temphosts1
wget -nv -O - http://adblock.gjtech.net/?format=hostfile >> $temphosts1
wget -nv -O - http://hosts-file.net/ad_servers.asp >> $temphosts1
wget -nv -O - "http://pgl.yoyo.org/adservers/serverlist.php?hostformat=hosts&showintro=0&mimetype=plaintext" >> $temphosts1
 
# This part gets pretty nasty :/
cp $temphosts1 $temphosts2
 
sed -e 's/\r//' -e '/^127.0.0.1/!d' -e '/localhost/d' -e 's/127.0.0.1/0.0.0.0/' -e 's/ \+/\t/' -e 's/#.*$//' -e 's/[ \t]*$//' < $temphosts1 | sort -u > temp1
sed -e 's/\r//' -e '/^127.0.0.1/!d' -e '/localhost/d' -e 's/127.0.0.1/::1/' -e 's/ \+/\t/' -e 's/#.*$//' -e 's/[ \t]*$//' < $temphosts2 | sort -u > temp2
cat temp1 temp2 > ./hosts/hosts
rm $temphosts1 $temphosts2 temp1 temp2
 
echo "127.0.0.1 localhost
::1 localhost" | cat - ./hosts/hosts > temp && mv temp ./hosts/hosts
 
sh ./ignore.sh
 
echo "# Last updated on $(date)" | cat - ./hosts/hosts > temp && mv temp ./hosts/hosts
