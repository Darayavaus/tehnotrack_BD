use ccg_db;

load data infile '/var/lib/mysql-files/dz6/users.csv' into table Users 
fields terminated by ';' lines terminated by '\n';

load data infile '/var/lib/mysql-files/dz6/heroes.csv' into table Heroes 
fields terminated by ';' lines terminated by '\n';

load data infile '/var/lib/mysql-files/dz6/spells.csv' into table Spells 
fields terminated by ';' lines terminated by '\n';

load data infile '/var/lib/mysql-files/dz6/matches.csv' into table Matches 
fields terminated by ';' lines terminated by '\n';

load data infile '/var/lib/mysql-files/dz6/minions.csv' into table Minions 
fields terminated by ';' lines terminated by '\n';

load data infile '/var/lib/mysql-files/dz6/decks.csv' into table Decks 
fields terminated by ';' lines terminated by '\n';

load data infile '/var/lib/mysql-files/dz6/spell_sets.csv' into table MinionSets 
fields terminated by ';' lines terminated by '\n';

load data infile '/var/lib/mysql-files/dz6/minion_sets.csv' into table SpellSets
fields terminated by ';' lines terminated by '\n';