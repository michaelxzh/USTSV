use classicmodels;
/*
select *
from customers
where city = 'NYC';
desc customers;

select state, city, count(distinct customerNumber) num
from customers
where state is not null
group by 1,2
order by 3 desc
limit 5 offset 5;

select o.orderNumber,c.customerNumber
from customers c
left join orders o on c.customerNumber=o.customerNumber
where c.city='NYC';

select od.productCode,sum(od.quantityOrdered) num
from customers c,orders o,orderdetails od
where c.city='NYC' and c.customerNumber=o.customerNumber and o.orderNumber=od.orderNumber
group by 1
order by 2 desc
limit 3;

select concat(e.firstName,' ',e.lastName) employee, concat(m.firstName,' ',m.lastName) manager
from employees e
left join employees m on e.reportsTo=m.employeeNumber
order by 2;
*/

-- shortest distance in a line
-- tbl_point: in x-axis x column stands for x coordinate in x-axis, no duplicates in x
-- find shortest distance
select min(t.x-tt.x)
from tbl_point t, tbl_point tt
where t.x > tt.x;

-- customers [customer_id, country]
-- orders [order_id, customer_id]
-- orderdetails [order_id, product_id, quantity]
-- products [product_id, category_id, price]
-- category [category_id, category_name]
-- 1. each customer average spend per order
select o.customer_id, sum(price*quantity)/count(distinct order_id)
from orders o
left join orderdetails od on o.order_id=od.order_id
left join products p on p.product_id=od.product_id
group by 1;
-- 2. each customer # of sales for pen, paper, other?
select o.customer_id, category_name, sum(quantity)
from orders o
left join orderdetails od on o.order_id=od.order_id
left join products p on p.product_id=od.product_id
left join category c on c.category_id=p.category_id
where category_name in ('pen','paper','other')
group by 1, 2
order by 1, 2;

-- employee [employee_id,name,job_title,level_sk,dept_sk,manager_id,location_sk,salary,start_date,term_date]
-- level [level_sk,level_name]
-- department [dept_sk,dept_name]
-- location [location_sk,city,state,country]
-- 1. select the employee in each department with the highest salary in the us include employee name depatment name, and salary in output
Select t.name, d.dept_name, t.salary
From (Select *, dense_rank() over (partition by dept_sk order by salary desc) r
From employee) t
Left join department d on d.dept_sk=t.dept_sk
left join location lc on lc.location_sk=t.location_sk
Where r=1 and country='US'
Order by 3 desc;
-- 2. top5
Select t.name, d.dept_name, t.salary
From (Select *, dense_rank() over (partition by dept_sk order by salary desc) r
From employee) t
Left join department d on d.dept_sk=t.dept_sk
left join location lc on lc.location_sk=t.location_sk
Where r<5 and country='US'
Order by 1,3 desc;
-- 3. create a table in database with information from all tables for depatment of BizOPS
create table bizops
select e.*,l.level_name,d.dept_name, lc.city, lc.state, lc.country
from employee e
left join level l on l.level_sk=e.level_sk
left join department d on e.dept_sk=d.dept_sk
left join location lc on lc.location_sk=e.location_sk
where d.dept_name='BizOPS';
-- 4. pull a list of manager and their direct reports in the output
select e.name employee_name, t.name manager_name
from employee e
join employee t on t.employee_id=e.manager_id
where e.employee_id in (select distinct manager_id from employee)
-- 5. find the number of employees that started at the company each quarter
select q quarter, count(distinct employee_id) num
from (select employee_id, case when month(start_date) between 1 and 3 then 'q1'
when month(start_date) between 4 and 6 then 'q2'
when month(start_date) between 7 and 9 then 'q3'
else 'q4' end q from employee) t
group by 1;
-- 6. find the average tenure of all employee by level. if an employee is still at the company term_date is null, use today's date to calculate tenure
select level_name, avg(term_date-start_date)
from (select level_sk, start_date, case when term_date is null then curdate() else term_date end term_date from employee) t
left join level l on l.level_sk=t.level_sk
group by 1;

select level_sk, avg(datediff(coalesce(term_date,curdate()),start_date)) avg_tenure
from employee
group by 1;

-- visit [id,view,timestamp]
-- find the time-difference of last visit and second last visit if user has only one visit, just leave it there
with tr as (select *, rank() over (partition by id order by timestamp desc) r from visit)
select id, case when t.id is null then tr.timestamp else tr.timestamp-t.timestamp end timediff
from tr
left join tr t on tr.id=t.id and tr.r=t.r-1
where tr.r=1;
