-- Look in geosource schema
set search_path = 'geosource';


-- Backup the settings and recreate the settings table
CREATE TABLE SettingsBackup AS SELECT * FROM Settings;

CREATE TABLE HarvesterSettings(
    id        int            not null,
    parentid  int,
    name      varchar(64)    not null,
    value     text,
    primary key(id),
    foreign key(parentId) references HarvesterSettings(id)
  );

INSERT INTO HarvesterSettings VALUES  (1,NULL,'harvesting',NULL);
-- Copy all harvester's root nodes config
INSERT INTO HarvesterSettings SELECT id, 1, name, value FROM Settings WHERE parentId = 2;
-- Copy all harvester's properties (Greater than last 2.10.1 settings ie. keepMarkedElement)
INSERT INTO HarvesterSettings SELECT * FROM Settings WHERE id > 958 AND parentId > 2;
-- Drop harvester config from Settings table

DROP TABLE Settings;

CREATE TABLE settings (
  name character varying(512) NOT NULL,
  value text,
  datatype integer,
  "position" integer,
  internal character varying(1),
  CONSTRAINT settings_pkey PRIMARY KEY (name)
);




-- ## To 2.9.0
-- Support multiple profiles per user
ALTER TABLE usergroups ADD profile varchar(32);
UPDATE usergroups SET profile = (SELECT profile from users WHERE id = userid);
ALTER TABLE usergroups DROP CONSTRAINT usergroups_pkey;
ALTER TABLE usergroups ADD PRIMARY KEY (userid, profile, groupid);

ALTER TABLE Metadata ALTER harvestUri TYPE varchar(512);

ALTER TABLE HarvestHistory ADD elapsedTime int;

CREATE TABLE Services (
    id         int,
    name       varchar(64)   not null,
    class       varchar(1048)   not null,
    description       varchar(1048),
    primary key(id)
  );

CREATE TABLE ServiceParameters(
    id         int,
    service         int,
    name       varchar(64)   not null,
    value       varchar(1048)   not null,
    primary key(id),
    foreign key(service) references Services(id)
  );



-- ## To 2.10.0
UPDATE UserGroups SET profile = 'RegisteredUser' WHERE profile IS null;

-- ## To 2.11.0
-- Creates New tables required for this version


CREATE TABLE Address(
    id              int             not null,
    address       varchar(128),
    city          varchar(128),
    state         varchar(32),
    zip           varchar(16),
    country       varchar(128),
    primary key(id)
);


CREATE TABLE UserAddress
(
    userid     int not null,
    addressid int not null,
    primary key(userid,addressid),
    foreign key(userid) references Users(id),
    foreign key(addressid) references Address(id)
);

CREATE TABLE Email
(
    user_id              int             not null,
    email         varchar(128),

    primary key(user_id),
    foreign key(user_id) references Users(id)
);



-- Update Requests column type (integer > boolean)
ALTER TABLE Requests ADD COLUMN autogeneratedtemp boolean;
UPDATE Requests SET autogeneratedtemp = false;
UPDATE Requests SET autogeneratedtemp = true WHERE autogenerated = 1;
ALTER TABLE Requests DROP COLUMN autogenerated;
ALTER TABLE Requests ADD COLUMN autogenerated boolean;
UPDATE Requests SET autogeneratedtemp = autogenerated;
ALTER TABLE Requests DROP COLUMN autogeneratedtemp;

ALTER TABLE Requests ADD COLUMN simpletemp boolean;
UPDATE Requests SET simpletemp = false;
UPDATE Requests SET simpletemp = true WHERE simple = 1;
ALTER TABLE Requests DROP COLUMN simple;
ALTER TABLE Requests ADD COLUMN simple boolean;
UPDATE Requests SET simpletemp = simple;
ALTER TABLE Requests DROP COLUMN simpletemp;

ALTER TABLE Requests ALTER COLUMN query TYPE text;
ALTER TABLE Requests ALTER COLUMN type TYPE text;
ALTER TABLE Requests ALTER COLUMN spatialfilter TYPE text;


--Inserts new data and modifies data
ALTER TABLE operations DROP COLUMN reserved;
--ALTER TABLE services DROP COLUMN id;

ALTER TABLE StatusValues ADD displayorder int;

