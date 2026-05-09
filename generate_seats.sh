> seats.txt #clear all before data in seats.txt

trains=$(cut -d"|" -f1 trains.txt)  # this extracts the train no. from 'trains.txt' file and store it into new varibale 'trains'
today=$(date +%Y-%m-%d)

for train in $trains
do
  for day in {0..29}
  do
    jdate=$(date -d "$today + $day days" +%Y-%m-%d)

    for coach in S1 S2 B1 B2 A1 A2 H1 H2
    do	      
	if [[ $coach == S* ]]; then type="SL"
	elif [[  $coach == B* ]]; then type="3AC"
	elif [[  $coach == A* ]]; then type="2AC"
	elif [[  $coach == H* ]]; then type="1AC"
	else continue
	fi

	seat=1

	#17 Lower Berths
	for i in {1..17}
	do
	  echo "$train|$jdate|$type|$coach|$seat|LB|Available" >> seats.txt
	  ((seat++))
	done

	#17 Middle Berths
	for i in {1..17}
	do
	  echo "$train|$jdate|$type|$coach|$seat|MB|Available" >> seats.txt
	  ((seat++))
	done

	#17 Upper Berths
	for i in {1..17}
	do
	  echo "$train|$jdate|$type|$coach|$seat|UB|Available" >> seats.txt
	  ((seat++))
	done
   done
  done
done

echo "Seat data generated successfully!"

