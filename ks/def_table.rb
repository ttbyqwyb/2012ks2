require "rubygems"
require "pg"
require "settings"
require "functions"

def create_table_users
  pg = Settings.get_pgconn
  sql = <<SQL
drop table if exists #{DB::Users};
create table #{DB::Users} (
  #{DB::Users_userid} serial not null unique,
  #{DB::Users_username} varchar(16) not null unique,
  #{DB::Users_password} text not null
);
SQL
  pg.exec(sql)
end

def create_table_scores
  pg = Settings.get_pgconn
  sql1 = <<SQL
drop table if exists #{DB::Scores};
create table #{DB::Scores} (
  #{DB::Scores_scoreid} serial not null unique,
  #{DB::Scores_userid} integer not null,
  #{DB::Scores_prob_num} integer not null,
  #{DB::Scores_date} varchar(30),
  #{DB::Scores_verdict} varchar(30),
  #{DB::Scores_execution_time} varchar(30),
  #{DB::Scores_language} varchar(10),
  #{DB::Scores_source_code} text
);
SQL
  sql2 = <<SQL
insert into #{DB::Scores}
(#{DB::Scores_userid},#{DB::Scores_prob_num},#{DB::Scores_verdict})
values (0, 0, 'dammy');
SQL
  pg.exec(sql1)
  pg.exec(sql2) # select last_value from scores_scoreid_seq
end

def create_table_messages
  pg = Settings.get_pgconn
  sql = <<SQL
drop table if exists #{DB::Messages};
create table #{DB::Messages} (
  #{DB::Messages_msgid} serial not null unique,
  #{DB::Messages_time} varchar(30),
  #{DB::Messages_title} varchar(20),
  #{DB::Messages_msg} text
);
SQL
  pg.exec(sql)
end

def insert_users
  pg = Settings.get_pgconn
  sql = <<SQL
insert into #{DB::Users} (#{DB::Users_username}, #{DB::Users_password})
  values ('name', 'pass'),
         ('waka', 'password'),
         ('wakatsuki', 'foo'),
         ('a', 'b');
SQL
  pg.exec(sql)
end

create_table_users
create_table_scores
create_table_messages
insert_users
save_msg( "table created" )
