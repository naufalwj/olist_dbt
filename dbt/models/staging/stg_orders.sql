SELECT
    order_id::string as order_id,
    customer_id::string as customer_id,
    order_status::string as status,
    order_purchase_timestamp::timestamp as purchased_date,
    order_approved_at::timestamp as approved_date,
    order_delivered_carrier_date::timestamp as delivered_carrier_date,
    order_delivered_customer_date::timestamp as delivered_customer_date,
    order_estimated_delivery_date::timestamp as estimated_delivery_date
FROM
    {{ source('source', 'olist_orders_dataset')}}