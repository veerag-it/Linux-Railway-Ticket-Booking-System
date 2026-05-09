echo "===== CHECK ALL AVAILABLE TRAINS FOR YOUR JOURNEY ====="

# Date input
read -p "Kindly enter Journey Date (YYYY-MM-DD) within 30 days: " jdate

# Validate date within next 30 days
today=$(date +%Y-%m-%d)
maxdate=$(date -d "+30 days" +%Y-%m-%d)

if [[ "$jdate" < "$today" || "$jdate" > "$maxdate" ]];
then
	echo "Invalid date. Kindly select a date that falls within the next 30 days."
   	sleep 2
	return 
fi


while true
do
 
	clear
	echo "===== SEARCH TRAINS ====="
	echo "1. By Train Number"
	echo "2. By Train Name"
	echo "3. From → To"
	echo "4. Go Back"
	echo 

	read -p "Choose option: " opt

	case $opt in
		1)
			read -p "Enter Train Number: " tno
			if ! grep -q "^$tno|" trains.txt; then
			   echo "No data"
			else
				grep "^$tno|" trains.txt
awk -F"|" -v t="$tno" -v d="$jdate" '
$1==t && $2==d {
    types[$3]          # register seat type
    if ($7=="Available")
        count[$3]++
}
END {
    for (type in types) {
        if (count[type] > 0)
            print type " : " count[type] " seats available"
        else
            print type " : No seats available"
    }
}' seats.txt
			echo 
			echo "1. Book this train"
			echo "2. Go Back"
			read -p "Kindly enter your chosen option: " action

			if [ "$action" -eq 1 ];
			then
				if [ -z "$current_user" ];     # -z checks if the variable's value is empty or not, if empty it returns TRUE (zero length)
				then
					echo "Login required!"		
					sleep 2
					source login.sh
				fi
			
				if [ -n "$current_user" ];     # -n checks if the variable's value is empty or not, if not empty it returns TRUE (non-zero length)
				then
					selected_train="$tno"
					selected_date="$jdate"
					source booking.sh		
				fi
			fi
			fi
			;;
		2)
			read -p "Enter Train Name: " tname
			if ! awk -F"|" -v name="$tname" 'tolower($2)==tolower(name)' trains.txt | grep .  > /dev/null; then 
				echo "No data"
			else
			awk -F"|" -v name="$tname" 'tolower($2)==tolower(name) {print $1}' trains.txt | 
			while read tno; 
				do
					awk -F"|" -v t="$tno" '$1==t {print}' trains.txt
					awk -F"|" -v t="$tno" -v d="$jdate" '
$1==t && $2==d {
    types[$3]          # register seat type
    if ($7=="Available")
        count[$3]++
}
END {
    for (type in types) {
        if (count[type] > 0)
            print type " : " count[type] " seats available"
        else
            print type " : No seats available"
    }
}' seats.txt
				done
			
			echo 
			echo "1. Book this train"
			echo "2. Go Back"
			read -p "Kindly enter your chosen option: " action

			if [ "$action" -eq 1 ];
			then
				if [ -z "$current_user" ];     # -z checks if the variable's value is empty or not, if empty it returns TRUE (zero length)
				then
					echo "Login required!"		
					sleep 2
					source login.sh
				fi
			
				if [ -n "$current_user" ];     # -n checks if the variable's value is empty or not, if not empty it returns TRUE (non-zero length)
				then
					selected_train="$tno"
					selected_date="$jdate"
					source booking.sh		
				fi
			fi
			fi
			;;
		3)
			read -p "From: " src
			read -p "To: " dest
			if ! awk -F"|" -v s="$src" -v d="$dest" 'tolower($3)==tolower(s) && tolower($4)==tolower(d)' trains.txt | grep . > /dev/null; then
				echo "No data"
			else
			#awk -F"|" -v s="$src" -v d="$dest" 'tolower($3)==tolower(s) && tolower($4)==tolower(d) {print}' trains.txt
			awk -F"|" -v s="$src" -v d="$dest" 'tolower($3)==tolower(s) && tolower($4)==tolower(d) {print $1}' trains.txt |
			while read tno; 
				do
					awk -F"|" -v t="$tno" '$1==t {print}' trains.txt
					awk -F"|" -v t="$tno" -v d="$jdate" '
$1==t && $2==d {
    types[$3]          # register seat type
    if ($7=="Available")
        count[$3]++
}
END {
    for (type in types) {
        if (count[type] > 0)
            print type " : " count[type] " seats available"
        else
            print type " : No seats available"
    }
}' seats.txt
				done
			
			echo
			echo "1. Book this train"
			echo "2. Go Back"
			read -p "Kindly enter your chosen option: " action

			if [ "$action" -eq 1 ];
			then
				if [ -z "$current_user" ];     # -z checks if the variable's value is empty or not, if empty it returns TRUE (zero length)
				then
					echo "Login required!"		
					sleep 2
					source login.sh
				fi
			
				if [ -n "$current_user" ];     # -n checks if the variable's value is empty or not, if not empty it returns TRUE (non-zero length)
				then
					selected_train="$tno"
					selected_date="$jdate"
					source booking.sh		
				fi
			fi
			fi
			;;
		4)
			return 
			;;
		*)		
			echo "Invalid option entered!"
			;;
	esac
	
	echo
	read -p "Kindly Press Enter to continue..."
done

