-- MySQL dump 9.11
--
-- Host: localhost    Database: mysql
-- ------------------------------------------------------
-- Server version	4.0.22

--
-- Table structure for table `columns_priv`
--

CREATE TABLE columns_priv (
  Host char(60) binary NOT NULL default '',
  Db char(64) binary NOT NULL default '',
  User char(16) binary NOT NULL default '',
  Table_name char(64) binary NOT NULL default '',
  Column_name char(64) binary NOT NULL default '',
  Timestamp timestamp(14) NOT NULL,
  Column_priv set('Select','Insert','Update','References') NOT NULL default '',
  PRIMARY KEY  (Host,Db,User,Table_name,Column_name)
) TYPE=MyISAM COMMENT='Column privileges';

--
-- Dumping data for table `columns_priv`
--


--
-- Table structure for table `db`
--

CREATE TABLE db (
  Host char(60) binary NOT NULL default '',
  Db char(64) binary NOT NULL default '',
  User char(16) binary NOT NULL default '',
  Select_priv enum('N','Y') NOT NULL default 'N',
  Insert_priv enum('N','Y') NOT NULL default 'N',
  Update_priv enum('N','Y') NOT NULL default 'N',
  Delete_priv enum('N','Y') NOT NULL default 'N',
  Create_priv enum('N','Y') NOT NULL default 'N',
  Drop_priv enum('N','Y') NOT NULL default 'N',
  Grant_priv enum('N','Y') NOT NULL default 'N',
  References_priv enum('N','Y') NOT NULL default 'N',
  Index_priv enum('N','Y') NOT NULL default 'N',
  Alter_priv enum('N','Y') NOT NULL default 'N',
  Create_tmp_table_priv enum('N','Y') NOT NULL default 'N',
  Lock_tables_priv enum('N','Y') NOT NULL default 'N',
  PRIMARY KEY  (Host,Db,User),
  KEY User (User)
) TYPE=MyISAM COMMENT='Database privileges';

--
-- Dumping data for table `db`
--

INSERT INTO db VALUES ('%','test','','Y','Y','Y','Y','Y','Y','N','Y','Y','Y','Y','Y');
INSERT INTO db VALUES ('%','test\\_%','','Y','Y','Y','Y','Y','Y','N','Y','Y','Y','Y','Y');
INSERT INTO db VALUES ('localhost','horde','horde','Y','Y','Y','Y','Y','Y','N','Y','Y','Y','Y','Y');
INSERT INTO db VALUES ('localhost','dbmail','spamass','Y','Y','Y','Y','N','N','N','N','N','N','N','N');

--
-- Table structure for table `func`
--

CREATE TABLE func (
  name char(64) binary NOT NULL default '',
  ret tinyint(1) NOT NULL default '0',
  dl char(128) NOT NULL default '',
  type enum('function','aggregate') NOT NULL default 'function',
  PRIMARY KEY  (name)
) TYPE=MyISAM COMMENT='User defined functions';

--
-- Dumping data for table `func`
--


--
-- Table structure for table `host`
--

CREATE TABLE host (
  Host char(60) binary NOT NULL default '',
  Db char(64) binary NOT NULL default '',
  Select_priv enum('N','Y') NOT NULL default 'N',
  Insert_priv enum('N','Y') NOT NULL default 'N',
  Update_priv enum('N','Y') NOT NULL default 'N',
  Delete_priv enum('N','Y') NOT NULL default 'N',
  Create_priv enum('N','Y') NOT NULL default 'N',
  Drop_priv enum('N','Y') NOT NULL default 'N',
  Grant_priv enum('N','Y') NOT NULL default 'N',
  References_priv enum('N','Y') NOT NULL default 'N',
  Index_priv enum('N','Y') NOT NULL default 'N',
  Alter_priv enum('N','Y') NOT NULL default 'N',
  Create_tmp_table_priv enum('N','Y') NOT NULL default 'N',
  Lock_tables_priv enum('N','Y') NOT NULL default 'N',
  PRIMARY KEY  (Host,Db)
) TYPE=MyISAM COMMENT='Host privileges;  Merged with database privileges';

--
-- Dumping data for table `host`
--


--
-- Table structure for table `tables_priv`
--

CREATE TABLE tables_priv (
  Host char(60) binary NOT NULL default '',
  Db char(64) binary NOT NULL default '',
  User char(16) binary NOT NULL default '',
  Table_name char(64) binary NOT NULL default '',
  Grantor char(77) NOT NULL default '',
  Timestamp timestamp(14) NOT NULL,
  Table_priv set('Select','Insert','Update','Delete','Create','Drop','Grant','References','Index','Alter') NOT NULL default '',
  Column_priv set('Select','Insert','Update','References') NOT NULL default '',
  PRIMARY KEY  (Host,Db,User,Table_name),
  KEY Grantor (Grantor)
) TYPE=MyISAM COMMENT='Table privileges';

--
-- Dumping data for table `tables_priv`
--

