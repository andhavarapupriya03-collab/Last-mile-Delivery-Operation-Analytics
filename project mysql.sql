DROP DATABASE IF EXISTS DELIVERY_MANAGEMENT_DB;
CREATE DATABASE DELIVERY_MANAGEMENT_DB;
USE DELIVERY_MANAGEMENT_DB;
-- CUSTOMERS TABLE
CREATE TABLE CUSTOMERS(
CUSTOMER_ID VARCHAR(20) PRIMARY KEY,
CUSTOMER_NAME VARCHAR(100),
CITY VARCHAR(50),
DELIVERY_ZONE_ID VARCHAR(10),
PREFERRED_TIME_SLOT VARCHAR(30),
CUSTOMER_TYPE VARCHAR(20),
ACCOUNT_SINCE VARCHAR(20)
);

-- ORDERS TABLE
CREATE TABLE ORDERS(
ORDER_ID VARCHAR(20) PRIMARY KEY,
CUSTOMER_ID VARCHAR(20),
ORDER_DATE VARCHAR(20),
DELIVERY_ZONE_ID VARCHAR(10),
PACKAGE_WEIGHT_KG DECIMAL(5,2),
SERVICE_TYPE VARCHAR(20),
PRIORITY VARCHAR(10),
TOTAL_VALUE DECIMAL(10,2),

CONSTRAINT CUSTOMERID FOREIGN KEY(CUSTOMER_ID) REFERENCES CUSTOMERS(CUSTOMER_ID)
);

-- DRIVERS TABLE
CREATE TABLE DRIVERS(
DRIVER_ID VARCHAR(10) PRIMARY KEY,
DRIVER_NAME VARCHAR(100),
HIRE_DATE VARCHAR(20),
RATING DECIMAL(3,2),
EMPLOYMENT_TYPE VARCHAR(20),
IS_ACTIVE VARCHAR(3)
);

-- VEHICLES TABLE
CREATE TABLE VEHICLES(
VEHICLE_ID VARCHAR(10) PRIMARY KEY,
VEHICLE_TYPE VARCHAR(20),
FUEL_TYPE VARCHAR(20),
MAX_PAYLOAD_KG DECIMAL(7,2),
DEPOT VARCHAR(10),
LAST_SERVICE_DATE VARCHAR(20),
IS_ACTIVE VARCHAR(3)
);

-- DELIVERIES TABLE
CREATE TABLE DELIVERIES(
DELIVERY_ID VARCHAR(20) PRIMARY KEY,
ORDER_ID VARCHAR(20),
DRIVER_ID VARCHAR(10),
VEHICLE_ID VARCHAR(10),
ASSIGNED_DATE VARCHAR(20),
ACTUAL_DELIVERY_DATE VARCHAR(20),
STATUS VARCHAR(20),
DELIVERY_ATTEMPT TINYINT,
DISTANCE_KM DECIMAL(6,2),
DELIVER_DURATION_MIN INT,

CONSTRAINT ORDERID FOREIGN KEY(ORDER_ID) REFERENCES ORDERS(ORDER_ID),
CONSTRAINT DRIVERID FOREIGN KEY(DRIVER_ID) REFERENCES DRIVERS(DRIVER_ID),
CONSTRAINT VEHICLEID FOREIGN KEY(VEHICLE_ID) REFERENCES VEHICLES(VEHICLE_ID)
);
SHOW TABLES;
SELECT * FROM CUSTOMERS;
SELECT COUNT(*) FROM CUSTOMERS;
SELECT * FROM ORDERS;
SELECT COUNT(*) FROM ORDERS;
SELECT * FROM DRIVERS;
SELECT COUNT(*) FROM DRIVERS;
SELECT * FROM VEHICLES;
SELECT COUNT(*) FROM VEHICLES;
SELECT * FROM DELIVERIES;
SELECT COUNT(*) FROM DELIVERIES;

-- ANALYTICAL THINKING FROM THE ER DIAGRAM

