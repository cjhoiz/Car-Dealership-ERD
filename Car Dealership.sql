-- VIN Table 
create table vin (
	vin_number VARCHAR(20) primary key,
	vehicle_desc VARCHAR(150)
);

-- Sales Table
create table sales (
	invoice_id SERIAL primary key,
	salesperson_id INTEGER,
	vin_number VARCHAR(20),
	total_sales INTEGER,
	total_revenue NUMERIC(10,2),
	foreign key(salesperson_id) references salesperson(salesperson_id),
	foreign key(vin_number) references vin(vin_number)
);

-- Salesperson Table
create table salesperson (
	salesperson_id SERIAL primary key,
	first_name VARCHAR(150),
	last_name VARCHAR(150),
	email VARCHAR(150),
	date_employed DATE,
	salary numeric(10,2),
	sales integer,
	revenue numeric(14,2)
);


-- New Vehicle Table (if customer purchased a car from the dealership)
create table new_vehicle (
	purchased_vehicle SERIAL primary key,
	date_purchased DATE,
	vehicle_price NUMERIC(10,2),
	invoice_id INTEGER,
	vin_number VARCHAR(20),
	foreign key(invoice_id) references sales(invoice_id),
	foreign key(vin_number) references vin(vin_number)
);

-- Parts Table
create table parts(
	part_id SERIAL primary key,
	part_ordered VARCHAR(150),
	part_cost NUMERIC(8,2)
);

-- Mechanic Table
create table mechanic(
	mechanic_id SERIAL primary key,
	first_name VARCHAR(150),
	last_name VARCHAR(150),
	email VARCHAR(150),
	date_employed DATE,
	salary numeric(6,2)
);

-- Service ID Table
create table service (
	service_id SERIAL primary key,
	mechanic_id INTEGER,
	foreign key(mechanic_id) references mechanic(mechanic_id)
);

-- Vehicle Service Table
create table service_vehicle (
	serviced_vehicle VARCHAR(150) primary key,
	vin_number VARCHAR(20),
	last_serviced DATE,
	miles INTEGER,
	part_id INTEGER,
	service_id INTEGER,
	service_cost NUMERIC(6,2),
	foreign key(vin_number) references vin(vin_number),
	foreign key(part_id) references parts(part_id),
	foreign key(service_id) references service(service_id)
);

-- Customer Table
create table customer (
	customer_id SERIAL primary key,
	invoice_id INTEGER,
	service_id INTEGER,
	vin_number VARCHAR(20),
	serviced_vehicle VARCHAR(150),
	foreign key(invoice_id) references sales(invoice_id),
	foreign key(service_id) references service(service_id),
	foreign key(vin_number) references vin(vin_number),
	foreign key(serviced_vehicle) references service_vehicle(serviced_vehicle)
);

-- Forgot to put first_name, last_name, email, and address into customer
alter table customer add first_name VARCHAR(150);
alter table customer add last_name VARCHAR(150);
alter table customer add email VARCHAR(150);
alter table customer add address VARCHAR(150);

-- Dealership Table
create table company (
	dealership_id SERIAL primary key,
	salesperson_id INTEGER,
	service_id INTEGER,
	foreign key(service_id) references service(service_id),
	foreign key(salesperson_id) references salesperson(salesperson_id)
);

-- Function to add to table vin
create or replace function add_vin(_vin_number VARCHAR, _vehicle_desc VARCHAR)
returns void
as $MAIN$
begin 
	insert into vin(vin_number, vehicle_desc)
	values (_vin_number, _vehicle_desc);
end;
$MAIN$
language plpgsql;

-- Call Function
select add_vin('1A', 'Chevrolet Silverado 1500 High Country');
select add_vin('1B', 'Chevrolet Silverado 2500HD High Country');

-- Test
select * from vin;

-- Drop Function
drop function add_vin;

-- Function to add to table salesperon
create or replace function add_salesperson(_salesperson_id INTEGER, _first_name VARCHAR, _last_name VARCHAR, _email VARCHAR, _date_employed DATE, _salary numeric, _sales INTEGER, _revenue numeric)
returns void
as $MAIN$
begin 
	insert into salesperson(salesperson_id, first_name, last_name, email, date_employed, salary, sales, revenue)
	values (_salesperson_id, _first_name, _last_name, _email, _date_employed, _salary, _sales, _revenue);
end;
$MAIN$
language plpgsql;

-- Call Function to add to salesperon
select add_salesperson(1, 'Jack', 'Sparrow', 'jsparrow@thepearl.com', '1999-05-14', 5000.00, 40, 100000.51);
select add_salesperson(2, 'Will', 'Turner', 'wturner@bootstrap.com', '2000-06-28', 5500.00, 43, 110000.52);

