echo "====== BOOK TICKET ====="

read -p "Select Coach Type (SL/3AC/2AC/1AC): " coach_type
coach_type=$(echo "$coach_type" | tr 'a-z' 'A-Z')

case "$coach_type" in
  SL|3AC|2AC|1AC) ;;
  *)
    echo "Invalid coach type!"
    sleep 1
    return 0
    ;;
esac


case "$coach_type" in
    SL)  fare_per_person=500 ;;
    3AC) fare_per_person=900 ;;
    2AC) fare_per_person=1300 ;;
    1AC) fare_per_person=2000 ;;
esac



read -p "Kindly enter no. of passengers travelling (1-6): " total_passengers

if ! [[ "$total_passengers" =~ ^[0-9]+$ ]] || [ "$total_passengers" -lt 1 ] || [ "$total_passengers" -gt 6 ]; then   # ~ is match operator in bash. 
	echo "Invalid passenger count entered!"
	sleep 2
	return 0
fi

# PNR generation
part1=$((100 + RANDOM % 900))
part2=$((100000 + RANDOM % 900000))
pnr="$part1-$part2"


timestamp=$(date +%s)
total_fare=$((fare_per_person * total_passengers))

all_passengers=""


for (( i=1; i<=total_passengers; i++ ))
do
	echo ""
	echo "----- Passenger $i Details -----"

	# NAME VALIDATION
read -p "Name: " name
if [ -z "$name" ]; then
    echo "Name cannot be empty!"
    sleep 2
    return 0
fi

# AGE VALIDATION
read -p "Age: " age
if ! [[ "$age" =~ ^[0-9]+$ ]] || [ "$age" -le 0 ] || [ "$age" -gt 120 ]; then
    echo "Invalid age entered!"
    sleep 2
    return 0
fi

# GENDER VALIDATION
read -p "Gender (M/F/O): " gender
gender=$(echo "$gender" | tr 'a-z' 'A-Z')
if [[ "$gender" != "M" && "$gender" != "F" "$gender" != "O"]]; then
    echo "Invalid gender! Enter M or F or O."
    sleep 2
    return 0
fi

# AADHAR VALIDATION
read -p "Aadhar No. (12 digits): " an
if ! [[ "$an" =~ ^[0-9]{12}$ ]]; then
    echo "Invalid Aadhar Number!"
    sleep 2
    return 0
fi

# PHONE VALIDATION
read -p "Phone No. (10 digits): " pn
if ! [[ "$pn" =~ ^[0-9]{10}$ ]]; then
    echo "Invalid Phone Number!"
    sleep 2
    return 0
fi

# BERTH VALIDATION
read -p "Berth Preference (LB/MB/UB): " pref_berth
pref_berth=$(echo "$pref_berth" | tr 'a-z' 'A-Z')
if [[ "$pref_berth" != "LB" && "$pref_berth" != "MB" && "$pref_berth" != "UB" ]]; then
    echo "Invalid berth preference!"
    sleep 2
    return 0
fi

	# Try to book preferred berth
	seat_data=$(awk -F"|" -v t="$selected_train" -v d="$selected_date" -v c="$coach_type" -v b="$pref_berth" '$1==t && $2==d && $3==c && $6==b && $7=="Available" {print; exit}' seats.txt) 

	# If preferred berth not available --> allocating next available berth
	if [ -z "$seat_data" ]; then
	    for other_berth in LB MB UB; do
	        seat_data=$(awk -F"|" -v t="$selected_train" -v d="$selected_date" -v c="$coach_type" -v b="$other_berth" '$1==t && $2==d && $3==c && $6==b && $7=="Available" {print; exit}' seats.txt)
	        [ -n "$seat_data" ] && break
	    done
	fi

	# Confirming status of the ticket
	if [ -z "$seat_data" ];then
		echo "No seats available. Ticket will be WAITING!"
		status="WL"
		coach_no="NA"
		seatno="NA"
    		berth="NA"
	else
		status="CON"
		
		train=$(echo "$seat_data" | cut -d"|" -f1)
		date=$(echo "$seat_data" | cut -d"|" -f2)
		coach=$(echo "$seat_data" | cut -d"|" -f3)
		coach_no=$(echo "$seat_data" | cut -d"|" -f4)
		seatno=$(echo "$seat_data" | cut -d"|" -f5)
		berth=$(echo "$seat_data" | cut -d"|" -f6)

		awk -F"|" -v OFS="|" -v t="$train" -v d="$date" -v c="$coach" -v cn="$coach_no" -v s="$seatno" '{
        if ($1==t && $2==d && $3==c && $4==cn && $5==s){
            $7="Locked-$pnr"
	}
        print
    }' seats.txt > temp.txt && mv temp.txt seats.txt
	fi
	

	# Confirming if the user wants to continue booking waiting ticket
	if [ "$status" = "WL" ]; then
	read -p "Do you want to continue booking a WAITING LIST ticket? (Y/N): " choice
		choice=$(echo "$choice" | tr 'a-z' 'A-Z')
	
		if [ "$choice" != "Y" ]; then
			echo "Booking Cancelled Successfully!"
			sleep 2
			return 0
		fi
	fi

	passenger_block="$coach_type-$coach_no-$seatno-$berth-$status-$name-$age-$gender-$an-$pn"

	if [ -z "$all_passengers" ]; then
		all_passengers="$passenger_block"
	else
		all_passengers="$all_passengers,$passenger_block"
	fi