-- 1. Management wants to find customers who have placed multiple orders. What information would you need to identify them?
/* THE INFORMATION WE NEED WHICH CUSTOMER PLACED THE ORDER AND HOW MANY ORDERS EACH CUSTOMER PLACED,TABLES WE USE CUSTOMERS AND ORDERS AND 
EXTRACT COLUMNS WE NEED AND USE AGGREAGTE FUNCTION LIKE COUNT TO COUNT THE NUMBER OF ORDERS FOR EACH CUSTOMER AND IDENTIFY CUSTOMERS WITH MORE THAN ONE ORDER.*/

-- 2. The Operations team wants to identify orders that required more than one delivery attempt. Where would you find the information needed to investigate this?
/* THE INFORMATION WE NEED ORDERS REQURING MORE THA ONE ATTEMPT,WE NEED ONLY DELIVERY TABLE AND EXTRACT THE COLUMN DELIVERY_ATTEMPT THEN USE WHERE CLAUSE TO FIND WHO ORDERS REQURING MORE THAN ONE ATTEMPT.*/

-- 3. The Customer team wants to compare Business and Individual customers based on their ordering activity. Which tables and columns would you need?
/* WE NEED CUSTOMERS AND ORDERS TABLES IN THAT WE NEED CUSTOMER_ID,CUSTOMER_TYPE COLUMNS FROM CUSTOMERS TABLE AND CUSTOMER_ID,ORDER_ID FROM ORDERS TABLE THEN SEPARATE CUSTOMERS INTO BUSINESS AND INDIVIDUAL,THEN COMPARE THEIR ORDERING ACTIVITY.*/

-- 4. The Operations team wants to compare different service types based on how far deliveries travel and how long they take. Which tables would you need to connect?
/* WE NEED ORDERS AND DELIVERY TABLES USING ORDER_ID,SERVICE_TYPE,DISTANCE_KM,DELIVERY_DURATION_MIN COLUMNS FROM TABLES THEN WE CAN COMPARE BASED ON DISTANCE TRAVELLED AND DELIVERY DURATION.*/

-- 5. The team wants to identify which drivers have handled deliveries and examine their recorded ratings. What information would you need?
/* THE INFORMATION WE NEED THAT DRIVER AND DELIVERIES TABLES AND EXTRACT COLUMNS LIKE DRIVER_ID,DRIVER_NAME AND RATING THEN CONNECT DRIVERS TO THEIR DELIVERIES AND EXAMINE THEIR RECORDING RATINGS*/

-- 6. Operations wants to understand whether different types of vehicles are being used for different deliveries. Which tables and columns would you need?
/* WE NEED VEHICLES AND DELIVERY TABLES AND WE HAVE TO EXTRACT VEHICLE_ID,VEHICLE_TYPE,DELIVERY_ID COLUMNS USING THESE COLUMNS WE DETERMINE WHICH VEHICLE TYPES ARE BEING USED FOR DELIVERIES.*/

-- 7. Management wants to compare delivery performance across different delivery zones. What information would you need from the database?
/* WE NEED ORDERS AND DELIVERY TABLES FROM THE DATABASE AND EXTRACT COLUMNS LIKE DELIVERY_ZONE_ID,ORDER_ID,STATUS, AND DELIVERY_DURATION_MIN
FROM TABLES AND WE HAVE TO CONNECT ORDERS WITH DELIVERIES AND COMPARE DELIVERY PERFORMANCE ACROSS DIFFERENT ZONES.*/

-- 8. The Operations team wants to investigate whether heavier packages are associated with longer delivery durations. Which information would you need, and where would you find it?
/* WE NEED orders and deliveries tables then we can compare package weight with delivery duration to investigate whether heavier packages are associated with longer delivery times.*/

-- 9. Management wants to understand whether delivery outcomes differ across service types. What tables and information would you bring together?
/* THE TABLES WE NEED ORDERS AND DELIVERIES AND CONNECT EACH ORDERS SERVICE TYPE WITH ITS DELIVERY STATUS AND COMPARE THEM.*/

