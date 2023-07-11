CREATE DATABASE airbnb_project;
USE  airbnb_project;
SET sql_mode=(SELECT REPLACE(@@sql_mode,'ONLY_FULL_GROUP_BY',''));

CREATE TABLE Air_User (
User_ID INTEGER AUTO_INCREMENT,
Date_Created DATE,
F_L_Name VARCHAR(500),
Birth_Date DATE,
Phone_Number VARCHAR(20),
Email VARCHAR(100),
Photo VARCHAR(500),
Description MEDIUMTEXT,
Street_Number VARCHAR(100),
Postal_Code CHAR(10),
City VARCHAR(100),
Country VARCHAR(100),
PRIMARY KEY (User_ID)
);


CREATE TABLE Speaks (
User_ID INTEGER NOT NULL,
Lang VARCHAR(100),
PRIMARY KEY (User_ID, Lang),
FOREIGN KEY (User_ID) REFERENCES Air_User(User_ID)
	ON DELETE CASCADE
);

CREATE TABLE Guest (
Guest_ID INTEGER AUTO_INCREMENT,
Rating DECIMAL(2,1),
Rating_Count INTEGER,
Card_Number VARCHAR(20),
Expiration DATE,
CVV INTEGER,
Postal_Code CHAR(10),
Country VARCHAR(100),
Card_Type VARCHAR(100),
User_ID INTEGER NOT NULL,
PRIMARY KEY (Guest_ID),
FOREIGN KEY (User_ID) REFERENCES Air_User(User_ID)
	ON DELETE CASCADE
);
ALTER TABLE Guest AUTO_INCREMENT=100;

CREATE TABLE Wishlist (
Guest_ID INTEGER NOT NULL,
List_Name VARCHAR(100) UNIQUE,
PRIMARY KEY (Guest_ID, List_Name),
FOREIGN KEY (Guest_ID) REFERENCES Guest(Guest_ID)
	ON DELETE CASCADE
);

CREATE TABLE Air_Host (
Host_ID INTEGER AUTO_INCREMENT,
Rating DECIMAL(2,1),
Is_Super_Host BOOLEAN,
Billing_Country VARCHAR(100),
Bank_Account VARCHAR(30),
Swift_BIC VARCHAR(10),
IBAN VARCHAR(30),
User_ID INTEGER NOT NULL,
PRIMARY KEY (Host_ID),
FOREIGN KEY (User_ID) REFERENCES Air_User(User_ID)
);
ALTER TABLE Air_Host AUTO_INCREMENT=300;

CREATE TABLE Rental (
Rental_ID INTEGER AUTO_INCREMENT,
Rental_Name VARCHAR(500),
Rental_Rating DECIMAL(2,1),
Description MEDIUMTEXT,
Created DATE,
Bedroom_Count INTEGER,
Bed_Count INTEGER,
Bathroom_Count DECIMAL(3,1),
Price_P_Night DECIMAL(7,2),
Cleaning_Fee DECIMAL(5,2),
Is_Refundable BOOLEAN,
Refund DECIMAL(5,2),
Tax DECIMAL(3,1),
Check_In TIME,
Check_Out TIME,
Max_Capacity INT,
Street_N_Number VARCHAR(500),
City VARCHAR(100),
Country VARCHAR(100),
Host_ID INTEGER NOT NULL,
PRIMARY KEY (Rental_ID),
FOREIGN KEY (Host_ID) REFERENCES Air_Host(Host_ID)
);
ALTER TABLE Rental AUTO_INCREMENT=500;

CREATE TABLE Rental_For_Wishlist (
Guest_ID INTEGER NOT NULL,
Rental_ID INTEGER NOT NULL, 
List_Name VARCHAR(100) NOT NULL,
Check_In DATE,
Check_Out DATE,
PRIMARY KEY (Guest_ID, Rental_ID, List_Name),
FOREIGN KEY (Guest_ID) REFERENCES Guest(Guest_ID)
	ON DELETE CASCADE,
FOREIGN KEY (Rental_ID) REFERENCES Rental(Rental_ID)
	ON DELETE CASCADE,
FOREIGN KEY (List_Name) REFERENCES Wishlist(List_Name)
);

CREATE TABLE Rental_Review (
Rental_ID INTEGER NOT NULL,
Guest_ID INTEGER NOT NULL, 
Review_Date DATE NOT NULL,
Review_Title MEDIUMTEXT,
Review_Text TEXT,
Comment_From_Host TEXT,
Host_Rating DECIMAL(2,1),
Cleanliness DECIMAL(2,1),
Communication DECIMAL(2,1),
Check_In DECIMAL(2,1),
Accuracy DECIMAL(2,1),
Location DECIMAL(2,1),
Rental_Value DECIMAL(2,1),
Host_ID INT NOT NULL,
PRIMARY KEY (Rental_ID, Guest_ID, REVIEW_DATE),
FOREIGN KEY (Rental_ID) REFERENCES Rental(Rental_ID)
	ON DELETE CASCADE,
FOREIGN KEY (Guest_ID) REFERENCES Guest(Guest_ID)
	ON DELETE CASCADE,
FOREIGN KEY (Host_ID) REFERENCES Air_Host(Host_ID)
	ON DELETE CASCADE
);

CREATE TABLE Photo_Review (
Rental_ID INTEGER NOT NULL,
Guest_ID INTEGER NOT NULL, 
Photo_Name VARCHAR(100),
Photo VARCHAR(500), 
PRIMARY KEY (Rental_ID, Guest_ID, Photo_Name),
FOREIGN KEY (Rental_ID) REFERENCES Rental(Rental_ID)
	ON DELETE CASCADE,
FOREIGN KEY (Guest_ID) REFERENCES Guest(Guest_ID)
	ON DELETE CASCADE
);

CREATE TABLE Voucher_Action (
Voucher_ID INTEGER AUTO_INCREMENT,
Voucher_Code VARCHAR(50) UNIQUE,
Discount INT,
Start_Date DATE,
End_Date DATE,
PRIMARY KEY (Voucher_ID)
);
ALTER TABLE Voucher_Action AUTO_INCREMENT=1000;

CREATE TABLE Booking (
Booking_ID INTEGER AUTO_INCREMENT,
Booking_Date TIMESTAMP,
Check_In DATE,
Check_Out DATE,
Guests_Adults INTEGER,
Guest_Children INTEGER,
Price_Per_Night DECIMAL(6,2),
Tax DECIMAL(3,1),
Cleaning_Fee DECIMAL(5,2),
Voucher_Code VARCHAR(50),
Final_Total DECIMAL(7,2),
Paid DECIMAL(7,2),
To_Be_Paid DECIMAL(7,2),
Is_Cancelled BOOLEAN,
Refund_Amoount DECIMAL(7,2),
Guest_ID INTEGER NOT NULL,
Rental_ID INTEGER NOT NULL, 
PRIMARY KEY (Booking_ID),
FOREIGN KEY (Voucher_Code) REFERENCES Voucher_Action(Voucher_Code)
	ON DELETE CASCADE,
FOREIGN KEY (Guest_ID) REFERENCES Guest(Guest_ID)
	ON DELETE CASCADE, 
FOREIGN KEY (Rental_ID) REFERENCES Rental(Rental_ID)
	ON DELETE CASCADE
);
ALTER TABLE Booking AUTO_INCREMENT=800;

CREATE TABLE Trips_Taken (
Guest_ID INTEGER NOT NULL, 
Booking_ID INTEGER NOT NULL,
PRIMARY KEY (Guest_ID, Booking_ID),
FOREIGN KEY (Guest_ID) REFERENCES Guest(Guest_ID)
	ON DELETE CASCADE, 
FOREIGN KEY (Booking_ID) REFERENCES Booking(Booking_ID)
	ON DELETE CASCADE
);

CREATE TABLE Message_From_Guest (
Guest_ID INTEGER NOT NULL, 
Host_ID INTEGER NOT NULL, 
M_Date TIMESTAMP,
Message TEXT,
PRIMARY KEY (Guest_ID, Host_ID, M_Date),
FOREIGN KEY (Guest_ID) REFERENCES Guest(Guest_ID)
	ON DELETE CASCADE, 
FOREIGN KEY (Host_ID) REFERENCES Air_Host(Host_ID)
	ON DELETE CASCADE
);

CREATE TABLE Voucher_Solution (
Guest_ID INTEGER NOT NULL, 
Voucher_ID INTEGER NOT NULL, 
Booking_ID INTEGER NOT NULL,
PRIMARY KEY (Guest_ID, Voucher_ID, Booking_ID),
FOREIGN KEY (Guest_ID) REFERENCES Guest(Guest_ID)
	ON DELETE CASCADE, 
FOREIGN KEY (Voucher_ID) REFERENCES Voucher_Action(Voucher_ID)
	ON DELETE CASCADE ON UPDATE CASCADE,
FOREIGN KEY (Booking_ID) REFERENCES Booking(Booking_ID)
	ON DELETE CASCADE
);

