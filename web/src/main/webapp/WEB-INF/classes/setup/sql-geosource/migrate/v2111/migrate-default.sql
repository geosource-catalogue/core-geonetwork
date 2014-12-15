UPDATE Settings SET value='2.11.1' WHERE name='system/platform/version';

INSERT INTO Settings (name, value, datatype, position, internal) VALUES ('metadata/resourceIdentifierPrefix', 'http://localhost:8080/geosource/', 0, 10001, 'n');