-- 10. The Operations team wants to understand which customers have placed orders and how their orders are being handled. What information would you need to connect a customer with their orders and deliveries?
/* THE TABLES WE NEED CUSTOMERS,ORDERS AND DELIVERIES AND START WITH A CUSTOMER,FIND THEIR ORDERS , AND THEN FIND HOW THOSE ORDERS WERE HANDLED THROUGH DELIVERIES*/

--  BASIC ANALYSIS / DATA EXPLORATION

-- 1.What is the total number of customers?
SELECT COUNT(*) AS NO_OF_CUSTOMERS FROM CUSTOMERS;
-- 2.What is the total number of orders?
SELECT COUNT(*) AS NO_OF_ORDERS FROM ORDERS;
-- 3.What is the total number of deliveries?
SELECT COUNT(*) NO_OF_DELIVERIES FROM DELIVERIES;
-- 4.What are the different service types available?
SELECT DISTINCT SERVICE_TYPE FROM ORDERS;
-- 5.How many drivers are currently active?
SELECT COUNT(*) AS ACTIVE_DRIVERS FROM DRIVERs
WHERE IS_ACTIVE='YES';
-- 6.What are the different vehicle types?
SELECT DISTINCT VEHICLE_TYPE FROM VEHICLES;
-- 7.What is the total order value?
SELECT SUM(TOTAL_VALUE) AS TOTAL_ORDER_VALUE FROM ORDERS;
-- 8.What is the average package weight?
SELECT AVG(PACKAGE_WEIGHT_KG) AS AVERAGE_PACKAGE_WEIGHT FROM ORDERS;

-- OBJECTIVE-BASED ANALYSIS

-- UNDERSTAND DELIVERY DEMAND

-- 1.Which delivery zones have the highest number of orders?
SELECT DELIVERY_ZONE_ID,COUNT(ORDER_ID) AS TOTAL_ORDERS 
FROM ORDERS
GROUP BY DELIVERY_ZONE_ID
ORDER BY TOTAL_ORDERS DESC;
/* Bussiness Insights
The delivery zone with the highest number of orders has the greatest demand and may require more delivery resources*/
-- 2.Which service type has highest number of orders?
SELECT  SERVICE_TYPE,COUNT(ORDER_ID) AS TOTAL_ORDERS FROM ORDERS
GROUP BY SERVICE_TYPE
ORDER BY TOTAL_ORDERS DESC;
/*Bussiness Insights
The service type with the highest order count is the most commonly used service and should receive appropriate operational capacity*/
-- 3.How are orders distributed accross different priorities?
SELECT PRIORITY,COUNT(ORDER_ID) AS TOTAL_ORDERS FROM ORDERS
GROUP BY PRIORITY
ORDER BY TOTAL_ORDERS DESC;
/*Bussiness Insights
This shows whether the business receives more high-priority,medium-priority or low-priority orders.*/
-- 4.How does order volume change over time?
SELECT ORDER_DATE,COUNT(ORDER_ID) AS TOTAL_ORDERS FROM ORDERS
GROUP BY ORDER_DATE
ORDER BY ORDER_DATE DESC;
/*Bussiness Insights
This helps identify dates with particularly high or low demand.*/

-- UNDERSTAND CUSTOMER ORDER BEHAVIOUR

-- 1.Which customers placed the most orders?
SELECT CUSTOMER_ID,COUNT(ORDER_ID) AS TOTAL_ORDERS FROM ORDERS
GROUP BY CUSTOMER_ID
ORDER BY TOTAL_ORDERS DESC;
/*Business Insights
Customer with a higher number of orders are the most active customers*/
-- 2.Which customer have highest total order value?
SELECT CUSTOMER_ID,SUM(TOTAL_VALUE) AS TOTAL_ORDER_VALUE FROM ORDERS
GROUP BY CUSTOMER_ID
ORDER BY TOTAL_ORDER_VALUE DESC;
/*Business Insights
Why sum()?
If one customer has orders worth:1000,2000,1500 
then:1000+2000+1500=5000
So,sum(total_value) gives the customers total order value*/
-- 3.Do business and individual have different ordering category?
SELECT C.CUSTOMER_TYPE,COUNT(O.ORDER_ID) AS TOTAL_ORDERS 
FROM CUSTOMERS C 
JOIN ORDERS O 
ON C.CUSTOMER_ID=O.CUSTOMER_ID
GROUP BY C.CUSTOMER_TYPE;
/*Business Insights
Using customer_id we connected two tables named customers and orders then using group by we grouped customer_type into a single row 
that means it gives count of business and individual categories.*/

