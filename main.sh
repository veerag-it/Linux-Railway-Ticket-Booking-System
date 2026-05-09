current_user=""

while true
do
	clear # clear refreshes the terminal screen before showing the menu again
	echo "======================================="
	echo "     RAILWAY TICKET BOOKING SYSTEM     "
	echo "======================================="
	echo "1. Register Passenger"
	echo "2. Passenger Login"
	echo "3. Check Trains (Guest Mode)"
	echo "4. Exit"
	echo

	read -p "Enter choice: " choice

	case $choice in
		1) source register.sh ;;
		2) source login.sh 
		   if [ -n "$current_user" ];then
			source dashboard.sh
		   fi 
		   ;;
		3) source check_trains.sh ;;
		4) echo "Exiting RAILWAY TICKET BOOKING SYSTEM..."
		   sleep 2
		   exit ;;
		*) echo "Invalid choice entered!"
		   sleep 2  # sleep pauses the execution of the script for 2 seconds before continuing
		   echo "Returning to Main Menu..." 
		   sleep 2
		   ;;
	esac
done
			
       
