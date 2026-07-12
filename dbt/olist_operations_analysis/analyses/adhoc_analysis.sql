SELECT
    *
FROM 
    {{ source('source', 'olist_products_dataset')}}
ORDER BY
    product_category_name
LIMIT 10

