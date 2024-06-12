-- Create table tblRetailers
CREATE TABLE tblRetailers (
    id INT,
    retailerName VARCHAR(255),
    createDateTime TIMESTAMP
);


-- Insert data into tblRetailers
INSERT INTO tblRetailers (id, retailerName, createDateTime) VALUES
(200, 'XYZ Store', '2020-01-28 11:36:21'),
(300, 'ABC Store', '2022-05-12 14:27:01'),
(400, 'QRS Store', '2022-05-12 14:27:01');


-- Create table tblRedemptions-ByDay
CREATE TABLE tblRedemptions_ByDay (
    id INT,
    retailerId INT,
    redemptionDate DATE,
    redemptionCount INT,
    createDateTime TIMESTAMP
);


-- Insert data into tblRedemptions-ByDay
INSERT INTO tblRedemptions_ByDay (id, retailerId, redemptionDate, redemptionCount, createDateTime) VALUES
(122, 200, '2023-10-29', 2738, '2023-11-05 11:00:00'),
(123, 200, '2023-10-30', 3217, '2023-11-05 11:00:00'),
(124, 200, '2023-10-31', 4193, '2023-11-05 11:00:00'),
(125, 200, '2023-11-01', 2931, '2023-11-05 11:00:00'),
(126, 200, '2023-11-02', 2017, '2023-11-05 11:00:00'),
(127, 200, '2023-11-03', 1936, '2023-11-05 11:00:00'),
(128, 200, '2023-11-04', 2813, '2023-11-05 11:00:00'),
(129, 300, '2023-10-29', 3737, '2023-11-05 11:00:00'),
(130, 300, '2023-10-30', 4216, '2023-11-05 11:00:00'),
(131, 300, '2023-10-31', 5192, '2023-11-05 11:00:00'),
(132, 300, '2023-11-01', 3930, '2023-11-05 11:00:00'),
(133, 300, '2023-11-03', 2935, '2023-11-05 11:00:00'),
(134, 300, '2023-11-04', 5224, '2023-11-05 11:00:00'),
(135, 200, '2023-10-30', 3281, '2023-11-06 11:00:00'),
(136, 200, '2023-10-31', 5162, '2023-11-06 11:00:00'),
(137, 200, '2023-11-01', 2931, '2023-11-06 11:00:00'),
(138, 200, '2023-11-02', 2021, '2023-11-06 11:00:00'),
(139, 200, '2023-11-03', 2007, '2023-11-06 11:00:00'),
(140, 200, '2023-11-04', 2813, '2023-11-06 11:00:00'),
(141, 200, '2023-11-05', 2703, '2023-11-06 11:00:00'),
(142, 300, '2023-10-30', 4274, '2023-11-06 11:00:00'),
(143, 300, '2023-10-31', 5003, '2023-11-06 11:00:00'),
(144, 300, '2023-11-01', 3930, '2023-11-06 11:00:00'),
(145, 300, '2023-11-03', 3810, '2023-11-06 11:00:00'),
(146, 300, '2023-11-05', 3702, '2023-11-06 11:00:00');





/* Query to pull back the most recent redemption count by redemption date for the date range
2023-10-30 to 2023-11-05 for retailer "ABC Store" */
WITH DateRange AS (
    SELECT DATE('2023-10-30') AS redemptionDate
    UNION ALL SELECT DATE('2023-10-31')
    UNION ALL SELECT DATE('2023-11-01')
    UNION ALL SELECT DATE('2023-11-02')
    UNION ALL SELECT DATE('2023-11-03')
    UNION ALL SELECT DATE('2023-11-04')
    UNION ALL SELECT DATE('2023-11-05')
),
LatestRedemptions AS (
    SELECT
        retailerId,
        redemptionDate,
        redemptionCount,
        createDateTime,
        ROW_NUMBER() OVER (PARTITION BY redemptionDate ORDER BY createDateTime DESC) AS row_num
    FROM
        tblRedemptions_ByDay
    WHERE
        retailerId = (SELECT id FROM tblRetailers WHERE retailerName = 'ABC Store')
)
SELECT
    dr.redemptionDate,
    lr.redemptionCount
FROM
    DateRange dr
LEFT JOIN
    LatestRedemptions lr ON dr.redemptionDate = lr.redemptionDate AND lr.row_num = 1
ORDER BY
    dr.redemptionDate;



-- Question-1: Date which had the least number of redemptions and the redemption count are "2023-11-05" and	"3702" respectively
-- Query to pull back the least number of redemptions and the redemption count

/*
SELECT redemptionDate, redemptionCount
FROM (
    WITH DateRange AS (
        SELECT DATE('2023-10-30') AS redemptionDate
        UNION ALL SELECT DATE('2023-10-31')
        UNION ALL SELECT DATE('2023-11-01')
        UNION ALL SELECT DATE('2023-11-02')
        UNION ALL SELECT DATE('2023-11-03')
        UNION ALL SELECT DATE('2023-11-04')
        UNION ALL SELECT DATE('2023-11-05')
    ),
    LatestRedemptions AS (
        SELECT
            retailerId,
            redemptionDate,
            redemptionCount,
            createDateTime,
            ROW_NUMBER() OVER (PARTITION BY redemptionDate ORDER BY createDateTime DESC) AS row_num
        FROM
            tblRedemptions_ByDay
        WHERE
            retailerId = (SELECT id FROM tblRetailers WHERE retailerName = 'ABC Store')
    )
    SELECT
        dr.redemptionDate,
        lr.redemptionCount
    FROM
        DateRange dr
    LEFT JOIN
        LatestRedemptions lr ON dr.redemptionDate = lr.redemptionDate AND lr.row_num = 1
    ORDER BY
        dr.redemptionDate
) AS results
WHERE redemptionCount IS NOT NULL
ORDER BY redemptionCount ASC
LIMIT 1;
*/


