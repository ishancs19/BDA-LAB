7.9833	21-JUN-07	SH_CLERK	26bmscecse@bmscecse-HP-Pro-3330-MT:~$ cd cassandra/apache-cassandra-3.11.0/bin
bmscecse@bmscecse-HP-Pro-3330-MT:~/cassandra/apache-cassandra-3.11.0/bin$ ./cqlsh
Connected to Test Cluster at 127.0.0.1:9042.
[cqlsh 5.0.1 | Cassandra 3.11.0 | CQL spec 3.4.4 | Native protocol v4]
Use HELP for help.
cqlsh> create keyspace students with replication = {
   ... 'class':'SimpleStrategy',
   ... 'replication_factor':1
   ... };
AlreadyExists: Keyspace 'students' already exists
cqlsh> create keyspace stud198 with replication = { 'class':'SimpleStrategy', 'replication_factor':1 };
cqlsh> describe keyspaces;

students   	system_auth  system_distributed  system_traces
system_schema  system   	employee        	stud198 	 

cqlsh> select * from system.schema_keyspaces;
InvalidRequest: Error from server: code=2200 [Invalid query] message="unconfigured table schema_keyspaces"
cqlsh> select * from system.stud198;
InvalidRequest: Error from server: code=2200 [Invalid query] message="unconfigured table stud198"
cqlsh> use stud198;
cqlsh:stud198> create table stud_info(
       	... rno int primary key,
       	... stud_name text,
       	... date_of_joining timestamp,
       	... last_exam_percentage double
       	... );
cqlsh:stud198> describe tables;

stud_info

cqlsh:stud198> describe table stud_info;

CREATE TABLE stud198.stud_info (
	rno int PRIMARY KEY,
	date_of_joining timestamp,
	last_exam_percentage double,
	stud_name text
) WITH bloom_filter_fp_chance = 0.01
	AND caching = {'keys': 'ALL', 'rows_per_partition': 'NONE'}
	AND comment = ''
	AND compaction = {'class': 'org.apache.cassandra.db.compaction.SizeTieredCompactionStrategy', 'max_threshold': '32', 'min_threshold': '4'}
	AND compression = {'chunk_length_in_kb': '64', 'class': 'org.apache.cassandra.io.compress.LZ4Compressor'}
	AND crc_check_chance = 1.0
	AND dclocal_read_repair_chance = 0.1
	AND default_time_to_live = 0
	AND gc_grace_seconds = 864000
	AND max_index_interval = 2048
	AND memtable_flush_period_in_ms = 0
	AND min_index_interval = 128
	AND read_repair_chance = 0.0
	AND speculative_retry = '99PERCENTILE';

cqlsh:stud198> begin batch
       	... insert into stud_info(rno, stud_name, date_of_joining, last_exam_percentage) values (1, 'Michael Storm','2012-02-29', 69.6);
       	...
       	... apply batch;
cqlsh:stud198> select * from stud_info;

 rno | date_of_joining             	| last_exam_percentage | stud_name
-----+---------------------------------+----------------------+---------------
   1 | 2012-02-28 18:30:00.000000+0000 |             	69.6 | Michael Storm

(1 rows)
cqlsh:stud198> insert into stud_info(rno, stud_name, date_of_joining, last_exam_percentage) values (2, 'Stephen Fox','2013-02-27', 72.5);
cqlsh:stud198> insert into stud_info(rno, stud_name, date_of_joining, last_exam_percentage) values (3, 'David Flemming','2014-04-12', 81.7);
cqlsh:stud198> insert into stud_info(rno, stud_name, date_of_joining, last_exam_percentage) values (4, 'Ian String','2012-05-11', 73.4);
cqlsh:stud198> select * from stud_info;

 rno | date_of_joining             	| last_exam_percentage | stud_name
-----+---------------------------------+----------------------+----------------
   1 | 2012-02-28 18:30:00.000000+0000 |             	69.6 |  Michael Storm
   2 | 2013-02-26 18:30:00.000000+0000 |             	72.5 |	Stephen Fox
   4 | 2012-05-10 18:30:00.000000+0000 |             	73.4 | 	Ian String
   3 | 2014-04-11 18:30:00.000000+0000 |             	81.7 | David Flemming

(4 rows)
cqlsh:stud198> select * from stud_info where rno in (1,2,3);

 rno | date_of_joining             	| last_exam_percentage | stud_name
-----+---------------------------------+----------------------+----------------
   1 | 2012-02-28 18:30:00.000000+0000 |             	69.6 |  Michael Storm
   2 | 2013-02-26 18:30:00.000000+0000 |             	72.5 |	Stephen Fox
   3 | 2014-04-11 18:30:00.000000+0000 |             	81.7 | David Flemming