CREATE TABLE Rental_Photo (
Rental_ID INTEGER NOT NULL, 
Photo_Name VARCHAR(50), 
Photo_File VARCHAR(500),
PRIMARY KEY (Rental_ID, Photo_Name),
FOREIGN KEY (Rental_ID) REFERENCES Rental(Rental_ID)
	ON DELETE CASCADE	
);

CREATE TABLE Rental_Rule (
Rental_ID INTEGER NOT NULL,
Rule_name VARCHAR(100),
PRIMARY KEY (Rental_ID, Rule_Name),
FOREIGN KEY (Rental_ID) REFERENCES Rental(Rental_ID)
	ON DELETE CASCADE
);

CREATE TABLE Amenity (
Rental_ID INTEGER NOT NULL,
Amenity_Name VARCHAR(100),
PRIMARY KEY (Rental_ID, Amenity_Name),
FOREIGN KEY (Rental_ID) REFERENCES Rental(Rental_ID)
	ON DELETE CASCADE
);

CREATE TABLE Rental_Type (
Rental_ID INTEGER NOT NULL,
Rental_Type VARCHAR(50),
PRIMARY KEY (Rental_ID, Rental_Type),
FOREIGN KEY (Rental_ID) REFERENCES Rental(Rental_ID)
	ON DELETE CASCADE
);

CREATE TABLE Availability (
Rental_ID INTEGER NOT NULL, 
Booking_ID INTEGER NOT NULL,  
Date_Booked TIMESTAMP,
PRIMARY KEY (Rental_ID, Booking_ID, Date_Booked),
FOREIGN KEY (Rental_ID) REFERENCES Rental(Rental_ID)
	ON DELETE CASCADE,
FOREIGN KEY (Booking_ID) REFERENCES Booking(Booking_ID)
	ON DELETE CASCADE
);

CREATE TABLE Message_From_Host (
Host_ID INTEGER NOT NULL, 
Guest_ID INTEGER NOT NULL,
M_Date TIMESTAMP,
Message TEXT,
PRIMARY KEY (Host_ID, Guest_ID, M_Date),
FOREIGN KEY (Host_ID) REFERENCES Air_Host(Host_ID)
	ON DELETE CASCADE,
FOREIGN KEY (Guest_ID) REFERENCES Guest(Guest_ID)
	ON DELETE CASCADE
);

INSERT INTO Air_User (Date_Created, F_L_Name, Birth_Date, Phone_Number, Email, Photo, 
Description, Street_Number, Postal_Code, City, Country) VALUES ('2010-04-12', 'Rita Blankenship', '1975-01-28', 
'(854) 759-7255', 'antoinette.ankunding@yahoo.com', 'https://unsplash.com/photos/xRTWii01yK0', 'Love to explore', 
'Carrer de Martí, 15', '48329', 'Barcelona', 'Spain'),
('2010-10-23', 'Linda Vaughan', '1975-05-25', '(428) 485-0949', 'jolie_bailey42@hotmail.com', 
'https://unsplash.com/photos/0sggvtAUjO0', 'Love travel', 'Cami dels Plans, 26', '33011', 'La Massana', 'Andorra'), 
('2011-04-08', 'Saba Pham', '1976-07-16', '(994) 649-5936', 'vinnie_swift12@hotmail.com',	
'https://unsplash.com/photos/0sggvtAUjO0', 'Love outdoors',	'Falen, 32', '15452', 'Odense', 'Denmark'), 
('2011-07-13', 'Elin Wagner', '1979-04-01', '(863) 498-6350', 'marques.blanda93@gmail.com', 
'https://unsplash.com/photos/0sggvtAUjO0', 'Love to explore', '8th Street, 32', '60515', 'London',	'UK'), 
('2011-12-01', 'Lilli Mays', '1981-04-22', '(940) 246-1686', 'allene19@gmail.com', 
'https://unsplash.com/photos/xRTWii01yK0', 'Love travel', 'Rua de C., 78', '141200', 'Rome', 'Italy'), 
('2012-09-05', 'Thalia Berg', '1981-11-06', '(883) 537-9952', 'elenor50@hotmail.com', 
'https://unsplash.com/photos/0sggvtAUjO0', 'Love outdoors', 'Main Street, 456', '11432', 'Houston', 'USA'), 
('2013-02-21', 'Rosemary Finley', '1984-07-10', '(835) 599-8326', 'yesenia_smitham14@hotmail.com',
'https://unsplash.com/photos/xRTWii01yK0', 'Love to explore', 'Rue de L., 65', '32250', 'Paris', 'France'), 
('2014-09-13', 'Leighton Padilla', '1984-07-11', '(800) 973-1080', 'ludwig_gusikowski@gmail.com', 
'https://unsplash.com/photos/0sggvtAUjO0', 	'Love travel', 	'Cosely Dr, 100', '85351', 	'The Valley', 'Anguilla'), 
('2016-10-20', 'Kabir Proctor', '1985-06-16', '(353) 983-8786',	'belle_weimann@gmail.com', 
'https://unsplash.com/photos/0sggvtAUjO0', 'Love outdoors', 'Badorferstrasse, 80', '21144', 'Cologne', 'Germany'), 
('2017-03-31', 	'Anika Duncan',	'1985-06-29', '(385) 458-1852',	'jerrold_bechtelar64@hotmail.com',	
'https://unsplash.com/photos/xRTWii01yK0',	'Love to explore',	'Djubor St, 87', '20264', 'Tucson', 'USA'),
('2017-07-01', 	'Summer Palmer', '1987-11-01',  '(482) 355-3130', 'eve.rogahn@hotmail.com',	
'https://unsplash.com/photos/0sggvtAUjO0',	'Love travel',	'2nd Street, 56',	'21242', 'Fes',	'Morocco'),
('2017-12-12',	'Nadia Moore',	'1988-09-26', '(785) 883-9447',	'augustus.jenkins@gmail.com',	
'https://unsplash.com/photos/xRTWii01yK0',	'Love outdoors', 'Lincoln Av., 48',	'85718', 'Los Angeles',	'USA'),
('2018-03-25',	'Kamran Montgomery', '1990-02-20', '(434) 235-7813', 'brook_windler45@gmail.com',	
'https://unsplash.com/photos/0sggvtAUjO0',	'Love to explore',	'Luxemburgerst. , 89',	'21207', 'Hamburg', 'Germany'),
('2018-08-26',	'Eugene Luna',	'1991-11-07', '(665) 989-9010',	'cynthia_herzog35@yahoo.com',	
'https://unsplash.com/photos/0sggvtAUjO0',	'Love travel',	'La Comparsita, 20', '11420', 'Montevideo', 'Uruguay'),
('2020-07-24',	'Skyla Robinson',	'1991-11-11', '(267) 924-4344', 'lesly97@yahoo.com',	
'https://unsplash.com/photos/xRTWii01yK0',	'Love outdoors', 'Calle Laurel, 2415',	'44805', 'San Juan', 'Puerto Rico'),
('2020-10-14', 'Mahir Holder', '1992-05-20', '(462) 801-7729', 'austin_lind@yahoo.com',	
'https://unsplash.com/photos/0sggvtAUjO0',	'Love to explore',	'Main Street, 89',	'35007', 'New York', 'USA'),
('2021-05-09', 'Casper Carver',	'1995-03-19', '(251) 514-3407',	'josie.shanahan26@yahoo.com',	
'https://unsplash.com/photos/0sggvtAUjO0', 'Love travel', 'Berlinerstrasse, 1187',	'11590', 'Berlin', 'Germany'),
('2021-09-14',	'Darren Fleming', '1995-03-21',	'(796) 439-8671', 'sean.mante14@gmail.com',
'https://unsplash.com/photos/xRTWii01yK0', 'Love outdoors', 'Avenida Eleuterio Gonzalez, 560', '75115', 'Monterrey',
'Mexico'), 
('2022-03-01',	'Gracie Merritt', '1996-04-09',	'(905) 522-7602', 'jason.becker@yahoo.com',
'https://unsplash.com/photos/0sggvtAUjO0',	'Love outdoors', 'Grenet St, 234',	'46342', 'Montreal', 'Canada'),
('2022-08-28',	'Saffron Rice',	'1997-06-15', '(582) 781-2849',	'taurean.mohr@gmail.com',	
'https://unsplash.com/photos/xRTWii01yK0',	"Love to travel", '9 Calle Oriente, 876', '37379', 'Antigua', 'Guatemala');

