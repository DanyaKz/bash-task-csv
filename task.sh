#!/bin/bash 

if [[ $1 == *.csv ]] ; then 
	
	
	declare -A check_email 

	while IFS=',' read -r c1 c2 c3 c4 c5 c6; do		
		IFS=' ' read -ra f_name <<< $c3
		new_email="${c3:0:1}${f_name[1]}@abc.com"
		(( check_email["${new_email,,}"]++ ))
	done < $1
	
	i=0

	while IFS= read -r line; do		

		((i++))
		if [[ $i -eq 1 ]]; then
			echo "id,location_id,name,title,email,department" > accounts_new.csv
			continue
		fi

		IFS=',' read -r -a parts <<< "$line"
    	cols=${#parts[@]}  
		idx=3
		title=${parts[3]}

		if [[ ${parts[3]:0:1} == '"' ]] ; then 
			 while (( idx < cols )) && [[ "${parts[$idx]: -1}" != '"' ]]; do
				((idx++))
				title+=",""${parts[$idx]}"
			done
		fi

		IFS=' ' read -ra f_name <<< ${parts[2]}
		new_email="${parts[2]:0:1}${f_name[1]}@abc.com"

		if [[ ${check_email["${new_email,,}"]} -gt 1 ]] ; then
			new_email="${parts[2]:0:1}${f_name[1]}${parts[1]}@abc.com"
		fi

		echo "${parts[0]},${parts[1]},${f_name[0]^} ${f_name[1]^},${title^},${new_email,,},${parts[$cols-1]}" >> accounts_new.csv	
	

	done < $1
fi

echo "OK: created accounts_new.csv"
