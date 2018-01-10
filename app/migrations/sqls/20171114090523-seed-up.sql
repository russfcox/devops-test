/* Replace with your SQL commands */SET SQL_MODE = "NO_AUTO_VALUE_ON_ZERO";
SET time_zone = "+00:00";


CREATE TABLE IF NOT EXISTS `t_user` (
  `user_id` int(11) NOT NULL AUTO_INCREMENT,
  `name` varchar(100) NOT NULL,
  `email` varchar(100) NOT NULL,
  `password` varchar(100) NOT NULL,
  PRIMARY KEY (`user_id`)
) ENGINE=InnoDB  DEFAULT CHARSET=latin1 AUTO_INCREMENT=6 ;

INSERT INTO `t_user` (`user_id`, `name`, `email`, `password`) VALUES
(1, 'Russ', 'russfcox@gmail.com', 'eefah1zoo0xohb3Zayev'),
(2, 'Bob', 'bob@gmail.com', 'Daavoh5id2amaek3uaca'),
(4, 'John', 'john@yahoo.com', 'iu6uyagiegh8sahd8eFi'),
(5, 'Nadya', 'nadya@yahoo.com', 'iMeiMahfoovah8ohLooB');