done

echo ""
echo "========================================="
echo "Total fare: Rs. $total_fare"
echo "Seats will be locked for 120 seconds. Complete payment to confirm booking."
echo "1. Proceed to Payment"
echo "2. Cancel Booking"
read -p "Kindly enter your choice: " pay_choice


if ! [[ "$pay_choice" =~ ^[0-9]+$ ]]; 
then
    echo "Invalid choice"
    return 0
fi

if [ "$pay_choice" -eq 2 ];
then
	echo "Releasing Locked Seats..."
	
	awk -F"|" -v OFS="|" '$7=="Locked-$pnr" { $7="Available" }
	{ print }
	'seats.txt > temp.txt && mv temp.txt seats.txt

	echo "Booking Cancelled Successfully!"
	sleep 2
	return 0
fi

echo ""
echo "Select Payment Method: "
echo "1. UPI"
echo "2. Card"
read -p "Kindly enter your choice: " payment_method


if ! [[ "$payment_method" =~ ^[0-9]+$ ]];
then
    echo "Invalid choice"
    return 0
fi

if [ "$payment_method" -eq 1 ];
then
	read -p "Kindly enter UPI ID: " upi

	if [[ ! "$upi" =~ ^[a-zA-Z0-9._-]+@[a-zA-Z0-9._-]+$ ]]
	then
		echo "Invalid UPI ID. Payment Failed!"
		payment_status="FAILED"
	else
		payment_status="SUCCESS"
	fi
fi
	
if [ "$payment_method" -eq 2 ];
then
	read -p "Kindly enter 16-digit Card Number: " card
	read -p "Kindly enter 3-digit CVV: " cvv

	if [[ ${#card} -ne 16 ]] || [[ ${#cvv} -ne 3 ]];
	then
		echo "Invalid Card Details. Payment Failed!"
		payment_status="FAILED"
	else
		payment_status="SUCCESS"
	fi
fi

if [ "$payment_status" = "FAILED" ];
then
	echo "Releasing locked seats..."

	awk -F"|" -v OFS="|" '$7=="Locked-$pnr" { $7="Available" }
	{ print }
	' seats.txt > temp.txt && mv temp.txt seats.txt

	echo "Booking Failed!"
	sleep 2
	return 0
fi

awk -F"|" -v OFS="|" '$7=="Locked-$pnr" { $7="Booked" }
{ print }
' seats.txt > temp.txt && mv temp.txt seats.txt

echo "$pnr|$current_user|$selected_train|$selected_date|$timestamp|$total_fare|$all_passengers" >> tickets.txt
echo "$pnr|$current_user|$total_fare|$payment_method|SUCCESS|$timestamp" >> payments.txt

echo ""
echo "========================================"
echo "Ticket Booked Successfully!     "
echo "PNR: $pnr"
echo "Coach Type: $coach_type"
echo "Journey Date: $jdate"
echo "Total Passengers: $total_passengers"
echo "Total Fare: Rs. $total_fare"
echo "========================================"

sleep 3
