#!/bin/bash


#Choose destination folder
 
Destination=



#Get total number of links
nmbrtotal=$#


#Count links yet to download
multi=$#


  

while [ $multi -ne 0 ]

do
	langfr="&lg=fr"
	url="$1&langfr"


	#Get file name
 
	linenumbernom=` curl --silent $url | grep -ni "nom" | cut -f1 -d: `


	linenumbernom=$(($linenumbernom + 1))


	nom=`curl --silent $url | sed -n "$linenumbernom p" | cut -d ">" -f 2 | cut -d "<" -f 1
`

	
	#Try to get download link
	dlink=`curl --silent -X POST $url | grep -n "ok btn-general btn-orange" | cut -d'"' -f2`


	
	#Wait if there is time before next download allowed
	if [ $dlink=submit ]

	then

		attente=`curl --silent -X POST $url | grep -n "must wait" | cut -d" " -f5`

		echo "$attente minutes to wait."

		sleep $(($attente + 1))m

        	dlink=`curl --silent -X POST $url | grep -n "ok btn-general btn-orange" | cut -d'"' -f2`

	fi

	
echo "Start download of $nom."


	curl $dlink > $Destination/$nom

	


	#Download done, shift variables
	
	multi=$(($multi-1))


	echo "Download of $nom is down."

        echo "$(($nmbrtotal-$multi))/$nmbrtotal downloads done. "


	shift

done