UPDATE StatusValues SET displayorder = 0 WHERE id = 0;
UPDATE StatusValues SET displayorder = 1 WHERE id = 1;
UPDATE StatusValues SET displayorder = 3 WHERE id = 2;
UPDATE StatusValues SET displayorder = 5 WHERE id = 3;
UPDATE StatusValues SET displayorder = 2 WHERE id = 4;
UPDATE StatusValues SET displayorder = 4 WHERE id = 5;

-- Populate new tables from Users
INSERT INTO Address (SELECT id, address, city, state, zip, country FROM Users);
INSERT INTO UserAddress (SELECT id, id FROM Users);
INSERT INTO Email (SELECT id, email FROM Users);

CREATE SEQUENCE HIBERNATE_SEQUENCE START WITH 4000 INCREMENT BY 1;
ALTER TABLE ServiceParameters DROP COLUMN id;

-- Create temporary tables used when modifying a column type

-- Convert Profile column to the profile enumeration ordinal

CREATE TABLE USERGROUPS_TMP
(
   USERID int NOT NULL,
   GROUPID int NOT NULL,
   PROFILE int NOT NULL
);


-- Convert Profile column to the profile enumeration ordinal

CREATE TABLE USERS_TMP
  (
    id            int         ,
    username      varchar(256),
    password      varchar(120),
    surname       varchar(32),
    name          varchar(32),
    profile       int,
    organisation  varchar(128),
    kind          varchar(16),
    security      varchar(128),
    authtype      varchar(32),

    primary key(id),
    unique(username)
  );

-- ----  Change notifier actions column to map to the MetadataNotificationAction enumeration

CREATE TABLE MetadataNotifications_Tmp
  (
    metadataId         int            not null,
    notifierId         int            not null,
    notified           char(1)        default 'n' not null,
    metadataUuid       varchar(250)   not null,
    action             char(1)        not null,
    errormsg           text
  );


-- ----  Change params querytype column to map to the LuceneQueryParamType enumeration

CREATE TABLE Params_TEMP
  (
    id          int           not null,
    requestId   int,
    queryType   int,
    termField   varchar(128),
    termText    varchar(128),
    similarity  float,
    lowerText   varchar(128),
    upperText   varchar(128),
    inclusive   char(1)
);


-- Copy data from a table that needs a column migrated to an enum to a temporary table

-- Update UserGroups profiles to be one of the enumerated profiles
INSERT INTO USERGROUPS_TMP (userid, groupid, profile) SELECT userid, groupid, 0 FROM USERGROUPS where profile='Administrator';
INSERT INTO USERGROUPS_TMP (userid, groupid, profile) SELECT userid, groupid, 1 FROM USERGROUPS where profile='UserAdmin';
INSERT INTO USERGROUPS_TMP (userid, groupid, profile) SELECT userid, groupid, 2 FROM USERGROUPS where profile='Reviewer';
INSERT INTO USERGROUPS_TMP (userid, groupid, profile) SELECT userid, groupid, 3 FROM USERGROUPS where profile='Editor';
INSERT INTO USERGROUPS_TMP (userid, groupid, profile) SELECT userid, groupid, 4 FROM USERGROUPS where profile='RegisteredUser';
INSERT INTO USERGROUPS_TMP (userid, groupid, profile) SELECT userid, groupid, 5 FROM USERGROUPS where profile='Guest';
INSERT INTO USERGROUPS_TMP (userid, groupid, profile) SELECT userid, groupid, 6 FROM USERGROUPS where profile='Monitor';

-- Convert Profile column to the profile enumeration ordinal
-- create address and email tables to allow multiple per user