-- Test
select * from salesperson;

-- Drop function
drop function add_salesperson;

-- Function to add mechanic data to the mechanic table
create or replace function add_mechanic(_customer_id INTEGER, _first_name VARCHAR, _last_name VARCHAR, _email VARCHAR, _date_employed DATE, _salary NUMERIC)
returns void
as $MAIN$
begin 
	insert into mechanic(mechanic_id, first_name, last_name, email, date_employed, salary)
	values (_mechanic_id, _first_name, _last_name, _email, _date_employed, _salary);
end;
$MAIN$
language plpgsql;

-- Call function 
select add_mechanic(1, 'Hector', 'Barbosa', 'hbarbosa@cursed.com', '2000-01-14', 6000.00);
select add_mechanic(2, 'Davy', 'Jones', 'djones@thelocker.com', '1998-02-16', 7000.00);

-- Test
select * from mechanic;

-- Drop Mechanic function
drop function add_mechanic;

-- Sales Function
create or replace function add_sales(_invoice_id INTEGER, _salesperson_id INTEGER, _vin_number VARCHAR, _total_sales numeric, _total_revenue NUMERIC)
returns void
as $MAIN$
begin 
	insert into sales(invoice_id, salesperson_id, vin_number, total_sales, total_revenue)
	values (_invoice_id, _salesperson_id, _vin_number, _total_sales, _total_revenue);
end;
$MAIN$
language plpgsql;

-- Call Sales function 
select add_sales(1, 1, '1A', 5, 100000.65);
select add_sales(2, 2, '1B', 12, 250135.65);

-- Test
select * from sales;

-- Drop Function
drop function add_sales;

-- Service ID data
insert into service(service_id, mechanic_id)
values (1, 1);

insert into service(service_id, mechanic_id)
values (2, 2);

-- Test
select * from service;

-- Parts Data
insert into parts(part_id, part_ordered, part_cost)
values(1, 'Carburetor', 5000.00);

insert into parts(part_id, part_ordered, part_cost)
values(2, 'Bolt', 26.50);

-- Test
select * from parts;

-- Service Vehicle Data
create or replace function add_service_vehicle(_serviced_vehicle VARCHAR, _vin_number VARCHAR, _last_serviced DATE, _miles INTEGER, _part_id INTEGER, _service_id INTEGER, _service_cost NUMERIC)
returns void
as $MAIN$
begin 
	insert into service_vehicle(serviced_vehicle, vin_number, last_serviced, miles , part_id, service_id, service_cost)
	values (_serviced_vehicle, _vin_number, _last_serviced, _miles, _part_id, _service_id, _service_cost);
end;
$MAIN$
language plpgsql;

-- Call Service Vehicle function 
select add_service_vehicle('Chevrolet Silverado 1500 High Country', '1A', null, 253, null, 1, 56.35);
select add_service_vehicle('Chevrolet Silverado 2500HD High Country', '1B', '2021-05-19', 45621, 2, 2, 165.21);

-- Test
select * from service_vehicle;

-- Drop service_vehicle function
drop function add_service_vehicle;

-- Customer Function
create or replace function add_customer(_customer_id INTEGER, _first_name VARCHAR, _last_name VARCHAR, _email VARCHAR, _invoice_id INTEGER, _service_id INTEGER, _vin_number VARCHAR, _serviced_vehicle VARCHAR, _address VARCHAR)
returns void
as $MAIN$
begin 
	insert into customer(customer_id, first_name, last_name, email, invoice_id, service_id, vin_number, serviced_vehicle, address)
	values (_customer_id, _first_name, _last_name, _email, _invoice_id, _service_id, _vin_number, _serviced_vehicle, _address);
end;
$MAIN$
language plpgsql;

-- Call function for add_customer 
select add_customer(1, 'Elizabeth', 'Swan', 'eswan@parlay.com', 1, 1, '1A', 'Chevrolet Silverado 1500 High Country');

-- Forgot to add address into the function
update customer
set address = '2500 Tortuga Pl. Tortuga, Carribbean 90241'
where customer_id = 1;

select add_customer(2, 'James', 'Norton', 'jnorton@theinterceptor.com', 2, 2, '1B', 'Chevrolet Silverado 2500HD High Country', '620 Ocean View Lane London, UK');
-- Drop function
drop function add_customer;

-- Test
select * from customer;

-- New Vehicle Data
insert into new_vehicle(purchased_vehicle, date_purchased, vehicle_price, invoice_id, vin_number)
values(1, null, 65000.00, null, '1B');

insert into new_vehicle(purchased_vehicle, date_purchased, vehicle_price, invoice_id, vin_number)
values(2, null, 75000.00, null, '1A');