CREATE TABLE IF NOT EXISTS restaurant_clients (
	id_restaurant integer NOT NULL,
	"name" varchar(260),
	address varchar(200),
	clients_count integer NOT NULL
);

INSERT INTO restaurant_clients (id_restaurant, "name", address, clients_count)
	SELECT 
		restaurant.id_restaurant,
		restaurant."name",
		restaurant.address,
		COALESCE(count(client_order.id_client), 0) as clients_count
	FROM 
		restaurant 
		LEFT JOIN 
		"order"
		ON restaurant.id_restaurant = "order".id_restaurant
		LEFT JOIN
		client_order
		ON "order".id_order = client_order.id_order
		GROUP BY restaurant.id_restaurant;