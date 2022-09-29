#!/bin/bash

# A script to enumerate web-sites using google dorks.
# Author: Ivan Glinkin
# Contact: ivan.o.glinkin@gmail.com
# Release Date: May 3, 2020

##### Variables #####

##### General #####
version="1.011"				## version
example_domain="testphp.vulnweb.com"		## example domain
sleeptime=15					## delay between queries, in seconds
domain=$1 						## get the domain
browser='Mozilla'			## browser information for curl
gsite="site:$domain"	## google site

##### Login Pages #####
lpadmin="inurl:admin"
lpadminarea="inurl:adminarea"
lpadmincp="inurl:admincp"
lpadminlogin="inurl:adminlogin"
lpadminpanel="inurl:adminpanel"
lpauth="inurl:auth"
lpcplogin="inurl:cplogin"
lpdashboard="inurl:dashboard"
lpexc="inurl:exchange"
lpfp="inurl:ForgotPassword"
lplogin="inurl:login"
lploginpanel="inurl:loginpanel"
lpmemberlogin="inurl:memberlogin"
lpportal="inurl:portal"
lpquicklogin="inurl:quicklogin"
lpremote="inurl:remote"
lptest="inurl:test"
lpuserportal="inurl:userportal"
lpweblogin="inurl:weblogin"
lpwp1="inurl:wp-admin"
lpwp2="inurl:wp-login"

loginpagearray=( $lpadmin $lpadminarea $lpadmincp $lpadminlogin $lpadminpanel $lpauth $lpcplogin $lpdashboard $lpexc $lpfp $lplogin $lploginpanel $lpmemberlogin $lpportal $lpquicklogin $lpremote $lptest $lpuserportal $lpweblogin $lpwp1 $lpwp2 )

##### FileTypes #####
ft7z="filetype:7z"
ftbak="filetype:bak"
ftconf="filetype:conf"
ftcsv="filetype:csv"
ftdat="filetype:dat"
ftdoc="filetype:doc"
ftdocx="filetype:docx"
ftgz="filetype:gz"
ftini="filetype:ini"
ftjson="filetype:json"
ftlog="filetype:log"
ftmdb="filetype:mdb"
ftold="filetype:old"
ftpdf="filetype:pdf"
ftppt="filetype:ppt"
ftpptx="filetype:pptx"
ftrtf="filetype:rtf"
ftsql="filetype:sql"
fttar="filetype:tar"
fttmp="filetype:tmp"
fttxt="filetype:txt"
ftxls="filetype:xls"
ftxlsx="filetype:xlsx"
ftxml="filetype:xml"
ftzip="filetype:zip"
ftidrsa="index%20of:id_rsa%20id_rsa.pub"	## index of:id_rsa id_rsa.pub

filetypesarray=( $ft7z $ftbak $ftconf $ftcsv $ftdat $ftdoc $ftdocx $ftgz $ftini $ftlog $ftmdb $ftold $ftpdf $ftppt $ftpptx $ftrtf $ftsql $fttar $fttmp $fttxt $ftxls $ftxlsx $ftxml $ftzip $ftidrsa )

##### Directory traversal #####
dtparent='intitle:%22index%20of%22%20%22parent%20directory%22' 	## intitle:"index of" "parent directory"
dtdcim='intitle:%22index%20of%22%20%22DCIM%22' 									## intitle:"index of" "DCIM"
dtftp='intitle:%22index%20of%22%20%22ftp%22' 										## intitle:"index of" "ftp"
dtbackup='intitle:%22index%20of%22%20%22backup%22'							## intitle:"index of" "backup"
dtmail='intitle:%22index%20of%22%20%22mail%22'									## intitle:"index of" "mail"
dtpassword='intitle:%22index%20of%22%20%22password%22'					## intitle:"index of" "password"
dtpub='intitle:%22index%20of%22%20%22pub%22'										## intitle:"index of" "pub"

