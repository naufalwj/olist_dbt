SELECT
    product_category_name::string as category_name,
    product_category_name_english::string as category_name_english
FROM
    {{ source('source', 'product_category_name_translation')}}