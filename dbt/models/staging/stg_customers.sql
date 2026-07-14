SELECT
    distinct
    customer_unique_id::string as customer_unique_id,
    customer_zip_code_prefix::bigint as zip_code_prefix,
    customer_city::string as city,
    customer_state::string as state
FROM
    {{ source('source', 'olist_customers_dataset')}}