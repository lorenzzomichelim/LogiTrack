USE logitrack;

DELIMITER $$

CREATE TRIGGER trg_item_pedido_insert
AFTER INSERT ON item_pedido
FOR EACH ROW
BEGIN
    UPDATE pedido
    SET valor_total = COALESCE((
        SELECT SUM(quantidade * preco_unitario)
        FROM item_pedido
        WHERE id_pedido = NEW.id_pedido
    ), 0.00)
    WHERE id_pedido = NEW.id_pedido;
END$$

DELIMITER ;


DELIMITER $$

CREATE TRIGGER trg_item_pedido_update
AFTER UPDATE ON item_pedido
FOR EACH ROW
BEGIN
    UPDATE pedido
    SET valor_total = COALESCE((
        SELECT SUM(quantidade * preco_unitario)
        FROM item_pedido
        WHERE id_pedido = NEW.id_pedido
    ), 0.00)
    WHERE id_pedido = NEW.id_pedido;
END$$

DELIMITER ;


DELIMITER $$

CREATE TRIGGER trg_item_pedido_delete
AFTER DELETE ON item_pedido
FOR EACH ROW
BEGIN
    UPDATE pedido
    SET valor_total = COALESCE((
        SELECT SUM(quantidade * preco_unitario)
        FROM item_pedido
        WHERE id_pedido = OLD.id_pedido
    ), 0.00)
    WHERE id_pedido = OLD.id_pedido;
END$$

DELIMITER ;


DELIMITER $$

CREATE TRIGGER trg_validar_estoque_insert
BEFORE INSERT ON item_pedido
FOR EACH ROW
BEGIN
    UPDATE estoque
    SET quantidade = quantidade - NEW.quantidade
    WHERE id_centro = (
        SELECT id_centro
        FROM pedido
        WHERE id_pedido = NEW.id_pedido
    )
    AND id_produto = NEW.id_produto
    AND quantidade >= NEW.quantidade;
    IF ROW_COUNT() = 0 THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'Estoque insuficiente no centro de distribuicao';
    END IF;
END$$

DELIMITER ;


DELIMITER $$

CREATE TRIGGER trg_atualizar_estoque_update
BEFORE UPDATE ON item_pedido
FOR EACH ROW
BEGIN
    DECLARE v_id_centro INT;
    DECLARE v_diferenca INT;
    IF NEW.id_pedido <> OLD.id_pedido
       OR NEW.id_produto <> OLD.id_produto THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'Não é permitido alterar o pedido ou produto do item';
    END IF;
    SET v_diferenca = NEW.quantidade - OLD.quantidade;
    SELECT id_centro
    INTO v_id_centro
    FROM pedido
    WHERE id_pedido = NEW.id_pedido;
    IF v_diferenca > 0 THEN
        UPDATE estoque
        SET quantidade = quantidade - v_diferenca
        WHERE id_centro = v_id_centro
          AND id_produto = NEW.id_produto
          AND quantidade >= v_diferenca;
        IF ROW_COUNT() = 0 THEN
            SIGNAL SQLSTATE '45000'
            SET MESSAGE_TEXT = 'Estoque insuficiente para alterar a quantidade';
        END IF;
    ELSEIF v_diferenca < 0 THEN
        UPDATE estoque
        SET quantidade = quantidade - v_diferenca
        WHERE id_centro = v_id_centro
          AND id_produto = NEW.id_produto;
    END IF;
END$$

DELIMITER ;


DELIMITER $$

CREATE TRIGGER trg_devolver_estoque_delete
AFTER DELETE ON item_pedido
FOR EACH ROW
BEGIN
    UPDATE estoque
    SET quantidade = quantidade + OLD.quantidade
    WHERE id_centro = (
        SELECT id_centro
        FROM pedido
        WHERE id_pedido = OLD.id_pedido
    )
    AND id_produto = OLD.id_produto;
END$$

DELIMITER ;


DELIMITER $$

CREATE TRIGGER trg_bloquear_troca_centro
BEFORE UPDATE ON pedido
FOR EACH ROW
BEGIN
    IF NEW.id_centro <> OLD.id_centro
       AND EXISTS (
           SELECT 1
           FROM item_pedido
           WHERE id_pedido = OLD.id_pedido
       ) THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'Não é permitido alterar o centro de um pedido com itens';
    END IF;
END$$

DELIMITER ;