INSERT INTO USERS_TMP SELECT id, username, password, surname, name, 0, organisation, kind, security, authtype FROM USERS where profile='Administrator';
INSERT INTO USERS_TMP SELECT id, username, password, surname, name, 1, organisation, kind, security, authtype FROM USERS where profile='UserAdmin';
INSERT INTO USERS_TMP SELECT id, username, password, surname, name, 2, organisation, kind, security, authtype FROM USERS where profile='Reviewer';
INSERT INTO USERS_TMP SELECT id, username, password, surname, name, 3, organisation, kind, security, authtype FROM USERS where profile='Editor';
INSERT INTO USERS_TMP SELECT id, username, password, surname, name, 4, organisation, kind, security, authtype FROM USERS where profile='RegisteredUser';
INSERT INTO USERS_TMP SELECT id, username, password, surname, name, 5, organisation, kind, security, authtype FROM USERS where profile='Guest';
INSERT INTO USERS_TMP SELECT id, username, password, surname, name, 6, organisation, kind, security, authtype FROM USERS where profile='Monitor';
INSERT INTO USERS_TMP SELECT id, username, password, surname, name, 4, organisation, kind, security, authtype FROM USERS where profile='Developer';
INSERT INTO USERS_TMP SELECT id, username, password, surname, name, 4, organisation, kind, security, authtype FROM USERS where profile='';

-- ----  Change notifier actions column to map to the MetadataNotificationAction enumeration

INSERT INTO MetadataNotifications_Tmp SELECT metadataId, notifierId, notified, metadataUuid, 0, errormsg FROM MetadataNotifications where action='u';
INSERT INTO MetadataNotifications_Tmp SELECT metadataId, notifierId, notified, metadataUuid, 1, errormsg FROM MetadataNotifications where action='d';

-- ----  Change params querytype column to map to the LuceneQueryParamType enumeration

INSERT INTO Params_TEMP SELECT id, requestId, 0, termField, termText, similarity, lowerText, upperText, inclusive FROM Params where querytype='BOOLEAN_QUERY';
INSERT INTO Params_TEMP SELECT id, requestId, 1, termField, termText, similarity, lowerText, upperText, inclusive FROM Params where querytype='TERM_QUERY';
INSERT INTO Params_TEMP SELECT id, requestId, 2, termField, termText, similarity, lowerText, upperText, inclusive FROM Params where querytype='FUZZY_QUERY';
INSERT INTO Params_TEMP SELECT id, requestId, 3, termField, termText, similarity, lowerText, upperText, inclusive FROM Params where querytype='PREFIX_QUERY';
INSERT INTO Params_TEMP SELECT id, requestId, 4, termField, termText, similarity, lowerText, upperText, inclusive FROM Params where querytype='MATCH_ALL_DOCS_QUERY';
INSERT INTO Params_TEMP SELECT id, requestId, 5, termField, termText, similarity, lowerText, upperText, inclusive FROM Params where querytype='WILDCARD_QUERY';
INSERT INTO Params_TEMP SELECT id, requestId, 6, termField, termText, similarity, lowerText, upperText, inclusive FROM Params where querytype='PHRASE_QUERY';
INSERT INTO Params_TEMP SELECT id, requestId, 7, termField, termText, similarity, lowerText, upperText, inclusive FROM Params where querytype='RANGE_QUERY';
INSERT INTO Params_TEMP SELECT id, requestId, 8, termField, termText, similarity, lowerText, upperText, inclusive FROM Params where querytype='NUMERIC_RANGE_QUERY';


-- Drop the old tables (that are being migrated to an enum) and create them again with new definition

-- Update UserGroups profiles to be one of the enumerated profiles

DROP TABLE USERGROUPS;
CREATE TABLE USERGROUPS
  (
    userId   int          not null,
    groupId  int          not null,
    profile  int          not null,

    primary key(userId,groupId,profile),

    foreign key(userId) references Users(id),
    foreign key(groupId) references Groups(id)
  );
-- Update UserGroups profiles to be one of the enumerated profiles

INSERT INTO USERGROUPS SELECT * FROM USERGROUPS_TMP;
DROP TABLE USERGROUPS_TMP;


-- Convert Profile column to the profile enumeration ordinal

ALTER TABLE metadata DROP CONSTRAINT IF EXISTS metadata_owner_fkey;
ALTER TABLE metadatastatus DROP CONSTRAINT IF EXISTS metadatastatus_userid_fkey;
ALTER TABLE useraddress DROP CONSTRAINT IF EXISTS useraddress_userid_fkey;
ALTER TABLE email DROP CONSTRAINT IF EXISTS email_user_id_fkey;
ALTER TABLE groups DROP CONSTRAINT IF EXISTS groups_referrer_fkey;
ALTER TABLE usergroups DROP CONSTRAINT IF EXISTS usergroups_userid_fkey;
DROP TABLE Users;
CREATE TABLE Users
  (
    id            int           not null,
    username      varchar(256)  not null,
    password      varchar(120)  not null,
    surname       varchar(32),
    name          varchar(32),
    profile       int not null,
    organisation  varchar(128),
    kind          varchar(16),
    security      varchar(128)  default '',
    authtype      varchar(32),
    primary key(id),
    unique(username)
  );


