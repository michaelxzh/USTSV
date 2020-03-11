use classicmodels;
-- Singleentity
-- 1
select *
from offices
order by country,state,city;
-- 2
select count(distinct employeenumber) num
from employees;
-- 3
select sum(amount) total
from payments;
-- 4
select *
from productlines
where productline like '%Cars%';
-- 11
select round(avg(buyprice/msrp)*100,2)
from products;
-- 14
select concat(firstname,' ',lastname) name
from employees
where jobtitle like '%VP%' or jobtitle like '%Manager%';
-- One to many relationship
-- 1
select c.customername, concat(e.firstname,' ',e.lastname) name
from customers c
left join employees e on c.salesrepemployeenumber=e.employeenumber;
-- 3
select paymentdate,sum(amount)
from payments
group by 1
order by 1;
-- 4
select productname
from products
where productcode not in
(select distinct productcode from orderdetails);
-- 5 customers, orders, orderdetails
-- 6 customers, orders
select count(*)
from orders
where customernumber=(select customernumber from customers where customername='Herkku Gifts');
-- 7 employees, offices
-- 8
select distinct customername
from customers c
left join payments p on c.customernumber=p.customernumber
where amount>100000;
-- 9
-- 10
select c.customernumber,c.customername,count(*) num
from orders o
right join customers c on c.customernumber=o.customernumber
where o.status='On Hold'
group by 1;
-- Many to many relationship
-- 1
select o.orderdate,p.productname
from orders o
left join orderdetails od on o.ordernumber=od.ordernumber
left join products p on p.productcode=od.productcode
order by 1;
-- 2
select o.orderdate,p.productname
from orders o
left join orderdetails od on o.ordernumber=od.ordernumber
left join products p on p.productcode=od.productcode
where p.productname='1940 Ford Pickup Truck'
order by 1 desc;
-- 3
select c.customername, o.ordernumber
from customers c
left join payments p on c.customernumber=p.customernumber
left join orders o on c.customernumber=o.customernumber
where amount>25000;
-- 4
-- 5
select productname
from products
where buyprice<0.8*msrp;
-- 6
select distinct p.productname
from products p
right join orderdetails od on p.productcode=od.productcode
where priceeach>2*buyprice;
-- 7
select distinct p.productname
from orders o
left join orderdetails od on o.ordernumber=od.ordernumber
left join products p on p.productcode=od.productcode
where weekday(orderdate)=2;
-- 8
select distinct p.productname,p.quantityinstock
from orders o
left join orderdetails od on o.ordernumber=od.ordernumber
left join products p on p.productcode=od.productcode
where o.status='On Hold';
-- Regular expressions
-- 1
select *
from products
where productname like '%Ford%';
-- 2
select *
from products
where productname like '%ship';
-- 3
select country,count(*)
from customers
where country='Denmark' or country='Norway' or country='Sweden'
group by 1;
-- 4
select productname
from products
where productcode between 'S700_1000' and 'S700_1499';
-- 5 regexp
select customernumber,customername
from customers
where customername regexp '[0-9]';
-- 6
select concat(firstname,' ',lastname)
from employees
where firstname='Dianne' or firstname='Diane';
-- 7
select productname
from products
where productname like '%ship%' or productname like '%boat%';
-- 8
select productcode,productname
from products
where productcode like 'S700%';
-- 9
select concat(firstname,' ',lastname)
from employees
where firstname='Larry' or firstname='Barry';
-- 10 regexp '[[:alpha:]]+'
select concat(firstname,' ',lastname)
from employees
where concat(firstname,lastname) not regexp '[[:alpha:]]+';
-- 11
select distinct productvendor
from products
where productvendor like '%Diecast';
-- General queries
-- 1
select concat(firstname,' ',lastname)
from employees
where reportsto is null;
-- 2
select concat(firstname,' ',lastname)
from employees
where reportsto = (select employeenumber from employees where concat(firstname,' ',lastname)='William Patterson');
-- 3
select c.customername,p.productname
from products p
join orderdetails od on od.productcode=p.productcode
join orders o on o.ordernumber=od.ordernumber
join customers c on c.customernumber=o.customernumber
where c.customername='Herkku Gifts';
-- 4
select concat(firstname,' ',lastname), sum(amount)*0.05
from customers c
join employees e on e.employeenumber=c.salesrepemployeenumber
join payments p on p.customernumber=c.customernumber
group by 1
order by lastname,firstname;
-- 5
select datediff(max(orderdate),min(orderdate))
from orders;
-- 6
-- 7
select count(*)
from orders
where date(shippeddate) between date('2004-08-01') and date('2004-08-31');
-- 8
select t.cc, (t.tod-tt.tp) diff
from (select c.customernumber cc, sum(priceeach*quantityordered) tod
from orderdetails od
join orders o on o.ordernumber=od.ordernumber
join customers c on c.customernumber=o.customernumber
where year(orderdate)=2004
group by 1) t, (select c.customernumber cc, sum(amount) tp
from payments p
join customers c on c.customernumber=p.customernumber
where year(paymentdate)=2004
group by 1) tt
where t.cc=tt.cc
order by 2 desc;

