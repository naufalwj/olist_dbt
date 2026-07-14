{% macro portuguese_letter_translator(text) %}
    TRIM(
      REGEXP_REPLACE(
        REGEXP_REPLACE(
        TRANSLATE({{ text }}, 'áàâãäéèêëíìîïóòôõöúùûüçñ', 'aaaaaeeeeiiiiooooouuuucn'),
        '-', ' ' ),
        '\\s+', ' ')
    )
{% endmacro %}