-- Convert Profile column to the profile enumeration ordinal

INSERT INTO USERS SELECT * FROM USERS_TMP;
DROP TABLE USERS_TMP;


ALTER TABLE metadata ADD CONSTRAINT metadata_owner_fkey FOREIGN KEY (owner)
      REFERENCES users (id);
ALTER TABLE metadatastatus ADD CONSTRAINT metadatastatus_userid_fkey FOREIGN KEY (userid)
      REFERENCES users (id);
ALTER TABLE useraddress ADD CONSTRAINT useraddress_userid_fkey FOREIGN KEY (userid)
      REFERENCES users (id);
ALTER TABLE email ADD CONSTRAINT email_user_id_fkey FOREIGN KEY (user_id)
      REFERENCES users (id);
ALTER TABLE groups ADD CONSTRAINT groups_referrer_fkey FOREIGN KEY (referrer)
      REFERENCES users (id);


-- ----  Change notifier actions column to map to the MetadataNotificationAction enumeration

DROP TABLE MetadataNotifications;
CREATE TABLE MetadataNotifications
  (
    metadataId         int            not null,
    notifierId         int            not null,
    notified           char(1)        default 'n' not null,
    metadataUuid       varchar(250)   not null,
    action             int        not null,
    errormsg           text,
    primary key(metadataId,notifierId)
  );

-- ----  Change notifier actions column to map to the MetadataNotificationAction enumeration

-- INSERT INTO MetadataNotifications SELECT * FROM MetadataNotifications_Tmp;
-- DROP TABLE MetadataNotifications_Tmp;

-- ----  Change params querytype column to map to the LuceneQueryParamType enumeration

DROP TABLE Params;

CREATE TABLE Params
  (
    id          int           not null,
    requestId   int,
    queryType   int,
    termField   varchar(128),
    termText    varchar(128),
    similarity  float,
    lowerText   varchar(128),
    upperText   varchar(128),
    inclusive   char(1),
    primary key(id),
    foreign key(requestId) references Requests(id)
  );

-- ----  Change params querytype column to map to the LuceneQueryParamType enumeration

INSERT INTO Params SELECT * FROM Params_TEMP;
DROP TABLE Params_TEMP;

CREATE INDEX ParamsNDX1 ON Params(requestId);
CREATE INDEX ParamsNDX2 ON Params(queryType);
CREATE INDEX ParamsNDX3 ON Params(termField);
CREATE INDEX ParamsNDX4 ON Params(termText);


UPDATE metadata SET displayorder = 0 WHERE displayorder IS NULL;


-- ## To 2.11.1
-- ## To 3.0.0

ALTER TABLE ServiceParameters ADD COLUMN occur varchar(1) default '+';
UPDATE ServiceParameters SET occur='+';

create sequence serviceparameter_id_seq start with 1 increment by 1;
alter table serviceparameters add column id integer;
UPDATE serviceparameters SET ID = nextval('serviceparameter_id_seq');

ALTER TABLE ServiceParameters DROP CONSTRAINT IF EXISTS serviceparameters_service_fkey;
ALTER TABLE ServiceParameters DROP CONSTRAINT IF EXISTS serviceparameters_pkey;
ALTER TABLE SERVICEPARAMETERS ADD PRIMARY KEY (id);


CREATE TABLE schematron
(
  id integer NOT NULL,
  displaypriority integer NOT NULL,
  filename character varying(255) NOT NULL,
  schemaname character varying(255) NOT NULL,
  CONSTRAINT schematron_pkey PRIMARY KEY (id),
  CONSTRAINT uk_k7c29i3x0x6p5hbvb0qsdmuek UNIQUE (schemaname, filename)
);


-- Insert settings


INSERT INTO Settings (name, value, datatype, position, internal) VALUES ('system/site/name', 'Mon GéoSource', 0, 110, 'n');
INSERT INTO Settings (name, value, datatype, position, internal) VALUES ('system/site/siteId', '', 0, 120, 'n');