INSERT INTO tables_priv VALUES ('localhost','horde','horde','horde_users','root@localhost',20040608164353,'Select,Insert,Update,Delete','');
INSERT INTO tables_priv VALUES ('localhost','horde','horde','horde_prefs','root@localhost',20040608164353,'Select,Insert,Update,Delete','');
INSERT INTO tables_priv VALUES ('localhost','horde','horde','horde_categories','root@localhost',20040608164353,'Select,Insert,Update,Delete','');
INSERT INTO tables_priv VALUES ('%','horde','horde','horde_vfs','root@localhost',20040608164436,'Select,Insert,Update,Delete','');
INSERT INTO tables_priv VALUES ('%','horde','horde','horde_sessionhandler','root@localhost',20040608164442,'Select,Insert,Update,Delete','');
INSERT INTO tables_priv VALUES ('%','horde','horde','mnemo_memos','root@localhost',20040608173633,'Select,Insert,Update,Delete','');
INSERT INTO tables_priv VALUES ('%','horde','hordemgr','nag_tasks','root@localhost',20040608173652,'Select,Insert,Update,Delete','');
INSERT INTO tables_priv VALUES ('%','horde','horde','turba_objects','root@localhost',20040608173728,'Select,Insert,Update,Delete','');
INSERT INTO tables_priv VALUES ('localhost','dbmail','spamass','userpref','root@localhost',20040707081206,'Select,Insert,Update,Delete','');
INSERT INTO tables_priv VALUES ('localhost','dbmail','qtrap','tblqtrap','root@localhost',20040707081253,'Select,Insert,Update,Delete','');
INSERT INTO tables_priv VALUES ('localhost','dbmail','spamass','awl','root@localhost',20040624190055,'Select,Insert,Update,Delete','');
INSERT INTO tables_priv VALUES ('localhost','dbmail','spamass','bayes_%','root@localhost',20040624190055,'Select,Insert,Update,Delete','');

--
-- Table structure for table `user`
--

CREATE TABLE user (
  Host varchar(60) binary NOT NULL default '',
  User varchar(16) binary NOT NULL default '',
  Password varchar(16) binary NOT NULL default '',
  Select_priv enum('N','Y') NOT NULL default 'N',
  Insert_priv enum('N','Y') NOT NULL default 'N',
  Update_priv enum('N','Y') NOT NULL default 'N',
  Delete_priv enum('N','Y') NOT NULL default 'N',
  Create_priv enum('N','Y') NOT NULL default 'N',
  Drop_priv enum('N','Y') NOT NULL default 'N',
  Reload_priv enum('N','Y') NOT NULL default 'N',
  Shutdown_priv enum('N','Y') NOT NULL default 'N',
  Process_priv enum('N','Y') NOT NULL default 'N',
  File_priv enum('N','Y') NOT NULL default 'N',
  Grant_priv enum('N','Y') NOT NULL default 'N',
  References_priv enum('N','Y') NOT NULL default 'N',
  Index_priv enum('N','Y') NOT NULL default 'N',
  Alter_priv enum('N','Y') NOT NULL default 'N',
  Show_db_priv enum('N','Y') NOT NULL default 'N',
  Super_priv enum('N','Y') NOT NULL default 'N',
  Create_tmp_table_priv enum('N','Y') NOT NULL default 'N',
  Lock_tables_priv enum('N','Y') NOT NULL default 'N',
  Execute_priv enum('N','Y') NOT NULL default 'N',
  Repl_slave_priv enum('N','Y') NOT NULL default 'N',
  Repl_client_priv enum('N','Y') NOT NULL default 'N',
  ssl_type enum('','ANY','X509','SPECIFIED') NOT NULL default '',
  ssl_cipher blob NOT NULL,
  x509_issuer blob NOT NULL,
  x509_subject blob NOT NULL,
  max_questions int(11) unsigned NOT NULL default '0',
  max_updates int(11) unsigned NOT NULL default '0',
  max_connections int(11) unsigned NOT NULL default '0',
  PRIMARY KEY  (Host,User)
) TYPE=MyISAM COMMENT='Users and global privileges';

--
-- Dumping data for table `user`
--

INSERT INTO user VALUES ('localhost','root','','Y','Y','Y','Y','Y','Y','Y','Y','Y','Y','Y','Y','Y','Y','Y','Y','Y','Y','Y','Y','Y','','','','',0,0,0);
INSERT INTO user VALUES ('spross.lxcdm.lu','root','','Y','Y','Y','Y','Y','Y','Y','Y','Y','Y','Y','Y','Y','Y','Y','Y','Y','Y','Y','Y','Y','','','','',0,0,0);
INSERT INTO user VALUES ('localhost','','','N','N','N','N','N','N','N','N','N','N','N','N','N','N','N','N','N','N','N','N','N','','','','',0,0,0);
INSERT INTO user VALUES ('spross.lxcdm.lu','','','N','N','N','N','N','N','N','N','N','N','N','N','N','N','N','N','N','N','N','N','N','','','','',0,0,0);
INSERT INTO user VALUES ('localhost','horde','55dbb6fb5b2b64fc','N','N','N','N','N','N','N','N','N','N','N','N','N','N','N','N','N','N','N','N','N','','','','',0,0,0);
INSERT INTO user VALUES ('%','horde','','N','N','N','N','N','N','N','N','N','N','N','N','N','N','N','N','N','N','N','N','N','','','','',0,0,0);
INSERT INTO user VALUES ('%','hordemgr','','N','N','N','N','N','N','N','N','N','N','N','N','N','N','N','N','N','N','N','N','N','','','','',0,0,0);
INSERT INTO user VALUES ('localhost','spamass','0022c8065bb03956','N','N','N','N','N','N','N','N','N','N','N','N','N','N','N','N','N','N','N','N','N','','','','',0,0,0);
INSERT INTO user VALUES ('localhost','qtrap','712a55fa3cb13658','N','N','N','N','N','N','N','N','N','N','N','N','N','N','N','N','N','N','N','N','N','','','','',0,0,0);

