DROP DATABASE IF EXISTS taniaHotelDB; 
CREATE DATABASE taniaHotelDB; 
USE taniaHotelDB; 

CREATE TABLE roomInfo (
roomNumber INT PRIMARY KEY, 
adaAceessible VARCHAR(5) NOT NULL, 
standardOccupancy TINYINT NOT NULL, 
maximumOccupancy TINYINT NOT NULL,
basePrice DECIMAL(6,2)  NOT NULL
);

CREATE TABLE amenity (
    amenityID INT PRIMARY KEY AUTO_INCREMENT ,
    amenityType VARCHAR(30)
);

CREATE TABLE roomAmenity (
    roomNumber INT NOT NULL,
    amenityID INT NOT NULL,
    PRIMARY KEY pk_roomAmenity (roomNumber, amenityId),
	FOREIGN KEY fk_roomAmenity_Room (roomNumber)
		REFERENCES roomInfo(roomNumber),
	FOREIGN KEY fk_roomAmenity_Amenity (amenityId)
		REFERENCES amenity(amenityId)
);

CREATE TABLE extraPersonCost(
extraPersonCostID INT PRIMARY KEY AUTO_INCREMENT, 
cost DECIMAL(4,2)
);

CREATE TABLE roomExtraPersonCost (
    roomNumber INT NOT NULL,
    extraPersonCostID INT NOT NULL,
    PRIMARY KEY pk_roomextraPersonCost (roomNumber, extraPersonCostID),
	FOREIGN KEY fk_roomextraPersonCost_RoomNumber (roomNumber)
		REFERENCES roomInfo(roomNumber),
	FOREIGN KEY fk_roomextraPersonCost_CostID (extraPersonCostID)
		REFERENCES extraPersonCost(extraPersonCostID)
);

CREATE TABLE roomType(
roomTypeID INT PRIMARY KEY AUTO_INCREMENT, 
roomType VARCHAR(10)
);

CREATE TABLE roomInfoType (
    roomNumber INT NOT NULL,
    roomTypeID INT NOT NULL,
    PRIMARY KEY pk_roomInfoType (roomNumber, roomTypeID),
	FOREIGN KEY fk_roomInfoType_RoomNumber (roomNumber)
		REFERENCES roomInfo(roomNumber),
	FOREIGN KEY fk_roomInfoType_RoomType (roomTypeID)
		REFERENCES roomType(roomTypeID)
);
   
   
CREATE TABLE guests (
guestID INT PRIMARY KEY AUTO_INCREMENT, 
firstName VARCHAR(50) NOT NULL, 
lastName VARCHAR(50) NOT NULL, 
address	VARCHAR(50) NOT NULL,
city VARCHAR(20) NOT NULL,	
state VARCHAR(5) NOT NULL,
zip	INT NOT NULL,
phone BIGINT(10) NOT NULL
);

CREATE TABLE reservations(
reservationID INT PRIMARY KEY AUTO_INCREMENT, 
noOfAdults TINYINT NOT NULL,
noOfChildren TINYINT NOT NULL,
startDate DATE NOT NULL,
endDate	DATE NOT NULL,
totalRoomCost DECIMAL(6,2) NOT NULL
);


CREATE TABLE guestReservation (
	guestID INT NOT NULL,
    reservationID INT NOT NULL,
    PRIMARY KEY pk_guestReservation (guestID, reservationID),
    FOREIGN KEY fk_guestReservation_guest (GuestID)
		REFERENCES guests (guestID),
	FOREIGN KEY fk_guestReservation_reservation (ReservationID)
		REFERENCES reservations (reservationID)
);

CREATE TABLE roomReservation(
	roomNumber INT,
    reservationID INT,
    PRIMARY KEY pk_roomReservation (roomNumber, reservationID),
    FOREIGN KEY fk_roomReservation_ramenityoom (RoomNumber)
		REFERENCES roomInfo (roomNumber),
	FOREIGN KEY fk_roomReservation_reservation (reservationID)
		REFERENCES reservations (reservationID)
);
    


