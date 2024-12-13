
CREATE OR REPLACE PROCEDURE upsert_restaurant_ingredient(
    restaurant_name TEXT, 
    restaurant_address TEXT, 
    restaurant_registration_info TEXT, 
    ingredient_name TEXT, 
    ingredient_amount INT
)
LANGUAGE plpgsql
AS $$
DECLARE
    restaurant_id INT;
    ingredient_id INT;
    storage_id INT;
BEGIN
    -- Get or insert restaurant
    SELECT id_restaurant INTO restaurant_id 
    FROM restaurant 
    WHERE name = restaurant_name AND address = restaurant_address AND registration_info = restaurant_registration_info;

    IF restaurant_id IS NULL THEN
        SELECT max(id_restaurant) + 1 INTO restaurant_id FROM restaurant;
        INSERT INTO restaurant (id_restaurant, name, address, registration_info, space, capacity)
        VALUES (restaurant_id, restaurant_name, restaurant_address, restaurant_registration_info, DEFAULT, DEFAULT);
    END IF;

    -- Get or insert ingredient
    SELECT id_ingredient INTO ingredient_id 
    FROM ingredient 
    WHERE name = ingredient_name;

    IF ingredient_id IS NULL THEN
        SELECT max(id_ingredient) + 1 INTO ingredient_id FROM ingredient;
        INSERT INTO ingredient (id_ingredient, name)
        VALUES (ingredient_id, ingredient_name);
    END IF;

    -- Get or insert/update ingredient_in_storage
    SELECT id_ingredient_in_storage INTO storage_id
    FROM ingredient_in_storage 
    WHERE id_ingredient = ingredient_id AND id_restaurant = restaurant_id;

    IF storage_id IS NULL THEN
        SELECT max(id_ingredient_in_storage) + 1 INTO storage_id FROM ingredient_in_storage;
        INSERT INTO ingredient_in_storage (id_ingredient_in_storage, amount, id_restaurant, id_ingredient)
        VALUES (storage_id, ingredient_amount, restaurant_id, ingredient_id);
    ELSE
        UPDATE ingredient_in_storage 
        SET amount = ingredient_amount 
        WHERE id_ingredient_in_storage = storage_id;
    END IF;
    
END;
$$;
