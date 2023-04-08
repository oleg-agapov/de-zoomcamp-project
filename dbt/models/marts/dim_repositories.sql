{{
    config(
        materialized = "incremental",
        unique_key="repo_id"
    )
}}

{% if is_incremental() %}
  {%- call statement('max_load_time', fetch_result=True) -%}

    select max(load_time) from {{ this }}

  {%- endcall -%}

  {%- set prev_load_time = load_result('max_load_time')['data'][0][0] -%}
{% endif %}


select distinct
    repo_id,
	  repo_name,
    max(created_at) over() as load_time
from {{ ref('stg_github__events') }}

{% if is_incremental() %}
where created_at >= timestamp('{{ prev_load_time }}')
{% endif %}
