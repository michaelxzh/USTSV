DROP TABLE IF EXISTS `classicmodels`.`vendors`;
CREATE TABLE `classicmodels`.`vendors` (
  `vendornumber` INT NOT NULL AUTO_INCREMENT,
  `name` VARCHAR(45) NOT NULL,
  `street` VARCHAR(45) NULL,
  `city` VARCHAR(45) NULL,
  `state` VARCHAR(45) NULL,
  `note` VARCHAR(45) NULL,
  PRIMARY KEY (`vendornumber`),
  UNIQUE INDEX `vendornumber_UNIQUE` (`vendornumber` ASC) VISIBLE);

ALTER TABLE `classicmodels`.`vendors`
ADD COLUMN `department` VARCHAR(45) NULL AFTER `note`;

INSERT INTO `classicmodels`.`vendors`
(`vendornumber`,
`name`,
`street`,
`city`,
`state`,
`note`,
`department`)
VALUES
(1,'a','st1','c1','s1','lll','d1'),
(2,'b','st2','c2','s2','lll','d2'),
(3,'c','st3','c3','s3',null,'d3'),
(4,'d','st4','c4','s4','lll','d4'),
(5,'e','st5','c5','s5',null,'d5');

update `classicmodels`.`vendors` set `note`='hhh' where `vendornumber`=3;
