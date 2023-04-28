#A.2 a folk registering to vote for a ballot
drop procedure if exists registerBallot;
delimiter //
create procedure registerBallot(in id varchar(16), in coordinate_x int, in coordinate_y int, in name varchar(4), in date_time datetime) CONTAINS SQL READS SQL DATA
begin
  DECLARE flag1 boolean;
  DECLARE flag2 boolean;
  DECLARE flag3 boolean;
  SET flag1 = exists(select * from ballot where ballot.name = name and date_time between ballot.avaibilty_start and ballot.avaibilty_end);
  SET flag2 = exists(select * from voting_center_operating_peroid where voting_center_operating_peroid.coordinate_x = coordinate_x and voting_center_operating_peroid.coordinate_y = coordinate_y and date_time between voting_center_operating_peroid.operating_peroid_start and voting_center_operating_peroid.operating_peroid_end);
  SET flag3 = exists(select * from folks where folks.id = id);
  IF (flag1 = true and flag2 = true and flag3 = true) THEN
        insert into register values(id, coordinate_x, coordinate_y, name, date_time);
    END IF;
end; //
delimiter ;
select * from register;

call registerBallot('2409699756416072', 1, 2, 'A983', '2023-11-01 01:45:33');
select * from register;
call registerBallot('2409699756416072', 4, 4, 'A983', '2023-11-01 01:45:33');
select * from register;
