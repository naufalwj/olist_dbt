SELECT
    product_id::string as product_id,
    product_category_name::string as category_name,
    product_name_lenght::int as name_length,
    product_description_lenght::int as description_length,
    product_photos_qty::int as photos_quantity,
    product_weight_g::double as weight_g,
    product_weight_g::double / 1000 as weight_kg,
    product_length_cm::double as length_cm,
    product_length_cm::double / 100 as length_m,
    product_height_cm::double as height_cm,
    product_height_cm::double / 100 as height_m,
    product_width_cm::double as width_cm,
    product_width_cm::double / 100 as width_m
FROM {{ source('source', 'olist_products_dataset')}}