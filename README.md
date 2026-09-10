# Hotel Management System

## Project Overview

The Hotel Management System is a DBMS project developed using MySQL.

It is designed to manage important hotel operations such as customer details, room inventory, bookings, payments, and check-in/check-out records.

The system provides a centralized and organized database for hotel administrators and receptionists.


## Technologies Used

- MySQL
- SQL
- Database Management Systems (DBMS)


## Database Tables

The project contains six main relational tables:

- **Customers** – Stores customer details such as name, contact information, address, date of birth, and ID proof.

- **Room_Types** – Stores room categories, bed type, maximum occupancy, AC status, area, and base price.

- **Rooms** – Stores physical room details such as room number, floor, status, room type, and price per night.

- **Bookings** – Stores customer bookings, stay dates, guest count, booking status, and total amount.

- **Payments** – Stores payment details including amount, payment method, transaction reference, and payment status.

- **Check_In_Out** – Stores arrival and departure information, actual check-in/check-out time, room condition, and status.


## Main Features

- Customer management
- Room type and room inventory management
- Hotel booking management
- Payment management
- Check-in and check-out tracking
- Automatic booking cost calculation
- SQL triggers
- Primary and foreign keys
- Referential integrity
- 1NF, 2NF and 3NF normalization
- CRUD operations
- SQL joins and aggregate functions
- Subqueries and HAVING clause
- Views and stored procedures
- User-defined functions
- ACID transactions
- B-Tree indexes


## Basic System Flow

**Customer → Room Type → Room → Booking → Payment → Check-In/Out**


## How to Run the Project

1. Install and open MySQL Workbench.
2. Open the `hotel_management.sql` file.
3. Execute the SQL script.
4. The database and required tables will be created.
5. Run the required SQL queries to view and manage the data.


## Automated Triggers

### 1. Booking Tariff Calculation

The `before_booking_insert` trigger automatically calculates the total booking amount using:

**Number of nights × Price per night**

The project also includes a `before_booking_update` trigger that recalculates the booking amount when the booking dates or room are updated.


### 2. Payment Confirmation

The `after_payment_insert` trigger updates the booking status to **Confirmed** when a completed payment is recorded.


## Reports

The system can generate reports such as:

- Revenue by payment mode
- Room category occupancy
- Current in-house guests
- Customer booking information
- Room and booking details


## ER Diagram

The ER model contains six core entities connected through relationships between customers, room types, rooms, bookings, payments, and check-in/check-out records.

The main relationships are:

- One customer can have multiple bookings.
- One room type can have multiple rooms.
- One room can be associated with multiple bookings over time.
- One booking can have multiple payments.
- One booking can have zero or one check-in/check-out record.


## Team 

- **Ganapathiraju Venkata Atchutha Ramaraju**
- **Ganta Yasaswini**
- **Boyina Kundana Venkata Sai**
