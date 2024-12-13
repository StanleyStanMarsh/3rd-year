-- Создание пользователя butters и назначение прав
CREATE USER butters WITH PASSWORD '1234';
GRANT SELECT ON ingredient_view TO butters;

-- Создание пользователя cartman и назначение прав
CREATE USER cartman WITH PASSWORD '1234';
GRANT SELECT, INSERT, DELETE, UPDATE ON ingredient TO cartman;
GRANT SELECT, INSERT, DELETE, UPDATE ON "order" TO cartman;
GRANT SELECT, INSERT, DELETE, UPDATE ON ready_ingredient TO cartman;
GRANT SELECT, INSERT, DELETE, UPDATE ON dish TO cartman;
GRANT SELECT, INSERT, DELETE, UPDATE ON list_of_dishes TO cartman;
GRANT SELECT ON ingredient_view TO cartman;