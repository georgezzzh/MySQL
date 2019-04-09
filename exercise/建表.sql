CREATE TABLE journal(
ID int(8) primary key auto_increment,
user varchar(32),
title tinytext,
article_main text,
date varchar(32),
time varchar(32)
);