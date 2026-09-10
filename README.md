🏨 Hotel Management System

A MySQL-based DBMS project for managing hotel operations — from customer registration to booking, payment, and check-out.

<p align="center">






</p>

✨ About the Project

The Hotel Management System is a relational database project developed using MySQL.

It provides a structured way to manage:

👤 Customer information

🛏️ Room types and rooms

📅 Hotel bookings

💳 Payments

🏨 Check-in and check-out details

The main idea is to keep all hotel information organized in one database and make common hotel operations easier to manage.

🧩 Database Structure

The system contains 6 main tables:

#

Table

Purpose

01

Customers

Stores customer details

02

Room_Types

Stores different room categories

03

Rooms

Stores physical room information

04

Bookings

Stores reservation details

05

Payments

Stores payment transactions

06

Check_In_Out

Stores arrival and departure details

🔗 System Flow

👤 Customer
     ↓
🛏️ Room Type
     ↓
🚪 Room
     ↓
📅 Booking
     ↓
💳 Payment
     ↓
🏨 Check-In / Check-Out

🚀 Key Features

👤 Customer Management

Store and manage customer information such as name, contact details, address and ID proof.

🛏️ Room Management

Maintain room types, room numbers, room status, pricing and other room information.

📅 Booking Management

Manage check-in/check-out dates, guest count, booking status and total booking amount.

💳 Payment Management

Record payment amount, payment method, transaction reference and payment status.

⚡ Automatic Booking Calculation

The database can automatically calculate the booking amount based on:

Number of Nights × Price Per Night

🔄 CRUD Operations

Supports the basic database operations:

Create → Read → Update → Delete

🔗 SQL Queries

Includes:

INNER JOIN

LEFT JOIN

Aggregate Functions

Subqueries

HAVING clause

🧠 Database Concepts

The project demonstrates:

Primary Keys

Foreign Keys

Referential Integrity

Normalization

SQL Constraints

Triggers

ACID Transactions

⚙️ Technologies

Technology

Usage

🐬 MySQL

Database

🧾 SQL

Queries and database operations

🗄️ DBMS Concepts

Database design and management

📂 Project Files

Hotel-Management-System/
│
├── 📄 README.md
├── 🗃️ hotel_management.sql
├── 🖼️ ER_Diagram.png
└── 📊 Hotel_Management_System.pptx

Add the SQL file, ER diagram and presentation to this repository to keep the complete project together.

▶️ How to Run

1️⃣ Open MySQL Workbench

Open MySQL Workbench on your computer.

2️⃣ Open the SQL file

Open:

hotel_management.sql

3️⃣ Execute the script

Run the SQL script to create the database and required tables.

4️⃣ Test the database

Run your SELECT, JOIN, INSERT, UPDATE and other queries to test the system.

📊 Example Query

To display all records from a table:

SELECT * FROM customers;

You can use the same format for the other tables:

SELECT * FROM room_types;
SELECT * FROM rooms;
SELECT * FROM bookings;
SELECT * FROM payments;
SELECT * FROM check_in_out;

👨‍💻 Team 15

Team Member

Ganapathiraju Venkata Atchutha Ramaraju

Ganta Yasaswini

Boyina Kundana Venkata Sai

🎓 Project

DBMS Laboratory Project

🏨 Hotel Management System

Organized data. Easier management. Better hotel operations.

<p align="center">
  ⭐ If you find this project useful, consider giving the repository a star!
</p>
