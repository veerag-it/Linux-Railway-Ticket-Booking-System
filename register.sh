echo "===== Passenger Registration Process ====="

read -p "Name: " name
read -p "Age: " age
if ! [[ "$age" =~ ^[0-9]+$ ]] || [ "$age" -le 0 ] || [ "$age" -gt 120 ]; then
    echo "Invalid age entered!"
    sleep 2
    return 0
fi

read -p "Aadhar Number(12 digits): " an
if ! [[ "$an" =~ ^[0-9]{12}$ ]]; then
    echo "Invalid Aadhar Number!"
    sleep 2
    return 0
fi


read -p "Phone Number(10 digits): " pn
if ! [[ "$pn" =~ ^[0-9]{10}$ ]]; then
    echo "Invalid Phone Number!"
    sleep 2
    return 0
fi

read -p "Username: " un
read -s -p "Password: " password  # -s while reading the input --> the password will not be seen in the terminal while entering
echo

# Check is username (un)already exists 
if grep -q "^$un|" users.txt   # -q is quite mode, without it, the matching text will be printed on the terminal.
then 
   echo "Username $un already exists!"
   sleep 2
else
   echo "$un|$password|$name|$age|$an|$pn|" >> users.txt
   echo "Registration successful."
   sleep 2
fi


