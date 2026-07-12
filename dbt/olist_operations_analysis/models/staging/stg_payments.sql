SELECT
    order_id::string as order_id,
    payment_sequential::int as sequential,
    payment_type::string as type,
    payment_installments::int as installments,
    payment_value::double as value
FROM
    {{ source('source', 'olist_order_payments_dataset')}}