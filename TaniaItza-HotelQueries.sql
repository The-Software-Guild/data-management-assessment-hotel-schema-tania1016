
USE taniaHotelDB; 

 -- ---------------------------------------------------------------------------------------------------
-- #1 Query that returns a list of reservations that end in July 2023, including the name of the guest, the room number(s), and the reservation dates.
SELECT 
	guests.FirstName,
    guests.LastName,
    roomInfo.RoomNumber,
    reservations.startDate,
    reservations.endDate
FROM guests
INNER JOIN guestReservation ON guests.guestID = guestReservation.guestID
INNER JOIN reservations ON  guestReservation.ReservationId = reservations.ReservationId
INNER JOIN roomReservation ON reservations.ReservationId = roomReservation.ReservationId
INNER JOIN roomInfo ON RoomReservation.RoomNumber = roomInfo.RoomNumber
WHERE endDate BETWEEN '2023-07-01' AND '2023-07-31';

-- RESULTS : 
-- Tania	Itza	205	2023-06-28	2023-07-02
-- Walter	Holaway	204	2023-07-13	2023-07-14
-- Wilfred	Vise	401	2023-07-18	2023-07-21
-- Bettyann	Seery	303	2023-07-28	2023-07-29


 -- ---------------------------------------------------------------------------------------------------
-- #2 Query that returns a list of all reservations for rooms with a jacuzzi, displaying the guest's name, the room number, and the dates of the reservation.
SELECT 
roomAmenity.roomNumber,
guests.firstName, 
guests.lastName, 
reservations.startDate,
reservations.endDate
FROM guests 
INNER JOIN guestReservation ON guests.guestID = guestReservation.guestID
INNER JOIN reservations ON  guestReservation.reservationID = reservations.reservationID
INNER JOIN roomReservation ON reservations.reservationID = roomReservation.reservationID
INNER JOIN roomAmenity ON RoomReservation.roomNumber = roomAmenity.roomNumber
WHERE roomAmenity.amenityID = 2 ;
 
 -- RESULTS : 
 -- 201	Karie	Yang	2023-03-06	2023-03-07
-- 203	Bettyann	Seery	2023-02-05	2023-02-10
-- 203	Karie	Yang	2023-09-13	2023-09-15
-- 205	Tania	Itza	2023-06-28	2023-07-02
-- 207	Wilfred	Vise	2023-04-23	2023-04-24
-- 301	Walter	Holaway	2023-04-09	2023-04-13
-- 301	Mack	Simmer	2023-11-22	2023-11-25
-- 303	Bettyann	Seery	2023-07-28	2023-07-29
-- 305	Duane	Cullison	2023-02-22	2023-02-24
-- 305	Bettyann	Seery	2023-08-30	2023-09-01
-- 307	Tania	Itza	2023-03-17	2023-03-20


 -- ---------------------------------------------------------------------------------------------------
-- #3 Query that returns all the rooms reserved for a specific guest, including the guest's name, the room(s) reserved, the starting date of the reservation, and how many people were included in the reservation. (Choose a guest's name from the existing data.)
SELECT 
guests.firstName, 
guests.lastName,
reservations.startDate, 
reservations.endDate, 
reservations.noOfAdults + reservations.noOfChildren AS totalNoOfPeople,
roomReservation.roomNumber

FROM guests 
JOIN guestReservation ON guests.guestID = guestReservation.guestID
JOIN reservations ON guestReservation.reservationID = reservations.reservationID
JOIN roomReservation ON reservations.reservationID = roomReservation.reservationID
WHERE guests.firstName = 'Bettyann' AND guests.lastName = 'Seery' ;

-- RESULTS:  
-- Using  guestReservation.guestID = 3;  returns the same results 
-- Bettyann	Seery	2023-02-05	2023-02-10	3	203
-- Bettyann	Seery	2023-07-28	2023-07-29	3	303
-- Bettyann	Seery	2023-08-30	2023-09-01	1	305

 -- ---------------------------------------------------------------------------------------------------
