#A.3 a clerk modifying the availability period of a current ballot
drop procedure if exists modifyBallot;
delimiter //
create procedure modifyBallot(in ballot_name varchar(4), in start_time datetime, in end_time datetime) CONTAINS SQL READS SQL DATA
begin
  DECLARE flag boolean;
  SET flag = not exists(select * from casts where casts.name = ballot_name);
  IF (flag = true) THEN
        update ballot set avaibilty_start = start_time, avaibilty_end = end_time where ballot.name = ballot_name;
    END IF;
end; //
delimiter ;

select * from ballot;
call modifyBallot('A983', '2023-10-15 01:00:00', '2023-11-08 12:59:59');
select * from ballot;

