-- @author prabhd 
-- @created 2014-04-01 12:00:00
-- @modified 2012-04-01 12:00:00
-- @tags dml MPP-21090 ORCA
-- @optimizer_mode on	
-- @description Tests for MPP-21090
\echo --start_ignore
set gp_enable_column_oriented_table=on;
\echo --end_ignore
DROP TABLE IF EXISTS mpp21090_pttab_dropfirstcol_addpt_index_date;
CREATE TABLE mpp21090_pttab_dropfirstcol_addpt_index_date
(
    col1 date,
    col2 date,
    col3 char,
    col4 date,
    col5 int
) 
DISTRIBUTED by (col1)
PARTITION BY RANGE(col2)(partition partone start('2013-12-01') end('2013-12-31') WITH(APPENDONLY=true, COMPRESSLEVEL=5, ORIENTATION=column),partition parttwo start('2013-12-31') end('2014-01-01') WITH (APPENDONLY=true, COMPRESSLEVEL=5, ORIENTATION=row),partition partthree start('2014-01-01') end('2014-02-01'));

INSERT INTO mpp21090_pttab_dropfirstcol_addpt_index_date VALUES('2013-12-30','2013-12-30','a','2013-12-30',0);

DROP INDEX IF EXISTS mpp21090_pttab_dropfirstcol_addpt_index_idx_date;
CREATE INDEX mpp21090_pttab_dropfirstcol_addpt_index_idx_date on mpp21090_pttab_dropfirstcol_addpt_index_date(col2);

ALTER TABLE mpp21090_pttab_dropfirstcol_addpt_index_date DROP COLUMN col1;
ALTER TABLE mpp21090_pttab_dropfirstcol_addpt_index_date ADD PARTITION partfour start('2014-02-01') end('2014-03-01') inclusive;

INSERT INTO mpp21090_pttab_dropfirstcol_addpt_index_date SELECT '2014-02-10','b','2014-02-10', 1;
SELECT * FROM mpp21090_pttab_dropfirstcol_addpt_index_date ORDER BY 1,2,3;

UPDATE mpp21090_pttab_dropfirstcol_addpt_index_date SET col4 = '2014-01-01' WHERE col2 = '2014-02-10' AND col4 = '2014-02-10';
SELECT * FROM mpp21090_pttab_dropfirstcol_addpt_index_date ORDER BY 1,2,3;

-- Update partition key
UPDATE mpp21090_pttab_dropfirstcol_addpt_index_date SET col2 = '2014-01-01' WHERE col2 = '2014-02-10' AND col4 = '2014-01-01';
SELECT * FROM mpp21090_pttab_dropfirstcol_addpt_index_date ORDER BY 1,2,3;

DELETE FROM mpp21090_pttab_dropfirstcol_addpt_index_date WHERE col2 = '2014-01-01';
SELECT * FROM mpp21090_pttab_dropfirstcol_addpt_index_date ORDER BY 1,2,3;

