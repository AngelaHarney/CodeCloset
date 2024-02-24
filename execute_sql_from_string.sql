-- title:  Snowflake - Execute SQL from a String
-- author: angela harney

-- Executes a SQL string from a variable
-- SQL string is dynamically generated from a query

-- Uses INTO the variable to get around string size limitations
-- By default returns the sql string for debugging purposes - set display_statement_only to true to run the sql

-- Context permissions - read rights to: snowflake_sample_data.information_schema.columns, snowflake_sample_data.tpch_sf1.customer table
-- Context database - to display output: run from any location that can read context tables
-- Context database - to execute SQL string output: Run from a database where you have permissions to create objects - string statement creates a view of all columns for a given table

declare
  QUERY_STATEMENT string;
  display_statement_only boolean default true;
begin

-- code statements

select lower(concat('create or replace view vw_' || table_name || ' as 
select ',listagg(column_name, '
    ,') within group (order by ordinal_position),'
from ' || table_catalog || '.' || table_schema || '.' || table_name || ';' ))
    INTO :QUERY_STATEMENT
from snowflake_sample_data.information_schema.columns
where lower(table_catalog) = 'snowflake_sample_data'
and lower(table_schema) = 'tpch_sf1'
and lower(table_name) = 'customer'
group by table_catalog, table_schema, table_name;   


-- executions

  if (display_statement_only = false) then

    execute immediate :QUERY_STATEMENT;

  end if;

  RETURN :QUERY_STATEMENT;

end;

