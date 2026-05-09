# 🚆 Linux Railway Reservation System

A terminal-based Railway Ticket Booking System developed using Bash Shell Scripting in a Red Hat Linux environment.  

This project simulates real-world railway reservation workflows including passenger authentication, train search, seat allocation, waiting list handling, payment validation, ticket generation, and cancellation with refund processing.

---

## ✨ Features

### 🔐 Authentication System
- Passenger Registration
- Secure Login System
- Duplicate Username Prevention

### 🚆 Train Search System
- Search by Train Number
- Search by Train Name
- Search by Source → Destination
- Guest Mode Train Checking

### 🎫 Ticket Booking Engine
- Dynamic Seat Allocation
- Preferred Berth Selection
- Automatic Alternate Berth Allocation
- Multi-Passenger Booking (1–6 passengers)
- PNR Generation System
- Waiting List (WL) Support

### 💳 Payment Module
- UPI Validation
- Card Validation
- Temporary Seat Locking During Payment
- Payment Failure Handling

### 📂 Ticket Management
- Show All Booked Tickets
- Detailed Ticket View
- Ticket Cancellation
- Refund Calculation System
- Automatic Seat Restoration After Cancellation

---

## 🛠️ Technologies Used

- Bash Shell Scripting
- Red Hat Linux
- VMware Workstation
- Linux Utilities:
  - `awk`
  - `grep`
  - `cut`
  - `tr`
  - `date`
- File Handling System

---

## 🧠 Core Concepts Implemented

- File-Based Database Management
- Authentication System
- Regex Validation
- Dynamic Seat Inventory Generation
- State Management
- Booking Lifecycle Processing
- Waiting List Handling
- Refund Processing Logic
- Linux Text Processing Utilities
- Modular Shell Script Architecture

---

## 📁 Project Structure

```text
Linux-Railway-Reservation-System/
│
├── scripts/
│   ├── main.sh
│   ├── register.sh
│   ├── login.sh
│   ├── dashboard.sh
│   ├── check_trains.sh
│   ├── booking.sh
│   ├── show_tickets.sh
│   ├── cancel_ticket.sh
│   └── generate_seats.sh
│
├── storage_text_files/
│   ├── users.txt
│   ├── trains.txt
│   ├── seats.txt
│   ├── tickets.txt
│   └── payments.txt
│
│
├── output/
│   └── OUTPUT.pdf
│   └── output preview.mp4
│
└── README.md
```

---

## ⚙️ How to Run

### 1️⃣ Give Execution Permission

```bash
chmod +x *.sh
```

### 2️⃣ Generate Seat Data

```bash
./generate_seats.sh
```

### 3️⃣ Start the System

```bash
./main.sh
```

---

## 🚄 Reservation Workflow

1. Passenger Registration/Login
2. Search Available Trains
3. Select Journey Date
4. Choose Coach Type
5. Enter Passenger Details
6. Seat Allocation Process
7. Payment Validation
8. Ticket Generation
9. Ticket Viewing/Cancellation

---

## 🔥 Advanced Functionalities

- Dynamic seat generation for upcoming 30 days
- Seat status tracking:
  - Available
  - Locked
  - Booked
  - Waiting List
- Automatic fallback berth allocation
- Real-time seat availability calculation
- Payment timeout handling
- Refund calculation based on cancellation timing
- Persistent storage using `.txt` files

---

## 📸 Preview video of my project


https://github.com/user-attachments/assets/046b86cc-c169-4232-8ac2-b51cace6b302



---

## 📄 Project Documentation

Detailed execution screenshots and workflow documentation are available in:

```text
/output/OUTPUT.pdf
```

---

## 🚀 Future Enhancements

- Database Integration (MySQL/PostgreSQL)
- Admin Dashboard
- Live Train Status
- Email/SMS Ticket Notifications
- GUI Version
- Online Payment Gateway
- RAC Ticket Logic
- Password Encryption

---

## 👨‍💻 Developed By

### Veera Gupta

BSc. Information Technology Student  
Passionate about Linux, Backend Logic, and System Development.

---
