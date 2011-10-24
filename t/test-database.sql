CREATE DATABASE test_factory;
use test_factory;

CREATE TABLE test_factory (
  `id` bigint(20) unsigned NOT NULL AUTO_INCREMENT,
  `int` int,
  `string` varchar(255),
  `text` text DEFAULT NULL,

  PRIMARY KEY (id)
) DEFAULT CHARSET=binary;