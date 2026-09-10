/* =========================================================
   1. CREATE DATABASE
   ========================================================= */

DROP DATABASE IF EXISTS hotel_management;

CREATE DATABASE hotel_management;

USE hotel_management;


/* =========================================================
   2. CREATE ROOM_TYPES TABLE
   ========================================================= */

CREATE TABLE room_types (
    Type_ID INT PRIMARY KEY AUTO_INCREMENT,
    Type_Name VARCHAR(50) NOT NULL UNIQUE,
    Description VARCHAR(255),
    Max_Occupancy INT NOT NULL,
    Bed_Type VARCHAR(50),
    Area_sqft DECIMAL(8,2),
    Is_AC BOOLEAN NOT NULL DEFAULT TRUE,
    Base_Price DECIMAL(10,2) NOT NULL,
    Room_Type_Status VARCHAR(20) NOT NULL DEFAULT 'Available',

    CONSTRAINT chk_max_occupancy
        CHECK (Max_Occupancy > 0),

    CONSTRAINT chk_area
        CHECK (Area_sqft > 0),

    CONSTRAINT chk_base_price
        CHECK (Base_Price > 0),

    CONSTRAINT chk_room_type_status
        CHECK (Room_Type_Status IN
        ('Available', 'Unavailable'))
);


/* =========================================================
   3. CREATE CUSTOMERS TABLE
   ========================================================= */

CREATE TABLE customers (
    Customer_ID INT PRIMARY KEY AUTO_INCREMENT,
    First_Name VARCHAR(50) NOT NULL,
    Last_Name VARCHAR(50) NOT NULL,
    Email VARCHAR(100) NOT NULL UNIQUE,
    Phone_No VARCHAR(15) NOT NULL UNIQUE,
    Date_Of_Birth DATE,
    Gender VARCHAR(10),
    Address VARCHAR(255),
    City VARCHAR(50),
    ID_Proof_Type VARCHAR(50),
    ID_Proof_Number VARCHAR(50) UNIQUE,

    CONSTRAINT chk_gender
        CHECK (Gender IN ('Male', 'Female', 'Other'))
);


/* =========================================================
   4. CREATE ROOMS TABLE
   ========================================================= */

CREATE TABLE rooms (
    Room_ID INT PRIMARY KEY AUTO_INCREMENT,
    Room_Number VARCHAR(10) NOT NULL UNIQUE,
    Floor INT NOT NULL,
    Status VARCHAR(20) NOT NULL DEFAULT 'Available',
    Type_ID INT NOT NULL,
    Price_Per_Night DECIMAL(10,2) NOT NULL,
    Amenities VARCHAR(255),
    Smoking_Allowed BOOLEAN NOT NULL DEFAULT FALSE,
    View_Type VARCHAR(50),
    Last_Maintenance_Date DATE,

    CONSTRAINT fk_room_type
        FOREIGN KEY (Type_ID)
        REFERENCES room_types(Type_ID)
        ON UPDATE CASCADE
        ON DELETE RESTRICT,

    CONSTRAINT chk_floor
        CHECK (Floor > 0),

    CONSTRAINT chk_room_price
        CHECK (Price_Per_Night > 0),

    CONSTRAINT chk_room_status
        CHECK (Status IN
        ('Available', 'Occupied', 'Maintenance'))
);


/* =========================================================
   5. CREATE BOOKINGS TABLE
   ========================================================= */

CREATE TABLE bookings (
    Booking_ID INT PRIMARY KEY AUTO_INCREMENT,
    Customer_ID INT NOT NULL,
    Room_ID INT NOT NULL,
    Booking_Date DATE NOT NULL DEFAULT (CURRENT_DATE),
    Check_In_Date DATE NOT NULL,
    Check_Out_Date DATE NOT NULL,
    No_Of_Guests INT NOT NULL,
    Total_Amount DECIMAL(10,2) NOT NULL DEFAULT 0,
    Booking_Status VARCHAR(20) NOT NULL DEFAULT 'Confirmed',
    Special_Requests VARCHAR(255),

    CONSTRAINT fk_booking_customer
        FOREIGN KEY (Customer_ID)
        REFERENCES customers(Customer_ID)
        ON UPDATE CASCADE
        ON DELETE RESTRICT,

    CONSTRAINT fk_booking_room
        FOREIGN KEY (Room_ID)
        REFERENCES rooms(Room_ID)
        ON UPDATE CASCADE
        ON DELETE RESTRICT,

    CONSTRAINT chk_guests
        CHECK (No_Of_Guests > 0),

    CONSTRAINT chk_booking_dates
        CHECK (Check_Out_Date > Check_In_Date),

    CONSTRAINT chk_total_amount
        CHECK (Total_Amount >= 0),

    CONSTRAINT chk_booking_status
        CHECK (Booking_Status IN
        ('Confirmed', 'Checked-In', 'Checked-Out', 'Cancelled'))
);


