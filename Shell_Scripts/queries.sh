sqlplus64 "$MOON_USERNAME/$MOON_PASSWORD@(DESCRIPTION=(ADDRESS=(PROTOCOL=TCP)(Host=oracle.scs.ryerson.ca)(Port=1521))(CONNECT_DATA=(SID=orcl)))" <<EOF

SELECT b.BranchID, b.BranchName, COUNT(*) AS NumberOfBookings
FROM Branchs b
JOIN Employees e ON b.BranchID = e.BranchID
JOIN Bookings bk ON e.UserID = bk.EmployeeID
WHERE bk.BookingIsActive = 1
GROUP BY b.BranchID, b.BranchName
HAVING COUNT(*) >= 3;


SELECT u.UserID, u.UserFirstName, u.UserLastName
FROM Users u
JOIN Customers c ON u.UserID = c.UserID
MINUS
SELECT b.CustomerID, NULL ,NULL
FROM Bookings b;

SELECT 'High-Salary Employees' AS Category, Employees.UserID, Users.UserFirstName, Users.UserLastName
FROM Employees
JOIN Users ON Employees.UserID = Users.UserID
WHERE Employees.EmployeeMonthlySalary > 4000
UNION
SELECT 'Frequent Customers' AS Category, Customers.UserID, Users.UserFirstName, Users.UserLastName
FROM Customers
JOIN Users ON Customers.UserID = Users.UserID
WHERE Customers.UserID IN (
    SELECT Bookings.CustomerID
    FROM Bookings
    GROUP BY Bookings.CustomerID
    HAVING COUNT(*) >= 2
);


SELECT v.VehicleID, v.VehicleLicensePlate
FROM Vehicles v
MINUS
SELECT DISTINCT b.VehicleID, v.VehicleLicensePlate
FROM Bookings b
JOIN Vehicles v ON b.VehicleID = v.VehicleID;


SELECT b.BranchName, COUNT(v.VehicleID) AS TotalVehiclesBooked
FROM Branchs b
JOIN Vehicles v ON b.BranchID = v.BranchID
JOIN Bookings bk ON v.VehicleID = bk.VehicleID
WHERE bk.BookingIsActive = 1
GROUP BY b.BranchName;


SELECT u.UserID, u.UserFirstName, u.UserLastName, u.UserEmail
FROM Users u
JOIN Employees e ON u.UserID = e.UserID
WHERE NOT EXISTS (
    SELECT 1 
    FROM Bookings b
    WHERE b.EmployeeID = e.UserID
);


exit;
EOF