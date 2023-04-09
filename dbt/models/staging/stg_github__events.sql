{{
    config(
        materialized = "incremental",
        incremental_strategy = "insert_overwrite",
        unique_key = "event_id",
        partition_by = {
            "field": "created_at",
            "data_type": "timestamp",
            "granularity": "day"
        },
        cluster_by = ["event_type"]
    )
}}


{% if is_incremental() %}
  {%- call statement('max_date_statement', fetch_result=True) -%}
    select max(report_date) from {{ this }}
  {%- endcall -%}
  {%- set prev_event_date = load_result('max_date_statement')['data'][0][0] -%}
{% endif %}


select
    id as event_id,
    created_at,
    public,
    `type` as event_type,
    --
    json_value(repo, '$.id') as repo_id,
    json_value(repo, '$.name') as repo_name,
    json_value(repo, '$.url') as repo_url,
    --
    json_value(actor, '$.avatar_url') as actor_avatar_url,
    json_value(actor, '$.display_login') as actor_display_login,
    json_value(actor, '$.gravatar_id') as actor_gravatar_id,
    json_value(actor, '$.id') as actor_id,
    json_value(actor, '$.login') as actor_login,
    json_value(actor, '$.url') as actor_url,
    --
    json_value(payload, '$.action') as payload_action,
    json_value(payload, '$.description') as payload_description,
    json_value(payload, '$.distinct_size') as payload_distinct_size,
    json_value(payload, '$.number') as payload_number,
    json_value(payload, '$.push_id') as payload_push_id,
    json_value(payload, '$.pusher_type') as payload_pusher_type,
    json_value(payload, '$.ref') as payload_ref,
    json_value(payload, '$.ref_type') as payload_ref_type,
    json_value(payload, '$.repository_id') as payload_repository_id,
    json_value(payload, '$.size') as payload_size,
    --
    current_timestamp() as row_created_at,
    `year` as report_year,
    `month` as report_month,
    `date` as report_date
from
{{ source('raw_data', 'external_github_events') }}

{% if is_incremental() %}
where timestamp(`date`) >= timestamp('{{ prev_event_date }}')
{% endif %}

-- deduplication
qualify row_number() over (partition by event_id order by created_at) = 1