/* =========================================================
   6. CREATE PAYMENTS TABLE
   ========================================================= */

CREATE TABLE payments (
    Payment_ID INT PRIMARY KEY AUTO_INCREMENT,
    Booking_ID INT NOT NULL,
    Payment_Date DATE NOT NULL DEFAULT (CURRENT_DATE),
    Amount DECIMAL(10,2) NOT NULL,
    Payment_Method VARCHAR(30) NOT NULL,
    Transaction_Ref VARCHAR(100) UNIQUE,
    Payment_Status VARCHAR(20) NOT NULL DEFAULT 'Pending',
    Currency VARCHAR(10) NOT NULL DEFAULT 'INR',
    Payment_Gateway VARCHAR(50),
    Remarks VARCHAR(255),

    CONSTRAINT fk_payment_booking
        FOREIGN KEY (Booking_ID)
        REFERENCES bookings(Booking_ID)
        ON UPDATE CASCADE
        ON DELETE RESTRICT,

    CONSTRAINT chk_payment_amount
        CHECK (Amount > 0),

    CONSTRAINT chk_payment_method
        CHECK (Payment_Method IN
        ('Cash', 'Card', 'UPI', 'Net Banking')),

    CONSTRAINT chk_payment_status
        CHECK (Payment_Status IN
        ('Pending', 'Completed', 'Failed', 'Refunded'))
);


/* =========================================================
   7. CREATE CHECK_IN_OUT TABLE
   ========================================================= */

CREATE TABLE check_in_out (
    Checkin_ID INT PRIMARY KEY AUTO_INCREMENT,
    Booking_ID INT NOT NULL UNIQUE,
    Checkin_Date DATE NOT NULL,
    Checkout_Date DATE,
    Actual_Checkin_Time TIME,
    Actual_Checkout_Time TIME,
    Checked_In_By VARCHAR(100),
    Room_Condition VARCHAR(100),
    Remarks VARCHAR(255),
    Status VARCHAR(20) NOT NULL DEFAULT 'Checked-In',

    CONSTRAINT fk_checkin_booking
        FOREIGN KEY (Booking_ID)
        REFERENCES bookings(Booking_ID)
        ON UPDATE CASCADE
        ON DELETE RESTRICT,

    CONSTRAINT chk_checkin_status
        CHECK (Status IN
        ('Checked-In', 'Checked-Out')),

    CONSTRAINT chk_checkout_date
        CHECK (
            Checkout_Date IS NULL
            OR Checkout_Date >= Checkin_Date
        )
);


/* =========================================================
   8. INSERT ROOM TYPES
   ========================================================= */

INSERT INTO room_types
(Type_Name, Description, Max_Occupancy, Bed_Type,
 Area_sqft, Is_AC, Base_Price, Room_Type_Status)
VALUES
('Single', 'Single room for one guest', 1, 'Single Bed',
 180, TRUE, 2000, 'Available'),

('Double', 'Room suitable for two guests', 2, 'Double Bed',
 250, TRUE, 3000, 'Available'),

('Deluxe', 'Deluxe room with premium facilities', 3, 'Queen Bed',
 350, TRUE, 4500, 'Available'),

('Suite', 'Luxury suite with living area', 4, 'King Bed',
 500, TRUE, 7000, 'Available'),

('Family', 'Large room for families', 5, 'King + Single Beds',
 600, TRUE, 8500, 'Available');


/* =========================================================
   9. INSERT CUSTOMERS
   ========================================================= */

