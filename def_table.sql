drop table if exists users;
create table users (
  userid serial not null unique,
  username varchar(16) not null unique ,
  password text not null,
  score text
);