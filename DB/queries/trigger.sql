-- По номеру заказа получаем информацию об id ресторана, в котором он был сделан,
-- затем увеличиваем/уменьшаем число клиентов
CREATE OR REPLACE FUNCTION update_client_count()
RETURNS TRIGGER
LANGUAGE plpgsql
AS
$$
DECLARE
  restaurant_id INT;
  client_id INT;
  count_clients INT;
BEGIN
  IF TG_OP = 'INSERT' THEN
    SELECT id_restaurant INTO restaurant_id
    FROM "order"
    WHERE "order".id_order = NEW.id_order;

    SELECT id_client INTO client_id
    FROM client_order
    WHERE client_order.id_order = NEW.id_order;

    -- Пересчитываем count_clients после вставки
    SELECT COUNT(DISTINCT client_order.id_order) INTO count_clients
    FROM client_order
    JOIN "order" ON client_order.id_order = "order".id_order
    WHERE "order".id_restaurant = restaurant_id AND client_order.id_client = client_id;
    
    IF count_clients = 1 THEN
      -- Увеличиваем кол-во клиентов
      UPDATE restaurant_clients
      SET clients_count = clients_count + 1
      WHERE id_restaurant = restaurant_id;
    END IF;

  ELSIF TG_OP = 'DELETE' THEN
    SELECT id_restaurant INTO restaurant_id
    FROM "order"
    WHERE "order".id_order = OLD.id_order;

    SELECT id_client INTO client_id
    FROM client_order
    WHERE client_order.id_order = OLD.id_order;

    -- Пересчитываем count_clients после удаления
    SELECT COUNT(DISTINCT client_order.id_order) INTO count_clients
    FROM client_order
    JOIN "order" ON client_order.id_order = "order".id_order
    WHERE "order".id_restaurant = restaurant_id AND client_order.id_client = client_id;

    IF count_clients = 0 THEN
      -- Уменьшаем кол-во клиентов
      UPDATE restaurant_clients
      SET clients_count = clients_count - 1
      WHERE id_restaurant = restaurant_id;
    END IF;
  END IF;

  RETURN NULL;
END;
$$;

-- Триггер
CREATE OR REPLACE TRIGGER after_update_client_order
	AFTER INSERT OR DELETE ON client_order
	FOR EACH ROW
	EXECUTE FUNCTION update_client_count();


SELECT event_object_table, trigger_name
FROM information_schema.triggers;

--INSERT INTO client(id_client, surname, "name", patronymic, phone_number)
	--VALUES(500, 'АСТАФЬЕВ', 'ИГОРЬ', 'ЕВГЕНЬЕВИЧ', '+79999999999999');
--INSERT INTO "order"(id_order, order_type, id_restaurant) VALUES(150000, 'takeaway'::order_type, 47);
--INSERT INTO client_order(id_client_order, id_client, id_order) VALUES(30001, 500, 150000);

DELETE FROM client WHERE id_client = 500;