INSERT INTO customers
(First_Name, Last_Name, Email, Phone_No, Date_Of_Birth,
 Gender, Address, City, ID_Proof_Type, ID_Proof_Number)
VALUES
('Rahul', 'Sharma', 'rahul@gmail.com', '9876543210',
 '2002-05-15', 'Male', 'MG Road', 'Bangalore',
 'Aadhar', 'AADHAR1001'),

('Priya', 'Kumar', 'priya@gmail.com', '9876543211',
 '2001-08-20', 'Female', 'Anna Nagar', 'Chennai',
 'Aadhar', 'AADHAR1002'),

('Arjun', 'Reddy', 'arjun@gmail.com', '9876543212',
 '2000-03-10', 'Male', 'Banjara Hills', 'Hyderabad',
 'Passport', 'PASS1003'),

('Sneha', 'Patel', 'sneha@gmail.com', '9876543213',
 '2003-01-25', 'Female', 'Navrangpura', 'Ahmedabad',
 'Aadhar', 'AADHAR1004'),

('Karan', 'Mehta', 'karan@gmail.com', '9876543214',
 '1999-11-05', 'Male', 'Andheri', 'Mumbai',
 'Driving License', 'DL1005');


/* =========================================================
   10. INSERT ROOMS
   ========================================================= */

INSERT INTO rooms
(Room_Number, Floor, Status, Type_ID, Price_Per_Night,
 Amenities, Smoking_Allowed, View_Type, Last_Maintenance_Date)
VALUES
('101', 1, 'Available', 1, 2000,
 'WiFi, TV', FALSE, 'Garden', '2026-06-01'),

('102', 1, 'Available', 2, 3000,
 'WiFi, TV, Mini Bar', FALSE, 'City', '2026-06-05'),

('201', 2, 'Available', 3, 4500,
 'WiFi, TV, Mini Bar, AC', FALSE, 'City', '2026-06-10'),

('202', 2, 'Available', 4, 7000,
 'WiFi, TV, Mini Bar, AC, Sofa', FALSE, 'Sea', '2026-06-12'),

('301', 3, 'Available', 5, 8500,
 'WiFi, TV, Mini Bar, AC, Sofa', FALSE, 'Garden', '2026-06-15'),

('302', 3, 'Maintenance', 3, 4500,
 'WiFi, TV, AC', FALSE, 'City', '2026-07-01');


/* =========================================================
   11. INSERT BOOKINGS
   ========================================================= */

INSERT INTO bookings
(Customer_ID, Room_ID, Booking_Date,
 Check_In_Date, Check_Out_Date,
 No_Of_Guests, Total_Amount,
 Booking_Status, Special_Requests)
VALUES
(1, 1, '2026-09-01', '2026-09-10', '2026-09-12',
 1, 4000, 'Confirmed', 'Late check-in'),

(2, 2, '2026-09-02', '2026-09-15', '2026-09-18',
 2, 9000, 'Confirmed', 'Extra pillows'),

(3, 3, '2026-09-03', '2026-09-20', '2026-09-22',
 2, 9000, 'Confirmed', 'Non-smoking room'),

(4, 4, '2026-09-04', '2026-09-25', '2026-09-28',
 3, 21000, 'Confirmed', 'Sea view'),

(5, 5, '2026-09-05', '2026-10-01', '2026-10-04',
 4, 25500, 'Confirmed', 'Family stay');


/* =========================================================
   12. INSERT PAYMENTS
   ========================================================= */

INSERT INTO payments
(Booking_ID, Payment_Date, Amount,
 Payment_Method, Transaction_Ref,
 Payment_Status, Currency, Payment_Gateway, Remarks)
VALUES
(1, '2026-09-01', 4000,
 'UPI', 'TXN1001', 'Completed', 'INR', 'Google Pay', 'Full payment'),

(2, '2026-09-02', 9000,
 'Card', 'TXN1002', 'Completed', 'INR', 'Razorpay', 'Full payment'),

(3, '2026-09-03', 5000,
 'UPI', 'TXN1003', 'Completed', 'INR', 'PhonePe', 'Partial payment'),