INSERT INTO Settings (name, value, datatype, position, internal) VALUES ('system/site/organization', 'Mon organisation', 0, 130, 'n');
INSERT INTO Settings (name, value, datatype, position, internal) VALUES ('system/platform/version', '3.0.1', 0, 150, 'n');
INSERT INTO Settings (name, value, datatype, position, internal) VALUES ('system/platform/subVersion', '0', 0, 160, 'n');
INSERT INTO Settings (name, value, datatype, position, internal) VALUES ('system/site/svnUuid', '', 0, 170, 'y');
INSERT INTO Settings (name, value, datatype, position, internal) VALUES ('system/server/host', 'localhost', 0, 210, 'n');
INSERT INTO Settings (name, value, datatype, position, internal) VALUES ('system/server/protocol', 'http', 0, 220, 'n');
INSERT INTO Settings (name, value, datatype, position, internal) VALUES ('system/server/port', '8080', 1, 230, 'n');
INSERT INTO Settings (name, value, datatype, position, internal) VALUES ('system/server/securePort', '8443', 1, 240, 'y');
INSERT INTO settings (name, value, datatype, position, internal) VALUES ('system/server/log','log4j.xml',0,250,'y');
INSERT INTO Settings (name, value, datatype, position, internal) VALUES ('system/intranet/network', '127.0.0.1', 0, 310, 'y');
INSERT INTO Settings (name, value, datatype, position, internal) VALUES ('system/intranet/netmask', '255.0.0.0', 0, 320, 'y');
INSERT INTO Settings (name, value, datatype, position, internal) VALUES ('system/z3950/enable', 'true', 2, 410, 'y');
INSERT INTO Settings (name, value, datatype, position, internal) VALUES ('system/z3950/port', '2100', 1, 420, 'y');
INSERT INTO Settings (name, value, datatype, position, internal) VALUES ('system/proxy/use', 'false', 2, 510, 'y');
INSERT INTO Settings (name, value, datatype, position, internal) VALUES ('system/proxy/host', NULL, 0, 520, 'y');
INSERT INTO Settings (name, value, datatype, position, internal) VALUES ('system/proxy/port', NULL, 1, 530, 'y');
INSERT INTO Settings (name, value, datatype, position, internal) VALUES ('system/proxy/username', NULL, 0, 540, 'y');
INSERT INTO Settings (name, value, datatype, position, internal) VALUES ('system/proxy/password', NULL, 0, 550, 'y');
INSERT INTO Settings (name, value, datatype, position, internal) VALUES ('system/proxy/ignorehostlist', NULL, 0, 560, 'y');
INSERT INTO Settings (name, value, datatype, position, internal) VALUES ('system/feedback/email', 'root@localhost', 0, 610, 'y');
INSERT INTO Settings (name, value, datatype, position, internal) VALUES ('system/feedback/mailServer/host', '', 0, 630, 'y');
INSERT INTO Settings (name, value, datatype, position, internal) VALUES ('system/feedback/mailServer/port', '25', 1, 640, 'y');
INSERT INTO Settings (name, value, datatype, position, internal) VALUES ('system/feedback/mailServer/username', '', 0, 642, 'y');
INSERT INTO Settings (name, value, datatype, position, internal) VALUES ('system/feedback/mailServer/password', '', 0, 643, 'y');
INSERT INTO Settings (name, value, datatype, position, internal) VALUES ('system/feedback/mailServer/ssl', 'false', 2, 641, 'y');
INSERT INTO Settings (name, value, datatype, position, internal) VALUES ('system/removedMetadata/dir', 'WEB-INF/data/removed', 0, 710, 'y');
INSERT INTO Settings (name, value, datatype, position, internal) VALUES ('system/selectionmanager/maxrecords', '1000', 1, 910, 'y');
INSERT INTO Settings (name, value, datatype, position, internal) VALUES ('system/csw/enable', 'true', 2, 1210, 'y');
INSERT INTO Settings (name, value, datatype, position, internal) VALUES ('system/csw/contactId', NULL, 0, 1220, 'y');
INSERT INTO Settings (name, value, datatype, position, internal) VALUES ('system/csw/metadataPublic', 'false', 2, 1310, 'y');
INSERT INTO Settings (name, value, datatype, position, internal) VALUES ('system/csw/transactionUpdateCreateXPath', 'true', 2, 1320, 'y');
INSERT INTO Settings (name, value, datatype, position, internal) VALUES ('system/shib/use', 'false', 2, 1710, 'y');
INSERT INTO Settings (name, value, datatype, position, internal) VALUES ('system/shib/path', '/geonetwork/srv/en/shib.user.login', 0, 1720, 'y');
INSERT INTO Settings (name, value, datatype, position, internal) VALUES ('system/shib/username', 'REMOTE_USER', 0, 1740, 'y');
INSERT INTO Settings (name, value, datatype, position, internal) VALUES ('system/shib/surname', 'Shib-Person-surname', 0, 1750, 'y');
INSERT INTO Settings (name, value, datatype, position, internal) VALUES ('system/shib/firstname', 'Shib-InetOrgPerson-givenName', 0, 1760, 'y');
INSERT INTO Settings (name, value, datatype, position, internal) VALUES ('system/shib/profile', 'Shib-EP-Entitlement', 0, 1770, 'y');
INSERT INTO Settings (name, value, datatype, position, internal) VALUES ('system/userSelfRegistration/enable', 'false', 2, 1910, 'n');
INSERT INTO Settings (name, value, datatype, position, internal) VALUES ('system/userFeedback/enable', 'true', 2, 1911, 'n');
INSERT INTO Settings (name, value, datatype, position, internal) VALUES ('system/clickablehyperlinks/enable', 'true', 2, 2010, 'y');
INSERT INTO Settings (name, value, datatype, position, internal) VALUES ('system/localrating/enable', 'false', 2, 2110, 'y');
INSERT INTO Settings (name, value, datatype, position, internal) VALUES ('system/downloadservice/leave', 'false', 0, 2210, 'y');
INSERT INTO Settings (name, value, datatype, position, internal) VALUES ('system/downloadservice/simple', 'true', 0, 2220, 'y');
INSERT INTO Settings (name, value, datatype, position, internal) VALUES ('system/downloadservice/withdisclaimer', 'false', 0, 2230, 'y');
INSERT INTO Settings (name, value, datatype, position, internal) VALUES ('system/xlinkResolver/enable', 'true', 2, 2310, 'n');
INSERT INTO Settings (name, value, datatype, position, internal) VALUES ('system/xlinkResolver/localXlinkEnable', 'true', 2, 2311, 'n');
INSERT INTO Settings (name, value, datatype, position, internal) VALUES ('system/hidewithheldelements/enableLogging', 'false', 2, 2320, 'y');
INSERT INTO Settings (name, value, datatype, position, internal) VALUES ('system/autofixing/enable', 'true', 2, 2410, 'y');
INSERT INTO Settings (name, value, datatype, position, internal) VALUES ('system/searchStats/enable', 'true', 2, 2510, 'n');
INSERT INTO Settings (name, value, datatype, position, internal) VALUES ('system/indexoptimizer/enable', 'true', 2, 6010, 'y');
INSERT INTO Settings (name, value, datatype, position, internal) VALUES ('system/indexoptimizer/at/hour', '0', 1, 6030, 'y');
INSERT INTO Settings (name, value, datatype, position, internal) VALUES ('system/indexoptimizer/at/min', '0', 1, 6040, 'y');
INSERT INTO Settings (name, value, datatype, position, internal) VALUES ('system/indexoptimizer/at/sec', '0', 1, 6050, 'y');
INSERT INTO Settings (name, value, datatype, position, internal) VALUES ('system/indexoptimizer/interval', NULL, 0, 6060, 'y');
INSERT INTO Settings (name, value, datatype, position, internal) VALUES ('system/indexoptimizer/interval/day', '0', 1, 6070, 'y');
INSERT INTO Settings (name, value, datatype, position, internal) VALUES ('system/indexoptimizer/interval/hour', '24', 1, 6080, 'y');
INSERT INTO Settings (name, value, datatype, position, internal) VALUES ('system/indexoptimizer/interval/min', '0', 1, 6090, 'y');
INSERT INTO Settings (name, value, datatype, position, internal) VALUES ('system/oai/mdmode', '1', 0, 7010, 'y');
INSERT INTO Settings (name, value, datatype, position, internal) VALUES ('system/oai/tokentimeout', '3600', 1, 7020, 'y');
INSERT INTO Settings (name, value, datatype, position, internal) VALUES ('system/oai/cachesize', '60', 1, 7030, 'y');
INSERT INTO Settings (name, value, datatype, position, internal) VALUES ('system/inspire/enable', 'true', 2, 7210, 'y');
INSERT INTO Settings (name, value, datatype, position, internal) VALUES ('system/inspire/enableSearchPanel', 'false', 2, 7220, 'n');
INSERT INTO Settings (name, value, datatype, position, internal) VALUES ('system/inspire/atom', 'disabled', 0, 7230, 'y');
INSERT INTO Settings (name, value, datatype, position, internal) VALUES ('system/inspire/atomSchedule', '0 0 0/24 ? * *', 0, 7240, 'y');
INSERT INTO Settings (name, value, datatype, position, internal) VALUES ('system/inspire/atomProtocol', 'INSPIRE-ATOM', 0, 7250, 'y');
INSERT INTO Settings (name, value, datatype, position, internal) VALUES ('system/harvester/enableEditing', 'false', 2, 9010, 'n');
INSERT INTO Settings (name, value, datatype, position, internal) VALUES ('system/harvesting/mail/recipient', NULL, 0, 9020, 'y');
INSERT INTO Settings (name, value, datatype, position, internal) VALUES ('system/harvesting/mail/template', '', 0, 9021, 'y');
INSERT INTO Settings (name, value, datatype, position, internal) VALUES ('system/harvesting/mail/templateError', 'There was an error on the harvesting: $$errorMsg$$', 0, 9022, 'y');
INSERT INTO Settings (name, value, datatype, position, internal) VALUES ('system/harvesting/mail/templateWarning', '', 0, 9023, 'y');
INSERT INTO Settings (name, value, datatype, position, internal) VALUES ('system/harvesting/mail/subject', '[$$harvesterType$$] $$harvesterName$$ finished harvesting', 0, 9024, 'y');
INSERT INTO Settings (name, value, datatype, position, internal) VALUES ('system/harvesting/mail/enabled', 'false', 2, 9025, 'y');
INSERT INTO Settings (name, value, datatype, position, internal) VALUES ('system/harvesting/mail/level1', 'false', 2, 9026, 'y');
INSERT INTO Settings (name, value, datatype, position, internal) VALUES ('system/harvesting/mail/level2', 'false', 2, 9027, 'y');
INSERT INTO Settings (name, value, datatype, position, internal) VALUES ('system/harvesting/mail/level3', 'false', 2, 9028, 'y');
INSERT INTO Settings (name, value, datatype, position, internal) VALUES ('system/metadata/prefergrouplogo', 'true', 2, 9111, 'y');
INSERT INTO Settings (name, value, datatype, position, internal) VALUES ('system/metadata/enableSimpleView', 'true', 2, 9110, 'y');
INSERT INTO Settings (name, value, datatype, position, internal) VALUES ('system/metadata/enableIsoView', 'false', 2, 9120, 'y');
INSERT INTO Settings (name, value, datatype, position, internal) VALUES ('system/metadata/enableInspireView', 'true', 2, 9130, 'y');
INSERT INTO Settings (name, value, datatype, position, internal) VALUES ('system/metadata/enableXmlView', 'true', 2, 9140, 'y');
INSERT INTO Settings (name, value, datatype, position, internal) VALUES ('system/metadata/defaultView', 'simple', 0, 9150, 'n');
INSERT INTO Settings (name, value, datatype, position, internal) VALUES ('system/metadata/allThesaurus', 'false', 2, 9160, 'n');
INSERT INTO Settings (name, value, datatype, position, internal) VALUES ('system/metadataprivs/usergrouponly', 'false', 2, 9180, 'n');
INSERT INTO Settings (name, value, datatype, position, internal) VALUES ('system/threadedindexing/maxthreads', '1', 1, 9210, 'y');
INSERT INTO Settings (name, value, datatype, position, internal) VALUES ('system/autodetect/enable', 'true', 2, 9510, 'y');
INSERT INTO Settings (name, value, datatype, position, internal) VALUES ('system/requestedLanguage/only', 'prefer_locale', 0, 9530, 'y');
INSERT INTO Settings (name, value, datatype, position, internal) VALUES ('system/requestedLanguage/sorted', 'false', 2, 9540, 'y');
INSERT INTO Settings (name, value, datatype, position, internal) VALUES ('system/requestedLanguage/ignorechars', '', 0, 9590, 'y');
INSERT INTO Settings (name, value, datatype, position, internal) VALUES ('system/requestedLanguage/preferUiLanguage', 'true', 2, 9595, 'y');


