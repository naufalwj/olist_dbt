SELECT
    review_id::string as review_id,
    order_id::string as order_id,
    review_score::int as score,
    review_comment_title::string as comment_title,
    review_comment_message::string as comment_message,
    review_creation_date::timestamp as creation_date,
    review_answer_timestamp::timestamp as answer_timestamp
FROM
    {{ source('source', 'olist_order_reviews_dataset')}}