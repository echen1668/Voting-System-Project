create table if not exists place(
	coordinate_x int,
    coordinate_y int,
    street_number varchar(10) NOT NULL,
    street_name varchar(30) NOT NULL,
    city varchar(20) NOT NULL,
    state varchar(20) NOT NULL,
    zipcode varchar(10) NOT NULL,
    primary key(coordinate_x, coordinate_y),
    unique(street_number)
);

create table if not exists residence(
	coordinate_x int,
    coordinate_y int,
    residence_number varchar(12) NOT NULL,
    unique(residence_number),
    FOREIGN KEY (coordinate_x, coordinate_y) REFERENCES place(coordinate_x, coordinate_y) 
		ON DELETE CASCADE
        ON UPDATE CASCADE
);

create table if not exists voting_center(
	coordinate_x int,
    coordinate_y int,
    id varchar(4) NOT NULL,
    num_reg_voters int(5) NOT NULL,
    unique(id),
    check (num_reg_voters >= 0),
    FOREIGN KEY (coordinate_x, coordinate_y) REFERENCES place(coordinate_x, coordinate_y)
		ON DELETE CASCADE
        ON UPDATE CASCADE
);

create table if not exists folks(
	id varchar(16),
    first_name varchar(20) NOT NULL,
    last_name varchar(20) NOT NULL,
    nickname varchar(20) NOT NULL,
    date_of_birth date NOT NULL,
    primary_phone varchar(10) NOT NULL,
    secondary_phone varchar(10) NOT NULL,
    coordinate_x int,
    coordinate_y int,
    primary key(id),
    unique(primary_phone, secondary_phone),
    FOREIGN KEY (coordinate_x, coordinate_y) REFERENCES residence(coordinate_x, coordinate_y)
		ON DELETE CASCADE
        ON UPDATE CASCADE
);

create table if not exists folks_email(
	id varchar(16),
    email varchar(40) NOT NULL,
    FOREIGN KEY (id) REFERENCES folks(id)
		ON DELETE CASCADE
        ON UPDATE CASCADE
);

create table if not exists staff(
	id varchar(16),
    role varchar(20) NOT NULL,
    coordinate_x int,
    coordinate_y int,
    date_time datetime,
    FOREIGN KEY (id) REFERENCES folks(id)
		ON DELETE CASCADE
        ON UPDATE CASCADE,
    FOREIGN KEY (coordinate_x, coordinate_y) REFERENCES voting_center(coordinate_x, coordinate_y)
		ON DELETE CASCADE
        ON UPDATE CASCADE
);

create table if not exists voting_center_operating_peroid(
	coordinate_x int,
    coordinate_y int,
    operating_peroid_start datetime NOT NULL,
    operating_peroid_end datetime NOT NULL,
    FOREIGN KEY (coordinate_x, coordinate_y) REFERENCES voting_center(coordinate_x, coordinate_y)
		ON DELETE CASCADE
        ON UPDATE CASCADE
);

create table if not exists ballot(
	name varchar(4),
    question varchar(100),
    avaibilty_start datetime,
    avaibilty_end datetime,
    answer varchar(10),
    primary key (name),
    check(answer in (null, "yes", "no", "abstain"))
);

create table if not exists register(
	id varchar(16),
	coordinate_x int,
    coordinate_y int,
    name varchar(4),
    date_time datetime,
    FOREIGN KEY (id) REFERENCES folks(id)
		ON DELETE CASCADE
        ON UPDATE CASCADE,
    FOREIGN KEY (coordinate_x, coordinate_y) REFERENCES voting_center(coordinate_x, coordinate_y)
		ON DELETE CASCADE
        ON UPDATE CASCADE,
    FOREIGN KEY (name) REFERENCES ballot(name)
		ON DELETE CASCADE
        ON UPDATE CASCADE
); 


create table if not exists casts(
	id varchar(16),
	coordinate_x int,
    coordinate_y int,
    name varchar(4),
    date_time datetime,
    FOREIGN KEY (id) REFERENCES folks(id)
		ON DELETE CASCADE
        ON UPDATE CASCADE,
    FOREIGN KEY (coordinate_x, coordinate_y) REFERENCES voting_center(coordinate_x, coordinate_y)
		ON DELETE CASCADE
        ON UPDATE CASCADE,
    FOREIGN KEY (name) REFERENCES ballot(name)
		ON DELETE CASCADE
        ON UPDATE CASCADE
); 

delimiter //
create trigger addvoter
	after insert on register
for each row
begin
	update voting_center set num_reg_voters = num_reg_voters + 1 where voting_center.coordinate_x = new.coordinate_x and voting_center.coordinate_y = new.coordinate_y;
end; //
delimiter ;
