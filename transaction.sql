set transaction isolation level serializable;

# you need user input for attributes id, coordinate, name, and date_time to insert into casts
drop procedure if exists checkForRegisteration;
delimiter //
create procedure checkForRegisteration(in id varchar(16), in coordinate_x int, in coordinate_y int, in name varchar(4), in date_time datetime) CONTAINS SQL READS SQL DATA
begin
  DECLARE flag boolean;
  start transaction;
  insert into casts values(id, coordinate_x, coordinate_y, name, date_time);
  select * from casts;
  SET flag = exists(select * from register where register.id = id and register.coordinate_x = coordinate_x and register.coordinate_y = coordinate_y and register.name = name and register.date_time = date_time);
  select flag;
  IF flag = true THEN
        commit;
    ELSE
        rollback;
    END IF;
end; //
delimiter ;

call checkForRegisteration('9078458986797290', 1, 2, 'B844', '2023-11-07 07:22:00');
select * from casts;