(4, '2026-09-04', 21000,
 'Net Banking', 'TXN1004', 'Completed', 'INR', 'Razorpay', 'Full payment'),

(5, '2026-09-05', 10000,
 'Card', 'TXN1005', 'Pending', 'INR', 'Stripe', 'Advance payment');


/* =========================================================
   13. INSERT CHECK-IN / CHECK-OUT DATA
   ========================================================= */

INSERT INTO check_in_out
(Booking_ID, Checkin_Date, Checkout_Date,
 Actual_Checkin_Time, Actual_Checkout_Time,
 Checked_In_By, Room_Condition, Remarks, Status)
VALUES
(1, '2026-09-10', NULL,
 '14:00:00', NULL,
 'Receptionist 1', 'Good', 'Guest checked in', 'Checked-In'),

(2, '2026-09-15', NULL,
 '14:30:00', NULL,
 'Receptionist 2', 'Good', 'Guest checked in', 'Checked-In');


/* =========================================================
   14. BASIC SELECT QUERIES
   ========================================================= */

-- Display all customers
SELECT * FROM customers;

-- Display all room types
SELECT * FROM room_types;

-- Display all rooms
SELECT * FROM rooms;

-- Display all bookings
SELECT * FROM bookings;

-- Display all payments
SELECT * FROM payments;

-- Display all check-in/check-out records
SELECT * FROM check_in_out;


/* =========================================================
   15. SELECT SPECIFIC COLUMNS
   ========================================================= */

SELECT Customer_ID, First_Name, Last_Name, Email
FROM customers;

SELECT Room_ID, Room_Number, Floor, Status, Price_Per_Night
FROM rooms;

SELECT Booking_ID, Customer_ID, Room_ID, Total_Amount, Booking_Status
FROM bookings;


/* =========================================================
   16. WHERE CLAUSE
   ========================================================= */

-- Available rooms
SELECT *
FROM rooms
WHERE Status = 'Available';

-- Rooms costing more than 4000
SELECT *
FROM rooms
WHERE Price_Per_Night > 4000;

-- Customers from Bangalore
SELECT *
FROM customers
WHERE City = 'Bangalore';

-- Confirmed bookings
SELECT *
FROM bookings
WHERE Booking_Status = 'Confirmed';


/* =========================================================
   17. ORDER BY
   ========================================================= */

-- Cheapest rooms first
SELECT *
FROM rooms
ORDER BY Price_Per_Night ASC;

-- Most expensive rooms first
SELECT *
FROM rooms
ORDER BY Price_Per_Night DESC;

-- Customers alphabetically
SELECT *
FROM customers
ORDER BY First_Name ASC;


/* =========================================================
   18. UPDATE
   ========================================================= */

UPDATE rooms
SET Price_Per_Night = 2200
WHERE Room_ID = 1;

UPDATE customers
SET Phone_No = '9999999999'
WHERE Customer_ID = 1;

UPDATE bookings
SET Booking_Status = 'Checked-In'
WHERE Booking_ID = 1;


/* =========================================================
   19. DELETE
   ========================================================= */

-- Example:
-- DELETE FROM customers
-- WHERE Customer_ID = 5;

-- Example:
-- DELETE FROM rooms
-- WHERE Room_ID = 6;


/* =========================================================
   20. AGGREGATE FUNCTIONS
   ========================================================= */

-- Number of customers
SELECT COUNT(*) AS Total_Customers
FROM customers;

-- Number of rooms
SELECT COUNT(*) AS Total_Rooms
FROM rooms;

-- Average room price
SELECT AVG(Price_Per_Night) AS Average_Room_Price
FROM rooms;

-- Highest room price
SELECT MAX(Price_Per_Night) AS Highest_Room_Price
FROM rooms;

-- Lowest room price
SELECT MIN(Price_Per_Night) AS Lowest_Room_Price
FROM rooms;

-- Total booking revenue
SELECT SUM(Total_Amount) AS Total_Booking_Revenue
FROM bookings;


/* =========================================================
   21. GROUP BY
   ========================================================= */

-- Number of rooms by status
SELECT Status, COUNT(*) AS Total_Rooms
FROM rooms
GROUP BY Status;

-- Number of customers by city
SELECT City, COUNT(*) AS Total_Customers
FROM customers
GROUP BY City;

