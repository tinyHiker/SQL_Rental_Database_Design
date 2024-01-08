sqlplus64 "$MOON_USERNAME/$MOON_PASSWORD@(DESCRIPTION=(ADDRESS=(PROTOCOL=TCP)(Host=oracle.scs.ryerson.ca)(Port=1521))(CONNECT_DATA=(SID=orcl)))" <<EOF

DROP TABLE Transactions ;
DROP TABLE PaymentDetails ;
DROP TABLE Bookings ;
DROP TABLE Vehicles ;
DROP TABLE Customers ;
DROP TABLE Employees ;
DROP TABLE VehicleTypes ;
DROP TABLE Branchs ;
DROP TABLE Users ;

exit;
EOF
