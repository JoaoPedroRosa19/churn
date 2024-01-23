SELECT compradores.id, compradores.first_name, compradores.email
FROM (
    SELECT u.id, u.first_name, u.email, SUM(num_of_item) as total_compras
    FROM bigquery-public-data.thelook_ecommerce.users as u
    INNER JOIN bigquery-public-data.thelook_ecommerce.orders as o ON u.id = o.user_id
    WHERE EXTRACT(YEAR FROM o.created_at) = 2023 AND (o.status = "Shipped" OR o.status = "Complete")
    GROUP BY u.id, u.first_name, u.email
) AS compradores
LEFT JOIN (
    SELECT user_id
    FROM bigquery-public-data.thelook_ecommerce.orders
    WHERE EXTRACT(YEAR FROM created_at) = 2023
    AND EXTRACT(MONTH FROM created_at) = 10
) AS compras_outubro ON compradores.id = compras_outubro.user_id
WHERE compras_outubro.user_id IS NULL 
ORDER BY compradores.total_compras DESC
LIMIT 1000;