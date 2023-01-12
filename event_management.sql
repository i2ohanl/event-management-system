-- phpMyAdmin SQL Dump
-- version 5.2.0
-- https://www.phpmyadmin.net/
--
-- Host: 127.0.0.1
-- Generation Time: Nov 30, 2022 at 01:18 PM
-- Server version: 10.4.24-MariaDB
-- PHP Version: 8.1.6

SET SQL_MODE = "NO_AUTO_VALUE_ON_ZERO";
START TRANSACTION;
SET time_zone = "+00:00";


/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8mb4 */;

--
-- Database: `event_management`
--

DELIMITER $$
--
-- Procedures
--
CREATE DEFINER=`root`@`localhost` PROCEDURE `check_past` (IN `event_id` INT, IN `event_date` DATE, OUT `msg` VARCHAR(30))   BEGIN
	IF event_date < SYSDATE() THEN
    INSERT INTO event_completed (event_id, user_id, theme, venue, event_date, admin_id)
	SELECT event_id, user_id, theme, venue, event_date, admin_id
	FROM event_confirmed
	WHERE event_confirmed.event_id = event_id;
    
    SET msg = "Event tables updated Successfully";
    END IF;
END$$

--
-- Functions
--
CREATE DEFINER=`root`@`localhost` FUNCTION `check_limit` (`events` INT) RETURNS VARCHAR(50) CHARSET utf8mb4 DETERMINISTIC BEGIN
    	DECLARE VALUE VARCHAR(50);
        IF events > 2 THEN SET VALUE = "Cannot have more than 2 active events";
        ELSE SET VALUE = "Can book an event";
        END IF;
        RETURN VALUE;
    END$$

DELIMITER ;

-- --------------------------------------------------------

--
-- Table structure for table `admin`
--

