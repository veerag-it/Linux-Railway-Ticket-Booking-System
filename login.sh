echo "===== Passenger Login ====="

read -p "Username: " un
read -s -p "Password: " password
echo

if grep -Fq "$un|$password|" users.txt
then
   current_user="$un"
   echo "Login successful!"
   sleep 2
else
   echo "Passenger not found. Registration required!"
   sleep 2
fi
