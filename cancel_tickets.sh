echo "===== CANCEL TICKET ====="
echo ""
user_tickets=$(grep "|$current_user|" tickets.txt)

if [ -z "$user_tickets" ]; 
then
	echo "No tickets found!"
	sleep 2
	return 0
fi

count=1
declare -A ticket_map



echo ""
echo "------------------------------------------------------------------"

while  IFS="|" read -r pnr user train date time fare passengers
do
	train_info=$(grep "^$train|" trains.txt)

	train_name=$(echo "$train_info" | cut -d"|" -f2)
	from=$(echo "$train_info" | cut -d"|" -f3)
	to=$(echo "$train_info" | cut -d"|" -f4)

	echo "$count. $date | Train $train - $train_name | $from → $to"

	ticket_map[$count]="$pnr"
	count=$((count+1))
done <<< "$user_tickets"

echo ""
read -p "Kindly enter ticket number to to cancel the ticket (0 to go back): " choice

if [ "$choice" -eq 0 ];
then
	return 0;
fi

selected_pnr=${ticket_map[$choice]}
if [ -z "$selected_pnr" ]; then
    echo "Invalid selection!"
    sleep 2
    return 0
fi

ticket_data=$(grep "^$selected_pnr|" tickets.txt)

IFS="|" read -r pnr user train date time fare passengers <<< "$ticket_data"

echo ""
read -p "Are you sure you want to cancel PNR $pnr? (Y/N): " confirm
confirm=$(echo "$confirm" | tr 'a-z' 'A-Z')

if [ "$confirm" != "Y" ]; then
    echo "Cancellation aborted."
    sleep 2
    return 0
fi
current_time=$(date +%s)
journey_time=$(date -d "$date" +%s)
time_diff=$((journey_time - current_time))
days_left=$((time_diff / 86400))

echo ""

if [ "$journey_time" -le "$current_time" ]; then
    refund_percent=0
    refund_amount=0
    echo "Journey date already passed. No refund applicable."
fi


echo "Releasing confirmed seats..."

# Split passengers
IFS="," read -ra passenger_array <<< "$passengers"

for p in "${passenger_array[@]}"
do
    IFS="-" read -r coach_type coach_no seat berth status name age gender aadhar phone <<< "$p"

    # Release only confirmed seats
    if [ "$status" = "CON" ]; then
        awk -F"|" -v OFS="|" -v t="$train" -v d="$date" -v c="$coach_type" -v cn="$coach_no" -v s="$seat" '
        {
            if ($1==t && $2==d && $3==c && $4==cn && $5==s)
                $7="Available"
            print
        }' seats.txt > temp.txt && mv temp.txt seats.txt
    fi
done

# Remove ticket from tickets.txt
grep -v "^$selected_pnr|" tickets.txt > temp.txt && mv temp.txt tickets.txt

# Add refund entry in payments.txt
if [ "$days_left" -gt 20 ]; then
    refund_percent=100
elif [ "$days_left" -ge 8 ]; then
    refund_percent=80
elif [ "$days_left" -ge 1 ]; then
    refund_percent=50
else
    refund_percent=0
fi

refund_amount=$((fare * refund_percent / 100))

echo "Days left before journey : $days_left day(s)"
echo "Refund Percentage        : $refund_percent%"
echo "Refund Amount            : Rs. $refund_amount"
echo "----------------------------------------"
echo ""
timestamp=$(date +%s)
echo "$selected_pnr|$current_user|$refund_amount|REFUND|PROCESSED|$timestamp" >> payments.txt

echo ""
echo "================================================"
echo "Ticket Cancelled Successfully!"
echo "Refund of Rs. $refund_amount will be processed."
echo "================================================"
sleep 7
