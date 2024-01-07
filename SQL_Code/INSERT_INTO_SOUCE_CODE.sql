-- Sample data for Users table
INSERT INTO Users
VALUES
 (1, 'John', 'Doe', NULL, '123 Main St', 'Los Angeles', 'CA', '90001', 'USA', '1990-01-15', 'johndoe@email.com', '5551234567', 'password1');


-- Sample data for Branchs table
INSERT INTO Branchs
VALUES
 (1, 'Downtown Branch', '500 Elm St', 'New York', 'NY', '10001', 'USA', '5552223333');


-- Sample data for VehicleTypes table
INSERT INTO VehicleTypes
VALUES
 (1, 'C', 'Sedan', '2022-01-01', 'Toyota', 50.00, 5, 1245,1235,'Gasoline', 'Automatic');




-- Sample data for Employees table
INSERT INTO Employees
VALUES
 (1, 1, 5000.00, '123456789', 'Manager');


-- Sample data for Customers table
INSERT INTO Customers
VALUES
 (1, 'DL123456');


-- Sample data for Vehicles table
INSERT INTO Vehicles
VALUES
 (1, 1, 1, 20000, 'ABC123');


-- Sample data for Bookings table
INSERT INTO Bookings
VALUES
 (1, 1, 1, 1, 1, '2023-09-20', '2023-09-25', 250.00);


-- Sample data for PaymentDetails table
INSERT INTO PaymentDetails
VALUES
 (1, 1, 1234567890123456, 123, '2025-12-31');


 -- Sample data for Transactions table (additional 5 transactions)
INSERT INTO Transactions
VALUES
 (1, 150.00, '2023-09-22', 1, 1);