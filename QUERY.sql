-- ============================================================
-- Football Ticket Booking System — SQL Queries
-- ============================================================


-- ────────────────────────────────────────────────────────────
-- Query 1:
-- Retrieve all upcoming football matches belonging to the
-- 'Champions League' where the match status is 'Available'.
-- ────────────────────────────────────────────────────────────

SELECT
    match_id,
    fixture,
    base_ticket_price
FROM matches
WHERE tournament_category = 'Champions League'
  AND match_status         = 'Available';

/*
Expected Output:
 match_id |         fixture          | base_ticket_price
----------+--------------------------+-------------------
      101 | Real Madrid vs Barcelona |               150
      103 | Bayern Munich vs PSG     |               130
*/


-- ────────────────────────────────────────────────────────────
-- Query 2:
-- Search for all users whose full names start with 'Tanvir'
-- OR contain the phrase 'Haque' (case-insensitive).
-- Concepts used: LIKE, ILIKE
-- ────────────────────────────────────────────────────────────

SELECT
    user_id,
    full_name,
    email
FROM users
WHERE full_name ILIKE 'Tanvir%'
   OR full_name ILIKE '%Haque%';

/*
Expected Output:
 user_id |   full_name   |      email
---------+---------------+----------------
       1 | Tanvir Rahman | tanvir@mail.com
       2 | Asif Haque    | asif@mail.com
*/


-- ────────────────────────────────────────────────────────────
-- Query 3:
-- Retrieve all booking records where the payment status is
-- missing (NULL), replacing the empty result with
-- 'Action Required'.
-- Concepts used: IS NULL, COALESCE
-- ────────────────────────────────────────────────────────────

SELECT
    booking_id,
    user_id,
    match_id,
    COALESCE(payment_status, 'Action Required') AS systematic_status
FROM bookings
WHERE payment_status IS NULL;

/*
Expected Output:
 booking_id | user_id | match_id | systematic_status
------------+---------+----------+-------------------
        504 |       2 |      101 | Action Required
*/


-- ────────────────────────────────────────────────────────────
-- Query 4:
-- Retrieve match booking details along with the user's full
-- name and the scheduled match fixture teams.
-- Concepts used: INNER JOIN
-- ────────────────────────────────────────────────────────────

SELECT
    b.booking_id,
    u.full_name,
    m.fixture,
    b.total_cost
FROM bookings b
INNER JOIN users   u ON b.user_id  = u.user_id
INNER JOIN matches m ON b.match_id = m.match_id;

/*
Expected Output:
 booking_id |   full_name   |          fixture           | total_cost
------------+---------------+----------------------------+------------
        501 | Tanvir Rahman | Real Madrid vs Barcelona   |        150
        502 | Tanvir Rahman | Man City vs Liverpool       |        120
        503 | Asif Haque    | Real Madrid vs Barcelona   |        150
        504 | Asif Haque    | Real Madrid vs Barcelona   |        150
        505 | Sajjad Rahman | Man City vs Liverpool       |        120
*/


-- ────────────────────────────────────────────────────────────
-- Query 5:
-- Display a comprehensive list of all users and their booking
-- IDs, ensuring that fans who have never bought a ticket are
-- still listed.
-- Concepts used: LEFT JOIN
-- ────────────────────────────────────────────────────────────

SELECT
    u.user_id,
    u.full_name,
    b.booking_id
FROM users u
LEFT JOIN bookings b ON u.user_id = b.user_id;

/*
Expected Output:
 user_id |   full_name   | booking_id
---------+---------------+------------
       1 | Tanvir Rahman |        501
       1 | Tanvir Rahman |        502
       2 | Asif Haque    |        503
       2 | Asif Haque    |        504
       3 | Sajjad Rahman |        505
       4 | Jannat Ara    |       NULL
*/


-- ────────────────────────────────────────────────────────────
-- Query 6:
-- Find all ticket bookings where the total cost is strictly
-- higher than the average cost of all ticket bookings.
-- Concepts used: Subquery / AVG aggregate
-- ────────────────────────────────────────────────────────────

SELECT
    booking_id,
    match_id,
    total_cost
FROM bookings
WHERE total_cost > (
    SELECT AVG(total_cost)
    FROM bookings
);

/*
Average total_cost = (150+120+150+150+120) / 5 = 138

Expected Output:
 booking_id | match_id | total_cost
------------+----------+------------
        501 |      101 |        150
        503 |      101 |        150
        504 |      101 |        150
*/


-- ────────────────────────────────────────────────────────────
-- Query 7:
-- Retrieve the top 2 most expensive matches sorted by base
-- ticket price, skipping the absolute highest premium match.
-- Concepts used: ORDER BY, LIMIT, OFFSET (pagination)
-- ────────────────────────────────────────────────────────────

SELECT
    match_id,
    fixture,
    base_ticket_price
FROM matches
ORDER BY base_ticket_price DESC
LIMIT  2
OFFSET 1;

/*
Ordered by price DESC:
  1st  → Real Madrid vs Barcelona  150  (skipped by OFFSET 1)
  2nd  → Bayern Munich vs PSG      130  ✓ returned
  3rd  → Man City vs Liverpool     120  ✓ returned

Expected Output:
 match_id |       fixture        | base_ticket_price
----------+----------------------+-------------------
      103 | Bayern Munich vs PSG |               130
      102 | Man City vs Liverpool|               120
*/