-- INSERT INTO Settings (name, value, datatype, position, internal) VALUES
--  ('map/backgroundChoices', '{"contextList": []}', 0, 9590, false);
INSERT INTO Settings (name, value, datatype, position, internal) VALUES
  ('map/config', '{"viewerMap": "../../map/config-viewer.xml", "listOfServices": {"wms": [], "wmts": []}, "useOSM":true,"context":"","layer":{"url":"http://www2.demis.nl/mapserver/wms.asp?","layers":"Countries","version":"1.1.1"},"projection":"EPSG:3857","projectionList":[{"code":"EPSG:4326","label":"WGS84 (EPSG:4326)"},{"code":"EPSG:3857","label":"Google mercator (EPSG:3857)"}]}', 0, 9590, 'n');

INSERT INTO Settings (name, value, datatype, position, internal) VALUES ('region/getmap/background', 'osm', 0, 9590, 'n');
INSERT INTO Settings (name, value, datatype, position, internal) VALUES ('region/getmap/width', '500', 0, 9590, 'n');
INSERT INTO Settings (name, value, datatype, position, internal) VALUES ('region/getmap/summaryWidth', '500', 0, 9590, 'n');
INSERT INTO Settings (name, value, datatype, position, internal) VALUES ('region/getmap/mapproj', 'EPSG:3857', 0, 9590, 'n');

