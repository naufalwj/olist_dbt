SELECT
    seller_id::string as seller_id,
    seller_zip_code_prefix::string as zip_code_prefix,
    seller_city::string as city,
    seller_state::string as state
FROM
    {{ source('source', 'olist_sellers_dataset')}}