-- Number of bookings by status
SELECT Booking_Status, COUNT(*) AS Total_Bookings
FROM bookings
GROUP BY Booking_Status;


/* =========================================================
   22. HAVING
   ========================================================= */

SELECT City, COUNT(*) AS Total_Customers
FROM customers
GROUP BY City
HAVING COUNT(*) > 1;

SELECT Booking_Status, COUNT(*) AS Total_Bookings
FROM bookings
GROUP BY Booking_Status
HAVING COUNT(*) >= 1;


/* =========================================================
   23. INNER JOIN
   ========================================================= */

-- Customer + Booking details
SELECT
    b.Booking_ID,
    c.First_Name,
    c.Last_Name,
    c.Email,
    b.Check_In_Date,
    b.Check_Out_Date,
    b.Total_Amount,
    b.Booking_Status
FROM bookings b
INNER JOIN customers c
ON b.Customer_ID = c.Customer_ID;


/* =========================================================
   24. JOIN BOOKINGS WITH ROOMS
   ========================================================= */

SELECT
    b.Booking_ID,
    r.Room_Number,
    r.Price_Per_Night,
    b.Check_In_Date,
    b.Check_Out_Date,
    b.Total_Amount
FROM bookings b
INNER JOIN rooms r
ON b.Room_ID = r.Room_ID;


/* =========================================================
   25. JOIN ROOMS WITH ROOM TYPES
   ========================================================= */

SELECT
    r.Room_ID,
    r.Room_Number,
    rt.Type_Name,
    rt.Bed_Type,
    rt.Max_Occupancy,
    r.Price_Per_Night
FROM rooms r
INNER JOIN room_types rt
ON r.Type_ID = rt.Type_ID;


/* =========================================================
   26. COMPLETE BOOKING REPORT
   ========================================================= */

SELECT
    b.Booking_ID,
    CONCAT(c.First_Name, ' ', c.Last_Name) AS Customer_Name,
    r.Room_Number,
    rt.Type_Name AS Room_Type,
    b.Check_In_Date,
    b.Check_Out_Date,
    b.No_Of_Guests,
    b.Total_Amount,
    b.Booking_Status
FROM bookings b
INNER JOIN customers c
    ON b.Customer_ID = c.Customer_ID
INNER JOIN rooms r
    ON b.Room_ID = r.Room_ID
INNER JOIN room_types rt
    ON r.Type_ID = rt.Type_ID;


/* =========================================================
   27. PAYMENT REPORT
   ========================================================= */

SELECT
    p.Payment_ID,
    b.Booking_ID,
    CONCAT(c.First_Name, ' ', c.Last_Name) AS Customer_Name,
    p.Amount,
    p.Payment_Method,
    p.Payment_Status,
    p.Payment_Date
FROM payments p
INNER JOIN bookings b
    ON p.Booking_ID = b.Booking_ID
INNER JOIN customers c
    ON b.Customer_ID = c.Customer_ID;


/* =========================================================
   28. LEFT JOIN
   ========================================================= */

-- Show all customers, including customers
-- who have no bookings
SELECT
    c.Customer_ID,
    c.First_Name,
    c.Last_Name,
    b.Booking_ID
FROM customers c
LEFT JOIN bookings b
ON c.Customer_ID = b.Customer_ID;


/* =========================================================
   29. RIGHT JOIN
   ========================================================= */

SELECT
    c.First_Name,
    c.Last_Name,
    b.Booking_ID,
    b.Total_Amount
FROM customers c
RIGHT JOIN bookings b
ON c.Customer_ID = b.Customer_ID;


/* =========================================================
   30. SUBQUERY
   ========================================================= */

-- Rooms costing more than the average room price
SELECT *
FROM rooms
WHERE Price_Per_Night >
(
    SELECT AVG(Price_Per_Night)
    FROM rooms
);


/* =========================================================
   31. SUBQUERY - MOST EXPENSIVE ROOM
   ========================================================= */

SELECT *
FROM rooms
WHERE Price_Per_Night =
(
    SELECT MAX(Price_Per_Night)
    FROM rooms
);