SELECT * FROM Air_User;

INSERT INTO Speaks (User_ID, Lang) VALUES (1, 'English'), (2,'English'), (3,'English'), (4,	'English'), 
(5,	'English'),(6,	'English'),(7,	'English'),(8,	'English'),(9,	'English'),(10,'English'),(11,'English'),
(12,'English'),(13,'English'),(14,'English'),(15,'English'),(16,'English'),(17,'English'),(18,'English'),
(19,'English'),(20,'English'), (1,	'German'),(2,'German'),(3,'German'),(4,'German'),(5,'German'),
(6,'German'),(7,'German'),(8,'German'),(9,'German'),(10,'German'),(11,'German'),(12,'German'),(20,'German'),
(9,	'French'), (10,	'French'),(11, 'French'), (1,'Spanish'),(6,'Spanish'), (14,'Spanish'), (20,'Spanish');

SELECT * FROM Speaks;

INSERT INTO Guest (Rating, Rating_Count, Card_Number, Expiration, CVV, 
Postal_Code, Country, Card_Type, User_ID) VALUES 
(4.0,	63,	4197937623497532,	'2025-06-06',	701,	'18582',	'Ireland',	'Visa',	1),
(4.0,	48,	4220525708139117,	'2025-07-30',	416,	'14645',	'UK',	'Mastercard',	2),
(4.0,	44,	4220570608139117,	'2025-08-14',	275,	'80634',	'Germany',	'Visa',	3),
(1.0,	51,	4024007195916381,	'2025-08-18',	215,	'31213',	'France',	'Mastercard',	4),
(3.0,	53,	4539093924615393,	'2025-09-23',	976,	'40715',	'Spain',	'Visa',	5),
(3.0,	36,	5391996140919296,	'2025-10-28',	148,	'40905',	'Italy',	'Mastercard',	6),
(5.0,	51,	5150012765294519,	'2025-12-04',	611,	'49232',	'Ireland',	'Visa',	7),
(2.0,	56,	5348518104381109,	'2026-01-05',	357,	'28581',	'Germany',	'Mastercard',	8),
(3.0,	38,	5503005496453937,	'2026-03-25',	982,	'16411',	'Italy',	'Visa',	9),
(2.0,	44,	5372843775577622,	'2026-04-10',	502,	'45521',	'Greece',	'Mastercard',	10),
(1.0,	45,	6011032198704741,	'2026-06-11',	871,	'33678',	'Portugal',	'Visa',	11),
(1.0,	57,	6011649099109165,	'2026-08-07',	241,	'12934',	'Ireland',	'Mastercard',	12),
(5.0,	70,	6011525489729989,	'2026-11-23',	900,	'88438',	'UK',	'Visa',	13),
(2.0,	70,	6011525280729989,	'2026-12-04',	294,	'43762',	'Germany',	'Mastercard',	14),
(5.0,	50,	6011709511530586,	'2027-03-08',	625,	'79649',	'France',	'Visa',	15),
(3.0,	43,	4347462667426914,	'2027-04-27',	904,	'50755',	'Spain',	'Mastercard',	16),
(2.0,	52,	3748130446119803,	'2027-06-21',	257,	'84607',	'Italy',	'Visa',	17),
(5.0,	40,	3446049162127015,	'2027-06-23',	952,	'48159',	'Ireland',	'Mastercard',	18),
(4.0,	66,	3788715593988526,	'2027-07-07',	281,	'82061',	'Germany',	'Visa',	19),
(1.0,	34,	3775362006995678,	'2027-10-20',	121,	'36953',	'Italy',	'Mastercard',	20);

SELECT * FROM Guest;

INSERT INTO Wishlist (Guest_ID, List_Name) VALUES 
(100, 'Caribean '),(101, 'Pizza!'),(102, 'O la la'),(108,'USA USA'),
(109, 'OktoberFest'),(110,	'Enlaplaya'),(111, 'A México!'),(112, 'Caribean Vacations'),
(115, 'Oktober Fest'),(116, 'En la playa'), (100, 'Vacay!'),(101, 'A Roma!'),(102, 'Las Ramblas'),
(103,'Oktober Fest!'),(104, 'USA-USA'),(107, 'Pizzasssss!'),(112, 'Ola la'),(113, 'Pizzass!'),
(114, 'Oo la la'),(118, 'Pizzas!'),(119, 'Caribean Vacay'),(101, 'Caribe'),(102, 'Playa alegre'),
(104, 'Playita'),(106, 'Caribik'), (111, 'Mex mex'), (118, 'En la playas'), (119, 'Pizzasssssssss!');

SELECT * FROM Wishlist;

INSERT INTO Air_Host (Rating, Is_Super_Host, Billing_Country, Bank_Account, Swift_BIC,
IBAN, User_ID) VALUES 
(1.0,	1,	'Spain',	'478006117091270096611235',	'6DAC353E',	'NL62INGB7123425928',	1),
(5.0,	0,	'Andorra',	'695505054503751048415709',	'EB9BB90B',	'DE47500105174237955442',	2),
(2.0,	1,	'Denmark',	'334321610346215257645652',	'AF3B5CF8',	'EE382200221020145685',	3),
(2.0,	0,	'UK',	'554285887470313069729437',	'87BDD610',	'AT543933653717925820',	4),
(4.0,	0,	'Italy',	'679598098846538642280310',	'EB5D8474',	'AZ84EZFB48032796669164457490',	5),
(2.0,	1,	'USA',	'211950506514507174932090',	'1EB873A2',	'AZ64PECU43282705429958532232',	6),
(5.0,	1,	'France',	'234021724444459241876639',	'7DC3DBA5',	'BA109231456451950966',	7),
(5.0,	0,	'Anguilla',	'045037251359077742753374',	'FF2B41C9',	'BA761743066136830679',	8),
(3.0,	1,	'Germany',	'451967411167978508530857',	'EBA18BBC',	'BE03228697913792',	9),
(1.0,	1,	'USA',	'586597562276936036927859',	'D52F32AD',	'BE52447614684411',	10),
(3.0,	1,	'Morocco',	'789211754311755885275539',	'7FDA463B',	'BG48NPWI86682985700622',	11),
(4.0,	0,	'USA',	'431796613474296672053244',	'9E38F4D8',	'BG11XSCX48198943793170',	12),
(5.0,	0,	'Germany',	'648415224206661011777365',	'5D28BDAE',	'BH88EEHQ68937382831557',	13),
(3.0,	0,	'Uruguay',	'249047981829134739988256',	'0BBE2F21',	'BH42VFHR13007876272556',	14),
(3.0,	1,	'Puerto Rico',	'776800649829844465845185',	'00A3A454',	'BI3192703905788485518057854',	15),
(2.0,	1,	'USA',	'117024947972582461876699',	'53304864',	'BI8439670006575845444882507',	16),
(2.0,	1,	'Germany',	'271615852532301550788053',	'1B0893C9',	'BR1107559975352344785531082I4',	17),
(3.0,	0,	'Mexico',	'088751758877704953940392',	'16C20F51',	'BR1887967395685840773825608S4',	18),
(3.0,	1,	'Canada',	'754262134061382604799595',	'F8906FE9',	'BY49998956089834344680336578',	19),
(5.0,	1,	'Guatemala',	'750076257999271475770656',	'30516072',	'BY41139525786654463650476612',	20);

SELECT * FROM Air_Host;