-- #4 Query that returns a list of rooms, reservation ID, and per-room cost for each reservation. The results should include all rooms, whether or not there is a reservation associated with the room.
SELECT
	roomInfo.roomNumber,
    reservations.ReservationID,
    CASE
		WHEN (((roomInfo.roomNumber BETWEEN '201' AND '204') OR (roomInfo.roomNumber BETWEEN '301' AND '304')) AND reservations.noOfAdults <= 2)
			THEN ((roomInfo.basePrice) * DATEDIFF(reservations.endDate, reservations.startDate))
		 WHEN (((roomInfo.roomNumber BETWEEN '201' AND '204') OR (roomInfo.roomNumber BETWEEN '301' AND '304')) AND reservations.noOfAdults > 2)
			 THEN ((roomInfo.basePrice + ((reservations.noOfAdults - roomInfo.standardOccupancy) * 10) * DATEDIFF(reservations.endDate, reservations.startDate)))
		WHEN ((roomInfo.roomNumber BETWEEN '205' AND '208') OR (roomInfo.roomNumber BETWEEN '305' AND '308'))
			 THEN ((roomInfo.BasePrice) * DATEDIFF(reservations.endDate, reservations.startDate))
		WHEN (((roomInfo.roomNumber BETWEEN '401' AND '402')) AND reservations.noOfAdults <= 3)
			THEN ((roomInfo.basePrice) * DATEDIFF(reservations.endDate, reservations.startDate))
		WHEN (((roomInfo.roomNumber BETWEEN '401' AND '402')) AND reservations.noOfAdults > 3)
			THEN ((roomInfo.basePrice + ((reservations.noOfAdults - roomInfo.StandardOccupancy) * 20) * DATEDIFF(reservations.endDate, reservations.startDate)))
	END AS Total
FROM guests
RIGHT OUTER JOIN guestReservation ON guests.guestID = guestReservation.guestID
RIGHT OUTER JOIN reservations ON  guestReservation.reservationID = reservations.reservationID
RIGHT OUTER JOIN roomReservation ON reservations.reservationID = roomReservation.reservationID
RIGHT OUTER JOIN roomInfo ON roomReservation.roomNumber = roomInfo.roomNumber;
    
-- RESULTS : 
-- 201	4	199.99
-- 202	7	349.98
-- 203	2	999.95
-- 203	21	399.98
-- 204	16	184.99
-- 205	15	699.96
-- 206	12	599.96
-- 206	23	449.97
-- 207	10	174.99
-- 208	13	599.96
-- 208	20	149.99
-- 301	9	799.96
-- 301	24	599.97
-- 302	6	224.99
-- 302	25	699.96
-- 303	18	199.99
-- 304	14	184.99
-- 305	3	349.98
-- 305	19	349.98
-- 306		
-- 307	5	524.97
-- 308	1	299.98
-- 401	11	1199.97
-- 401	17	459.99
-- 401	22	1199.97
-- 402		

 -- ---------------------------------------------------------------------------------------------------
-- #5 Query that returns all rooms with a capacity of three or more and that are reserved on any date in April 2023.

SELECT 
roomInfo.roomNumber

FROM roomInfo 
JOIN roomReservation ON roomInfo.roomNumber = roomReservation.roomNumber
JOIN reservations ON roomReservation.reservationID = reservations.reservationID

WHERE 	(roomInfo.standardOccupancy>=3 OR roomInfo.maximumOccupancy>=3) 
		AND ((reservations.startDate BETWEEN '2023-04-01' AND '2023-04-30')
		OR (reservations.endDate BETWEEN '2023-04-01' AND '2023-04-30'));
        
-- RESULTS: 
-- 301

-- #6 Query that returns a list of all guest names and the number of reservations per guest, sorted starting with the guest with the most reservations and then by the guest's last name.
SELECT 
guests.firstName,
guests.lastName, 
COUNT( guestReservation.guestID) AS noOfReservations

FROM guests 
JOIN guestReservation ON guests.guestID = guestReservation.guestID
JOIN reservations ON guestReservation.reservationID = reservations.reservationID
GROUP BY guests.guestID
ORDER BY noOfReservations DESC, guests.lastName;

-- RESULTS : 
-- Mack	Simmer	4
-- Bettyann	Seery	3
-- Duane	Cullison	2
-- Walter	Holaway	2
-- Tania	Itza	2
-- Aurore	Lipton	2
-- Maritza	Tilton	2
-- Joleen	Tison	2
-- Wilfred	Vise	2
-- Karie	Yang	2
-- Zachery	Luechtefield	1



 -- ---------------------------------------------------------------------------------------------------
-- #7 Query that displays the name, address, and phone number of a guest based on their phone number.
SELECT 
	firstName,
    lastName,
    address,
    city,
    state,
    zip,
    phone
FROM guests
WHERE phone = 2403852599;
-- Tania	Itza	17 Consett PL	Frederick	MD	21703	2403852599
