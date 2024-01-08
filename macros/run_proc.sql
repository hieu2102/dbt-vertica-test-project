{% macro run_proc() %}
  {% set current_node = run_query("select node_name from current_session;")%}
  {{ print("executing procedure...") }}
  {% do current_node.print_json()%}
  {{ print("\nInserting to staging")}}
  {% do run_query("insert into huyndai.staging_sales values(round(EXTRACT(EPOCH FROM now()))::integer,0,0,'05-JUL-22 00:00:00',2,'ihsnhdvhttsudhmli');commit;") %}
  {{ print("Pre-execution rows count")}}
    {% set sales_res = run_query("with sr as (select count(*) as o from huyndai.sales),
stg_r as (select count(*) as o from huyndai.staging_sales)
select sr.o as sales, stg_r.o as staging from sr, stg_r;") %}
  {% do sales_res.print_table() %}

  {{ print("Executing proc")}}
  {% do run_query("call huyndai.sales_upsert2();") %}
  {{ print("Checking output")}}
  {% set sales_res = run_query("with sr as (select count(*) as o from huyndai.sales),
stg_r as (select count(*) as o from huyndai.staging_sales)
select sr.o as sales, stg_r.o as staging from sr, stg_r;") %}
  {% do sales_res.print_table() %}
  {% set sales_res = run_query("with sr as ( SELECT node_name ,count(*) as session_count FROM sessions /* these are only the currently connected sessions */ GROUP BY 1 ORDER BY 2)
select node_name, session_count as sessions from sr;") %}
  {% do sales_res.print_table() %}
{% endmacro %}








