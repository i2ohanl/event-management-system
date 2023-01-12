-- JOIN OPERATIONS --
-- Selecting users with concluded events and pending bills --
SELECT users.user_id, users.user_name, event_completed.event_id, event_completed.event_date
FROM users JOIN event_completed
WHERE event_completed.event_id IN (
    SELECT event_id
    FROM bill
    WHERE payed = "Pending")

-- Selecting users that have events planned --
SELECT users.user_name , event_confirmed.event_id
FROM users NATURAL JOIN event_confirmed;

-- Selecting bill and corresponding decor bill --
SELECT * FROM bill
INNER JOIN decor_order ON bill.event_id = decor_order.event_id;

-- Selecting bill and corresponding caterer bill --
SELECT * FROM bill
INNER JOIN caterer_order ON bill.event_id = caterer_order.event_id;



-- SET OPERATIONS --
-- Selecting users with events --
SELECT user_id, user_name FROM users
WHERE user_id IN (
    SELECT user_id from users
    INTERSECT 
    SELECT user_id from event_requests
);

-- Select all caterer and decor bills more than 5000 -- 
SELECT * FROM caterer_order WHERE bill_amt > 5000
UNION
SELECT * FROM decor_order WHERE bill_amt > 5000;

-- Select events with caterer orders -- 
SELECT event_id FROM event_confirmed
INTERSECT
SELECT event_id FROM caterer_order;

-- Select users with no active events --
SELECT user_id FROM users where
not exists SELECT user_id FROM event_confirmed;


-- Aggregate operations --
-- find total catering expenditure -- 
SELECT SUM(caterer_order.bill_amt) as catering from caterer_order

SELECT SUM(decor_order.bill_amt) as decor from decor_order

-- find number of events booked by each user --
SELECT user_id, COUNT(event_id) from event_confirmed
GROUP BY user_id;

-- Find total expenditure of users --
SELECT user_id, SUM(total) from bill
GROUP BY user_id;