ALTER TABLE ServiceParameters ADD COLUMN occur varchar(1) default '+';
UPDATE ServiceParameters SET occur='+';

create sequence serviceparameter_id_seq start with 1 increment by 1;
alter table serviceparameters add column id integer;
UPDATE serviceparameters SET ID=nextval('serviceparameter_id_seq');

ALTER TABLE ServiceParameters DROP CONSTRAINT IF EXISTS serviceparameters_service_fkey;
ALTER TABLE ServiceParameters DROP CONSTRAINT IF EXISTS serviceparameters_pkey;
ALTER TABLE SERVICEPARAMETERS ADD PRIMARY KEY (id);

ALTER TABLE Schematron RENAME file TO filename;
