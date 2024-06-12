#This SQL script helps to load data of required fields by changing dataypes simultaneously


CREATE OR REPLACE TABLE
  project-0039-384911.usecase2_history.tab AS
SELECT
  cast(EMPLID as string) as emp,
  DEPTID
FROM
  usecase2_history.table1;


Script by: Red

