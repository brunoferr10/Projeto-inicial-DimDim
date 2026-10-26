-- Execute após CADA operação da API para demonstrar o estado real do PostgreSQL.
SELECT id, nome, email FROM clientes ORDER BY id;
SELECT id, cliente_id, descricao, valor FROM pedidos ORDER BY id;
-- Confirma vínculo cliente -> pedido.
SELECT p.id AS pedido_id, c.id AS cliente_id, c.nome, p.descricao, p.valor
FROM pedidos p JOIN clientes c ON c.id = p.cliente_id ORDER BY p.id;
