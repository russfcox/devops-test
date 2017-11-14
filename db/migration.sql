SET SQL_MODE = "NO_AUTO_VALUE_ON_ZERO";
SET time_zone = "+00:00";


CREATE TABLE IF NOT EXISTS `t_user` (
  `user_id` int(11) NOT NULL AUTO_INCREMENT,
  `name` varchar(100) NOT NULL,
  `email` varchar(100) NOT NULL,
  `password` varchar(100) NOT NULL,
  PRIMARY KEY (`user_id`)
) ENGINE=InnoDB  DEFAULT CHARSET=latin1 AUTO_INCREMENT=6 ;

INSERT INTO `t_user` (`user_id`, `name`, `email`, `password`) VALUES
(1, 'Mas Banyar', 'banyar@yahoo.com', '23235645yghgf'),
(2, 'Mas Mapmup', 'mapmup@gmail.com', 'dncskdcndscsdcdsc'),
(4, 'Boronong', 'borononn@yahoo.com', '032bcsjdncsdjc3223'),
(5, 'Nadya Ek', 'nadya@yahoo.com', 'bonbon032932');


INSERT INTO `t_user` (`user_id`, `name`, `email`, `password`) VALUES
(6, 'Russ Cox', 'russfcox@gmail.com', 'testpass');
