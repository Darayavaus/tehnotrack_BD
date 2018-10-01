use tehnotrack_db;

drop table if exists sessions, payments, users; 

create table if not exists users (
	user_id int not null primary key,
    login varchar(50) not null unique,
    reg_dttm timestamp
);

create table if not exists payments (
	payment_id int not null primary key,
    user_id int,
    payment_sum double,
    payment_dttm timestamp,
    foreign key (user_id) references users(user_id) on delete set null
);

create table if not exists sessions (
	session_id int not null primary key,
    user_id int,
	begin_dttm timestamp default current_timestamp,
    end_dttm timestamp default current_timestamp,
    foreign key (user_id) references users(user_id) on delete set null
);

load data infile '/var/lib/mysql-files/dz2_users.csv' into table users 
fields terminated by ',' lines terminated by '\n';

load data infile '/var/lib/mysql-files/dz2_payments.csv' into table payments
fields terminated by ',' lines terminated by '\n';

load data infile '/var/lib/mysql-files/dz2_sessions.csv' into table sessions
fields terminated by ',' lines terminated by '\n';