INSERT INTO Settings (name, value, datatype, position, internal) VALUES
  ('map/proj4js', '[{"code":"EPSG:2154","value":"+proj=lcc +lat_1=49 +lat_2=44 +lat_0=46.5 +lon_0=3 +x_0=700000 +y_0=6600000 +ellps=GRS80 +towgs84=0,0,0,0,0,0,0 +units=m +no_defs"}]', 0, 9591, 'n');


INSERT INTO Settings (name, value, datatype, position, internal) VALUES ('metadata/resourceIdentifierPrefix', 'http://localhost:8080/geosource/metadata/srv/{{uuid}}.xml', 0, 10001, 'n');
INSERT INTO Settings (name, value, datatype, position, internal) VALUES
  ('map/isMapViewerEnabled', 'false', 2, 9592, 'n');
INSERT INTO Settings (name, value, datatype, position, internal) VALUES
  ('map/is3DModeAllowed', 'false', 2, 9593, 'n');



INSERT INTO Settings (name, value, datatype, position, internal) VALUES
  ('metadata/editor/schemaConfig', '{"iso19110":{"defaultTab":"default","displayToolTip":false,"related":{"display":true,"readonly":true,"categories":["dataset"]},"validation":{"display":true}},"iso19139":{"defaultTab":"inspire","displayToolTip":false,"related":{"display":true,"categories":[]},"suggestion":{"display":true},"validation":{"display":true}},"dublin-core":{"defaultTab":"default","related":{"display":true,"readonly":false,"categories":["parent","onlinesrc"]}}}', 0, 10000, 'n');

INSERT INTO Settings (name, value, datatype, position, internal) VALUES ('system/ui/defaultView', 'default', 0, 10100, 'n');



UPDATE Settings SET value = (SELECT value FROM SettingsBackup WHERE id = 11) WHERE name = 'system/site/name';
UPDATE Settings SET value = (SELECT value FROM SettingsBackup WHERE id = 21) WHERE name = 'system/server/host';
UPDATE Settings SET value = (SELECT value FROM SettingsBackup WHERE id = 53) WHERE name = 'system/server/port';
UPDATE Settings SET value = (SELECT value FROM SettingsBackup WHERE id = 12) WHERE name = 'system/site/siteId';

UPDATE harvesthistory SET elapsedtime = 0;

