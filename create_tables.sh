sqlplus64 "$MOON_USERNAME/$MOON_PASSWORD@(DESCRIPTION=(ADDRESS=(PROTOCOL=TCP)(Host=oracle.scs.ryerson.ca)(Port=1521))(CONNECT_DATA=(SID=orcl)))" <<EOF

CREATE TABLE Users (
 UserID NUMBER PRIMARY KEY,
 UserFirstName VARCHAR2(25) NOT NULL,
 UserLastName VARCHAR2(25) NOT NULL,
 UserMiddleName VARCHAR2(25),
 UserStreetName VARCHAR2(25) NOT NULL,
 UserCity VARCHAR2(25) NOT NULL,
 UserRegion VARCHAR(25) NOT NULL,
 UserZipCode VARCHAR2(25) NOT NULL,
 UserCountry VARCHAR2(25) DEFAULT 'Canada' CHECK (UserCountry IN ('Canada', 'USA')),
 UserDateOfBirth DATE NOT NULL,
 UserEmail VARCHAR2(254) NOT NULL UNIQUE, -- TODO: CHECK (REGEXP_LIKE(Email, '^[A-Za-z0-9._%-]+@[A-Za-z0-9.-]+\.[A-Za-z]{2,4}$')),
 UserPhoneNumber CHAR(10) NOT NULL, /* fixed length */
 UserPassword VARCHAR2(255) NOT NULL , /* Passworsds should not be forced to be unique */
 UNIQUE(UserFirstName, UserMiddleName, UserLastName) /*  No two people can share the same name*/
);


/* The relationship between branch and employee is a one to many relationship. One branch has many employees. */
CREATE TABLE Branchs (
   BranchID NUMBER PRIMARY KEY,
   BranchName VARCHAR2(50) NOT NULL,
   AddressStreet VARCHAR2(20) NOT NULL,
   AddressCity VARCHAR2(10) NOT NULL,
   AddressRegion VARCHAR2(10) NOT NULL,
   AddressZipCode CHAR(10) NOT NULL,
   AddressCountry VARCHAR2(255) DEFAULT 'Canada' CHECK (AddressCountry IN ('Canada', 'USA')),
   BranchPhoneNumber CHAR(10) NOT NULL UNIQUE
);


CREATE TABLE VehicleTypes (
   VehicleTypeID NUMBER PRIMARY KEY,
   SubType CHAR(1) DEFAULT 'C' CHECK (SubType IN ('C', 'T')),
   VehicleTypeModel VARCHAR2(20),
   VehicleTypeYear DATE,
   VehicleTypeMake VARCHAR2(20),
   VehicleTypeDailyRate NUMBER(8,2),
   SeatingCapacity NUMBER(2),
   MaxLoadWeight NUMBER(5),
   CargoCapacity NUMBER(5),
   FuelType VARCHAR2(20) DEFAULT 'Gasoline' CHECK (FuelType IN ('Electrical', 'Gasoline', 'Diesel')),
   TransmissionType VARCHAR2(20) DEFAULT 'Automatic' CHECK (TransmissionType IN ('Automatic', 'Manual'))
);



/* Subclass of User */
CREATE TABLE Employees (
 UserID NUMBER PRIMARY KEY,
 BranchID NUMBER NOT NULL,  /* should not be unique cuz two employees can work for the same branch */
 EmployeeMonthlySalary NUMBER(10, 2) NOT NULL,
 EmployeeSINNumber CHAR(9) UNIQUE NOT NULL,
 EmployeePermissions VARCHAR2(255) NOT NULL,
 CONSTRAINT FK_EmployeeUser FOREIGN KEY (UserID) REFERENCES Users(UserID),
 CONSTRAINT FK_EmployeeBranch FOREIGN KEY (BranchID) REFERENCES Branchs(BranchID)
);




/*  Subclass of User */
CREATE TABLE Customers (
 UserID NUMBER PRIMARY KEY,
 CustomerDriversLicenseNumber VARCHAR2(20) UNIQUE NOT NULL,
 CONSTRAINT FK_CustomerUser FOREIGN KEY (UserID) REFERENCES Users(UserID)
);


CREATE TABLE Vehicles (
   VehicleID NUMBER PRIMARY KEY,
   BranchID NUMBER NOT NULL,
   VehicleTypeID NUMBER NOT NULL,
   VehicleMileage NUMBER(10, 0),
   VehicleLicensePlate VARCHAR2(10) NOT NULL UNIQUE,
   CONSTRAINT FK_VehicleBranch FOREIGN KEY (BranchID) REFERENCES Branchs(BranchID),
   CONSTRAINT FK_VehicleType FOREIGN KEY (VehicleTypeID) REFERENCES VehicleTypes(VehicleTypeID)
);


CREATE TABLE Bookings (
   BookingID NUMBER PRIMARY KEY,
   CustomerID NUMBER NOT NULL,
   VehicleID NUMBER NOT NULL,
   EmployeeID NUMBER NOT NULL,  /* Replaces the CREATE thing  */
   BookingIsActive NUMBER(1) DEFAULT 0 NOT NULL,  /* Or use BINARY DOUBLE */
   BookingLeaseStartDate DATE NOT NULL,
   BookingLeaseEndDate DATE NOT NULL,  /* Can be null becuase the lease is not over is its Active */
   BookingDuePayment NUMBER,
   CONSTRAINT FK_BookingCustomer FOREIGN KEY (CustomerID) REFERENCES Customers(UserID), /* Vehicle has a one to many relationhsip with branch and one to many relationship eith vehicletype */
   CONSTRAINT FK_BookingVehicle FOREIGN KEY (VehicleID) REFERENCES Vehicles(VehicleID),
   CONSTRAINT FK_BookingEmployee FOREIGN KEY (EmployeeID) REFERENCES Employees(UserID)
);


/* THE AGGREGATED BLOCK IS DONE */
/* Now we just do the connections to the aggregated block */


CREATE TABLE PaymentDetails(
 PaymentDetailsID NUMBER(20, 0) PRIMARY KEY,
 CustomerID NUMBER(20,0) NOT NULL UNIQUE,
 PaymentDetailsCardNumber NUMBER(16,0) NOT NULL UNIQUE,
 PaymentDetailsCVV NUMBER(3,0) NOT NULL,
 PaymentDetailsExpDate DATE NOT NULL, /* Should not be UNIQUE */
 CONSTRAINT FK_PaymentDetailCustomer FOREIGN KEY(CustomerID) REFERENCES Customers(UserID)
);


CREATE TABLE Transactions(
 TransactionID NUMBER NOT NULL PRIMARY KEY,
 TransactionAmount NUMBER(8) NOT NULL,
 TransactionDate DATE NOT NULL,
 PaymentDetailsID NUMBER NOT NULL,  /* Should not be UNIQUE */
 BookingID NUMBER NOT NULL,
 CONSTRAINT FK_TransactionBooking FOREIGN KEY (BookingID) REFERENCES Bookings(BookingID),
 CONSTRAINT FK_TransactionPaymentDetail FOREIGN KEY (PaymentDetailsID) REFERENCES PaymentDetails(PaymentDetailsID)
);