-- EVALUATE DELIVERY PERFORMANCE

-- 1.What are the different delivery statuses and how many deliveries have each status?
SELECT STATUS,COUNT(DELIVERY_ID) AS TOTAL_DELIVERIES 
FROM DELIVERIES
GROUP BY STATUS 
ORDER BY TOTAL_DELIVERIES DESC;
/*Business Insights
We have statuses such as:Delivered,Pending,Failed,Rescheduled
So these are the statuses when we evaluate*/
-- 2.What is average delivery duration for each status?
SELECT STATUS,AVG(DELIVERY_DURATION_MIN) AS AVERAGE_DURATION
FROM DELIVERIES
GROUP BY STATUS;
/*Business Insights
We can compare the statuses of deliveries tend to have different duration.*/
-- 3.Which delivery zone have highest delivery activity?
SELECT O.DELIVERY_ZONE_ID,COUNT(D.DELIVERY_ID) AS TOTAL_DELIVERIES
FROM ORDERS O
JOIN DELIVERIES D
ON O.ORDER_ID=D.ORDER_ID
GROUP BY O.DELIVERY_ZONE_ID
ORDER BY TOTAL_DELIVERIES DESC;
/*Business Insights
Zone information is in orders,while delivery information is in deliveries,so we need a JOIN.*/
-- 4.What is the average delivery duration?
-- TABLES:Deliveries
-- COLUMNS:DELIVERY_DURATION_MIN
-- QUERY:
SELECT AVG(DELIVERY_DURATION_MIN) AS AVG_DELIVERY_DURATION
FROM DELIVERIES;
-- Findings:We can find average delivery duration of deliveries.
/*Business Insights
This will give overall average delivery duration*/
-- 5.Which delivery zones have more failed deliveries?
SELECT o.DELIVERY_ZONE_ID,COUNT(d.DELIVERY_ID) AS failed_deliveries
FROM orders o
JOIN deliveries d
ON o.ORDER_ID = d.ORDER_ID
WHERE d.STATUS = 'Failed'
GROUP BY o.DELIVERY_ZONE_ID
ORDER BY failed_deliveries DESC;

-- UNDERSTAND DRIVER AND VEHICLE PERFORMANCE