-- Question-2: Date which had the most number of redemptions and the redemption count are "2023-11-04" and "5224"respectively
-- Query to pull back the most number of redemptions and the redemption count


/*
SELECT redemptionDate, redemptionCount
FROM (
    WITH DateRange AS (
        SELECT DATE('2023-10-30') AS redemptionDate
        UNION ALL SELECT DATE('2023-10-31')
        UNION ALL SELECT DATE('2023-11-01')
        UNION ALL SELECT DATE('2023-11-02')
        UNION ALL SELECT DATE('2023-11-03')
        UNION ALL SELECT DATE('2023-11-04')
        UNION ALL SELECT DATE('2023-11-05')
    ),
    LatestRedemptions AS (
        SELECT
            retailerId,
            redemptionDate,
            redemptionCount,
            createDateTime,
            ROW_NUMBER() OVER (PARTITION BY redemptionDate ORDER BY createDateTime DESC) AS row_num
        FROM
            tblRedemptions_ByDay
        WHERE
            retailerId = (SELECT id FROM tblRetailers WHERE retailerName = 'ABC Store')
    )
    SELECT
        dr.redemptionDate,
        lr.redemptionCount
    FROM
        DateRange dr
    LEFT JOIN
        LatestRedemptions lr ON dr.redemptionDate = lr.redemptionDate AND lr.row_num = 1
    ORDER BY
        dr.redemptionDate
) AS results
WHERE redemptionCount IS NOT NULL
ORDER BY redemptionCount DESC
LIMIT 1;
*/


-- Question-3: createDateTime for each redemptionCount for above two questions are "2023-11-06 11:00:00" and "2023-11-05 11:00:00" respectively
-- Query to pull back the createDateTime for each redemptionCount for above two questions 

/*
WITH DateRange AS (
    SELECT DATE('2023-10-30') AS redemptionDate
    UNION ALL SELECT DATE('2023-10-31')
    UNION ALL SELECT DATE('2023-11-01')
    UNION ALL SELECT DATE('2023-11-02')
    UNION ALL SELECT DATE('2023-11-03')
    UNION ALL SELECT DATE('2023-11-04')
    UNION ALL SELECT DATE('2023-11-05')
),
RedemptionCounts AS (
    SELECT
        dr.redemptionDate,
        COALESCE(rbd.redemptionCount, 0) AS redemptionCount,
        rbd.createDateTime
    FROM
        DateRange dr
    LEFT JOIN
        tblRedemptions_ByDay rbd ON dr.redemptionDate = rbd.redemptionDate
                                AND rbd.retailerId = (SELECT id FROM tblRetailers WHERE retailerName = 'ABC Store')
)
SELECT
    RedemptionCounts.redemptionDate,
    RedemptionCounts.redemptionCount,
    RedemptionCounts.createDateTime
FROM
    RedemptionCounts
WHERE
    RedemptionCounts.redemptionCount IN (3702, 5224);

*/



-- Question-4: Another method to pull back the most recent redemption count, by redemption date, for the date range 2023-10-30 to 2023-11-05, for retailer "ABC Store"

/*
-- Selecting the redemption date and the maximum redemption count for each date within the specified date range
SELECT
    DATE(dr.redemptionDate) AS redemptionDate, -- Selecting the redemption date from the DateRange subquery
    MAX(lr.redemptionCount) AS redemptionCount -- Finding the maximum redemption count for each redemption date
FROM
    (
        SELECT DATE('2023-10-30') AS redemptionDate -- Starting with the first date in the range
        UNION ALL SELECT DATE('2023-10-31') -- Adding subsequent dates in the range using UNION ALL
        UNION ALL SELECT DATE('2023-11-01')
        UNION ALL SELECT DATE('2023-11-02')
        UNION ALL SELECT DATE('2023-11-03')
        UNION ALL SELECT DATE('2023-11-04')
        UNION ALL SELECT DATE('2023-11-05')
    ) dr
-- Joining the generated date range with the redemption data for the specified retailer
LEFT JOIN
    (
        -- Selecting redemption data for the specified retailer ('ABC Store')
        SELECT
            redemptionDate,
            redemptionCount
        FROM
            tblRedemptions_ByDay
        WHERE
            retailerId = (SELECT id FROM tblRetailers WHERE retailerName = 'ABC Store') -- Filtering data for 'ABC Store'
    ) lr ON dr.redemptionDate = lr.redemptionDate -- Joining on redemption date to link the date range with redemption data
GROUP BY
    dr.redemptionDate -- Grouping the results by redemption date to get one row per date
ORDER BY
    dr.redemptionDate; -- Ordering the results by redemption date 
*/