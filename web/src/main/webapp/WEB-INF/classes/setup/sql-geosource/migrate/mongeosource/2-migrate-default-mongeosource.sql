--Inserts new data and modifies data

ALTER TABLE operations DROP COLUMN reserved;
-- FIXME: ALTER TABLE services DROP COLUMN id;

CREATE TABLE SettingsBackup AS SELECT * FROM SETTINGS;

INSERT INTO HarvesterSettings (id, parentid, name, value) VALUES  (1,NULL,'harvesting',NULL);

-- Copy all harvester's root nodes config
INSERT INTO HarvesterSettings SELECT id, 1, name, value FROM Settings WHERE parentId = 2;
-- Copy all harvester's properties (Greater than last 2.10.1 settings ie. keepMarkedElement)
-- INSERT INTO HarvesterSettings SELECT * FROM Settings WHERE id >= (SELECT MIN(id) FROM settings WHERE parentId = 2) AND parentId > 2;
-- mongeosource only
-- TODO: 
-- INSERT INTO HarvesterSettings SELECT * FROM Settings WHERE id >= (SELECT MIN(id) FROM settings WHERE parentId = 2) AND parentId > 2 AND name != 'usergrouponly';
-- Drop harvester config from Settings table
--DELETE FROM Settings WHERE id >= (SELECT MIN(id) FROM settings WHERE parentId = 2);
--DELETE FROM Settings WHERE id=2;

DELETE FROM Settings;

ALTER TABLE Settings ALTER name TYPE varchar(512);

-- 0 is char, 1 is number, 2 is boolean
ALTER TABLE Settings ADD datatype int;
ALTER TABLE Settings ADD position int;
ALTER TABLE Settings ADD internal varchar(1);

ALTER TABLE Settings DROP COLUMN parentId;
ALTER TABLE Settings DROP COLUMN id;
ALTER TABLE Settings ADD PRIMARY KEY (name);



INSERT INTO Settings (name, value, datatype, position, internal) VALUES ('system/site/name', 'Mon GéoSource', 0, 110, 'n');
INSERT INTO Settings (name, value, datatype, position, internal) VALUES ('system/site/siteId', '', 0, 120, 'n');
INSERT INTO Settings (name, value, datatype, position, internal) VALUES ('system/site/organization', 'Mon organisation', 0, 130, 'n');
INSERT INTO Settings (name, value, datatype, position, internal) VALUES ('system/platform/version', '2.11.0', 0, 150, 'n');
INSERT INTO Settings (name, value, datatype, position, internal) VALUES ('system/platform/subVersion', 'SNAPSHOT', 0, 160, 'n');
INSERT INTO Settings (name, value, datatype, position, internal) VALUES ('system/site/svnUuid', '', 0, 170, 'y');
INSERT INTO Settings (name, value, datatype, position, internal) VALUES ('system/server/host', 'localhost', 0, 210, 'n');
INSERT INTO Settings (name, value, datatype, position, internal) VALUES ('system/server/protocol', 'http', 0, 220, 'n');
INSERT INTO Settings (name, value, datatype, position, internal) VALUES ('system/server/port', '8080', 1, 230, 'n');
INSERT INTO Settings (name, value, datatype, position, internal) VALUES ('system/server/securePort', '8443', 1, 240, 'y');
INSERT INTO Settings (name, value, datatype, position, internal) VALUES ('system/intranet/network', '127.0.0.1', 0, 310, 'y');
INSERT INTO Settings (name, value, datatype, position, internal) VALUES ('system/intranet/netmask', '255.0.0.0', 0, 320, 'y');
INSERT INTO Settings (name, value, datatype, position, internal) VALUES ('system/z3950/enable', 'false', 2, 410, 'y');
INSERT INTO Settings (name, value, datatype, position, internal) VALUES ('system/z3950/port', '2100', 1, 420, 'y');
INSERT INTO Settings (name, value, datatype, position, internal) VALUES ('system/proxy/use', 'false', 2, 510, 'y');
INSERT INTO Settings (name, value, datatype, position, internal) VALUES ('system/proxy/host', NULL, 0, 520, 'y');
INSERT INTO Settings (name, value, datatype, position, internal) VALUES ('system/proxy/port', NULL, 1, 530, 'y');
INSERT INTO Settings (name, value, datatype, position, internal) VALUES ('system/proxy/username', NULL, 0, 540, 'y');
INSERT INTO Settings (name, value, datatype, position, internal) VALUES ('system/proxy/password', NULL, 0, 550, 'y');
INSERT INTO Settings (name, value, datatype, position, internal) VALUES ('system/feedback/email', NULL, 0, 610, 'y');
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
INSERT INTO Settings (name, value, datatype, position, internal) VALUES ('system/metadata/enableSimpleView', 'true', 2, 9110, 'y');
INSERT INTO Settings (name, value, datatype, position, internal) VALUES ('system/metadata/enableIsoView', 'false', 2, 9120, 'y');
INSERT INTO Settings (name, value, datatype, position, internal) VALUES ('system/metadata/enableInspireView', 'true', 2, 9130, 'y');
INSERT INTO Settings (name, value, datatype, position, internal) VALUES ('system/metadata/enableXmlView', 'true', 2, 9140, 'y');
INSERT INTO Settings (name, value, datatype, position, internal) VALUES ('system/metadata/defaultView', 'simple', 0, 9150, 'n');
INSERT INTO Settings (name, value, datatype, position, internal) VALUES ('system/metadataprivs/usergrouponly', 'false', 2, 9180, 'n');
INSERT INTO Settings (name, value, datatype, position, internal) VALUES ('system/threadedindexing/maxthreads', '1', 1, 9210, 'y');
INSERT INTO Settings (name, value, datatype, position, internal) VALUES ('system/autodetect/enable', 'true', 2, 9510, 'y');
INSERT INTO Settings (name, value, datatype, position, internal) VALUES ('system/requestedLanguage/only', 'prefer_locale', 0, 9530, 'y');
INSERT INTO Settings (name, value, datatype, position, internal) VALUES ('system/requestedLanguage/sorted', 'false', 2, 9540, 'y');
INSERT INTO Settings (name, value, datatype, position, internal) VALUES ('system/hidewithheldelements/enable', 'false', 2, 9570, 'n');
INSERT INTO Settings (name, value, datatype, position, internal) VALUES ('system/hidewithheldelements/keepMarkedElement', 'true', 2, 9580, 'y');
INSERT INTO Settings (name, value, datatype, position, internal) VALUES ('system/requestedLanguage/ignorechars', '', 0, 9590, 'y');
INSERT INTO Settings (name, value, datatype, position, internal) VALUES ('system/requestedLanguage/preferUiLanguage', 'true', 2, 9595, 'y');


