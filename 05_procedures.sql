USE logitrack;

DELIMITER $$

CREATE PROCEDURE sp_cadastrar_pedido(
    IN p_id_cliente INT,
    IN p_id_centro INT
)
BEGIN
    INSERT INTO pedido (id_cliente, id_centro)
    VALUES (p_id_cliente, p_id_centro);
END$$

DELIMITER ;


DELIMITER $$

CREATE PROCEDURE sp_adicionar_item_pedido(
    IN p_id_pedido INT,
    IN p_id_produto INT,
    IN p_quantidade INT,
    IN p_preco_unitario DECIMAL(10,2)
)
BEGIN
    INSERT INTO item_pedido (
        id_pedido,
        id_produto,
        quantidade,
        preco_unitario
    )
    VALUES (
        p_id_pedido,
        p_id_produto,
        p_quantidade,
        p_preco_unitario
    );
END$$

DELIMITER ;


DELIMITER $$

CREATE PROCEDURE sp_atualizar_status_entrega(
    IN p_id_entrega INT,
    IN p_novo_status VARCHAR(30)
)
BEGIN
    UPDATE entrega
    SET status_entrega = p_novo_status
    WHERE id_entrega = p_id_entrega;
END$$

DELIMITER ;