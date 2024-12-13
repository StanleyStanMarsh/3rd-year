CREATE OR REPLACE VIEW ingredient_view AS
	SELECT
    	i.id_ingredient,
    	i.name,
    	COUNT(DISTINCT d.id_dish) AS num_dishes,
    	COUNT(o.id_order) AS num_orders
	FROM
    	ingredient i
	LEFT JOIN
    	ready_ingredient ri ON i.id_ingredient = ri.id_ingredient
	LEFT JOIN
    	dish d ON ri.id_dish = d.id_dish
	LEFT JOIN
    	list_of_dishes lod ON d.id_dish = lod.id_dish
	LEFT JOIN
		"order" o ON lod.id_order = o.id_order
	GROUP BY
		i.id_ingredient, i.name;