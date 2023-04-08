{{
    config(
        materialized = "incremental",
        partition_by = {
            "field": "event_date",
            "data_type": "date"
        },
    )
}}

{% if is_incremental() %}
  {%- call statement('last_date', fetch_result=True) -%}
    select max(event_date) from {{ this }}
  {%- endcall -%}
  {%- set prev_event_date = load_result('last_date')['data'][0][0] -%}
{% endif %}


select
	date(e.created_at) AS event_date,
	e.repo_id,
	e.repo_name,
	e.event_type,
	e.payload_action AS event_subtype,
    t.category as event_category,
    t.description,
	count(1) AS events
from {{ ref('stg_github__events') }} e
left join {{ ref('event_types') }} t
    on t.type = e.event_type

{% if is_incremental() %}
where date(e.created_at) >= date_sub('{{ prev_event_date }}', interval 1 day)
{% endif %}

group by 1, 2, 3, 4, 5, 6, 7