(3 rows)
cqlsh:stud198> create index on stud_info(stud_name);
cqlsh:stud198> select * from stud_info where stud_name = "Stephen Fox";
SyntaxException: line 1:55 no viable alternative at input ';' (...from stud_info where stud_name = ["Stephen Fo]x";)
cqlsh:stud198> select * from stud_info where stud_name = 'Stephen Fox';

 rno | date_of_joining             	| last_exam_percentage | stud_name
-----+---------------------------------+----------------------+-------------
   2 | 2013-02-26 18:30:00.000000+0000 |             	72.5 | Stephen Fox

(1 rows)
cqlsh:stud198> create index on stud_info(last_exam_percentage);
cqlsh:stud198> select * from stud_info where last_exam_percentage = 81.7
       	... ;

 rno | date_of_joining             	| last_exam_percentage | stud_name
-----+---------------------------------+----------------------+----------------
   3 | 2014-04-11 18:30:00.000000+0000 |             	81.7 | David Flemming

(1 rows)
cqlsh:stud198> select rno, hobbies, language, last_exam_percentage from stud_info limit 2;
InvalidRequest: Error from server: code=2200 [Invalid query] message="Undefined column name hobbies"
cqlsh:stud198> update stud_info set stud_name = 'David Sheen' where rno = 2;
cqlsh:stud198> update stud_info set rno = 6 where rno = 3;
InvalidRequest: Error from server: code=2200 [Invalid query] message="PRIMARY KEY part rno found in SET part"
cqlsh:stud198> delete last_exam_percentage from stud_info where rno = 2;
cqlsh:stud198> select * from stud_info;

 rno | date_of_joining             	| last_exam_percentage | stud_name
-----+---------------------------------+----------------------+----------------
   1 | 2012-02-28 18:30:00.000000+0000 |             	69.6 |  Michael Storm
   2 | 2013-02-26 18:30:00.000000+0000 |             	null |	David Sheen
   4 | 2012-05-10 18:30:00.000000+0000 |             	73.4 | 	Ian String
   3 | 2014-04-11 18:30:00.000000+0000 |             	81.7 | David Flemming

(4 rows)
cqlsh:stud198> delete from stud_info where rno =2;
cqlsh:stud198> select * from stud_info;

 rno | date_of_joining             	| last_exam_percentage | stud_name
-----+---------------------------------+----------------------+----------------
   1 | 2012-02-28 18:30:00.000000+0000 |             	69.6 |  Michael Storm
   4 | 2012-05-10 18:30:00.000000+0000 |             	73.4 | 	Ian String
   3 | 2014-04-11 18:30:00.000000+0000 |             	81.7 | David Flemming

(3 rows)
cqlsh:stud198> create table project_details (
       	... project_id int,
       	... project_name text,
       	... stud_name text,
       	... rating double,
       	... duration int,
       	... primary key(project_id, project_name)
       	... );
cqlsh:stud198> insert into project_details (project_id, project_name stud_name, rating, duration)
       	... values (1, 'MS data migration','David Sheen',3.5,720);
SyntaxException: line 1:54 mismatched input 'stud_name' expecting ')' (...into project_details (project_id, project_name [stud_name]...)
cqlsh:stud198> insert into project_details(project_id, project_name stud_name, rating, duration) values (1, 'MS data migration','David Sheen',3.5,720);
SyntaxException: line 1:53 mismatched input 'stud_name' expecting ')' (... into project_details(project_id, project_name [stud_name]...)
cqlsh:stud198> insert into project_details(project_id, project_name, stud_name, rating, duration) values(1, 'MS data migration', 'David Sheen', 3.5, 720);
cqlsh:stud198> insert into project_details(project_id, project_name, stud_name, rating, duration) values(1, 'MS data warehouse', 'David Sheen', 3.9, 1440);
cqlsh:stud198> insert into project_details(project_id, project_name, stud_name, rating, duration) values(2, 'SAP Reporting', 'Stephen Fox', 4.2, 3000);
cqlsh:stud198> insert into project_details(project_id, project_name, stud_name, rating, duration) values(2, 'SAP BI DW', 'Stephen Fox', 4, 9000);
cqlsh:stud198> select * from project_details;

 project_id | project_name  	| duration | rating | stud_name
------------+-------------------+----------+--------+-------------
      	1 | MS data migration |  	720 |	3.5 | David Sheen
      	1 | MS data warehouse | 	1440 |	3.9 | David Sheen
      	2 |     	SAP BI DW | 	9000 |  	4 | Stephen Fox
      	2 | 	SAP Reporting | 	3000 |	4.2 | Stephen Fox

(4 rows)
cqlsh:stud198> select * from project_details where project_id = 1;

 project_id | project_name  	| duration | rating | stud_name
------------+-------------------+----------+--------+-------------
      	1 | MS data migration |  	720 |	3.5 | David Sheen
      	1 | MS data warehouse | 	1440 |	3.9 | David Sheen

(2 rows)
cqlsh:stud198> alter table stud_info add hobbies set<text>;
cqlsh:stud198> update stud_info
       	... set hobbies = hobbies + {'Chess, Table Tennis'}
       	... where rno = 1;
cqlsh:stud198> select * from stud_info;

 rno | date_of_joining             	| hobbies             	| last_exam_percentage | stud_name
-----+---------------------------------+-------------------------+----------------------+----------------
   1 | 2012-02-28 18:30:00.000000+0000 | {'Chess, Table Tennis'} |             	69.6 |  Michael Storm
   4 | 2012-05-10 18:30:00.000000+0000 |                	null |             	73.4 | 	Ian String
   3 | 2014-04-11 18:30:00.000000+0000 |                	null |             	81.7 | David Flemming

(3 rows)
cqlsh:stud198> update stud_info set hobbies = hobbies + {'Music', 'Basketball'} where rno = 1;
cqlsh:stud198> select * from stud_info;

 rno | date_of_joining             	| hobbies                                    	| last_exam_percentage | stud_name
-----+---------------------------------+------------------------------------------------+----------------------+----------------
   1 | 2012-02-28 18:30:00.000000+0000 | {'Basketball', 'Chess, Table Tennis', 'Music'} |             	69.6 |  Michael Storm
   4 | 2012-05-10 18:30:00.000000+0000 |                                       	null |             	73.4 | 	Ian String
   3 | 2014-04-11 18:30:00.000000+0000 |                                       	null |             	81.7 | David Flemming

(3 rows)
cqlsh:stud198> alter table stud_info add language list<text>;
cqlsh:stud198> update stud_info
       	... set language = language + ['Hindi, English']
       	... where rno = 1;
cqlsh:stud198> select * from stud_info;

 rno | date_of_joining             	| hobbies                                    	| language       	| last_exam_percentage | stud_name
-----+---------------------------------+------------------------------------------------+--------------------+----------------------+----------------
   1 | 2012-02-28 18:30:00.000000+0000 | {'Basketball', 'Chess, Table Tennis', 'Music'} | ['Hindi, English'] |             	69.6 |  Michael Storm
   4 | 2012-05-10 18:30:00.000000+0000 |                                       	null |           	null |             	73.4 | 	Ian String
   3 | 2014-04-11 18:30:00.000000+0000 |                                       	null |           	null |             	81.7 | David Flemming

(3 rows)
cqlsh:stud198> create table users (
       	... user_id text primary key,
       	... first_name text,
       	... last_name text,
       	... emails set<text>
       	... );
cqlsh:stud198> insert into users (user_id, first_name, Last_name, emails)
       	... values ('AB','Albert','Baggins', {'a@baggins.com','baggins@gmail.com'});
cqlsh:stud198> select * from users;

 user_id | emails                             	| first_name | last_name
---------+----------------------------------------+------------+-----------
  	AB | {'a@baggins.com', 'baggins@gmail.com'} | 	Albert |   Baggins

(1 rows)
cqlsh:stud198> update users
       	... set emails = emails + {'ab@friendsofmordor.org}
       	... where user_id = 'AB';
       	...
       	...
cqlsh:stud198> set emails = emails + {'ab@friendsofmordor.org'} where user_id = 'AB';
SyntaxException: line 1:0 no viable alternative at input 'set' ([set]...)
cqlsh:stud198> update users
       	... set emails = emails + {'ab@friendsofmordor'}
       	... where user_id = 'AB';
cqlsh:stud198> select user_id, emails from users where user_id = 'AB';

 user_id | emails
---------+--------------------------------------------------------------
  	AB | {'a@baggins.com', 'ab@friendsofmordor', 'baggins@gmail.com'}

(1 rows)
cqlsh:stud198> update users set emails = emails - {'ab@friendsofmordor'} where user_id = 'AB';
cqlsh:stud198> select user_id, emails from users where user_id = 'AB';

 user_id | emails
---------+----------------------------------------
  	AB | {'a@baggins.com', 'baggins@gmail.com'}

(1 rows)
cqlsh:stud198> update users
       	... set emails = {}
       	... where user_id = 'AB';
cqlsh:stud198> select user_id, emails from users where user_id = 'AB';

 user_id | emails
---------+--------
  	AB |   null

(1 rows)
cqlsh:stud198> alter table users add top_places list<text>;
cqlsh:stud198> update users
       	... set top_places = ['Lonavla','Khandala']
       	... where user_id = 'AB';
cqlsh:stud198> select user_id, emails from users where user_id = 'AB';

 user_id | emails
---------+--------
  	AB |   null

(1 rows)
cqlsh:stud198> select * from users where user_id = 'AB';

 user_id | emails | first_name | last_name | top_places
---------+--------+------------+-----------+-------------------------
  	AB |   null | 	Albert |   Baggins | ['Lonavla', 'Khandala']

(1 rows)
cqlsh:stud198> update users
       	... set top_places = ['Mahabaleshwar'] + top_places
       	... where user_id = 'AB';
cqlsh:stud198> select * from users where user_id = 'AB';

 user_id | emails | first_name | last_name | top_places
---------+--------+------------+-----------+------------------------------------------
  	AB |   null | 	Albert |   Baggins | ['Mahabaleshwar', 'Lonavla', 'Khandala']

(1 rows)
cqlsh:stud198> update users
       	... set top_places = top_places + ['Tapola']
       	... where user_id = 'AB';
cqlsh:stud198> select * from users where user_id = 'AB';

 user_id | emails | first_name | last_name | top_places
---------+--------+------------+-----------+----------------------------------------------------
  	AB |   null | 	Albert |   Baggins | ['Mahabaleshwar', 'Lonavla', 'Khandala', 'Tapola']

(1 rows)
cqlsh:stud198> delete top_places[3]
       	... from users
       	... where user_id = 'AB';
cqlsh:stud198> select * from users where user_id = 'AB';

 user_id | emails | first_name | last_name | top_places
---------+--------+------------+-----------+------------------------------------------
  	AB |   null | 	Albert |   Baggins | ['Mahabaleshwar', 'Lonavla', 'Khandala']

(1 rows)
cqlsh:stud198> alter table users add todo map<timestamp, text>;
cqlsh:stud198> update users
       	... set todo =
       	... {'2014-09-24':'Cassandra Session',
       	... '2014-10-02 12:00':'MongoDB Session'}
       	... where user_id = 'AB';
cqlsh:stud198> select * from users where user_id = 'AB';

 user_id | emails | first_name | last_name | todo                                                                                                       	| top_places
---------+--------+------------+-----------+----------------------------------------------------------------------------------------------------------------+------------------------------------------
  	AB |   null | 	Albert |   Baggins | {'2014-09-23 18:30:00.000000+0000': 'Cassandra Session', '2014-10-02 06:30:00.000000+0000': 'MongoDB Session'} | ['Mahabaleshwar', 'Lonavla', 'Khandala']

(1 rows)
cqlsh:stud198> select user_id, todo from users where user_id = 'AB';

 user_id | todo
---------+----------------------------------------------------------------------------------------------------------------
  	AB | {'2014-09-23 18:30:00.000000+0000': 'Cassandra Session', '2014-10-02 06:30:00.000000+0000': 'MongoDB Session'}

(1 rows)
cqlsh:stud198> delete todo['2014-09-24']
       	... from users
       	... where user_id = 'AB';
cqlsh:stud198> select user_id, todo from users where user_id = 'AB';

 user_id | todo
---------+--------------------------------------------------------
  	AB | {'2014-10-02 06:30:00.000000+0000': 'MongoDB Session'}

(1 rows)
cqlsh:stud198> create table library_book(
       	... counter_value counter,
       	... book_name varchar,
       	... stud_name varcha,
       	... primary key(book_name, stud_name)
       	... );
InvalidRequest: Error from server: code=2200 [Invalid query] message="Unknown type stud198.varcha"
cqlsh:stud198> create table library_book( counter_value counter, book_name varchar, stud_name varchar, primary key(book_name, stud_name) );
cqlsh:stud198> update library_book
       	... set counter_value = counter_value +1
       	... where book_name = 'book1' and stud_name = 'jeet';
cqlsh:stud198> select * from library_book;

 book_name | stud_name | counter_value
-----------+-----------+---------------
 	book1 |  	jeet |         	1

(1 rows)
cqlsh:stud198> update library_book set counter_value = counter_value +1 where book_name = 'book1' and stud_name = 'shaan';
cqlsh:stud198> update library_book set counter_value = counter_value +1 where book_name = 'book1' and stud_name = 'jeet';
cqlsh:stud198> select * from library_book;

 book_name | stud_name | counter_value
-----------+-----------+---------------
 	book1 |  	jeet |         	2
 	book1 | 	shaan |         	1

(2 rows)
cqlsh:stud198> create table userlogin(
       	... userid int primary key,
       	... passwd text
       	... );
cqlsh:stud198> insert into userlogin (userid, passwd) values (1, 'infy') using ttl 20;
cqlsh:stud198> select * from userlogin;

 userid | passwd
--------+--------
  	1 |   infy

(1 rows)
cqlsh:stud198> select * from userlogin;

 userid | passwd
--------+--------
  	1 |   infy

(1 rows)
cqlsh:stud198> select * from userlogin;

 userid | passwd
--------+--------
  	1 |   infy

(1 rows)
cqlsh:stud198> select * from userlogin;

 userid | passwd
--------+--------
  	1 |   infy

(1 rows)
cqlsh:stud198> select * from userlogin;

 userid | passwd
--------+--------

(0 rows)
cqlsh:stud198> insert into userlogin (userid, passwd) values (1, 'infy') using ttl 30;
cqlsh:stud198> select ttl(passwd)
       	... from userlogin
       	... where userid = 1;

 ttl(passwd)
-------------
      	10

(1 rows)
cqlsh:stud198> select ttl(passwd) from userlogin where userid = 1;

 ttl(passwd)
-------------
       	8

(1 rows)
cqlsh:stud198> select ttl(passwd) from userlogin where userid = 1;

 ttl(passwd)
-------------
       	7

(1 rows)
cqlsh:stud198> select ttl(passwd) from userlogin where userid = 1;

 ttl(passwd)
-------------
       	6

(1 rows)
cqlsh:stud198> select ttl(passwd) from userlogin where userid = 1;

 ttl(passwd)
-------------
       	5

(1 rows)
cqlsh:stud198> select ttl(passwd) from userlogin where userid = 1;

 ttl(passwd)
-------------
       	4

(1 rows)
cqlsh:stud198> select ttl(passwd) from userlogin where userid = 1;

 ttl(passwd)
-------------
       	3

(1 rows)
cqlsh:stud198> select ttl(passwd) from userlogin where userid = 1;

 ttl(passwd)
-------------
       	3

(1 rows)
cqlsh:stud198> select ttl(passwd) from userlogin where userid = 1;

 ttl(passwd)
-------------
       	1

(1 rows)
cqlsh:stud198> select ttl(passwd) from userlogin where userid = 1;

 ttl(passwd)
-------------

(0 rows)
cqlsh:stud198> create table sample (
       	... sample_id text,
       	... sample_name text,
       	... primary key(sample_id)
       	... );
cqlsh:stud198> insert into sample(sample_id, sample_name) values ('s101', 'big data');
cqlsh:stud198> select * from sample;

 sample_id | sample_name
-----------+-------------
  	s101 |	big data

(1 rows)
cqlsh:stud198> alter table sample
       	... alter sample_id type int;
InvalidRequest: Error from server: code=2200 [Invalid query] message="Altering of types is not allowed"
cqlsh:stud198> alter table sample alter sample_id type varchar;
InvalidRequest: Error from server: code=2200 [Invalid query] message="Altering of types is not allowed"
cqlsh:stud198> alter table sample
       	... drop sample_id;
InvalidRequest: Error from server: code=2200 [Invalid query] message="Cannot drop PRIMARY KEY part sample_id"
cqlsh:stud198> alter table sample drop sample_name;
cqlsh:stud198> select * from sample;

 sample_id
-----------
  	s101

(1 rows)
cqlsh:stud198> drop columnfamily sample;
cqlsh:stud198> select * from sample;
InvalidRequest: Error from server: code=2200 [Invalid query] message="unconfigured table sample"
cqlsh:stud198> describe tables;

users  library_book  userlogin  stud_info  project_details

cqlsh:stud198> describe tables users;
Improper describe command.
cqlsh:stud198> describe table users;

CREATE TABLE stud198.users (
	user_id text PRIMARY KEY,
	emails set<text>,
	first_name text,
	last_name text,
	todo map<timestamp, text>,
	top_places list<text>
) WITH bloom_filter_fp_chance = 0.01
	AND caching = {'keys': 'ALL', 'rows_per_partition': 'NONE'}
	AND comment = ''
	AND compaction = {'class': 'org.apache.cassandra.db.compaction.SizeTieredCompactionStrategy', 'max_threshold': '32', 'min_threshold': '4'}
	AND compression = {'chunk_length_in_kb': '64', 'class': 'org.apache.cassandra.io.compress.LZ4Compressor'}
	AND crc_check_chance = 1.0
	AND dclocal_read_repair_chance = 0.1
	AND default_time_to_live = 0
	AND gc_grace_seconds = 864000
	AND max_index_interval = 2048
	AND memtable_flush_period_in_ms = 0
	AND min_index_interval = 128
	AND read_repair_chance = 0.0
	AND speculative_retry = '99PERCENTILE';

cqlsh:stud198> select * from users;

 user_id | emails | first_name | last_name | todo                                               	| top_places
---------+--------+------------+-----------+--------------------------------------------------------+------------------------------------------
  	AB |   null | 	Albert |   Baggins | {'2014-10-02 06:30:00.000000+0000': 'MongoDB Session'} | ['Mahabaleshwar', 'Lonavla', 'Khandala']

(1 rows)
cqlsh:stud198> copy users(user_id, emails, first_name, last_name, todo, top_places) to '~desktop/198.csv';
Using 3 child processes
Can't open '~desktop/198.csv' for writing: [Errno 2] No such file or directory: '~desktop/198.csv'
cqlsh:stud198> copy users(user_id, emails, first_name, last_name, todo, top_places) to '/home/bmscecse/Desktop/198.csv';
Using 3 child processes

Starting copy of stud198.users with columns [user_id, emails, first_name, last_name, todo, top_places].
Processed: 1 rows; Rate:   	4 rows/s; Avg. rate:   	4 rows/s
1 rows exported to 1 files in 0.242 seconds.
cqlsh:stud198>















bmsce@bmsce-Precision-T1700:~$ cd cassandra/apache-cassandra-3.11.0/bin
bmsce@bmsce-Precision-T1700:~/cassandra/apache-cassandra-3.11.0/bin$ ./cqlsh
Connected to Test Cluster at 127.0.0.1:9042.
[cqlsh 5.0.1 | Cassandra 3.11.4 | CQL spec 3.4.4 | Native protocol v4]
Use HELP for help.
cqlsh> describe keyspaces;

students       system_auth  students1  system_distributed  system_traces
system_schema  system       student    employee          

cqlsh> use students;
cqlsh:students> describe students;

CREATE KEYSPACE students WITH replication = {'class': 'SimpleStrategy', 'replication_factor': '1'}  AND durable_writes = true;

CREATE TABLE students.project (
    projectid int PRIMARY KEY,
    managername text,
    numberofstudents int,
    projectname text
) WITH bloom_filter_fp_chance = 0.01
    AND caching = {'keys': 'ALL', 'rows_per_partition': 'NONE'}
    AND comment = ''
    AND compaction = {'class': 'org.apache.cassandra.db.compaction.SizeTieredCompactionStrategy', 'max_threshold': '32', 'min_threshold': '4'}
    AND compression = {'chunk_length_in_kb': '64', 'class': 'org.apache.cassandra.io.compress.LZ4Compressor'}
    AND crc_check_chance = 1.0
    AND dclocal_read_repair_chance = 0.1
    AND default_time_to_live = 0
    AND gc_grace_seconds = 864000
    AND max_index_interval = 2048
    AND memtable_flush_period_in_ms = 0
    AND min_index_interval = 128
    AND read_repair_chance = 0.0
    AND speculative_retry = '99PERCENTILE';
CREATE INDEX project_projectname_idx ON students.project (projectname);
CREATE INDEX project_numberofstudents_idx ON students.project (numberofstudents);

CREATE TABLE students.studnet_info (
    rollno int PRIMARY KEY,
    dateofjoining timestamp,
    lastexampercent double,
    studname text
) WITH bloom_filter_fp_chance = 0.01
    AND caching = {'keys': 'ALL', 'rows_per_partition': 'NONE'}
    AND comment = ''
    AND compaction = {'class': 'org.apache.cassandra.db.compaction.SizeTieredCompactionStrategy', 'max_threshold': '32', 'min_threshold': '4'}
    AND compression = {'chunk_length_in_kb': '64', 'class': 'org.apache.cassandra.io.compress.LZ4Compressor'}
    AND crc_check_chance = 1.0
    AND dclocal_read_repair_chance = 0.1
    AND default_time_to_live = 0
    AND gc_grace_seconds = 864000
    AND max_index_interval = 2048
    AND memtable_flush_period_in_ms = 0
    AND min_index_interval = 128
    AND read_repair_chance = 0.0
    AND speculative_retry = '99PERCENTILE';

CREATE TABLE students.project_details (
    projectid int PRIMARY KEY,
    managername text,
    numberofstudents int,
    projectname text,
    title text
) WITH bloom_filter_fp_chance = 0.01
    AND caching = {'keys': 'ALL', 'rows_per_partition': 'NONE'}
    AND comment = ''
    AND compaction = {'class': 'org.apache.cassandra.db.compaction.SizeTieredCompactionStrategy', 'max_threshold': '32', 'min_threshold': '4'}
    AND compression = {'chunk_length_in_kb': '64', 'class': 'org.apache.cassandra.io.compress.LZ4Compressor'}
    AND crc_check_chance = 1.0
    AND dclocal_read_repair_chance = 0.1
    AND default_time_to_live = 0
    AND gc_grace_seconds = 864000
    AND max_index_interval = 2048
    AND memtable_flush_period_in_ms = 0
    AND min_index_interval = 128
    AND read_repair_chance = 0.0
    AND speculative_retry = '99PERCENTILE';

CREATE TABLE students.student_info (
    rollno int PRIMARY KEY,
    dateofjoining timestamp,
    lastexampercent double,
    studentname text
) WITH bloom_filter_fp_chance = 0.01
    AND caching = {'keys': 'ALL', 'rows_per_partition': 'NONE'}
    AND comment = ''
    AND compaction = {'class': 'org.apache.cassandra.db.compaction.SizeTieredCompactionStrategy', 'max_threshold': '32', 'min_threshold': '4'}
    AND compression = {'chunk_length_in_kb': '64', 'class': 'org.apache.cassandra.io.compress.LZ4Compressor'}
    AND crc_check_chance = 1.0
    AND dclocal_read_repair_chance = 0.1
    AND default_time_to_live = 0
    AND gc_grace_seconds = 864000
    AND max_index_interval = 2048
    AND memtable_flush_period_in_ms = 0
    AND min_index_interval = 128
    AND read_repair_chance = 0.0
    AND speculative_retry = '99PERCENTILE';
CREATE INDEX student_info_lastexampercent_idx ON students.student_info (lastexampercent);
CREATE INDEX student_info_studentname_idx ON students.student_info (studentname);

cqlsh:students> describe table student_info;

CREATE TABLE students.student_info (
    rollno int PRIMARY KEY,
    dateofjoining timestamp,
    lastexampercent double,
    studentname text
) WITH bloom_filter_fp_chance = 0.01
    AND caching = {'keys': 'ALL', 'rows_per_partition': 'NONE'}
    AND comment = ''
    AND compaction = {'class': 'org.apache.cassandra.db.compaction.SizeTieredCompactionStrategy', 'max_threshold': '32', 'min_threshold': '4'}
    AND compression = {'chunk_length_in_kb': '64', 'class': 'org.apache.cassandra.io.compress.LZ4Compressor'}
    AND crc_check_chance = 1.0
    AND dclocal_read_repair_chance = 0.1
    AND default_time_to_live = 0
    AND gc_grace_seconds = 864000
    AND max_index_interval = 2048
    AND memtable_flush_period_in_ms = 0
    AND min_index_interval = 128
    AND read_repair_chance = 0.0
    AND speculative_retry = '99PERCENTILE';
CREATE INDEX student_info_lastexampercent_idx ON students.student_info (lastexampercent);
CREATE INDEX student_info_studentname_idx ON students.student_info (studentname);

cqlsh:students> copy employees(employee_id, first_name, last_name, salary, hire_date) from '~desktop/employees.csv'
            ... 
            ... 
cqlsh:students> copy employees(employee_id, first_name, last_name, salary, hire_date) from '~desktop/employees.csv';
Column family 'employees' not found
cqlsh:students> select * from student_info;

 rollno | dateofjoining                   | lastexampercent | studentname
--------+---------------------------------+-----------------+--------------
      1 | 2018-02-01 18:30:00.000000+0000 |              95 | Amber Mishra
      2 | 2019-04-11 18:30:00.000000+0000 |            93.5 |  Aniruddh NS
      4 | 2018-06-20 18:30:00.000000+0000 |            97.5 |      Divyank
      3 | 2018-06-20 18:30:00.000000+0000 |            93.5 |   B Praneeth

(4 rows)
cqlsh:students> copy student_info from stdin;
Using 3 child processes

Starting copy of students.student_info with columns [rollno, dateofjoining, lastexampercent, studentname].
[Use . on a line by itself to end input]
[copy] Process FeedingProcess-4:

cqlsh:students> copy student_info(rollno, studentname) from stdin;
Using 3 child processes

Starting copy of students.student_info with columns [rollno, studentname].
[Use . on a line by itself to end input]
[copy] 4, Ishan
[copy] .

Processed: 1 rows; Rate:       0 rows/s; Avg. rate:       0 rows/s
1 rows imported from 1 files in 12.776 seconds (0 skipped).
cqlsh:students> select * from student_info;

 rollno | dateofjoining                   | lastexampercent | studentname
--------+---------------------------------+-----------------+--------------
      1 | 2018-02-01 18:30:00.000000+0000 |              95 | Amber Mishra
      2 | 2019-04-11 18:30:00.000000+0000 |            93.5 |  Aniruddh NS
      4 | 2018-06-20 18:30:00.000000+0000 |            97.5 |        Ishan
      3 | 2018-06-20 18:30:00.000000+0000 |            93.5 |   B Praneeth

(4 rows)
cqlsh:students> copy student_info(rollno, studentname) from stdin;
Using 3 child processes

Starting copy of students.student_info with columns [rollno, studentname].
[Use . on a line by itself to end input]
[copy] 5, Bruno
[copy] .

Processed: 1 rows; Rate:       0 rows/s; Avg. rate:       0 rows/s
1 rows imported from 1 files in 11.384 seconds (0 skipped).
cqlsh:students> select * from student_info;

 rollno | dateofjoining                   | lastexampercent | studentname
--------+---------------------------------+-----------------+--------------
      5 |                            null |            null |        Bruno
      1 | 2018-02-01 18:30:00.000000+0000 |              95 | Amber Mishra
      2 | 2019-04-11 18:30:00.000000+0000 |            93.5 |  Aniruddh NS
      4 | 2018-06-20 18:30:00.000000+0000 |            97.5 |        Ishan
      3 | 2018-06-20 18:30:00.000000+0000 |            93.5 |   B Praneeth

(5 rows)
cqlsh:students> copy student_info(rollno, studentname) to stdout;
1,Amber Mishra
2,Aniruddh NS
4, Ishan
3,B Praneeth
5, Bruno
cqlsh:students> describe keyspaces;

students       system_auth  students1  system_distributed  system_traces
system_schema  system       student    employee          

cqlsh:students> create keyspace university with replication={'class':SimpleStrategy, 'replication_factor':3};
SyntaxException: line 1:67 no viable alternative at input ',' (... university with replication={'class':[SimpleStrategy],...)
cqlsh:students> create keyspace University with replication={'class':SimpleStrategy, 'replication_factor':3};
SyntaxException: line 1:67 no viable alternative at input ',' (... University with replication={'class':[SimpleStrategy],...)
cqlsh:students> exit
bmsce@bmsce-Precision-T1700:~/cassandra/apache-cassandra-3.11.0/bin$ cqlsh
Connected to Test Cluster at 127.0.0.1:9042.
[cqlsh 5.0.1 | Cassandra 3.11.4 | CQL spec 3.4.4 | Native protocol v4]
Use HELP for help.
cqlsh> create keyspace University with replication={'class':SimpleStrategy, 'replication_factor':3};
SyntaxException: line 1:67 no viable alternative at input ',' (... University with replication={'class':[SimpleStrategy],...)
cqlsh> create keyspace University with replication={'class':SimpleStrategy, 'replication_factor':1};
SyntaxException: line 1:67 no viable alternative at input ',' (... University with replication={'class':[SimpleStrategy],...)
cqlsh> create keyspace university with replication = {
   ... 'class':'SimpleStrategy',
   ... 'replication_factor':3
   ... };
cqlsh> describe keyspaces;

students       system_auth  students1  system_distributed  system_traces
system_schema  system       student    employee            university   

cqlsh> use university;
cqlsh:university> create table student
              ... (
              ... rollno int,
              ... name text,
              ... dept text,
              ... primary key(rollno)
              ... );
cqlsh:university> select * from student;

 rollno | dept | name
--------+------+------

(0 rows)
cqlsh:university> alter table student
              ... add semester int;
cqlsh:university> select * from student;

 rollno | dept | name | semester
--------+------+------+----------

(0 rows)
cqlsh:university> describe table student;

CREATE TABLE university.student (
    rollno int PRIMARY KEY,
    dept text,
    name text,
    semester int
) WITH bloom_filter_fp_chance = 0.01
    AND caching = {'keys': 'ALL', 'rows_per_partition': 'NONE'}
    AND comment = ''
    AND compaction = {'class': 'org.apache.cassandra.db.compaction.SizeTieredCompactionStrategy', 'max_threshold': '32', 'min_threshold': '4'}
    AND compression = {'chunk_length_in_kb': '64', 'class': 'org.apache.cassandra.io.compress.LZ4Compressor'}
    AND crc_check_chance = 1.0
    AND dclocal_read_repair_chance = 0.1
    AND default_time_to_live = 0
    AND gc_grace_seconds = 864000
    AND max_index_interval = 2048
    AND memtable_flush_period_in_ms = 0
    AND min_index_interval = 128
    AND read_repair_chance = 0.0
    AND speculative_retry = '99PERCENTILE';

cqlsh:university> insert into student(rollno, name, dept, semester) values(18, 'Ishan', 'CSE', 6);
cqlsh:university> select * from student;

 rollno | dept | name  | semester
--------+------+-------+----------
     18 |  CSE | Ishan |        6

(1 rows)
cqlsh:university> update student
              ... set name='John'
              ... where rollno=18;
cqlsh:university> select * from student;

 rollno | dept | name | semester
--------+------+------+----------
     18 |  CSE | John |        6

(1 rows)
cqlsh:university> delete from student where rollno=18;
cqlsh:university> select * from student;

 rollno | dept | name | semester
--------+------+------+----------

(0 rows)
cqlsh:university> create index DeptIndex on student(dept);
cqlsh:university> select * from student where dept='CSE';

 rollno | dept | name | semester
--------+------+------+----------

(0 rows)
cqlsh:university> insert into student(rollno, name, dept, semester) values(18, 'Ishan', 'CSE', 6);
cqlsh:university> select * from student where dept='CSE';

 rollno | dept | name  | semester
--------+------+-------+----------
     18 |  CSE | Ishan |        6

(1 rows)
cqlsh:university> select * from student where dept='ISE';

 rollno | dept | name | semester
--------+------+------+----------

(0 rows)
cqlsh:university> drop index if exists DeptIndex;
cqlsh:university> create table teacher(
              ... id int primary key,
              ... name text,
              ... email varchar);
cqlsh:university> drop table teacher;
cqlsh:university> create table teacher( id int primary key, name text, email set<text>);
cqlsh:university> alter table teacher add coursenames list<text>;
cqlsh:university> insert into teacher(id, name, email, coursenames) values
              ... (1,'Hamilton',{'hamiltonyahoo.com},['Data Science']);
              ... 
              ... 
              ... 
cqlsh:university> (1,'Hamilton',{'hamiltonyahoo.com},['Data Science']);
              ... 
cqlsh:university> (1,'Hamilton',{'hamiltonyahoo.com'},['Data Science']);
SyntaxException: line 1:0 no viable alternative at input '(' ([(]...)
cqlsh:university> insert into teacher(id, name, email, coursenames) values
              ... (1,'Hamilton',{'hamiltonyahoo.com'},['Data Science']);
cqlsh:university> select * from teacher;

 id | coursenames      | email                 | name
----+------------------+-----------------------+----------
  1 | ['Data Science'] | {'hamiltonyahoo.com'} | Hamilton

(1 rows)
cqlsh:university> create table course(
              ... id int primary key,
              ... prereq map<text, text>
              ... );
cqlsh:university> insert into course(id, prereq) values (1, {'Data Science':'Database', 'Neural Network':'Artificial Intelligence'});
cqlsh:university> select * from course;

 id | prereq
----+---------------------------------------------------------------------------
  1 | {'Data Science': 'Database', 'Neural Network': 'Artificial Intelligence'}

(1 rows)
cqlsh:university> truncate student;
cqlsh:university> select * from student;

 rollno | dept | name | semester
--------+------+------+----------

(0 rows)
