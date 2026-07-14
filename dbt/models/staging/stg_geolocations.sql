WITH raw_geolocations AS (
SELECT
    DISTINCT
    geolocation_zip_code_prefix::bigint as zip_code,
    geolocation_state::string as state,
    geolocation_city::string as city,
    bs.name as state_name
FROM
    {{ source('source', 'olist_geolocation_dataset')}}
LEFT JOIN
    {{ref('seed_brazil_state')}} as bs
    ON geolocation_state = bs.shortcode
)

SELECT
    DISTINCT
    zip_code,
    state as state,
    LOWER(
        {{ portuguese_letter_translator('city') }}
    ) AS city,
    {{ portuguese_letter_translator('state_name') }} as full_state
FROM
    raw_geolocations