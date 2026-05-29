{#
    Calculate trip duration in minutes from pickup and dropoff timestamps.

    Uses dbt built-in cross-database datediff macro.
    Works across BigQuery, Snowflake, Redshift, Postgres, DuckDB, etc.

    Returns: Trip duration in minutes
#}
{% macro get_trip_duration_minutes(pickup_datetime, dropoff_datetime) %}
    timestamp_diff({{ dropoff_datetime }}, {{ pickup_datetime }}, MINUTE)
{% endmacro %}