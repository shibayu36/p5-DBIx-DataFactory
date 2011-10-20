DROP TABLE IF EXISTS test_factory;
CREATE TABLE test_factory (
  `id` bigint(20) unsigned NOT NULL AUTO_INCREMENT,
  -- `tinyint` tinyint NOT NULL,
  -- `smallint` smallint NOT NULL,
  -- `int` int NOT NULL,
  -- `mediumint` MEDIUMINT NOT NULL,
  -- `integer` integer NOT NULL,
  -- `float` float NOT NULL,
  -- `double` double NOT NULL,
  -- `decimal` decimal NOT NULL,
  -- `dec` decimal NOT NULL,
  -- `datetime` datetime NOT NULL,
  -- `timestamp` timestamp NOT NULL DEFAULT '0000-00-00 00:00:00',
  -- `time` time NOT NULL,
  -- `year` year NOT NULL,
  -- `varchar` varchar(30) NOT NULL,
  `int` int,
  `double` double,
  `string` varchar(255),
  `nullable` int DEFAULT NULL,

  PRIMARY KEY (id)
) DEFAULT CHARSET=binary;