CREATE TABLE `admin` (
  `admin_id` varchar(20) NOT NULL,
  `admin_name` varchar(20) DEFAULT NULL,
  `start_date` date DEFAULT NULL,
  `salary` int(11) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

--
-- Dumping data for table `admin`
--

INSERT INTO `admin` (`admin_id`, `admin_name`, `start_date`, `salary`) VALUES
('ADMN001', 'Sara Siddhi', '2020-02-01', 40000),
('ADMN002', 'Rimjhim Prakha', '2020-05-23', 35000),
('ADMN003', 'Rafan Prant', '2021-12-03', 20000);

-- --------------------------------------------------------

--
-- Table structure for table `bill`
--

CREATE TABLE `bill` (
  `event_id` int(11) NOT NULL,
  `user_id` varchar(20) DEFAULT NULL,
  `admin_id` varchar(20) DEFAULT NULL,
  `catering` int(11) DEFAULT 0,
  `decor` int(11) DEFAULT 0,
  `services` int(11) DEFAULT 0,
  `total` int(11) DEFAULT 0,
  `payed` varchar(10) NOT NULL DEFAULT 'Pending'
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

--
-- Dumping data for table `bill`
--

INSERT INTO `bill` (`event_id`, `user_id`, `admin_id`, `catering`, `decor`, `services`, `total`, `payed`) VALUES
(202203, 'USR003', 'ADMN001', 0, 0, 0, 0, 'Pending'),
(202204, 'USR002', 'ADMN001', 10000, 8000, 6000, 24000, 'Pending'),
(202205, 'USR002', 'ADMN001', 0, 0, 0, 0, 'Pending'),
(202208, 'USR004', 'ADMN001', 30000, 0, 6000, 36000, 'Pending'),
(202209, 'USR004', 'ADMN001', 0, 30000, 15000, 45000, 'Pending'),
(202210, 'USR004', 'ADMN001', 18000, 0, 3600, 21600, 'Pending');

-- --------------------------------------------------------

--
-- Table structure for table `caterer_order`
--

CREATE TABLE `caterer_order` (
  `event_id` int(11) NOT NULL,
  `caterer_id` varchar(20) DEFAULT NULL,
  `orders` varchar(20) DEFAULT NULL,
  `bill_amt` int(11) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

--
-- Dumping data for table `caterer_order`
--

INSERT INTO `caterer_order` (`event_id`, `caterer_id`, `orders`, `bill_amt`) VALUES
(202204, 'CATER1', 'Cake, Food', 10000),
(202208, 'CATER06', 'idly', 30000),
(202210, 'CATER2', 'Cake, Food', 18000);

--
-- Triggers `caterer_order`
--
DELIMITER $$
CREATE TRIGGER `update_caterer` AFTER INSERT ON `caterer_order` FOR EACH ROW BEGIN
    	UPDATE bill
        SET catering = new.bill_amt, services = services + (new.bill_amt * 0.2), total = total + new.bill_amt + (new.bill_amt * 0.2)
        WHERE event_id = new.event_id;
    END
$$
DELIMITER ;

-- --------------------------------------------------------

--
-- Table structure for table `decor_order`
--

CREATE TABLE `decor_order` (
  `event_id` int(11) NOT NULL,
  `decorator_id` varchar(20) DEFAULT NULL,
  `orders` varchar(20) DEFAULT NULL,
  `bill_amt` int(11) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

--
-- Dumping data for table `decor_order`
--

INSERT INTO `decor_order` (`event_id`, `decorator_id`, `orders`, `bill_amt`) VALUES
(202204, 'DECOR3', 'Curtains, Stage', 8000),
(202209, 'DECOR4', 'Stage, Flowers', 30000);

--
-- Triggers `decor_order`
--
DELIMITER $$
CREATE TRIGGER `update_decorator` AFTER INSERT ON `decor_order` FOR EACH ROW BEGIN
    	UPDATE bill
        SET decor = new.bill_amt, services = services + (new.bill_amt * 0.5), total = total + new.bill_amt + (new.bill_amt * 0.5)
        WHERE event_id = new.event_id;
    END
$$
DELIMITER ;

-- --------------------------------------------------------

--
-- Table structure for table `event_completed`
--

CREATE TABLE `event_completed` (
  `event_id` int(11) NOT NULL,
  `user_id` varchar(20) DEFAULT NULL,
  `theme` varchar(20) DEFAULT NULL,
  `venue` varchar(30) DEFAULT NULL,
  `event_date` varchar(20) DEFAULT NULL,
  `admin_id` varchar(20) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

--
-- Dumping data for table `event_completed`
--

INSERT INTO `event_completed` (`event_id`, `user_id`, `theme`, `venue`, `event_date`, `admin_id`) VALUES
(202210, 'USR004', 'Birthday', 'Raja Theater', '2022-11-15', 'ADMN001');

-- --------------------------------------------------------

--
-- Table structure for table `event_confirmed`
--

CREATE TABLE `event_confirmed` (
  `event_id` int(11) NOT NULL,
  `user_id` varchar(20) DEFAULT NULL,
  `theme` varchar(20) DEFAULT NULL,
  `venue` varchar(30) DEFAULT NULL,
  `event_date` date DEFAULT NULL,
  `admin_id` varchar(20) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

--
-- Dumping data for table `event_confirmed`
--

INSERT INTO `event_confirmed` (`event_id`, `user_id`, `theme`, `venue`, `event_date`, `admin_id`) VALUES
(202203, 'USR003', 'Wedding', 'Yara Wedding Grounds', '2023-07-23', 'ADMN001'),
(202204, 'USR002', 'Birthday Party', 'Radha Hall', '2022-12-30', 'ADMN001'),
(202205, 'USR002', 'New Years Party', 'Rameshwaram Dance Hall', '2022-12-31', 'ADMN001'),
(202208, 'USR004', 'Disco', 'Teja Layout', '2022-12-12', 'ADMN001'),
(202209, 'USR004', 'Wedding', 'Lingu Hall', '2023-02-03', 'ADMN001'),
(202210, 'USR004', 'Birthday Party', 'Raja Theater', '2022-11-15', 'ADMN001');

--
-- Triggers `event_confirmed`
--
DELIMITER $$
CREATE TRIGGER `create_bill` AFTER INSERT ON `event_confirmed` FOR EACH ROW BEGIN
        insert into bill(event_id, user_id, admin_id) values (new.event_id, new.user_id, new.admin_id);
    END
$$
DELIMITER ;
DELIMITER $$
CREATE TRIGGER `event_accepted` AFTER INSERT ON `event_confirmed` FOR EACH ROW BEGIN
    	DELETE FROM event_requests WHERE req_id = new.event_id;
    END
$$
DELIMITER ;

-- --------------------------------------------------------

--
-- Table structure for table `event_requests`
--

CREATE TABLE `event_requests` (
  `req_id` int(11) NOT NULL,
  `user_id` varchar(20) DEFAULT NULL,
  `theme` varchar(20) DEFAULT NULL,
  `venue` varchar(30) DEFAULT NULL,
  `event_date` date DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

--
-- Dumping data for table `event_requests`
--

INSERT INTO `event_requests` (`req_id`, `user_id`, `theme`, `venue`, `event_date`) VALUES
(202206, 'USR005', 'Birthday', 'Lingu Hall', '2023-01-30'),
(202207, 'USR005', 'Wedding', 'Yara Wedding Grounds', '2023-03-07');

-- --------------------------------------------------------

--
-- Table structure for table `users`
--

CREATE TABLE `users` (
  `user_id` varchar(6) NOT NULL,
  `user_name` varchar(20) DEFAULT NULL,
  `phone` varchar(10) DEFAULT NULL,
  `email` varchar(20) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

--
-- Dumping data for table `users`
--

INSERT INTO `users` (`user_id`, `user_name`, `phone`, `email`) VALUES
('USR001', 'Akhil Mahatre', '9892938462', 'am@gmail.com'),
('USR002', 'Tejas Shrivastava', '9723483628', 'ts@gmail.com'),
('USR003', 'Rishi Sathra', '9241524252', 'rs@gmail.com'),
('USR004', 'Sana Vithi', '7262361753', 'sv@yahoo.com'),
('USR005', 'Thia Binda', '9284726217', 'tb@gmail.com');

--
-- Indexes for dumped tables
--

--
-- Indexes for table `admin`
--
ALTER TABLE `admin`
  ADD PRIMARY KEY (`admin_id`);

--
-- Indexes for table `bill`
--
ALTER TABLE `bill`
  ADD PRIMARY KEY (`event_id`),
  ADD KEY `user_id` (`user_id`),
  ADD KEY `admin_id` (`admin_id`);

--
-- Indexes for table `caterer_order`
--
ALTER TABLE `caterer_order`
  ADD PRIMARY KEY (`event_id`);

--
-- Indexes for table `decor_order`
--
ALTER TABLE `decor_order`
  ADD PRIMARY KEY (`event_id`);

--
-- Indexes for table `event_completed`
--
ALTER TABLE `event_completed`
  ADD PRIMARY KEY (`event_id`),
  ADD KEY `user_id` (`user_id`),
  ADD KEY `admin_id` (`admin_id`);

--
-- Indexes for table `event_confirmed`
--
ALTER TABLE `event_confirmed`
  ADD PRIMARY KEY (`event_id`),
  ADD KEY `user_id` (`user_id`),
  ADD KEY `admin_id` (`admin_id`);

--
-- Indexes for table `event_requests`
--
ALTER TABLE `event_requests`
  ADD PRIMARY KEY (`req_id`),
  ADD KEY `user_id` (`user_id`);

--
-- Indexes for table `users`
--
ALTER TABLE `users`
  ADD PRIMARY KEY (`user_id`);

--
-- Constraints for dumped tables
--

--
-- Constraints for table `bill`
--
ALTER TABLE `bill`
  ADD CONSTRAINT `bill_ibfk_1` FOREIGN KEY (`event_id`) REFERENCES `event_confirmed` (`event_id`),
  ADD CONSTRAINT `bill_ibfk_2` FOREIGN KEY (`user_id`) REFERENCES `users` (`user_id`),
  ADD CONSTRAINT `bill_ibfk_3` FOREIGN KEY (`admin_id`) REFERENCES `admin` (`admin_id`),
  ADD CONSTRAINT `fk_name` FOREIGN KEY (`event_id`) REFERENCES `event_confirmed` (`event_id`) ON DELETE CASCADE;

--
-- Constraints for table `caterer_order`
--
ALTER TABLE `caterer_order`
  ADD CONSTRAINT `caterer_order_ibfk_1` FOREIGN KEY (`event_id`) REFERENCES `event_confirmed` (`event_id`);

--
-- Constraints for table `decor_order`
--
ALTER TABLE `decor_order`
  ADD CONSTRAINT `decor_order_ibfk_1` FOREIGN KEY (`event_id`) REFERENCES `event_confirmed` (`event_id`);

--
-- Constraints for table `event_completed`
--
ALTER TABLE `event_completed`
  ADD CONSTRAINT `event_completed_ibfk_1` FOREIGN KEY (`event_id`) REFERENCES `event_confirmed` (`event_id`),
  ADD CONSTRAINT `event_completed_ibfk_2` FOREIGN KEY (`user_id`) REFERENCES `users` (`user_id`),
  ADD CONSTRAINT `event_completed_ibfk_3` FOREIGN KEY (`admin_id`) REFERENCES `admin` (`admin_id`);

--
-- Constraints for table `event_confirmed`
--
ALTER TABLE `event_confirmed`
  ADD CONSTRAINT `event_confirmed_ibfk_1` FOREIGN KEY (`user_id`) REFERENCES `users` (`user_id`),
  ADD CONSTRAINT `event_confirmed_ibfk_2` FOREIGN KEY (`admin_id`) REFERENCES `admin` (`admin_id`);

--
-- Constraints for table `event_requests`
--
ALTER TABLE `event_requests`
  ADD CONSTRAINT `event_requests_ibfk_1` FOREIGN KEY (`user_id`) REFERENCES `users` (`user_id`);
COMMIT;

/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