/* =========================================================
   32. SUBQUERY - CUSTOMERS WITH BOOKINGS
   ========================================================= */

SELECT First_Name, Last_Name, Email
FROM customers
WHERE Customer_ID IN
(
    SELECT Customer_ID
    FROM bookings
);


/* =========================================================
   33. SUBQUERY - BOOKINGS ABOVE AVERAGE
   ========================================================= */

SELECT *
FROM bookings
WHERE Total_Amount >
(
    SELECT AVG(Total_Amount)
    FROM bookings
);


/* =========================================================
   34. EXISTS SUBQUERY
   ========================================================= */

SELECT
    c.Customer_ID,
    c.First_Name,
    c.Last_Name
FROM customers c
WHERE EXISTS
(
    SELECT 1
    FROM bookings b
    WHERE b.Customer_ID = c.Customer_ID
);


/* =========================================================
   35. CREATE VIEW - AVAILABLE ROOMS
   ========================================================= */

CREATE OR REPLACE VIEW available_rooms AS
SELECT
    r.Room_ID,
    r.Room_Number,
    rt.Type_Name,
    r.Floor,
    r.Price_Per_Night,
    r.Amenities,
    r.View_Type
FROM rooms r
INNER JOIN room_types rt
ON r.Type_ID = rt.Type_ID
WHERE r.Status = 'Available';


/* VIEW OUTPUT */

SELECT * FROM available_rooms;


/* =========================================================
   36. CREATE VIEW - BOOKING REPORT
   ========================================================= */

CREATE OR REPLACE VIEW booking_report AS
SELECT
    b.Booking_ID,
    CONCAT(c.First_Name, ' ', c.Last_Name) AS Customer_Name,
    c.Email,
    r.Room_Number,
    rt.Type_Name AS Room_Type,
    b.Check_In_Date,
    b.Check_Out_Date,
    b.No_Of_Guests,
    b.Total_Amount,
    b.Booking_Status
FROM bookings b
INNER JOIN customers c
    ON b.Customer_ID = c.Customer_ID
INNER JOIN rooms r
    ON b.Room_ID = r.Room_ID
INNER JOIN room_types rt
    ON r.Type_ID = rt.Type_ID;


/* VIEW OUTPUT */

SELECT * FROM booking_report;


/* =========================================================
   37. STORED PROCEDURE - SHOW AVAILABLE ROOMS
   ========================================================= */

DELIMITER //

CREATE PROCEDURE GetAvailableRooms()
BEGIN
    SELECT
        r.Room_ID,
        r.Room_Number,
        rt.Type_Name,
        r.Price_Per_Night,
        r.Status
    FROM rooms r
    INNER JOIN room_types rt
    ON r.Type_ID = rt.Type_ID
    WHERE r.Status = 'Available';
END //

DELIMITER ;


/* CALL PROCEDURE */

CALL GetAvailableRooms();


/* =========================================================
   38. STORED PROCEDURE - CUSTOMER BOOKINGS
   ========================================================= */

DELIMITER //

CREATE PROCEDURE GetCustomerBookings(IN cust_id INT)
BEGIN
    SELECT
        b.Booking_ID,
        r.Room_Number,
        b.Check_In_Date,
        b.Check_Out_Date,
        b.Total_Amount,
        b.Booking_Status
    FROM bookings b
    INNER JOIN rooms r
    ON b.Room_ID = r.Room_ID
    WHERE b.Customer_ID = cust_id;
END //

DELIMITER ;


/* CALL PROCEDURE */

CALL GetCustomerBookings(1);


/* =========================================================
   39. STORED PROCEDURE - ADD CUSTOMER
   ========================================================= */

DELIMITER //

CREATE PROCEDURE AddCustomer(
    IN fname VARCHAR(50),
    IN lname VARCHAR(50),
    IN email_id VARCHAR(100),
    IN phone VARCHAR(15),
    IN city_name VARCHAR(50)
)
BEGIN
    INSERT INTO customers
    (First_Name, Last_Name, Email, Phone_No, City)
    VALUES
    (fname, lname, email_id, phone, city_name);
END //

DELIMITER ;


/* CALL PROCEDURE */

