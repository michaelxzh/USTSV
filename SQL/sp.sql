/* 
select * from information_schema.routines;
select * from information_schema.tables;

drop procedure if exists `search`;
delimiter //
create procedure `search` (m int, y int, n char(45))
begin
select c.customername, count(*)
from customers c
right join orders o on c.customernumber=o.customernumber
where month(orderdate)=m and year(orderdate)=y and c.customername like n
group by 1;
end
//
delimiter ;
call search(8,2004,'%signal%');

drop procedure if exists `getTopCustomer`;
delimiter //
create procedure `getTopCustomer` (s char(45))
begin
select c.customername
from customers c
where state = s
order by 1;
end //

delimiter ;
call search(8,2004,'%signal%');
*/
drop procedure if exists `getTopCustomer`;
delimiter //
create procedure `getTopCustomer` (in state char(45), out customer char(45))
begin
select c.customername into customer
from customers c
where c.state = state
order by 1
limit 1;
end //
delimiter ;
call getTopCustomer('CA',@customer);
select @customer;

drop procedure if exists `getTopSales`;
delimiter //
create procedure `getTopSales` (in topc char(400), out sales char(400))
begin
declare finished integer default 0;
declare sale char(100) default '';
declare s cursor for select salesrepemployeenumber from customers where ;
declare continue handler for not found set finished = 1;
open s;
gets: loop
fetch s into sale;
if 

end //
delimiter ;
call getTopCustomer('CA',@customer);
select @customer;


