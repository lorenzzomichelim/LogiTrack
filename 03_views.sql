USE logitrack;

CREATE OR REPLACE VIEW vw_relatorio_entregas AS
SELECT
    c.nome AS cliente,
    p.id_pedido,
    e.status_entrega,
    p.valor_total,
    en.nome AS entregador,
    v.modelo AS veiculo
FROM cliente c
INNER JOIN pedido p
    ON c.id_cliente = p.id_cliente
INNER JOIN entrega e
    ON p.id_pedido = e.id_pedido
INNER JOIN entregador en
    ON e.id_entregador = en.id_entregador
INNER JOIN veiculo v
    ON e.id_veiculo = v.id_veiculo;


CREATE OR REPLACE VIEW vw_faturamento_cliente AS
SELECT
    c.id_cliente,
    c.nome AS cliente,
    COUNT(p.id_pedido) AS quantidade_pedidos,
    COALESCE(SUM(p.valor_total), 0.00) AS total_gasto
FROM cliente c
LEFT JOIN pedido p
    ON c.id_cliente = p.id_cliente
GROUP BY c.id_cliente, c.nome;


CREATE OR REPLACE VIEW vw_clientes_acima_1000 AS
SELECT
    cliente,
    total_gasto
FROM vw_faturamento_cliente
WHERE total_gasto > 1000;


CREATE OR REPLACE VIEW vw_entregas_pendentes AS
SELECT
    COUNT(*) AS entregas_pendentes
FROM entrega
WHERE status_entrega = 'PENDENTE';


CREATE OR REPLACE VIEW vw_resumo_entregas AS
SELECT
    status_entrega,
    COUNT(*) AS quantidade
FROM entrega
GROUP BY status_entrega;


SELECT *
FROM vw_relatorio_entregas
ORDER BY valor_total DESC;

SELECT *
FROM vw_relatorio_entregas
WHERE status_entrega = 'ENTREGUE';

SELECT *
FROM vw_faturamento_cliente
ORDER BY total_gasto DESC;

SELECT *
FROM vw_clientes_acima_1000;

SELECT *
FROM vw_entregas_pendentes;

SELECT *
FROM vw_resumo_entregas;