INSERT INTO Rental (Rental_Name, Rental_Rating, Description, Created, Bedroom_Count,
Bed_Count, Bathroom_Count, Price_P_Night, Cleaning_Fee, Is_Refundable, Refund, Tax, Check_In, Check_Out, Max_Capacity, Street_N_Number,
City, Country, Host_ID) VALUES 
('Apartment in City Center',	3.0,	'Beautiful Apartment in City Center near great restaurants.',	'2010-04-12',	5,	5,	1,	215.00,	55,	0,	0.00,	19.0,	'15:00',	'9:00',	3,	'Carrer de Martí, 15',	'Barcelona',	'Spain',	300),
('Apartment with Views',	1.0,	'Beautiful Apartment in City Center near great restaurants.',	'2010-10-23',	4,	4,	1.5,	203.00,	26,	0,	0.00,	18.0,	'15:00',	'10:00',	2,	'Cami dels Plans, 26',	'La Massana',	'Andorra',	301),
('Comfortable House',	4.0,	'Cozy Home to enjoy while on vacations.',	'2011-04-08',	3,	3,	2,	229.00,	56,	0,	0.00,	19.0,	'16:00',	'10:00',	5	,'Falen, 32',	'Odense',	'Denmark',	302),
('Near the Forest',	2.0,	'Beautiful Apartment in City Center near great restaurants.',	'2011-07-13',	2,	2,	1,	170.00,	28,	1,	50.00,	15.0,	'16:00',	'10:00',	6	,'8th Street, 32',	'London',	'UK',	303),
('Enjoy the City',	3.0,	'Cozy Home to enjoy while on vacations.',	'2011-12-01',	5,	5,	1.5,	288.00,	53,	1,	70.00,	16.0,	'15:00',	'10:00',	2,	'Rua de C., 78',	'Rome',	'Italy',	304),
('In the City',	1.0,	'Cozy Home to enjoy while on vacations.',	'2012-09-05',	1,	1,	1,	181.00,	52,	0,	0.00,	19.0,	'15:00',	'10:00',	3,	'Main Street, 456',	'Houston',	'USA',	305),
('Relax outside of the City',	5.0, 'Cozy Home to enjoy while on vacations.',	'2013-02-21',	2,	2,	1,	191.00,	29,	1,	50.00,	19.0,	'16:00',	'9:00',	4,	'Rue de L., 65',	'Paris', 'France',	306),
('Great Apartment',	5.0,	'Beautiful Apartment in City Center near great restaurants.',	'2014-09-13',	5,	5,	1,	260.00,	50,	0,	0.00,	18.0,	'16:00',	'10:00',	1,	'Cosely Dr, 100',	'The Valley',	'Anguilla',	307),
('Awesome Apartment',	3.0	,'Beautiful Apartment in City Center near great restaurants.',	'2016-10-20',	5,	5,	1,	276.00,	27,	1,	50.00,	19.0,	'16:00',	'10:00',	3,	'Badorferstrasse, 80',	'Cologne',	'Germany',	308),
('Great Views',	2.0,	'Cozy Home to enjoy while on vacations.',	'2017-03-31',	4,	4,	2,	147.00,	43,	0,	0.00,	15.0,	'15:00',	'9:00',	4,	'Djubor St, 87',	'Tucson',	'USA',	309),
('House to Love',	2.0,	'Cozy Home to enjoy while on vacations.', '2017-07-01',	5,	5,	2,	220.00,	37,	0,	0.00,	16.0,	'14:00',	'10:00',	2,	'2nd Street, 56',	'Fes',	'Morocco',	310),
('Apartment in the City',	1.0,	'Beautiful Apartment in City Center near great restaurants.',	'2017-12-12',	3,	3,	2,	149.00,	52,	0,	0.00,	19.0,	'15:00',	'9:00',	3,	'Lincoln Av., 48',	'Los Angeles',	'USA',	311),
('Under the Stars',	4.0,	'Cozy Home to enjoy while on vacations.', '2018-03-25',	4,	4,	2,	246.00,	50,	0,	0.00,	19.0,	'15:00',	'10:00',	2,	'Luxemburgerst. , 89',	'Hamburg',	'Germany',	312),
('Penthouse with View',	3.0,	'Cozy Home to enjoy while on vacations.',	'2018-08-26',	4,	4,	1.5,	190.00,	58,	1,	30.00,	18.0,	'16:00',	'9:00',	1,	'La Comparsita, 20',	'Montevideo',	'Uruguay',	313),
('Apartment to Enjoy',	3.0,	'Beautiful Apartment in City Center near great restaurants.',	'2020-07-24',	5,	5,	2,	223.00,	35,	1,	70.00,	19.0,	'15:00',	'10:00',	4,	'Calle Laurel, 2415 ',	'San Juan',	'Puerto Rico',	314),
('Cozy House',	1.0,	'Cozy Home to enjoy while on vacations.',	'2020-10-14',	5,	5,	1,	279.00,	29,	0,	0.00,	15.0,	'15:00',	'9:00',	3,	'Main Street, 89',	'New York',	'USA',	315),
('Entire Apartment',	5.0,	'Beautiful Apartment in City Center near great restaurants.',	'2021-05-09',	3,	3, 1.5,	211.00,	42,	1,	80.00,	16.0,	'16:00',	'10:00',	2,	'Berlinerstrasse, 1187',	'Berlin',	'Germany',	316),
('Beautiful Home',	1.0,	'Cozy Home to enjoy while on vacations.',	'2021-09-14',	2,	2,	0.5,	251.00,	49,	0,	0.00,	19.0,	'16:00',	'10:00',	1,	'Avenida Eleuterio Gonzalez, 560',	'Monterrey',	'Mexico',	317),
('Amazing Views',	5.0,	'Beautiful Apartment in City Center near great restaurants.',	'2022-03-01',	4,	4,	2,	289.00,	49,	0,	0.00,	16.0,	'15:00',	'10:00',	3,	'Grenet St, 234',	'Montreal',	'Canada',	318),
('In the Heart of History',	1.0,'Beautiful Apartment in City Center near great restaurants.',	'2022-08-28',	5,	5,	1,	270.00,	60,	0,	0.00,	19.0,	'15:00',	'9:00',	2,	'9 Calle Oriente, 876',	'Antigua',	'Guatemala',	319);

SELECT * FROM Rental;

INSERT INTO Rental_For_Wishlist (Guest_ID, Rental_ID, List_Name, Check_In, Check_Out) VALUES
(100,	501,	'Caribean',	'2025-01-06',	'2025-01-23'),
(101,	502, 	'A Roma!',	'2025-02-06',	'2025-02-26'),
(102,	503,	'O la la', 	'2025-02-27',	'2025-03-06'),
(103,	504,	'Oktober Fest!',	'2025-03-05',	'2025-03-21'),
(104,	505,	'USA-USA',	'2025-03-10',	'2025-03-20'),
(106,	507,	'Caribik',	'2025-06-11',	'2025-07-01'),
(107,	508,	'Pizzasssss!',	'2025-08-15',	'2025-08-21'),
(108,	509,	'USA USA',	'2026-02-19',	'2026-03-03'),
(109,	510,	'OktoberFest',	'2026-04-01',	'2026-04-23'),
(110,	511,	'Enlaplaya',	'2026-05-01',	'2026-05-21'),
(111,	512,	'A México!',	'2026-07-02',	'2026-07-23'),
(112,	513,	'Caribean Vacations',	'2026-07-07',	'2026-07-30'),
(113,	514,	'Pizzass!',	'2026-07-09',	'2026-07-23'),
(114,	515,	'Oo la la',	'2026-11-19',	'2026-12-03'),
(115,	516,	'Oktober Fest',	'2026-11-30',	'2026-12-02'),
(116,	517,	'En la playa',	'2027-01-28',	'2027-02-03'),			
(118,	519,	'Pizzas!',	'2027-09-09',	'2027-10-06'),
(119,	500,	'Caribean Vacay',	'2027-10-13',	'2027-11-03'),
(100,	510,	'Caribean ',	'2025-01-08',	'2025-01-09'),
(101,	511,	'A Roma!',	'2025-02-08',	'2025-02-09'),
(102,	512,	'O la la', 	'2025-03-01',	'2025-03-02'),
(103,	513,	'Oktober Fest!',	'2025-03-07',	'2025-03-08'),
(104,	514,	'USA-USA',	'2025-03-12',	'2025-03-13'),
(107,	517,	'Pizzasssss!',	'2025-08-17',	'2025-08-18'),
(108,	518,	'USA USA',	'2026-02-21',	'2026-02-22'),
(109,	519,	'OktoberFest',	'2026-04-03',	'2026-04-04'),
(110,	500,	'Enlaplaya',	'2026-05-03',	'2026-05-04'),
(111,	501,	'A México!',	'2026-07-04',	'2026-07-05'),
(112,	502,	'Caribean Vacations',	'2026-07-09',	'2026-07-10'),
(113,	503,	'Pizzass!',	'2026-07-11',	'2026-07-12'),
(114,	514,	'Oo la la',	'2026-11-21',	'2026-11-22'),
(115,	505,	'Oktober Fest',	'2026-12-02',	'2026-12-03'),
(116,	506,	'En la playa',	'2027-01-30',	'2027-01-31'),
(118,	517,	'Pizzas!',	'2027-09-11',	'2027-09-12'),
(119,	509,	'Caribean Vacay',	'2027-10-15',	'2027-10-16');

SELECT * FROM Rental_For_Wishlist;

