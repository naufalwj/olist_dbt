-- here's a missing category
-- Question is, is there any orders for this product with Null Category?
-- if yes then we might need to keep to capture the weight, etc


SELECT
    sp.product_id as product_id,
    spt.category_name_english as category_name,
    sp.name_length,
    sp.description_length,
    sp.photos_quantity,
    sp.weight_g,
    sp.weight_kg,
    sp.length_cm,
    sp.length_m,
    sp.height_cm,
    sp.height_m,
    sp.width_cm,
    sp.width_m
FROM
    {{ref('stg_products')}} as sp
LEFT JOIN
    {{ref('stg_product_category_translations')}} as spt
    ON sp.category_name = spt.category_name
WHERE spt.category_name_english is null
LIMIT 10