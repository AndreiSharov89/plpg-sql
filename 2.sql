--1
select * from aircrafts;

--2
select aircraft_code, model
from aircrafts;

--3
select model, range
from bookings.aircrafts_data
where range < 5000;

--4
select book_ref, passenger_id, passenger_name
from bookings.tickets
where passenger_name like 'V%'
or passenger_name like 'E%';

--5
select flight_no, scheduled_departure, scheduled_arrival,
departure_airport, arrival_airport
from bookings.flights
where departure_airport = 'DME'
and scheduled_departure between '2017-08-31' and '2017-09-01';

--6
select flight_no, scheduled_departure, scheduled_arrival,
departure_airport, arrival_airport
from bookings.flights
where departure_airport = 'DME'
and arrival_airport in ('LED', 'KZN')
and scheduled_departure between '2017-08-31' and '2017-09-01';

--7
select flight_no, scheduled_departure, scheduled_arrival,
actual_departure, actual_arrival
from bookings.flights
where departure_airport = 'DME'
and actual_departure = NULL;

select flight_no, scheduled_departure, scheduled_arrival,
actual_departure, actual_arrival
from bookings.flights
where departure_airport = 'DME'
and actual_departure is NULL;

select flight_no, scheduled_departure, scheduled_arrival,
coalesce(actual_departure, '9999-12-31'), 
coalesce(actual_arrival, '9999-12-31')
from bookings.flights
where departure_airport = 'DME'
and arrival_airport = 'KZN';

select flight_no, scheduled_departure, scheduled_arrival,
coalesce(actual_departure, '9999-12-31') as "Actual Departure", 
coalesce(actual_arrival, '9999-12-31') "Actual Arrival"
from bookings.flights
where departure_airport = 'DME'
and arrival_airport = 'KZN';

select scheduled_departure, flight_no,
coalesce(actual_departure::varchar, 'CANCELED') as "Actual Departure"
from bookings.flights
where departure_airport = 'DME'
and arrival_airport = 'KZN';

--8
select scheduled_departure, flight_no,
departure_airport, arrival_airport
from bookings.flights
where departure_airport = 'DME'
order by arrival_airport;

select scheduled_departure, flight_no,
departure_airport, arrival_airport
from bookings.flights
where departure_airport = 'DME'
order by arrival_airport, scheduled_departure desc;

--9
select distinct
departure_airport,
arrival_airport
from bookings.flights
order by 1,2;

--10
select scheduled_departure,
'from ' || departure_airport::varchar || ' to '
|| arrival_airport::varchar as Destination,
status
from bookings.flights;

select book_ref, 
substring (passenger_name from 1 for position (' ' in passenger_name)) as Name,
substring (passenger_name from position (' ' in passenger_name)) as Surname
from bookings.tickets;

--11
select
avg(amount) as Average,
sum(amount) as Summary
from bookings.ticket_flights
where fare_conditions = 'Economy';

select
count(*)
from bookings.ticket_flights
where fare_conditions = 'Economy';

--12
select
count(*)
from bookings.flights
where coalesce(actual_arrival::date, '2017-06-12') = '2017-06-12';

select
count(actual_arrival)
from bookings.flights
where coalesce(actual_arrival::date, '2017-06-12') = '2017-06-12';

--13
/*select departure_airport, count(actual_arrival)
from bookings.flights;*/

--14
select departure_airport, count(actual_arrival)
from bookings.flights
group by departure_airport;

--15
select departure_airport, count(actual_arrival)
from bookings.flights
group by departure_airport
having count(actual_arrival) <50;

--16
select departure_airport, arrival_airport, count(actual_arrival)
from bookings.flights
group by rollup (departure_airport, arrival_airport)
having count(actual_arrival) >300;

select departure_airport, arrival_airport, count(actual_arrival)
from bookings.flights
group by cube (departure_airport, arrival_airport)
having count(actual_arrival) >300;