INSERT INTO Rental_Review (Rental_ID, Guest_ID, Review_Date, Review_Title, Review_Text, Comment_From_Host, Host_Rating, Cleanliness, Communication, Check_In, Accuracy, 
Location, Rental_Value, Host_ID) VALUES
(500,	101,	'2014-08-01',	'Lovely place',	'We had a very nice stay there.',	'Thank you for your comment.',	4.0,	4.0,	3.0, 4.0,	5.0,	3.0,	3.0, 300),
(501,	102,	'2014-11-26',	'Very clean',	'Loved the place.',	'Thank you for your comment.',	5.0,	5.0,	4.0,	4.0,	5.0,	5.0,	4.0, 301),
(502,	103,	'2015-08-18',	'Enjoyable',	'Would go again.',	'Thank you for your comment.',	4.0,	5.0,	4.0,	5.0,	5.0,	3.0,	4.0, 302),
(503,	104,	'2015-09-08',	'Not as described',	'The place was not as advertised.',	'Thank you for your comment.',	3.0,	3.0,	4.0,	3.0,	5.0,	3.0,	5.0, 303),
(504,	105,	'2015-11-20',	'Lovely place',	'We had a very nice stay there.',	'Thank you for your comment.',	4.0,	3.0,	4.0,	4.0,	3.0,	4.0,	5.0, 304),
(505,	106,	'2016-03-09',	'Enjoyable',	'Would go again.',	'Thank you for your comment.',	4.0,	5.0,	4.0,	4.0,	5.0,	4.0,	4.0, 305),
(506,	107,	'2016-06-16',	'Highly recommended',	'Loved the place.',	'Thank you for your comment.',	4.0,	4.0,	3.0,	3.0,	3.0,	4.0,	3.0, 306),
(507,	108,	'2016-09-30',	'Not as described',	'The place was not as advertised.',	'Thank you for your comment.',	5.0,	5.0,	4.0,	4.0,	4.0,	4.0,	4.0, 307),
(508,	109,	'2016-12-30',	'Very clean',	'Would go again.',	'Thank you for your comment.',	5.0,	3.0,	5.0,	5.0,	4.0,	5.0, 3.0, 308),
(509,	110,	'2017-09-07',	'Lovely place',	'Would go again.',	'Thank you for your comment.',	4.0,	3.0,	3.0,	4.0,	4.0,	3.0,	3.0, 309),
(510,	111,	'2018-01-11',	'Highly recommended',	'Very comfortable and spacious.',	'Thank you for your comment.',	5.0,	5.0,	4.0,	3.0,	3.0,	5.0,	4.0, 310),
(511,	112,	'2018-11-01',	'Highly recommended',	'Very comfortable and spacious.',	'Thank you for your comment.',	4.0,	4.0,	4.0,	4.0,	3.0,	4.0,	3.0, 311),
(512,	113,	'2019-05-10',	'Lovely place',	'Very comfortable and spacious.',	'Thank you for your comment.',	5.0,	5.0,	5.0,	3.0,	3.0,	5.0,	5.0, 312),
(513,	114,	'2019-09-20',	'Highly recommended',	'Loved the place.',	'Thank you for your comment.',	4.0,	3.0,	4.0,	5.0,	3.0,	3.0,	5.0, 313),
(514,	115,	'2019-12-13',	'Enjoyable',	'Very comfortable and spacious.',	'Thank you for your comment.',	5.0,	3.0,	5.0,	3.0,	5.0,	3.0,	3.0, 314),
(515,	116,	'2019-12-19',	'Very clean',	'Very comfortable and spacious.',	'Thank you for your comment.',	5.0,	4.0,	3.0,	4.0,	3.0,	3.0,	3.0, 315),
(516,	117,	'2021-04-07',	'Lovely place',	'We had a very nice stay there.',	'Thank you for your comment.',	4.0,	3.0,	4.0,	3.0,	3.0,	4.0,	5.0, 316),
(517,	118,	'2021-10-19',	'Not as described',	'The place was not as advertised.',	'Thank you for your comment.',	4.0,	4.0,	5.0,	3.0,	5.0,	5.0,	5.0, 317),
(518,	119,	'2022-04-14',	'Enjoyable',	'We had a very nice stay there.',	'Thank you for your comment.',	5.0,	4.0,	4.0,	4.0,	4.0,	4.0,	4.0, 318),
(519,	100,	'2022-05-24',	'Lovely place',	'We had a very nice stay there.',	'Thank you for your comment.',	5.0,	3.0,	5.0,	4.0,	5.0,	3.0,	3.0, 319);

SELECT * FROM Rental_Review;

INSERT INTO Photo_Review (Rental_ID, Guest_ID, Photo_Name, Photo) VALUES
(500,	101,	'Photo 1',	'https://unsplash.com/photos/0YIVAB2oYQI'),
(501,	102, 	'Photo 2',	'https://unsplash.com/photos/0YIVAB2oYQI'),
(502,	103,	'Photo3',	'https://unsplash.com/photos/0sggvtAUjO0'),
(503,	104,	'Photo1',	'https://unsplash.com/photos/xRTWii01yK0'),
(504,	105,	'Photo1-',	'https://unsplash.com/photos/0sggvtAUjO0'),
(505,	106,	'Photo2-',	'https://unsplash.com/photos/0sggvtAUjO0'),
(506,	107,	'Photo3',	'https://unsplash.com/photos/xRTWii01yK0'),
(507,	108,	'Photo.1',	'https://unsplash.com/photos/0sggvtAUjO0'),
(508,	109, 	'Photo..1',	'https://unsplash.com/photos/0sggvtAUjO0'),
(509,	110,	'Photo..2',	'https://unsplash.com/photos/0YIVAB2oYQI'),
(510,	111,	'Photo..3',	'https://unsplash.com/photos/xRTWii01yK0'),
(511,	112,	'Photo...1',	'https://unsplash.com/photos/0sggvtAUjO0'),
(512,	113,	'Photo*1',	'https://unsplash.com/photos/0YIVAB2oYQI'),
(513,	114,	'Photo*2',	'https://unsplash.com/photos/0sggvtAUjO0'),
(514,	115,	'Photo*3',	'https://unsplash.com/photos/xRTWii01yK0'),
(515,	116,	'Photo. 1',	'https://unsplash.com/photos/0sggvtAUjO0'),
(516,	117,	'Photo--1',	'https://unsplash.com/photos/0YIVAB2oYQI'),
(517,	118,	'Photo--2',	'https://unsplash.com/photos/0sggvtAUjO0'),
(518,	119,	'Photo--3',	'https://unsplash.com/photos/xRTWii01yK0'),
(519,	100,	'Photo---1',	'https://unsplash.com/photos/0sggvtAUjO0');

SELECT * FROM Photo_Review;

INSERT INTO Voucher_Action (Voucher_Code, Discount, Start_Date, End_Date) VALUES
('AK3HO1JYIC7C49UYVL2O',	25,	'2023-02-24',	'2023-03-09'),
('STC1AI67TVSM8Q91C1O3',	0,	'2023-02-27',	'2023-03-09'),
('TDFSHHOGEY28395P5LHJ',	0,	'2023-03-02',	'2023-04-06'),
('388ET60BWZD7HKPGRLPJ',	0,	'2023-03-03',	'2023-04-06'),
('ON3MP53EPZMZIZ1I1RU6',	0,	'2023-03-04',	'2023-04-04'),
('3PTYLFT3Q0H0IP4XI0JQ',	0,	'2023-03-05',	'2023-03-29'),
('USUSDSX1AWISK6LBTQ66',	0,	'2023-03-07',	'2023-03-29'),
('3E9FO0AWGMMR817AWO1Z',	0,	'2023-03-08',	'2023-03-29'),
('0MXHCQEH5EGQTAYK178H',	15,	'2023-03-11',	'2023-03-29'),
('T9ZR0GQTOGAT1SEJ6AN7',	0,	'2023-03-13',	'2023-03-29'),
('NQH5BQZWTMO297NT5TLO',	0,	'2023-03-16',	'2023-03-27'),
('LCKBYRTRBMC3CQKXRGE7',	0,	'2023-03-17',	'2023-03-19'),
('Q1ITTY2HJ9WGMOE4DQ8C',	0,	'2023-03-20',	'2023-03-31'),
('DEL14DAJ5M658AGRS8O1',	0,	'2023-03-21',	'2023-03-29'),
('EI4JW0WCCE0O0SQIYZ99',	15,	'2023-03-22',	'2023-04-05'),
('VDQY8EO2F5R7JC86ZUKE',	25,	'2023-03-23',	'2023-04-04'),
('FTBABMAB7SU54DIGF3RE',	0,	'2023-03-25',	'2023-04-03'),
('SRDQ9MHLBZ0VP8SNPQMZ',	0,	'2023-03-26',	'2023-04-07'),
('IS26UTK56OX2R4FCMH8A',	0,	'2023-03-27',	'2023-04-08'),
('8M2K1MRPVIWLE0E0JZLT',	15,	'2023-03-28',	'2023-04-03');

