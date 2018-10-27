drop database if exists ccg_db;
create database ccg_db character set UTF8mb4 collate utf8mb4_bin;
use ccg_db;


create table if not exists Users (
	user_id int not null primary key,
    login varchar(40) not null unique,
    email varchar(150) not null unique,
    password varchar(200) not null
);

create table if not exists Heroes (
	hero_id int not null primary key,
    name varchar(50) not null unique,
    hp int not null,
    ap int not null
);

create table if not exists Minions (
	minion_id int not null primary key,
    hero_id int,
    name varchar(50) not null unique,
    hp int not null,
    ap int not null,
    foreign key (hero_id) references Heroes(hero_id) on delete set null
);

create table if not exists Spells (
	spell_id int not null primary key,
    name varchar(70) not null unique,
    ap int
);

create table if not exists Decks (
	deck_id int not null primary key auto_increment,
    user_id int not null,
    foreign key (user_id) references Users(user_id) on delete cascade
);

create table if not exists Matches (
    match_id int not null primary key,
    user1_id int,
    user2_id int,
    result bool,
    foreign key (user1_id) references Users(user_id) on delete set null,
    foreign key (user2_id) references Users(user_id) on delete set null
);

create table if not exists SpellSets (
    set_id int not null primary key,
    deck_id int not null,
    spell_id int not null,
    foreign key (deck_id) references Decks(deck_id) on delete cascade,
    foreign key (spell_id) references Spells(spell_id) on delete cascade
);

create table if not exists MinionSets (
    set_id int not null primary key,
    deck_id int not null,
    minion_id int not null,
    num int not null,
    foreign key (deck_id) references Decks(deck_id) on delete cascade,
    foreign key (minion_id) references Minions(minion_id) on delete cascade
);



