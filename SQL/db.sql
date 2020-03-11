DROP DATABASE IF EXISTS `abc`;
CREATE DATABASE `abc`;
USE `abc`;
DROP TABLE IF EXISTS `users`;
CREATE TABLE `users` (
  `id` INT NOT NULL AUTO_INCREMENT,
  `name` VARCHAR(45) NOT NULL,
  `street` VARCHAR(45) NULL,
  `city` VARCHAR(45) NULL,
  `state` VARCHAR(45) NULL,
  `serviceid` INT NULL,
  PRIMARY KEY (`id`),
  UNIQUE INDEX `id_UNIQUE` (`id` ASC) VISIBLE);

INSERT INTO `users`
(`id`,
`name`,
`street`,
`city`,
`state`,
`serviceid`)
VALUES
(1,'a','st1','c1','s1',1),
(2,'b','st2','c2','s2',2),
(3,'c','st3','c3','s3',3),
(4,'d','st4','c4','s4',4),
(5,'e','st5','c5','s5',5);

DROP TABLE IF EXISTS `product`;
CREATE TABLE `product` (
  `id` INT NOT NULL AUTO_INCREMENT,
  `name` VARCHAR(45) NOT NULL,
  PRIMARY KEY (`id`),
  UNIQUE INDEX `id_UNIQUE` (`id` ASC) VISIBLE);

INSERT INTO `product`
(`id`,
`name`)
VALUES
(1,'dcl'),
(2,'cs'),
(3,'p');

DROP TABLE IF EXISTS `service`;
CREATE TABLE `service` (
  `id` INT NOT NULL AUTO_INCREMENT,
  `name` VARCHAR(45) NOT NULL,
  `productid` INT NULL,
  PRIMARY KEY (`id`),
  UNIQUE INDEX `id_UNIQUE` (`id` ASC) VISIBLE);

INSERT INTO `service`
(`id`,
`name`,
`productid`)
VALUES
(1,'aiir',2),
(2,'aivt',2),
(3,'ailt',2),
(4,'dp',1),
(5,'da',3);