CALL AddCustomer(
    'Amit',
    'Singh',
    'amit@gmail.com',
    '9888888888',
    'Delhi'
);


/* =========================================================
   40. FUNCTION - CALCULATE NUMBER OF NIGHTS
   ========================================================= */

DELIMITER //

CREATE FUNCTION CalculateNights(
    checkin DATE,
    checkout DATE
)
RETURNS INT
DETERMINISTIC
BEGIN
    RETURN DATEDIFF(checkout, checkin);
END //

DELIMITER ;


/* USE FUNCTION */

SELECT
    Booking_ID,
    Check_In_Date,
    Check_Out_Date,
    CalculateNights(Check_In_Date, Check_Out_Date)
    AS Number_Of_Nights
FROM bookings;


/* =========================================================
   41. FUNCTION - CALCULATE BOOKING COST
   ========================================================= */

DELIMITER //

CREATE FUNCTION CalculateBookingCost(
    room_id INT,
    checkin DATE,
    checkout DATE
)
RETURNS DECIMAL(10,2)
READS SQL DATA
BEGIN
    DECLARE room_price DECIMAL(10,2);

    SELECT Price_Per_Night
    INTO room_price
    FROM rooms
    WHERE Room_ID = room_id;

    RETURN room_price * DATEDIFF(checkout, checkin);
END //

DELIMITER ;


/* USE FUNCTION */

SELECT
    Booking_ID,
    CalculateBookingCost(
        Room_ID,
        Check_In_Date,
        Check_Out_Date
    ) AS Calculated_Cost
FROM bookings;


/* =========================================================
   42. TRIGGER - AUTOMATICALLY CALCULATE TOTAL AMOUNT
   ========================================================= */

DELIMITER //

CREATE TRIGGER before_booking_insert
BEFORE INSERT ON bookings
FOR EACH ROW
BEGIN
    DECLARE room_price DECIMAL(10,2);

    SELECT Price_Per_Night
    INTO room_price
    FROM rooms
    WHERE Room_ID = NEW.Room_ID;

    SET NEW.Total_Amount =
        room_price *
        DATEDIFF(NEW.Check_Out_Date, NEW.Check_In_Date);
END //

DELIMITER ;


/* =========================================================
   43. TRIGGER - UPDATE BOOKING TOTAL WHEN DATES CHANGE
   ========================================================= */

DELIMITER //

CREATE TRIGGER before_booking_update
BEFORE UPDATE ON bookings
FOR EACH ROW
BEGIN
    DECLARE room_price DECIMAL(10,2);

    SELECT Price_Per_Night
    INTO room_price
    FROM rooms
    WHERE Room_ID = NEW.Room_ID;

    SET NEW.Total_Amount =
        room_price *
        DATEDIFF(NEW.Check_Out_Date, NEW.Check_In_Date);
END //

DELIMITER ;


/* =========================================================
   44. TRIGGER - UPDATE BOOKING STATUS AFTER PAYMENT
   ========================================================= */

DELIMITER //

CREATE TRIGGER after_payment_insert
AFTER INSERT ON payments
FOR EACH ROW
BEGIN

    IF NEW.Payment_Status = 'Completed' THEN

        UPDATE bookings
        SET Booking_Status = 'Confirmed'
        WHERE Booking_ID = NEW.Booking_ID;

    END IF;

END //

DELIMITER ;


/* =========================================================
   45. TEST TRIGGER
   ========================================================= */

INSERT INTO bookings
(
    Customer_ID,
    Room_ID,
    Check_In_Date,
    Check_Out_Date,
    No_Of_Guests,
    Booking_Status
)
VALUES
(
    1,
    2,
    '2026-11-10',
    '2026-11-13',
    2,
    'Confirmed'
);


/* Check automatically calculated amount */

SELECT *
FROM bookings
ORDER BY Booking_ID DESC
LIMIT 1;


/* =========================================================
   46. INDEXES
   ========================================================= */

CREATE INDEX idx_customer_email
ON customers(Email);

CREATE INDEX idx_booking_customer
ON bookings(Customer_ID);

CREATE INDEX idx_booking_room
ON bookings(Room_ID);

CREATE INDEX idx_booking_dates
ON bookings(Check_In_Date, Check_Out_Date);

