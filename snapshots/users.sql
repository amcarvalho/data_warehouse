{% snapshot users %}

    {{
        config(
          target_schema='datamart',
          strategy='timestamp',
          unique_key='id',
          updated_at='load_date'
        )
    }}

    select * from staging."user" where load_date = '{{ var("run_date", "1990-01-01") }}'

{% endsnapshot %}