-- 1.How many deliveries has each driver handled?
-- TABLES:Deliveries
-- COLUMNS:DELIVERY_ID,DRIVER_ID
-- QUERY:
SELECT DRIVER_ID,COUNT(DELIVERY_ID) AS TOTAL_DELIVERIES
FROM DELIVERIE
GROUP BY DRIVER_ID
ORDER BY TOTAL_DELIVERIES DESC;
-- Findings:Driver DRV00073 has highest total_deliveries.
/*Business Insights
This identifies drivers handling highest and lowest number of deliveries*/
-- 2.What is the average delivery duration for each driver?
-- TABLES:Deliveries
-- COLUMNS:DELIVERY_DURATION_MIN,DRIVER_ID
-- QUERY:
SELECT DRIVER_ID,AVG(DELIVERY_DURATION_MIN) AS AVERAGE_DURATION
FROM DELIVERIES
GROUP BY DRIVER_ID
ORDER BY AVERAGE_DURATION;
-- Findings:Giving average delivery duration for each driver.
/*Business Insights
This helps compare delivery speed across drivers.*/
-- 3.How many deliveries were handled by each vehicle type?
-- TABLES:Orders,Deliveries
-- COLUMNS:Delivery_zone_id,Delivery_id,Delivery_attempt,Order_id
-- QUERY:
SELECT V.VEHICLE_TYPE,COUNT(D.DELIVERY_ID) AS TOTAL_DELIVERIES
FROM VEHICLES V
JOIN DELIVERIES D
ON V.VEHICLE_ID=D.VEHICLE_ID
GROUP BY V.VEHICLE_TYPE
ORDER BY TOTAL_DELIVERIES DESC;
-- Findings:Cargo Bike is handled highest no of deliveries of total 717.
/*Business Insights
Here we need deliveries and vehicles tables and use a relationship called join then by using group by we can count how many deliveries were handled.*/
-- 4.What is the delivery performance of each vehicle?
-- TABLES:Vehicles,Deliveries
-- COLUMNS:Delivery_Duration_Min,Delivery_id,Vehicle_id,Vehicle_type
-- QUERY:
SELECT V.VEHICLE_ID,V.VEHICLE_TYPE,COUNT(D.DELIVERY_ID) AS TOTAL_DELIVERIES,AVG(D.DELIVER_DURATION_MIN) AS AVG_DURATION
FROM VEHICLES V
JOIN DELIVERIES D
ON V.VEHICLE_ID=D.VEHICLE_ID
GROUP BY V.VEHICLE_ID,V.VEHICLE_TYPE
ORDER BY TOTAL_DELIVERIES DESC;
-- Findings:For each vehicle the delivery performace is different that is in between 40 to 55
/*Business Insights
Using this we can compare usage and average delivery duration*/

-- IDENTIFY DELIVERY PROBLEMS

-- 1.How many deliveries required more than one attempt?
-- TABLES:Deliveries
-- COLUMNS:Delivery_id,Delivery_attempt
-- QUERY:
SELECT COUNT(DELIVERY_ID) AS MULTIPLE_ATTEMPT_DELIVERIES
FROM DELIVERIEs
WHERE DELIVERY_ATTEMPT>1;
-- Findings:165 deliveries required more than one attempt.
/*Business Insights
Here we gave a condition using WHERE clause so it will consider deliveries that needed at least 2 attempts*/
-- 2.Which deliveries required multiple attempts?
-- TABLES:Deliveries
-- COLUMNS:Delivery_id,Delivery_attempt,Status,Order_id
-- QUERY:
SELECT DELIVERY_ID,ORDER_ID,DELIVERY_ATTEMPT,STATUS
FROM DELIVERIEs
WHERE DELIVERY_ATTEMPT>1;
-- Findings:Except delivered status for remianing all require multiple attempts. 
/*Business Insights
This gives you the actual deliveries rather than just the count*/
-- 3.Which delivery zones have the most multiple-attempt deliveries?
-- TABLES:Orders,Deliveries
-- COLUMNS:Delivery_zone_id,Delivery_id,Delivery_attempt,Order_id
-- QUERY:
SELECT O.DELIVERY_ZONE_ID,COUNT(D.DELIVERY_ID) AS MULTIPLE_ATTEMPT_DELIVERIES
FROM ORDERS O 
JOIN DELIVERIEs D
ON O.ORDER_ID=D.ORDER_ID
WHERE D.DELIVERY_ATTEMPT>1
GROUP BY O.DELIVERY_ZONE_ID
ORDER BY MULTIPLE_ATTEMPT_DELIVERIES DESC;
-- Findings:'ZONE0019' is the most multiple-attempt deliveried zone.
/*Business Insights
For finding who have most multiple attempt deliveries in different delivery zones we need orders and deliveries table by this we can count
which zone have high number of multiple attempt deliveries may require investigation for operational or delivery related problems.*/
-- 4.What are the most common delivery statuses?
-- TABLES:Deliveries
-- COLUMNS:All
-- QUERY:
SELECT STATUS,COUNT(*) AS TOTAL_DELIVERIES
FROM DELIVERIES
GROUP BY STATUS
ORDER BY TOTAL_DELIVERIES DESC;
-- Findings:The most common delivery status is 'DELIVERED'.
/*Business Insights
This helps identify common delivery outcomes and possible problem patterns.*/