-- INSERT INTO Settings (name, value, datatype, position, internal) VALUES
--  ('map/backgroundChoices', '{"contextList": []}', 0, 9590, false);
INSERT INTO Settings (name, value, datatype, position, internal) VALUES
  ('map/config', '{"useOSM":true,"context":"","layer":{"url":"http://www2.demis.nl/mapserver/wms.asp?","layers":"Countries","version":"1.1.1"},"projection":"EPSG:3857","projectionList":[{"code":"EPSG:4326","label":"WGS84 (EPSG:4326)"},{"code":"EPSG:3857","label":"Google mercator (EPSG:3857)"}, {"code": "EPSG:2154", "label": "Lambert 93"}]}', 0, 9590, 'n');
INSERT INTO Settings (name, value, datatype, position, internal) VALUES
  ('metadata/editor/schemaConfig', '{"iso19110":{"defaultTab":"default","displayToolTip":false,"related":{"display":true,"readonly":true,"categories":["dataset"]},"validation":{"display":true}},"iso19139":{"defaultTab":"inspire","displayToolTip":false,"related":{"display":true,"categories":[]},"suggestion":{"display":true},"validation":{"display":true}},"iso19139.fra":{"defaultTab":"inspire","displayToolTip":false,"related":{"display":true,"categories":[]},"suggestion":{"display":true},"validation":{"display":true}},"dublin-core":{"defaultTab":"default","related":{"display":true,"readonly":true,"categories":[]},}}', 0, 10000, 'n');
INSERT INTO Settings (name, value, datatype, position, internal) VALUES
  ('map/proj4js', '[{"code":"EPSG:2154","value":"+proj=lcc +lat_1=49 +lat_2=44 +lat_0=46.5 +lon_0=3 +x_0=700000 +y_0=6600000 +ellps=GRS80 +towgs84=0,0,0,0,0,0,0 +units=m +no_defs"}]', 0, 9591, 'n');


UPDATE Settings SET value = (SELECT value FROM SettingsBackup where id = 11) WHERE name = 'system/site/name';
UPDATE Settings SET value = (SELECT value FROM SettingsBackup where id = 12) WHERE name = 'system/site/siteId';
UPDATE Settings SET value = (SELECT value FROM SettingsBackup where id = 13) WHERE name = 'system/site/organization';
-- UPDATE Settings SET value = (SELECT value FROM SettingsBackup where id = 13) WHERE name = 'system/server/host';

ALTER TABLE StatusValues ADD displayorder int;

UPDATE StatusValues SET displayorder = 0 WHERE id = 0;
UPDATE StatusValues SET displayorder = 1 WHERE id = 1;
UPDATE StatusValues SET displayorder = 3 WHERE id = 2;
UPDATE StatusValues SET displayorder = 5 WHERE id = 3;
UPDATE StatusValues SET displayorder = 2 WHERE id = 4;
UPDATE StatusValues SET displayorder = 4 WHERE id = 5;


-- Version update
UPDATE Settings SET value='2.11.1' WHERE name='system/platform/version';
UPDATE Settings SET value='0' WHERE name='system/platform/subVersion';

-- Populate new tables from Users
INSERT INTO Address (SELECT id, address, city, state, zip, country FROM Users);
INSERT INTO UserAddress (SELECT id, id FROM Users);
INSERT INTO Email (SELECT id, email FROM Users);


INSERT INTO CategoriesDes (iddes, langid, label) VALUES (11,'fre','Serveurs Z3950');
INSERT INTO CategoriesDes (iddes, langid, label) VALUES (12,'fre','Annuaires');
