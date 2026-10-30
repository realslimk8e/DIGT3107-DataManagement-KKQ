/*
DIGT 3107 - Phase 3: Complex Queries
Section: A

Team Members:
Student#: 221888888
Sur (Family) Name: Arnaud
Given Name: Katherine

Student#: 221794649
Sur (Family) Name: Bauchman
Given Name: Katherine (Katie)

Student#: 221449814
Sur (Family) Name: Nguyen
Given Name: Quinn
*/

USE ElmwoodGuestHouse;

-- QUERY 1: Available rooms

SET @start = '2025-01-11 15:00:00';
SET @end   = '2025-01-12 10:00:00';

SELECT
    r.RoomNumber,
    rt.TypeName,
    rt.Capacity,
    rt.NightlyPrice
FROM Room AS r
JOIN RoomType AS rt
    ON rt.RoomTypeID = r.RoomTypeID
WHERE NOT EXISTS (
    SELECT 1
    FROM Booking AS b
    WHERE b.RoomID = r.RoomID
      AND b.Status <> 'Cancelled'
      AND b.CheckInDateTime < @end
      AND b.CheckOutDateTime > @start
)
ORDER BY rt.NightlyPrice, r.RoomNumber;

-- QUERY 2: Guest booking history
SET @guest_id = 1;

SELECT
    CONCAT(g.FirstName, ' ', g.LastName) AS GuestName,
    r.RoomNumber,
    rt.TypeName,
    b.CheckInDateTime,
    b.CheckOutDateTime,
    b.Status
FROM Booking AS b
JOIN Guest AS g ON g.GuestID = b.GuestID
JOIN Room AS r ON r.RoomID = b.RoomID
JOIN RoomType AS rt ON rt.RoomTypeID = r.RoomTypeID
WHERE g.GuestID = @guest_id
ORDER BY b.CheckInDateTime DESC;

-- QUERY 3: Most-booked room types
SELECT
    rt.TypeName,
    COUNT(b.BookingID) AS TotalBookings,
    RANK() OVER (ORDER BY COUNT(b.BookingID) DESC) AS PopularityRank
FROM RoomType AS rt
LEFT JOIN Room AS r ON r.RoomTypeID = rt.RoomTypeID
LEFT JOIN Booking AS b ON b.RoomID = r.RoomID
    AND b.Status <> 'Cancelled'
GROUP BY rt.RoomTypeID, rt.TypeName
ORDER BY TotalBookings DESC, rt.TypeName;

-- QUERY 4: 2025 bookings and revenue
SELECT
    COUNT(*) AS TotalBookings,
    ROUND(
        SUM(
            DATEDIFF(b.CheckOutDateTime, b.CheckInDateTime)
            * rt.NightlyPrice
            * 0.90
        ),
        2
    ) AS TotalRevenue
FROM Booking AS b
JOIN Room AS r ON r.RoomID = b.RoomID
JOIN RoomType AS rt ON rt.RoomTypeID = r.RoomTypeID
WHERE b.Status <> 'Cancelled'
  AND b.CheckInDateTime >= '2025-01-01'
  AND b.CheckInDateTime <  '2026-01-01';

-- QUERY 5: Monthly revenue by room type
SET @month_start = '2025-02-01';
SET @month_end   = '2025-03-01';

SELECT
    rt.TypeName,
    ROUND(
        COALESCE(
            SUM(
                DATEDIFF(b.CheckOutDateTime, b.CheckInDateTime)
                * rt.NightlyPrice
            ),
            0
        ),
        2
    ) AS TotalEarnings
FROM RoomType AS rt
LEFT JOIN Room AS r ON r.RoomTypeID = rt.RoomTypeID
LEFT JOIN Booking AS b ON b.RoomID = r.RoomID
    AND b.Status = 'Completed'
    AND b.CheckInDateTime >= @month_start
    AND b.CheckInDateTime <  @month_end
GROUP BY rt.RoomTypeID, rt.TypeName
ORDER BY TotalEarnings DESC, rt.TypeName;

-- QUERY 6: Cancellations by month
SELECT
    DATE_FORMAT(b.CancellationDateTime, '%Y-%m') AS CancelMonth,
    COUNT(*) AS Cancellations
FROM Booking AS b
WHERE b.Status = 'Cancelled'
GROUP BY DATE_FORMAT(b.CancellationDateTime, '%Y-%m')
ORDER BY CancelMonth;

-- QUERY 7: Cancellations by room type
SELECT
    rt.TypeName,
    SUM(b.Status = 'Cancelled') AS Cancellations,
    COUNT(b.BookingID) AS TotalBookings,
    ROUND(
        100.0 * SUM(b.Status = 'Cancelled') / COUNT(b.BookingID),
        1
    ) AS CancelRatePct
FROM RoomType AS rt
JOIN Room AS r ON r.RoomTypeID = rt.RoomTypeID
JOIN Booking AS b ON b.RoomID = r.RoomID
GROUP BY rt.RoomTypeID, rt.TypeName
ORDER BY Cancellations DESC, rt.TypeName;

-- QUERY 8: Cancellations by month and room type
SELECT
    DATE_FORMAT(b.CancellationDateTime, '%Y-%m') AS CancelMonth,
    rt.TypeName,
    COUNT(*) AS Cancellations
FROM Booking AS b
JOIN Room AS r ON r.RoomID = b.RoomID
JOIN RoomType AS rt ON rt.RoomTypeID = r.RoomTypeID
WHERE b.Status = 'Cancelled'
GROUP BY
    DATE_FORMAT(b.CancellationDateTime, '%Y-%m'),
    rt.RoomTypeID,
    rt.TypeName
ORDER BY CancelMonth, rt.TypeName;