SELECT * FROM Voucher_Action; 

INSERT INTO Booking (Booking_Date, Check_In, Check_Out, Guests_Adults, Guest_Children, 
Price_Per_Night, Tax, Cleaning_Fee, Voucher_Code, Final_Total, Paid, To_Be_Paid, Is_Cancelled, 
Refund_Amoount, Guest_ID, Rental_ID) VALUES 
('2023-01-04',	'2023-03-19',	'2023-03-20',	2,	0,	215.00,	19.0,	55.00,	'AK3HO1JYIC7C49UYVL2O',	233.13,	233.13,	0.00,	0,	0.00,	101,	500),
('2023-01-09',	'2023-03-26',	'2023-03-28',	2,	1,	203.00,	18.0,	26.00,	'STC1AI67TVSM8Q91C1O3',	509.76,	200.00,	309.76,	0,	0.00,	102,	501),
('2023-01-11',	'2023-04-07',	'2023-04-08',	1,	1,	229.00,	19.0,	56.00, 'TDFSHHOGEY28395P5LHJ', 		339.15,	239.15,	100.00,	0,	0.00,	103,	502),
('2023-01-14',	'2023-05-18',	'2023-05-20',	1,	1,	170.00,	15.0,	28.00,	'388ET60BWZD7HKPGRLPJ',	372.20,	372.20,	0.00,	0,	0.00,	104,	503),
('2023-01-15',	'2023-05-20',	'2023-05-21',	2,	1,	288.00,	16.0,	53.00,	'ON3MP53EPZMZIZ1I1RU6',	349.48,	349.48,	0.00,	0,	0.00,	105,	504),
('2023-01-21',	'2023-05-28',	'2023-05-30',	3,	0,	181.00,	19.0,	52.00,	'3PTYLFT3Q0H0IP4XI0JQ',	492.66,	492.66,	0.00,	0,	0.00,	106,	505),
('2023-01-24',	'2023-06-10',	'2023-06-12',	2,	0,	191.00,	19.0,	29.00,	'USUSDSX1AWISK6LBTQ66',	489.09,	489.09,	0.00,	1,	244.54,	107,	506),
('2023-01-25',	'2023-07-07',	'2023-07-08',	2,	0,	260.00,	18.0,	50.00,	'3E9FO0AWGMMR817AWO1Z',	365.80,	265.80,	100.00,	0,	0.00,	108,	507),
('2023-01-28',	'2023-07-30',	'2023-08-01',	2,	1,	276.00,	19.0,	27.00,	'0MXHCQEH5EGQTAYK178H',	585.65,	385.65,	200.00,	0,	0.00,	109,	508),
('2023-01-31',	'2023-08-05',	'2023-08-06',	1,	1,	147.00,	15.0,	43.00,	'T9ZR0GQTOGAT1SEJ6AN7',	218.50,	218.50,	0.00,	0,	0.00,	110,	509),
('2023-02-01',	'2023-08-12',	'2023-08-14',	1,	0,	220.00,	16.0,	37.00,	'NQH5BQZWTMO297NT5TLO',	553.32,	553.32,	0.00,	0,	0.00,	111,	510),
('2023-02-07',	'2023-08-21',	'2023-08-23',	2,	1,	149.00,	19.0,	52.00,	'LCKBYRTRBMC3CQKXRGE7',	416.50,	416.50,	0.00,	0,	0.00,	112,	511),
('2023-02-09',	'2023-08-25',	'2023-08-26',	3,	0,	246.00,	19.0,	50.00,	'Q1ITTY2HJ9WGMOE4DQ8C',	352.24,	352.24,	0.00,	0,	0.00,	113,	512),
('2023-02-12',	'2023-09-13',	'2023-09-15',	1,	1,	190.00,	18.0,	58.00,	'DEL14DAJ5M658AGRS8O1',	516.84,	516.84,	0.00,	1,	155.05,	114,	513),
('2023-02-13',	'2023-10-13',	'2023-10-15',	2,	1,	223.00,	19.0,	35.00,	'EI4JW0WCCE0O0SQIYZ99',	486.53,	486.53,	0.00,	0,	0.00,	115,	514),
('2023-02-14',	'2023-10-25',	'2023-10-26',	2,	1,	279.00,	15.0,	29.00,	'VDQY8EO2F5R7JC86ZUKE',	234.26,	234.26,	0.00,	0,	0.00,	116,	515),
('2023-02-15',	'2023-11-02',	'2023-11-04',	3,	0,	211.00,	16.0,	42.00,	'FTBABMAB7SU54DIGF3RE',	538.24,	538.24,	0.00,	1,	430.59,	117,	516),
('2023-02-16',	'2023-11-08',	'2023-11-10',	1,	1,	251.00,	19.0,	49.00,	'SRDQ9MHLBZ0VP8SNPQMZ',	655.69,	655.69,	0.00,	0,	0.00,	118,	517),
('2023-02-17',	'2023-12-17',	'2023-12-18',	1,	1,	289.00,	16.0,	49.00,	'IS26UTK56OX2R4FCMH8A',	392.08,	392.08,	0.00,	0,	0.00,	119,	518),
('2023-02-21',	'2023-12-19',	'2023-12-20',	2,	0,	270.00,	19.0,	60.00,	'8M2K1MRPVIWLE0E0JZLT',	290.19,	290.19,	0.00,	0,	0.00,	100,	519);

SELECT * FROM Booking;

INSERT INTO Trips_Taken (Guest_ID, Booking_ID) VALUES 
(101,	800),
(102,	801),
(103,	802),
(104,	803),
(105,	804),
(106,	805),
(107,	806),
(108,	807),
(109,	808),
(110,	809),
(111,	810),
(112,	811),
(113,	812),
(114,	813),
(115,	814),
(116,	815),
(117,	816),
(118,	817),
(119,	818),
(100,	819);

SELECT * FROM  Trips_Taken;

INSERT INTO Message_From_Guest (Guest_ID, Host_ID, M_Date, Message) VALUES
(101,	300,	'2012-01-30 2:24:07',	'I would like to confirm that..'),
(102,	301,	'2013-04-11 10:59:03',	'Were the rooms that we booked...?'),
(103,	302,	'2016-09-29 8:43:47',	'I would like to confirm that..'),
(104,	303,	'2021-08-29 8:47:04',	'Were the rooms that we booked...?'),
(105,	304,	'2015-07-05 10:44:53',	'Were the rooms that we booked...?'),
(106,	305, 	'2016-06-30 1:35:03',	'I would like to confirm that..'),
(107,	306,	'2014-01-21 8:18:37',	'I was wondering if...'),
(108,	307,	'2021-04-21 21:14:34',	'Were the rooms that we booked...?'),
(109,	308,	'2019-05-23 4:32:25',	'I was wondering if...'),
(110,	309,	'2019-09-15 12:11:47',	'I would like to confirm that..'),
(111,	310,	'2010-01-24 14:17:55',	'I was wondering if...'),
(112,	311,	'2010-11-24 16:23:17',	'Were the rooms that we booked...?'),
(113,	312,	'2020-08-15 15:50:16',	'I was wondering if...'),
(114,	313,	'2017-12-03 21:02:56',	'Were the rooms that we booked...?'),
(115,	314,	'2012-01-21 12:16:32',	'I would like to confirm that..'),
(116,	315,	'2020-09-13 22:37:26',	'I was wondering if...'),
(117,	316,	'2019-10-05 4:11:05',	'Were the rooms that we booked...?'),
(118,	317,	'2017-04-14 18:20:39',	'I would like to confirm that..'),
(119,	318,	'2020-08-22 0:39:35',	'Were the rooms that we booked...?'),
(100,	319,	'2022-01-04 6:48:55',	'I would like to confirm that..');

SELECT * FROM Message_From_Guest;

INSERT INTO Voucher_Solution (Guest_ID, Voucher_ID, Booking_ID) VALUES
(101,	1000,	800),
(109,	1008,	808),
(115,	1014,	814),
(116,	1015,	815),
(100,	1019,	819),
(102,	1001,	801),
(103,	1002,	802),
(104,	1003,	803),
(105,	1004,	804),
(106,	1005,	805),
(107,	1006,	806),
(108,	1007,	807),
(110,	1009,	809),
(111,	1010,	810),
(112,	1011,	811),
(113,	1012,	812),
(114,	1013,	813),
(117,	1016,	816),
(118,	1017,	817),
(119,	1018,	818);

SELECT * FROM Voucher_Solution;

