SELECT
	cnd.id_condition,
	cnd.condition,
	SUM(iv.num_dishes) AS number_of_dishes
FROM
	condition cnd
JOIN
	ready_ingredient ri ON cnd.id_condition = ri.id_condition
JOIN
	ingredient_view iv ON ri.id_ingredient = iv.id_ingredient
GROUP BY
	cnd.id_condition;