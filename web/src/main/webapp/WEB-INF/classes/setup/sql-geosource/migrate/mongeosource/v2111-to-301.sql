ALTER TABLE ServiceParameters ADD COLUMN occur varchar(1) default '+';
UPDATE ServiceParameters SET occur='+';

create sequence serviceparameter_id_seq start with 1 increment by 1;
-- alter table serviceparameters add column id integer;
UPDATE serviceparameters SET ID=nextval('serviceparameter_id_seq');

--ALTER TABLE ServiceParameters DROP CONSTRAINT IF EXISTS serviceparameters_service_fkey;
--ALTER TABLE ServiceParameters DROP CONSTRAINT IF EXISTS serviceparameters_pkey;
--ALTER TABLE SERVICEPARAMETERS ADD PRIMARY KEY (id);

ALTER TABLE Schematron RENAME file TO filename;

INSERT INTO settings (name, value, datatype, position, internal) VALUES ('system/server/log','log4j.xml',0,250,'y');

INSERT INTO Settings (name, value, datatype, position, internal) VALUES ('region/getmap/background', 'osm', 0, 9590, 'n');
INSERT INTO Settings (name, value, datatype, position, internal) VALUES ('region/getmap/width', '500', 0, 9590, 'n');
INSERT INTO Settings (name, value, datatype, position, internal) VALUES ('region/getmap/summaryWidth', '500', 0, 9590, 'n');
INSERT INTO Settings (name, value, datatype, position, internal) VALUES ('region/getmap/mapproj', 'EPSG:3857', 0, 9590, 'n');

INSERT INTO Settings (name, value, datatype, position, internal) VALUES ('system/proxy/ignorehostlist', NULL, 0, 560, 'y');

INSERT INTO Settings (name, value, datatype, position, internal) VALUES ('system/inspire/atom', 'disabled', 0, 7230, 'y');
INSERT INTO Settings (name, value, datatype, position, internal) VALUES ('system/inspire/atomSchedule', '0 0 0/24 ? * *', 0, 7240, 'y');
INSERT INTO Settings (name, value, datatype, position, internal) VALUES ('system/inspire/atomProtocol', 'INSPIRE-ATOM', 0, 7250, 'y');
INSERT INTO Settings (name, value, datatype, position, internal) VALUES ('system/metadata/prefergrouplogo', 'true', 2, 9111, 'y');

INSERT INTO Settings (name, value, datatype, position, internal) VALUES ('map/isMapViewerEnabled', 'false', 2, 9592, 'n');
INSERT INTO Settings (name, value, datatype, position, internal) VALUES ('system/metadata/allThesaurus', 'false', 2, 9160, 'n');
INSERT INTO Settings (name, value, datatype, position, internal) VALUES ('system/ui/defaultView', 'default', 0, 10100, 'n');

UPDATE Settings SET value = '{"viewerMap": "../../map/config-viewer.xml", "listOfServices": {"wms": [], "wmts": []}, "useOSM":true,"context":"","layer":{"url":"http://www2.demis.nl/mapserver/wms.asp?","layers":"Countries","version":"1.1.1"},"projection":"EPSG:3857","projectionList":[{"code":"EPSG:4326","label":"WGS84 (EPSG:4326)"},{"code":"EPSG:3857","label":"Google mercator (EPSG:3857)"}]}' WHERE name = 'map/config';

UPDATE Settings SET value = '[{"code":"EPSG:2154","value":"+proj=lcc +lat_1=49 +lat_2=44 +lat_0=46.5 +lon_0=3 +x_0=700000 +y_0=6600000 +ellps=GRS80 +towgs84=0,0,0,0,0,0,0 +units=m +no_defs"}]' WHERE name = 'map/proj4js';

INSERT INTO Settings (name, value, datatype, position, internal) VALUES
  ('map/is3DModeAllowed', 'false', 2, 9593, 'n');

INSERT INTO Settings (name, value, datatype, position, internal) VALUES
  ('map/isSaveMapInCatalogAllowed', 'true', 2, 9594, 'n');


SELECT setval('HIBERNATE_SEQUENCE', 
	GREATEST((SELECT max(id) as NB FROM Params), 
	(SELECT max(id) as NB FROM Metadata))
	);


UPDATE Settings SET value='3.0.1' WHERE name='system/platform/version';
UPDATE Settings SET value='SNAPSHOT' WHERE name='system/platform/subVersion';