INSERT INTO Rental_Photo (Rental_ID, Photo_Name, Photo_File) VALUES
(500,	'Photo1',	'https://unsplash.com/photos/xRTWii01yK0'),
(501,	'Photo1',	'https://unsplash.com/photos/0YIVAB2oYQI'),
(502,	'Photo1',	'https://unsplash.com/photos/0OHsrQ6G5Cc'),
(503,	'Photo1',	'https://unsplash.com/photos/xRTWii01yK0'),
(504,	'Photo1',	'https://unsplash.com/photos/0YIVAB2oYQI'),
(505,	'Photo1',	'https://unsplash.com/photos/0OHsrQ6G5Cc'),
(506,	'Photo1',	'https://unsplash.com/photos/xRTWii01yK0'),
(507,	'Photo1',	'https://unsplash.com/photos/0YIVAB2oYQI'),
(508,	'Photo1',	'https://unsplash.com/photos/0OHsrQ6G5Cc'),
(509,	'Photo1',	'https://unsplash.com/photos/xRTWii01yK0'),
(510,	'Photo1',	'https://unsplash.com/photos/0YIVAB2oYQI'),
(511,	'Photo1',	'https://unsplash.com/photos/0OHsrQ6G5Cc'),
(512,	'Photo1',	'https://unsplash.com/photos/0OHsrQ6G5Cc'),
(513,	'Photo1',	'https://unsplash.com/photos/0YIVAB2oYQI'),
(514,	'Photo1',	'https://unsplash.com/photos/0YIVAB2oYQI'),
(515,	'Photo1',	'https://unsplash.com/photos/0OHsrQ6G5Cc'),
(516,	'Photo1',	'https://unsplash.com/photos/0YIVAB2oYQI'),
(517,	'Photo1',	'https://unsplash.com/photos/0OHsrQ6G5Cc'),
(518,	'Photo1',	'https://unsplash.com/photos/0YIVAB2oYQI'),
(519,	'Photo1',	'https://unsplash.com/photos/0OHsrQ6G5Cc');

SELECT * FROM Rental_Photo;

INSERT INTO Rental_Rule (Rental_ID, Rule_name) VALUES 
(500,	'No pets'),(501,	'No pets'),(502,	'No pets'),(503,	'No pets'),
(504,	'No pets'), (505,	'No pets'),(506,	'No pets'),(507,	'No pets'),
(508,	'No pets'),(509,	'No pets'),(510,	'No pets'),(511,	'No pets'),
(512,	'No pets'),(513,	'No pets'),(514,	'No pets'),(515,	'No pets'),
(516,	'No pets'),(517,	'No pets'),(518,	'No pets'),(519,	'No pets'),
(500,	'No extra guests allowed'),(501,	'No extra guests allowed'),(502,	'No extra guests allowed'),
(503,	'No extra guests allowed'),(504,	'No extra guests allowed'),(505,	'No extra guests allowed'),
(506,	'No extra guests allowed'),(507,	'No extra guests allowed'),(508,	'No extra guests allowed'),(509,	'No extra guests allowed'),
(510,	'No extra guests allowed'),(511,	'No extra guests allowed'),(512,	'No extra guests allowed'),
(513,	'No extra guests allowed'),(514,	'No extra guests allowed'),(515,	'No extra guests allowed'),
(516,	'No extra guests allowed'),(517,	'No extra guests allowed'),(518,	'No extra guests allowed'),
(519,	'No extra guests allowed'),(500,	'No parties'),(501,	'No parties'),
(502,	'No parties'),(503,	'No parties'),(504,	'No parties'),(505,	'No parties'),
(506,	'No parties'),(507,	'No parties'),(508,	'No parties'),(509,	'No parties'),
(510,	'No parties'),(511,	'No parties'),(512,	'No parties'),(513,	'No parties'),
(514,	'No parties'),(515,	'No parties'),(516,	'No parties'),(517,	'No parties'),
(518,	'No parties'),(519,	'No parties');

SELECT * FROM Rental_Rule;

INSERT INTO Amenity(Rental_ID, Amenity_Name) VALUES 
(500,	'Pool'),(501,	'Private patio'),(502,	'Mountain View'),(503,	'Pool'),
(504,	'Private patio'),(505,	'Mountain View'),(506,	'Pool'),(507,	'Private patio'),
(508,	'Mountain View'),(509,	'Pool'),(510,	'Private patio'),(511,	'Mountain View'),
(512,	'Pool'),(513,	'Private patio'),(514,	'Mountain View'),(515,	'Pool'),
(516,	'Private patio'),(517,	'Mountain View'),(518,	'Pool'),(519,	'Private patio'),
(500,	'Coffee Maker'),(501,	'Grill'),(502,	'Wifi'),(503,	'Coffee Maker'),
(504,	'Grill'),(505,	'Wifi'),(506,	'Coffee Maker'),(507,	'Grill'),(508,	'Wifi'),
(509,	'Coffee Maker'),(510,	'Grill'),(511,	'Wifi'),(512,	'Coffee Maker'),
(513,	'Grill'),(514,	'Wifi'),(515,	'Coffee Maker'),(516,	'Grill'),(517,	'Wifi'),
(518,	'Coffee Maker'),(519,	'Grill'),
(500,	'TV'),(501,	'Kitchen'),(502,	'Sauna'),(503,	'TV'),(504,	'Kitchen'),
(505,	'Sauna'),(506,	'TV'),(507,	'Kitchen'),(508,	'Sauna'),(509,	'TV'),
(510,	'Kitchen'),(511,	'Sauna'),(512,	'TV'),(513,	'Kitchen'),(514,	'Sauna'),
(515,	'TV'),(516,	'Kitchen'),(517,	'Sauna'),(518,	'TV'),(519,	'Kitchen');

SELECT * FROM Amenity;

INSERT INTO Rental_Type (Rental_ID, Rental_Type) VALUES 
(500,	'Cabin'),(501,	'Amazing Views'),(502,	'Beachfront'),(503,	'Lakeside'),
(504,	'Cabin'),(505,	'Cabin'),(506,	'Amazing Pools'),(507,	'Vineyard '),(508,	'Beachfront'),(509,	'Lakeside'),
(510,	'Design'),(511,	'Beachfront'),(512,	'Vineyard '),(513,	'Design'),(514,	'Lakeside'),
(515,	'Vineyard '),(516,	'Design'),(517,	'Vineyard '),(518,	'Lakeside'),(519,	'Kitchen'),
(500,	'Luxe'),(501,	'Lakeside'),(502,	'Luxe'),(503,	'Countryside'),(504,	'Luxe'),
(505,	'Luxe'),(506,	'Luxe'),(507,	'Bed&Breakfast'),(508,	'Luxe'),(509,	'Countryside'),
(510,	'Luxe'),(511,	'Luxe'),(512,	'Bed&Breakfast'),(513,	'Luxe'),(514,	'Countryside'),
(515,	'Bed&Breakfast'),(516,	'Luxe'),(517,	'Bed&Breakfast'),(518,	'Countryside'),(502,	'New'),
(503,	'Cabin'),(507,	'Amazing Views'),(508,	'New'),(509,	'Cabin'),
(512,	'Amazing Views'),(513,	'New'),(514,	'Cabin'),(515,	'Amazing Views'),(516,	'New'),
(517,	'Amazing Views'),(518,	'Cabin');

SELECT * FROM Rental_Type;

INSERT INTO Availability (Rental_ID, Booking_ID, Date_Booked)  VALUES
(500,	800,	'2023-01-04'),(501,	801,	'2023-01-09'),
(502,	802,	'2023-01-11'),(503,	803,	'2023-01-14'),
(504,	804,	'2023-01-15'),(505,	805,	'2023-01-21'),
(506,	806,	'2023-01-24'),(507,	807,	'2023-01-25'),
(508,	808,	'2023-01-28'),(509,	809,	'2023-01-31'),
(510,	810,	'2023-02-01'),(511,	811,	'2023-02-07'),
(512,	812,	'2023-02-09'),(513,	813,	'2023-02-12'),
(514,	814,	'2023-02-13'),(515,	815,	'2023-02-14'),
(516,	816,	'2023-02-15'),(517,	817,	'2023-02-16'),
(518,	818,	'2023-02-17'),(519,	819,	'2023-02-21'),
(500,	800,	'2023-01-05'),(501,	801,	'2023-01-10'),
(502,	802,	'2023-01-12'),(503,	803,	'2023-01-15'),
(504,	804,	'2023-01-16'),(505,	805,	'2023-01-22'),
(506,	806,	'2023-01-25'),(507,	807,	'2023-01-26'),
(508,	808,	'2023-01-29'),(509,	809,	'2023-02-01'),
(510,	810,	'2023-02-02'),(511,	811,	'2023-02-08'),
(512,	812,	'2023-02-10'),(513,	813,	'2023-02-13'),
(514,	814,	'2023-02-14'),(515,	815,	'2023-02-15'),
(516,	816,	'2023-02-16'),(517,	817,	'2023-02-17'),
(518,	818,	'2023-02-18'),(519,	819,	'2023-02-22');