dirtravarray=($dtparent $dtdcim $dtftp $dtbackup $dtmail $dtpassword $dtpub)

##### Header #####
echo -e "\n\e[00;33m#########################################################\e[00m"
echo -e "\e[00;33m#                                                       #\e[00m" 
echo -e "\e[00;33m#\e[00m" "\e[01;32m               Fast Google Dorks Scan                \e[00m" "\e[00;33m#\e[00m"
echo -e "\e[00;33m#                                                       #\e[00m" 
echo -e "\e[00;33m#########################################################\e[00m"
echo -e ""
echo -e "\e[00;33m# https://www.linkedin.com/in/IvanGlinkin/ | @IvanGlinkin\e[00m"
echo -e "\e[00;33m# Version:                 \e[00m" "\e[01;31m$version\e[00m"

# check domain
if [ -z "$domain" ] 
then
	echo -e "\e[00;33m# Usage Example:\e[00m" "\e[01;31m$0 $example_domain \e[00m\n"
	exit
else
	echo -e "\e[00;33m# Get Information About:   \e[00m" "\e[01;31m$domain\e[00m"
	echo -e "\e[00;33m# Delay Between Queries:   \e[00m" "\e[01;31m$sleeptime\e[00m" "\e[00;33msec\e[00m\n"
fi

##### Function to get information about site ##### START
function Query {
		result="";
		for start in `seq 0 10 40`; ##### last number - quantity of possible answers
			do
				query=$(echo; curl -sS -b "CONSENT=YES+srp.gws-20211028-0-RC2.es+FX+330" -A $browser "https://www.google.com/search?q=$gsite%20$1&start=$start&client=firefox-b-e")

				checkban=$(echo $query | grep -io "https://www.google.com/sorry/index")
				if [ "$checkban" == "https://www.google.com/sorry/index" ]
				then 
					echo -e "Google thinks you are the robot and has banned you;) How dare he? So, you have to wait some time to unban or change your ip!"; 
					exit;
				fi
				
				checkdata=$(echo $query | grep -Eo "(http|https)://[a-zA-Z0-9./?=_~-]*$domain/[a-zA-Z0-9./?=_~-]*")
				if [ -z "$checkdata" ]
					then
						sleep $sleeptime; # sleep to prevent banning
						break; # exit the loop
					else
						result+="$checkdata ";
						sleep $sleeptime; # sleep to prevent banning
				fi
			done

		# echo results
		if [ -z "$result" ] 
			then
				echo -e "\e[00;33m[\e[00m\e[01;31m-\e[00m\e[00;33m]\e[00m No results"
			else
				IFS=$'\n' sorted=($(sort -u <<<"${result[@]}" | tr " " "\n")) # Sort the results with unique key
				echo -e " "
				for each in "${sorted[@]}"; do echo -e "     \e[00;33m[\e[00m\e[01;32m+\e[00m\e[00;33m]\e[00m $each"; done
		fi

		# unset variables
		unset IFS sorted result checkdata checkban query
}
##### Function to get information about site ##### END


##### Function to print the results ##### START
function PrintTheResults {
	for dirtrav in $@; 
		do echo -en "\e[00;33m[\e[00m\e[01;31m*\e[00m\e[00;33m]\e[00m" Checking $(echo $dirtrav | cut -d ":" -f 2 | tr '[:lower:]' '[:upper:]' | sed "s@+@ @g;s@%@\\\\x@g" | xargs -0 printf "%b") "\t" 
		Query $dirtrav 
	done
echo " "
}
##### Function to print the results ##### END

##### Exploit #####

echo -e "\e[01;32mChecking Login Page:\e[00m"; PrintTheResults "${loginpagearray[@]}";

echo -e "\e[01;32mChecking Specific Files:\e[00m"; PrintTheResults "${filetypesarray[@]}";

echo -e "\e[01;32mChecking Path Traversal:\e[00m"; PrintTheResults "${dirtravarray[@]}";
