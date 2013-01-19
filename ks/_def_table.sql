drop table if exists users;
create table users (
  userid serial not null unique,
  username varchar(16) not null unique ,
  password text not null,
  score text	
);

drop table if exists messages;
create table messages (
  msgid serial not null unique,
  title varchar(20),
  msg text
);
  