SELECT * FROM Availability;

INSERT INTO Message_From_Host (Host_ID, Guest_ID, M_Date, Message) VALUES
(300,	101,	'2012-01-31 2:24:07',	'Thank you for your message...'),	
(301,	102,	'2013-04-12 10:59:03',	'Thank you for your message...'),	
(302,	103,	'2016-09-30 8:43:47',	'Thank you for your message...'	),
(303,	104,	'2021-08-30 8:47:04',	'Thank you for your message...'),	
(304,	105,	'2015-07-06 10:44:53',	'Thank you for your message...'),	
(305,	106,	'2016-07-01 1:35:03',	'Thank you for your message...'),	
(306,	107,	'2014-01-22 8:18:37',	'Thank you for your message...'),	
(307,	108,	'2021-04-22 21:14:34',	'Thank you for your message...'),	
(308,	109,	'2019-05-24 4:32:25',	'Thank you for your message...'),	
(309,	110,	'2019-09-16 12:11:47',	'Thank you for your message...'	),
(310,	111,	'2010-01-25 14:17:55',	'Thank you for your message...'	),
(311,	112,	'2010-11-25 16:23:17',	'Thank you for your message...'	),
(312,	113,	'2020-08-16 15:50:16',	'Thank you for your message...'	),
(313,	114,	'2017-12-04 21:02:56',	'Thank you for your message...'	),
(314,	115,	'2012-01-22 12:16:32',	'Thank you for your message...'	),
(315,	116,	'2020-09-14 22:37:26',	'Thank you for your message...'	),
(316,	117,	'2019-10-06 4:11:05',	'Thank you for your message...'	),
(317,	118,	'2017-04-15 18:20:39',	'Thank you for your message...'	),
(318,	119,	'2020-08-23 0:39:35',	'Thank you for your message...'	),
(319,	100,	'2022-01-05 6:48:55',	'Thank you for your message...'	);

SELECT * FROM Message_From_Host;

SELECT CONCAT_WS (', ', Air_User.F_L_Name, Guest.Card_Number, ';') AS Name_and_Card_Number
FROM Air_User
INNER JOIN Guest
ON Air_User.User_ID = Guest.User_ID;

SELECT CONCAT_WS (' ', Air_User.F_L_Name, Speaks.Lang, ';') AS User_Languages
FROM Air_User
INNER JOIN Speaks
ON Air_User.User_ID = Speaks.User_ID
ORDER BY Air_User.F_L_Name;

SELECT CONCAT_WS (', ', Air_User.F_L_Name, Guest.Rating, Guest.Rating_Count) AS Rating_and_Count
FROM Air_User
INNER JOIN Guest
ON Air_User.User_ID = Guest.User_ID
ORDER BY Air_User.F_L_Name;

SELECT Wishlist.List_Name AS Wishlist, Air_User.F_L_Name AS User_Name
FROM Wishlist
INNER JOIN Guest
ON Wishlist.Guest_ID = Guest.Guest_ID
INNER JOIN Air_User
ON Guest.User_ID = Air_User.User_ID;

SELECT Guest_ID, COUNT(*) AS Number_of_Wishlists
FROM Wishlist GROUP BY Guest_ID;

SELECT CONCAT_WS(', ', Air_User.F_L_Name, Air_Host.Host_ID) AS Super_Hosts
FROM Air_Host 
INNER JOIN Air_User
ON Air_Host.User_ID = Air_User.User_ID
WHERE Is_Super_Host = 1;

SELECT CONCAT_WS(', ',Rental_ID, Rental_Name, City,Country) AS Refundable_Rentals
FROM Rental
WHERE Is_Refundable = 1;

SELECT Rental_For_Wishlist.List_Name AS Wishlist, COUNT(Rental_For_Wishlist.Rental_ID) 
AS Rentals_in_Wishlist
FROM Rental_For_Wishlist
GROUP BY Rental_For_Wishlist.List_Name;

SELECT CONCAT_WS(', ', Rental_Review.Rental_ID, Rental.Rental_Name, Rental_Review.Rental_Value, 
Rental_Review.Host_Rating) AS Great_Rentals
FROM Rental_Review  
INNER JOIN Rental
ON Rental_Review.Rental_ID = Rental.Rental_ID
WHERE Rental_Value >= 4.0 AND Host_Rating = 5.0;

SELECT  CONCAT_WS(', ', Rental_Review.Rental_ID, Rental_Review.Review_Title, Photo_Review.Photo_Name, 
Photo_Review.Photo) AS Photos_of_Great_Rentals
FROM Photo_Review
INNER JOIN Rental_Review
ON Photo_Review.Rental_ID = Rental_Review.Rental_ID
WHERE Rental_Value < 4.0;

SELECT *  FROM Voucher_Action 
WHERE Discount >= 20; 

SELECT * FROM Booking
WHERE To_Be_Paid = 0.00;

SELECT CONCAT_WS(', ', Guest.Guest_ID, Air_User.F_L_Name) AS User_made_this, 
Trips_Taken.Booking_ID AS Booking 
FROM Trips_Taken
INNER JOIN Guest
ON Trips_Taken.Guest_ID = Guest.Guest_ID
INNER JOIN Air_User
ON Guest.User_ID = Air_User.User_ID
INNER JOIN Booking
ON Guest.Guest_ID = Booking.Guest_ID
WHERE Is_Cancelled = 0;

SELECT CONCAT_WS(', ', Message_From_Guest.Guest_ID, Air_User.F_L_Name) AS Guest_ID_and_Name	,
Message_From_Guest.Message AS Messaged, Host_ID AS This_Host
FROM Message_From_Guest
INNER JOIN Guest
ON Message_From_Guest.Guest_ID = Guest.Guest_ID
INNER JOIN Air_User
ON Guest.User_ID = Air_User.User_ID;

SELECT Booking.Booking_ID, Booking.Voucher_Code, Voucher_Action.Discount, Booking.Final_Total, 
Voucher_Solution.Voucher_ID
FROM Voucher_Solution
INNER JOIN Voucher_Action
ON Voucher_Solution.Voucher_ID = Voucher_Action.Voucher_ID
INNER JOIN Booking
ON Voucher_Action.Voucher_Code = Booking.Voucher_Code
WHERE Voucher_Action.Discount != 0;

SELECT CONCAT_WS(', ', Rental_Photo.Rental_ID, Rental.Rental_Name) AS Rental,
CONCAT_WS(', ', Rental_Photo.Photo_Name, Rental_Photo.Photo_File) AS Photo
FROM Rental_Photo
INNER JOIN Rental
ON Rental_Photo.Rental_ID = Rental.Rental_ID;

SELECT Rental_Rule.Rental_ID, Rental.Rental_Name, COUNT(Rental_Rule.Rule_name) AS NumberOfRules
FROM Rental_Rule
INNER JOIN Rental
ON Rental_Rule.Rental_ID = Rental.Rental_ID
GROUP BY Rental_ID;

SELECT Amenity.Rental_ID, Rental.Rental_Name, Amenity.Amenity_Name
FROM Amenity
INNER JOIN Rental
ON Amenity.Rental_ID = Rental.Rental_ID
WHERE Amenity.Amenity_Name = 'TV' OR Amenity.Amenity_Name = 'Wifi';


SELECT Rental_Type.Rental_ID, Rental.Rental_Name, Rental_Type.Rental_Type
FROM Rental_Type
INNER JOIN Rental
ON Rental_Type.Rental_ID = Rental.Rental_ID
WHERE Rental_Type.Rental_Type LIKE 'Amaz%' OR Rental_Type.Rental_Type LIKE 'Bed%';

SELECT Rental_ID,  COUNT(Date_Booked) AS RentedNights
FROM Availability
GROUP BY Rental_ID;

SELECT Message_From_Host.Host_ID, Air_User.F_L_Name AS Host_Name,
Message_From_Host.Guest_ID, Message_From_Host.M_Date, 
COUNT(Message_From_Host.Message) AS Number_Of_Messages
FROM Message_From_Host
INNER JOIN Air_Host
ON Message_From_Host.Host_ID = Air_Host.Host_ID
INNER JOIN Air_User
ON Air_Host.User_ID = Air_User.User_ID
GROUP BY Host_ID;
