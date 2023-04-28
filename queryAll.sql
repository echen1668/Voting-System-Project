
#B.1 . List the name, city, and email (any single email suffices) of all folks.
select first_name, last_name, city, email from (folks inner join (residence natural inner join place) using(coordinate_x, coordinate_y)) inner join folks_email using(id);

#B.2 . List the city, state, and the number of residents of each city in Wonderland (skip cities with no residents) in decreasing order of number of residents.
select city, state, count(distinct id)  as num_resd from folks inner join (residence natural inner join place) using(coordinate_x, coordinate_y) group by city, state order by count(distinct id) desc;

#B.3 . List each state together with its number of currently inhabited places (include states with no inhabited places) in increasing alphabetical order
select state, count(distinct folks.coordinate_x, folks.coordinate_y) as num_inhabited_places from folks inner join (residence natural inner join place) using(coordinate_x, coordinate_y) group by state order by state;

#B.4 Find the distinct identifiers of folks registered at a given voting center within a given time period
#Need user input for this voting_center.id and register.date_time interval
select distinct register.id as folk_id from register inner join voting_center using(coordinate_x, coordinate_y) where voting_center.id = 'A476' and date_time between '2023-10-15 01:45:33' and '2023-11-03 11:59:59';

#B.5 Find for a given month, the number of unique registrations at any voting center which is within 5 miles from the center of Megapolis, except for voting centers in a given (exclusion) list of voting centers.
#Need user input for this voting_center.id and month value
select count(distinct register.id) as num_reg from register inner join voting_center using(coordinate_x, coordinate_y) where voting_center.id not in ('B088', 'C245') and power(voting_center.coordinate_x, 2) + power(voting_center.coordinate_y, 2) < 25 and month(register.date_time) = 10;

#B.6 Find the most popular voting center(s) (in terms of total number of registrations) in a given time period among those in a given city. 
#Need user input for this place.city and register.date_time peroid interval
select voting_center.id as voting_cen_id, count(distinct register.id) as num_reg from (voting_center natural inner join place) inner join register using(coordinate_x, coordinate_y) where place.city = 'Baltimore' and register.date_time between '2023-10-15 01:45:33' and '2023-11-03 11:59:59' group by voting_center.id order by count(distinct register.id) desc limit 1;

#B.7 Find the unique folk that have valid registrations with every voting center on a given state. 
#Need user input for place.state
select distinct id from register as A where not exists(select voting_center.coordinate_x, voting_center.coordinate_y from voting_center natural inner join place where state = 'Maryland' and (voting_center.coordinate_x, voting_center.coordinate_y) not in (select coordinate_x, coordinate_y from register as B where B.id = A.id));

#B.8 Find folks that registered at a voting center that is farther away than the voting center closest to their residence (break ties alphabetically by center’s acronym)
select distinct register.id as folk_id from (folks natural inner join (residence as A)) inner join register using(id) where sqrt(power(abs(register.coordinate_x - A.coordinate_x), 2) + power(abs(register.coordinate_y - A.coordinate_y), 2))
	> (select min(sqrt(power(abs(voting_center.coordinate_x - B.coordinate_x), 2) + power(abs(voting_center.coordinate_y - B.coordinate_y), 2))) from (residence as B), voting_center where B.residence_number = A.residence_number);
    

#B.9 Write a SQL function that returns the acronym of the voting center closest to the residence of a given folk among those whose operating period(s) contain a given date (return NULL if no such center exists; break ties at alphabetically by acronym).
drop function if exists b9Function;
delimiter //
create function b9Function(folk_id varchar(16), date_time datetime) returns varchar(4) CONTAINS SQL READS SQL DATA
begin
	declare nearest_vc varchar(4);
    declare min_value float;
    DECLARE flag boolean;
	select sqrt(power(abs(voting_center.coordinate_x - residence.coordinate_x), 2) + power(abs(voting_center.coordinate_y - residence.coordinate_y), 2)), voting_center.id into min_value, nearest_vc from voting_center, (folks natural inner join residence) where folks.id = folk_id order by sqrt(power(abs(voting_center.coordinate_x - residence.coordinate_x), 2) + power(abs(voting_center.coordinate_y - residence.coordinate_y), 2)), voting_center.id asc limit 1;
	set flag = exists(select * from voting_center natural inner join voting_center_operating_peroid where voting_center.id = nearest_vc and date_time between voting_center_operating_peroid.operating_peroid_start and voting_center_operating_peroid.operating_peroid_end);
	if (flag = true) then
        return nearest_vc;
	else
		return null;
    END IF;
end; //
delimiter ;

select b9Function('0252501238384682', '2023-10-16 12:59:59') as output;

#B.10 For a given ballot, construct a cross-tabulation of voting centers (acronym) as rows, unique ballot answers (options) as columns, and cells indicating number of cast votes at the row’s center with the column’s option.
#Need to input ballot.question
select voting_center.id as voting_center_id, count(case when ballot.answer = 'yes' then 1 end) as YES,  count(case when ballot.answer = 'no' then 1 end) as NO, count(case when ballot.answer = 'abstain' then 1 end) as ABSTAIN from (voting_center inner join casts using(coordinate_x, coordinate_y)) inner join ballot using(name) where ballot.question = 'Should this country provide paid family leave?' group by voting_center.id;

