USE ElmwoodGuestHouse;

INSERT INTO RoomType (RoomTypeID, TypeName, Capacity, NightlyPrice) VALUES
(1, 'Single', 1, 110.00),
(2, 'Duplex', 4, 185.00),
(3, 'Presidential Suite', 2, 350.00);

INSERT INTO Room (RoomID, RoomNumber, RoomTypeID) VALUES
(1, '101', 1),
(2, '102', 1),
(3, '103', 1),
(4, '201', 2),
(5, '202', 2),
(6, '203', 2),
(7, '301', 3),
(8, '302', 3);

INSERT INTO Guest (GuestID, FirstName, LastName, Email, Phone, IsUniversityStaff) VALUES
(1, 'Avery', 'Morgan', 'avery.morgan@example.com', '519-555-0101', 1),
(2, 'Noah', 'Patel', 'noah.patel@example.com', '519-555-0102', 0),
(3, 'Mia', 'Chen', 'mia.chen@example.com', '519-555-0103', 0),
(4, 'Liam', 'Wilson', 'liam.wilson@example.com', '519-555-0104', 1),
(5, 'Sophia', 'Brown', 'sophia.brown@example.com', '519-555-0105', 0),
(6, 'Ethan', 'Nguyen', 'ethan.nguyen@example.com', '519-555-0106', 0),
(7, 'Olivia', 'Martin', 'olivia.martin@example.com', '519-555-0107', 1),
(8, 'Lucas', 'Taylor', 'lucas.taylor@example.com', '519-555-0108', 0);

INSERT INTO Booking (
    BookingID, GuestID, RoomID, BookingDateTime,
    CheckInDateTime, CheckOutDateTime,
    PaymentMethod, Status, CancellationDateTime
) VALUES
(1, 1, 1, '2025-01-03 09:15:00', '2025-01-10 15:00:00', '2025-01-12 11:00:00', 'Credit Card', 'Completed', NULL),
(2, 2, 4, '2025-02-05 14:20:00', '2025-02-20 15:00:00', '2025-02-23 11:00:00', 'Debit Card', 'Completed', NULL),
(3, 3, 7, '2025-03-11 10:00:00', '2025-03-25 15:00:00', '2025-03-27 11:00:00', 'Credit Card', 'Cancelled', '2025-03-18 16:30:00'),
(4, 4, 2, '2025-05-02 08:45:00', '2025-05-16 15:00:00', '2025-05-18 11:00:00', 'Cash', 'Completed', NULL),
(5, 5, 5, '2025-06-09 12:10:00', '2025-06-21 15:00:00', '2025-06-24 11:00:00', 'Credit Card', 'Completed', NULL),
(6, 6, 3, '2025-08-14 17:05:00', '2025-08-29 15:00:00', '2025-08-31 11:00:00', 'Debit Card', 'Cancelled', '2025-08-22 09:00:00'),
(7, 7, 6, '2025-10-01 11:30:00', '2025-10-10 15:00:00', '2025-10-13 11:00:00', 'Credit Card', 'Completed', NULL),
(8, 8, 8, '2025-11-15 13:00:00', '2025-12-01 15:00:00', '2025-12-04 11:00:00', 'Credit Card', 'Completed', NULL),
(9, 1, 4, '2026-09-15 09:00:00', '2026-10-20 15:00:00', '2026-10-23 11:00:00', 'Credit Card', 'Active', NULL),
(10, 3, 7, '2026-09-28 15:45:00', '2026-11-05 15:00:00', '2026-11-07 11:00:00', 'Debit Card', 'Active', NULL);