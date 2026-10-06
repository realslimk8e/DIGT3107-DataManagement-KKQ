CREATE DATABASE IF NOT EXISTS ElmwoodGuestHouse;
USE ElmwoodGuestHouse;

DROP TABLE IF EXISTS Booking;
DROP TABLE IF EXISTS Room;
DROP TABLE IF EXISTS RoomType;
DROP TABLE IF EXISTS Guest;

CREATE TABLE Guest (
    GuestID INT PRIMARY KEY AUTO_INCREMENT,
    FirstName VARCHAR(45) NOT NULL,
    LastName VARCHAR(45) NOT NULL,
    Email VARCHAR(100) NOT NULL UNIQUE,
    Phone VARCHAR(20),
    IsUniversityStaff TINYINT(1) NOT NULL DEFAULT 0
);

CREATE TABLE RoomType (
    RoomTypeID INT PRIMARY KEY AUTO_INCREMENT,
    TypeName VARCHAR(45) NOT NULL UNIQUE,
    Capacity INT NOT NULL,
    NightlyPrice DECIMAL(10,2) NOT NULL
);

CREATE TABLE Room (
    RoomID INT PRIMARY KEY AUTO_INCREMENT,
    RoomNumber VARCHAR(10) NOT NULL UNIQUE,
    RoomTypeID INT NOT NULL,
    CONSTRAINT fk_room_roomtype
        FOREIGN KEY (RoomTypeID)
        REFERENCES RoomType(RoomTypeID)
);

CREATE TABLE Booking (
    BookingID INT PRIMARY KEY AUTO_INCREMENT,
    GuestID INT NOT NULL,
    RoomID INT NOT NULL,
    BookingDateTime DATETIME NOT NULL,
    CheckInDateTime DATETIME NOT NULL,
    CheckOutDateTime DATETIME NOT NULL,
    PaymentMethod VARCHAR(45) NOT NULL,
    Status VARCHAR(45) NOT NULL,
    CancellationDateTime DATETIME NULL,

    CONSTRAINT fk_booking_guest
        FOREIGN KEY (GuestID)
        REFERENCES Guest(GuestID),

    CONSTRAINT fk_booking_room
        FOREIGN KEY (RoomID)
        REFERENCES Room(RoomID),

    CONSTRAINT chk_booking_status
        CHECK (Status IN ('Active', 'Completed', 'Cancelled')),

    CONSTRAINT chk_payment_method
        CHECK (PaymentMethod IN ('Credit Card', 'Debit Card', 'Cash')),

    CONSTRAINT chk_booking_dates
        CHECK (CheckOutDateTime > CheckInDateTime),

    CONSTRAINT chk_cancellation_consistency
        CHECK (
            (Status = 'Cancelled' AND CancellationDateTime IS NOT NULL)
            OR
            (Status <> 'Cancelled' AND CancellationDateTime IS NULL)
        )
);
