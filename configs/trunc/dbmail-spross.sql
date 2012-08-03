-- MySQL dump 9.11
--
-- Host: localhost    Database: dbmail
-- ------------------------------------------------------
-- Server version	4.0.22

--
-- Table structure for table `awl`
--

CREATE TABLE awl (
  username varchar(100) NOT NULL default '',
  email varchar(200) NOT NULL default '',
  ip varchar(10) NOT NULL default '',
  count int(11) default '0',
  totscore float default '0',
  PRIMARY KEY  (username,email,ip)
) TYPE=MyISAM;

--
-- Dumping data for table `awl`
--


--
-- Table structure for table `bayes_expire`
--

CREATE TABLE bayes_expire (
  id int(11) NOT NULL default '0',
  runtime int(11) NOT NULL default '0',
  KEY bayes_expire_idx1 (id)
) TYPE=MyISAM;

--
-- Dumping data for table `bayes_expire`
--


--
-- Table structure for table `bayes_global_vars`
--

CREATE TABLE bayes_global_vars (
  variable varchar(30) NOT NULL default '',
  value varchar(200) NOT NULL default '',
  PRIMARY KEY  (variable)
) TYPE=MyISAM;

--
-- Dumping data for table `bayes_global_vars`
--

INSERT INTO bayes_global_vars VALUES ('VERSION','3');

--
-- Table structure for table `bayes_seen`
--

CREATE TABLE bayes_seen (
  id int(11) NOT NULL default '0',
  msgid varchar(200) binary NOT NULL default '',
  flag char(1) NOT NULL default '',
  PRIMARY KEY  (id,msgid)
) TYPE=MyISAM;

--
-- Dumping data for table `bayes_seen`
--


--
-- Table structure for table `bayes_token`
--

CREATE TABLE bayes_token (
  id int(11) NOT NULL default '0',
  token char(5) NOT NULL default '',
  spam_count int(11) NOT NULL default '0',
  ham_count int(11) NOT NULL default '0',
  atime int(11) NOT NULL default '0',
  PRIMARY KEY  (id,token)
) TYPE=MyISAM;

--
-- Dumping data for table `bayes_token`
--


--
-- Table structure for table `bayes_vars`
--

CREATE TABLE bayes_vars (
  id int(11) NOT NULL auto_increment,
  username varchar(200) NOT NULL default '',
  spam_count int(11) NOT NULL default '0',
  ham_count int(11) NOT NULL default '0',
  token_count int(11) NOT NULL default '0',
  last_expire int(11) NOT NULL default '0',
  last_atime_delta int(11) NOT NULL default '0',
  last_expire_reduce int(11) NOT NULL default '0',
  oldest_token_age int(11) NOT NULL default '2147483647',
  newest_token_age int(11) NOT NULL default '0',
  PRIMARY KEY  (id),
  UNIQUE KEY bayes_vars_idx1 (username)
) TYPE=MyISAM;

--
-- Dumping data for table `bayes_vars`
--


--
-- Table structure for table `tblqtrap`
--

CREATE TABLE tblqtrap (
  idqtrap int(10) unsigned NOT NULL auto_increment,
  dtkeyword tinytext,
  dtactive tinyint(3) unsigned default NULL,
  PRIMARY KEY  (idqtrap)
) TYPE=MyISAM;

--
-- Dumping data for table `tblqtrap`
--

INSERT INTO tblqtrap VALUES (1,'porn',1);
INSERT INTO tblqtrap VALUES (2,'PORN',1);
INSERT INTO tblqtrap VALUES (3,'Sex',1);
INSERT INTO tblqtrap VALUES (4,'SEX',1);
INSERT INTO tblqtrap VALUES (5,'Libanesen',1);
INSERT INTO tblqtrap VALUES (6,'Tuerken',1);
INSERT INTO tblqtrap VALUES (7,'weltfremd',1);
INSERT INTO tblqtrap VALUES (8,'Auslaender',1);
INSERT INTO tblqtrap VALUES (9,'Moschee',1);
INSERT INTO tblqtrap VALUES (10,'Gesundheitswesen',1);
INSERT INTO tblqtrap VALUES (11,'Xanax',1);
INSERT INTO tblqtrap VALUES (12,'biracial',1);
INSERT INTO tblqtrap VALUES (13,'Hydrocodone',1);
INSERT INTO tblqtrap VALUES (14,'Voelkerwanderung',1);
INSERT INTO tblqtrap VALUES (27,'Xa*nax',1);
INSERT INTO tblqtrap VALUES (16,'Wahrheit',1);
INSERT INTO tblqtrap VALUES (17,'Zuwanderungsgesetz',1);
INSERT INTO tblqtrap VALUES (18,'SEXUALLY-EXPLICIT',0);
INSERT INTO tblqtrap VALUES (25,'Freizuegigkeit',1);
INSERT INTO tblqtrap VALUES (26,'Va*lium',1);
INSERT INTO tblqtrap VALUES (28,'cial*is',1);
INSERT INTO tblqtrap VALUES (29,'Vi*agra',1);
INSERT INTO tblqtrap VALUES (30,'lev*itra',1);
INSERT INTO tblqtrap VALUES (31,'0nline!',1);
INSERT INTO tblqtrap VALUES (32,'pr*escribed',1);
INSERT INTO tblqtrap VALUES (33,'Di*et',1);
INSERT INTO tblqtrap VALUES (34,'Pi*lls',1);
INSERT INTO tblqtrap VALUES (35,'Bundesrepublik',1);
INSERT INTO tblqtrap VALUES (36,'Augen',1);
INSERT INTO tblqtrap VALUES (38,'SEXUALLY',1);
INSERT INTO tblqtrap VALUES (40,'CIALIS',1);
INSERT INTO tblqtrap VALUES (41,'cialapren',1);
INSERT INTO tblqtrap VALUES (42,'Cialis',1);
INSERT INTO tblqtrap VALUES (43,'XANAX',1);
INSERT INTO tblqtrap VALUES (44,'vicodin',1);
INSERT INTO tblqtrap VALUES (45,'Vcod1n',1);
INSERT INTO tblqtrap VALUES (46,'A:d:v:',1);
INSERT INTO tblqtrap VALUES (47,'Sploogefest',1);

--
-- Table structure for table `userpref`
--

CREATE TABLE userpref (
  username varchar(100) NOT NULL default '',
  preference varchar(30) NOT NULL default '',
  value varchar(100) NOT NULL default '',
  prefid int(11) NOT NULL auto_increment,
  PRIMARY KEY  (prefid),
  KEY username (username)
) TYPE=MyISAM;

--
-- Dumping data for table `userpref`
--


