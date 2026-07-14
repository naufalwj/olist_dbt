SELECT
    order_id::string,
    order_item_id::string,
    product_id::string,
    seller_id::string,
    shipping_limit_date::timestamp,
    price::double,
    freight_value::double
FROM
    {{ source('source', 'olist_order_items_dataset')}}