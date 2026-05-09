while true
do
	clear
	echo "================================="
	echo "       Passenger Dashboard       " 
	echo "================================="
	echo "Logged in as: $current_user"
	echo
	echo "1. Book Ticket"
	echo "2. Show my Tickets"
	echo "3. Cancel Ticket"
	echo "4. Logout"
	echo

	read -p "Kindly enter your choice: " choice

	case $choice in
		1) 
			source check_trains.sh
			;;
		2)
			source show_tickets.sh
			;;
		3)
			source cancel_tickets.sh
			;;
		
		4) 
			current_user=""
			echo "Logged out succesfully!"
			sleep 2
			break
			;;
		*)
			echo "Invalid choice entered!"
			sleep 2
			;;
	esac
done
			
