CREATE OR REPLACE FUNCTION update_restaurant_clients()
RETURNS TRIGGER
LANGUAGE plpgsql
AS $$
BEGIN
    IF TG_OP = 'INSERT' THEN
        -- Вставляет новую строку в restaurant_clients с числом клиентов по умолчанию равным 0
        INSERT INTO restaurant_clients (id_restaurant, "name", address, clients_count)
        VALUES (NEW.id_restaurant, NEW."name", NEW.address, 0);

    ELSIF TG_OP = 'UPDATE' THEN
        -- Обновляет соответствующую строку в restaurant_clients
        UPDATE restaurant_clients
        SET "name" = NEW."name", address = NEW.address
        WHERE id_restaurant = OLD.id_restaurant;

    ELSIF TG_OP = 'DELETE' THEN
        -- Удаляет соответствующую строку из restaurant_clients
        DELETE FROM restaurant_clients
        WHERE id_restaurant = OLD.id_restaurant;
    END IF;
END;
$$;


-- Триггер для вставки и удаления
CREATE TRIGGER restaurant_clients_insert
AFTER INSERT OR DELETE ON restaurant
FOR EACH ROW EXECUTE FUNCTION update_restaurant_clients();

-- Триггер для обновления названия или адреса ресторана
CREATE TRIGGER restaurant_clients_update
AFTER UPDATE OF name, address ON restaurant
FOR EACH ROW EXECUTE FUNCTION update_restaurant_clients();