#!/bin/bash

#Color Codes
red=`tput setaf 1`
white=`tput setab 7`
redbg=`tput setab 1`
bold=`tput bold`
reset=`tput sgr0`


#Primary Cluster Login Details
echo -e "\n\n$bold PRIMARY CLUSTER DETAILS:$reset"
echo -en "$red IP Address \t:$reset";read primaryClusterIP
echo -en "$red Username \t:$reset";read primaryClusterUser
echo -en "$red Password \t:$reset";read -s primaryClusterPassword

export primaryAPIToken=$(curl -sX POST \
       -H "Content-Type: application/json" \
       -k https://$primaryClusterIP:8000/v1/session/login \
       -d "{\"username\": \"$primaryClusterUser\", \"password\": \"$primaryClusterPassword\"}" |jq -r '.bearer_token')

echo -en "\n\n$redbg$white######################################$reset\n\n"

#Secondary Cluster Login Details
echo -e "$bold SECONDARY CLUSTER DETAILS:$reset"
echo -en "$red IP Address \t:$reset";read secondaryClusterIP
echo -en "$red Username \t:$reset";read secondaryClusterUser
echo -en "$red Password \t:$reset";read -s secondaryClusterPassword
echo
echo

export secondaryAPIToken=$(curl -sX POST \
       -H "Content-Type: application/json" \
       -k https://$secondaryClusterIP:8000/v1/session/login \
       -d "{\"username\": \"$secondaryClusterUser\", \"password\": \"$secondaryClusterPassword\"}" | jq -r '.bearer_token')
	


for shareID in $(curl -sX GET \
	-H "Authorization: Bearer $primaryAPIToken" \
	-k https://$primaryClusterIP:8000/v2/smb/shares/|\
	jq -r '.[].id')
do
        curl -sX GET \
		-H "Authorization: Bearer $primaryAPIToken" \
		-k https://$primaryClusterIP:8000/v2/smb/shares/$shareID |\
		jq -r '.'|grep -v "\"id\""|grep -v "sid"|grep -v "auth_id" > /tmp/smb_$shareID.json

	
	echo -en "$bold $red Path:$reset";jq -r '.fs_path' /tmp/smb_$shareID.json
	echo -en "$bold $red Share Name:$reset"; jq -r '.share_name' /tmp/smb_$shareID.json
	echo -e "$bold $red Trustees:$reset";jq -r '.permissions|.[].trustee.name' /tmp/smb_$shareID.json
        echo
	echo -en "$bold $red Do you want to create share? (Y/N) $reset":;read answer
        
	if [[ $answer == "y"  || $answer == "Y" ]]
        then
		curl -sX POST \
			-H "Content-Type: application/json" \
			-H "Authorization: Bearer $secondaryAPIToken" \
			-k https://$secondaryClusterIP:8000/v2/smb/shares/ \
                        -d @/tmp/smb_$shareID.json
	
		echo -en "\n\n$redbg$white######################################$reset\n\n"
	
	else
		echo -en "\n\n$redbg$white######################################$reset\n\n"
        fi
done
#!/bin/bash

#Color Codes
red=`tput setaf 1`
white=`tput setab 7`
redbg=`tput setab 1`
bold=`tput bold`
reset=`tput sgr0`


#Primary Cluster Login Details
echo -e "\n\n$bold PRIMARY CLUSTER DETAILS:$reset"
echo -en "$red IP Address \t:$reset";read primaryClusterIP
echo -en "$red Username \t:$reset";read primaryClusterUser
echo -en "$red Password \t:$reset";read -s primaryClusterPassword

export primaryAPIToken=$(curl -sX POST \
       -H "Content-Type: application/json" \
       -k https://$primaryClusterIP:8000/v1/session/login \
       -d "{\"username\": \"$primaryClusterUser\", \"password\": \"$primaryClusterPassword\"}" |jq -r '.bearer_token')

echo -en "\n\n$redbg$white######################################$reset\n\n"

#Secondary Cluster Login Details
echo -e "$bold SECONDARY CLUSTER DETAILS:$reset"
echo -en "$red IP Address \t:$reset";read secondaryClusterIP
echo -en "$red Username \t:$reset";read secondaryClusterUser
echo -en "$red Password \t:$reset";read -s secondaryClusterPassword
echo
echo

export secondaryAPIToken=$(curl -sX POST \
       -H "Content-Type: application/json" \
       -k https://$secondaryClusterIP:8000/v1/session/login \
       -d "{\"username\": \"$secondaryClusterUser\", \"password\": \"$secondaryClusterPassword\"}" | jq -r '.bearer_token')
	


for shareID in $(curl -sX GET \
	-H "Authorization: Bearer $primaryAPIToken" \
	-k https://$primaryClusterIP:8000/v2/smb/shares/|\
	jq -r '.[].id')
do
        curl -sX GET \
		-H "Authorization: Bearer $primaryAPIToken" \
		-k https://$primaryClusterIP:8000/v2/smb/shares/$shareID |\
		jq -r '.'|grep -v "\"id\""|grep -v "sid"|grep -v "auth_id" > /tmp/smb_$shareID.json

	
	echo -en "$bold $red Path:$reset";jq -r '.fs_path' /tmp/smb_$shareID.json
	echo -en "$bold $red Share Name:$reset"; jq -r '.share_name' /tmp/smb_$shareID.json
	echo -e "$bold $red Trustees:$reset";jq -r '.permissions|.[].trustee.name' /tmp/smb_$shareID.json
        echo
	echo -en "$bold $red Do you want to create share? (Y/N) $reset":;read answer
        
	if [[ $answer == "y"  || $answer == "Y" ]]
        then
		curl -sX POST \
			-H "Content-Type: application/json" \
			-H "Authorization: Bearer $secondaryAPIToken" \
			-k https://$secondaryClusterIP:8000/v2/smb/shares/ \
                        -d @/tmp/smb_$shareID.json
	
		echo -en "\n\n$redbg$white######################################$reset\n\n"
	
	else
		echo -en "\n\n$redbg$white######################################$reset\n\n"
        fi
done