CREATE INDEX idx_payment_booking
ON payments(Booking_ID);

CREATE INDEX idx_room_status
ON rooms(Status);


/* =========================================================
   47. TRANSACTION - BOOKING
   ========================================================= */

START TRANSACTION;

INSERT INTO bookings
(
    Customer_ID,
    Room_ID,
    Check_In_Date,
    Check_Out_Date,
    No_Of_Guests,
    Booking_Status
)
VALUES
(
    2,
    1,
    '2026-12-01',
    '2026-12-03',
    1,
    'Confirmed'
);

COMMIT;


/* =========================================================
   48. TRANSACTION WITH ROLLBACK
   ========================================================= */

START TRANSACTION;

UPDATE rooms
SET Status = 'Maintenance'
WHERE Room_ID = 1;

-- If everything is correct:
COMMIT;

-- If something goes wrong instead of COMMIT use:
-- ROLLBACK;


/* =========================================================
   49. USEFUL HOTEL REPORTS
   ========================================================= */

-- 1. Available rooms
SELECT *
FROM available_rooms;


-- 2. All bookings with customer names
SELECT *
FROM booking_report;


-- 3. Total revenue
SELECT
    SUM(Amount) AS Total_Revenue
FROM payments
WHERE Payment_Status = 'Completed';


-- 4. Total payments by method
SELECT
    Payment_Method,
    SUM(Amount) AS Total_Amount
FROM payments
WHERE Payment_Status = 'Completed'
GROUP BY Payment_Method;


-- 5. Customer-wise total booking amount
SELECT
    c.Customer_ID,
    CONCAT(c.First_Name, ' ', c.Last_Name) AS Customer_Name,
    SUM(b.Total_Amount) AS Total_Spent
FROM customers c
INNER JOIN bookings b
ON c.Customer_ID = b.Customer_ID
GROUP BY c.Customer_ID, c.First_Name, c.Last_Name
ORDER BY Total_Spent DESC;


-- 6. Room-type-wise bookings
SELECT
    rt.Type_Name,
    COUNT(b.Booking_ID) AS Total_Bookings
FROM room_types rt
INNER JOIN rooms r
ON rt.Type_ID = r.Type_ID
LEFT JOIN bookings b
ON r.Room_ID = b.Room_ID
GROUP BY rt.Type_ID, rt.Type_Name;


-- 7. Supplier-style equivalent:
-- Room type-wise revenue
SELECT
    rt.Type_Name,
    SUM(b.Total_Amount) AS Revenue
FROM room_types rt
INNER JOIN rooms r
ON rt.Type_ID = r.Type_ID
INNER JOIN bookings b
ON r.Room_ID = b.Room_ID
GROUP BY rt.Type_ID, rt.Type_Name
ORDER BY Revenue DESC;


-- 8. Customers who spent more than average
SELECT
    c.Customer_ID,
    CONCAT(c.First_Name, ' ', c.Last_Name) AS Customer_Name,
    SUM(b.Total_Amount) AS Total_Spent
FROM customers c
INNER JOIN bookings b
ON c.Customer_ID = b.Customer_ID
GROUP BY c.Customer_ID, c.First_Name, c.Last_Name
HAVING SUM(b.Total_Amount) >
(
    SELECT AVG(Total_Amount)
    FROM bookings
);


-- 9. Pending payments
SELECT *
FROM payments
WHERE Payment_Status = 'Pending';


-- 10. Current checked-in guests
SELECT
    c.First_Name,
    c.Last_Name,
    r.Room_Number,
    cio.Checkin_Date,
    cio.Status
FROM check_in_out cio
INNER JOIN bookings b
ON cio.Booking_ID = b.Booking_ID
INNER JOIN customers c
ON b.Customer_ID = c.Customer_ID
INNER JOIN rooms r
ON b.Room_ID = r.Room_ID
WHERE cio.Status = 'Checked-In';


/* =========================================================
   50. FINAL DATABASE CHECK
   ========================================================= */

SHOW TABLES;

SELECT * FROM room_types;
SELECT * FROM customers;
SELECT * FROM rooms;
SELECT * FROM bookings;
SELECT * FROM payments;
SELECT * FROM check_in_out;