drop view if exists `totalorder`;
CREATE VIEW `totalorder` AS
select c.customernumber cc, sum(priceeach*quantityordered) tod
from orderdetails od
join orders o on o.ordernumber=od.ordernumber
join customers c on c.customernumber=o.customernumber
where year(orderdate)=2004
group by 1;

drop view if exists `totalpay`;
CREATE VIEW `totalpay` AS
select c.customernumber cc, sum(amount) tp
from payments p
join customers c on c.customernumber=p.customernumber
where year(paymentdate)=2004
group by 1;

select t.cc, (t.tod-tt.tp) diff
from totalorder t, totalpay tt
where t.cc=tt.cc
order by 2 desc;
-- 9
select concat(firstname,' ',lastname)
from employees
where reportsto=(select employeenumber from employees where concat(firstname,' ',lastname)='Diane Murphy');
-- 10
-- 11
drop function if exists `miletokm`;

CREATE FUNCTION `miletokm` (mile int)
RETURNS INTEGER DETERMINISTIC
RETURN mile*235.21;

select miletokm(1);
-- 12 ?
-- 13
-- 14
-- 15
-- 16

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
-- 17
drop procedure if exists `credit`;
delimiter //
create procedure credit (n int, c char(45))
begin
update customers
set creditlimit=creditlimit*(1+n)
where country=c
end
//
delimiter ;
-- 18
select o.ordernumber,od.productcode,quantityordered
from orders o
join orderdetails od on o.ordernumber=od.ordernumber
group by 1,2;

-- Quiz
-- 1
select city, count(*) 'employee count'
from employees e
left join offices o on o.officecode=e.officecode
group by 1
order by 2 desc
limit 3;

-- 2
select productline, (sum((msrp-buyprice)*quantityinstock)/sum(buyprice*quantityinstock)) 'profit margin'
from products
group by 1;

-- 3a
select c.salesrepemployeenumber,concat(firstname,' ',lastname) employee
from customers c
left join payments p on c.customernumber=p.customernumber
left join employees e on c.salesrepemployeenumber=e.employeenumber
group by 1
order by sum(amount) desc
limit 3;
/*
3b employees jobtitle
3c First, we should add a column in employees table to show each employee's active status.
Then, we can create a procedure with in employeenumber and active status, so we can update the employees table with those input information. 
Also, we need to update the salesrepnumber in customers table with the reportsto of the inactive employees.
*/

-- 4
select department_name, employee_name,case when num is null then 1 else num end 'salary changes'
from employee e
left join department d on e.department_id=d.department_id
left join (select employee_id, salary,count(*) num from employee_salary group by 1,2) s on e.employee_id=s.employee_id;

-- 5
select department_name, employee_name
from (select department_id, employee_name, dense_rank() over (partition by department_id order by current_salary desc) r
from employee where term_date is null) t
left join department d on d.department_id=t.department_id
where r<4;












