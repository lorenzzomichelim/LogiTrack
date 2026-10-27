USE logitrack;

INSERT INTO centro_distribuicao (
	nome,
    cep,
    logradouro,
    numero,
    bairro,
    cidade,
    estado,
    capacidade_maxima
)
VALUES
    ('CD Maringá', '87020000', 'Av. Tiradentes', '1500', 'Centro', 'Maringá', 'PR', 10000),
    ('CD Curitiba', '89050000', 'Av. Caranguejeira', '233', 'Centro', 'Curitiba', 'PR', 15000),
    ('CD Londrina', '82080000', 'Av. Pirapó', '2566', 'Centro', 'Londrina', 'PR', 12500);
    
    
INSERT INTO produto (
	nome,
	descricao,
	sku,
	preco,
	peso_kg
)
VALUES
	('Notebook Dell Inspiron 15', 'Notebook de 15 polegadas, ideal para estudos, trabalho e atividades do dia a dia.', 'NOTE-DELL-001', 3299.90, 1.650),
    ('Monitor LG 24"', 'Monitor de 24 polegadas com resolução Full HD, indicado para uso doméstico e profissional.', 'MON-LG-001', 799.90, 3.200),
    ('Mouse Logitech M170', 'Mouse sem fio com conexão USB, design compacto e compatibilidade com diferentes sistemas operacionais.', 'MOU-LOG-001', 79.90, 0.070),
    ('Teclado Redragon Kumara', 'Teclado mecânico gamer com iluminação LED, estrutura resistente e formato compacto.', 'TEC-RED-001', 229.90, 0.950),
    ('Headset HyperX Cloud II', 'Headset gamer com microfone removível, almofadas confortáveis e áudio de alta qualidade.', 'HEAD-HYP-001', 449.90, 0.320);
    
    
INSERT INTO estoque (
    id_centro,
    id_produto,
    quantidade
)
VALUES
    (1, 1, 29),
    (1, 2, 43),
    (1, 3, 98),
    (1, 4, 29),
    (2, 1, 60),
    (3, 3, 100),
    (3, 5, 19);
    
    
INSERT INTO cliente (
    nome,
    cpf,
    email,
    telefone,
    cep,
    logradouro,
    numero,
    complemento,
    bairro,
    cidade,
    estado
)
VALUES
	('João Neto', '44761235448', 'joao@email.com', 
    '(44) 01234-5678', '89324543', 'Rua Iracema', 
    '47', NULL, 'Jardim Guaratuba', 'Maringá', 'PR'),
    ('Mariana Vargas', '98765432100', 'mariana@email.com',
     '(41) 98888-7777', '46275241', 'Av. Paraná',
     '1200', NULL, 'Centro', 'Curitiba', 'PR'),
     ('Lucas Fernandes', '45678912300', 'lucas@email.com',
     '(43) 97777-6666', '47524862', 'Rua Santos Dumont',
     '85', 'Casa 2', 'Centro', 'Londrina', 'PR');
     
     
INSERT INTO pedido (id_cliente, id_centro)
VALUES
    (1, 1),
    (2, 1),
    (3, 3);
    
    
INSERT INTO item_pedido (
    id_pedido,
    id_produto,
    quantidade,
    preco_unitario
)
VALUES
	(1, 1, 1, 3299.90),
    (1, 3, 2, 79.90),
    (2, 2, 2, 799.90),
    (2, 4, 1, 229.90),
    (3, 5, 1, 449.90);
    
    
UPDATE pedido
SET valor_total = COALESCE((
    SELECT SUM(quantidade * preco_unitario)
    FROM item_pedido
    WHERE item_pedido.id_pedido = pedido.id_pedido
), 0.00)
WHERE id_pedido IN (1, 2, 3);


INSERT INTO entregador (
	nome,
    cpf,
    telefone,
    cnh,
    categoria_cnh,
    data_validade_cnh
)
VALUES
    ('Carlos Oliveira', '12345678901', '44999998888', '12345678901', 'B', '2030-05-15'),
    ('Rafael Mendes', '23456789012', '41988887777', '23456789012', 'D', '2029-08-20'),
    ('Pedro Almeida', '34567890123', '43977776666', '34567890123', 'AB', '2031-02-10');
    
    
INSERT INTO veiculo (
	placa, 
    modelo, 
    marca, 
    ano_fabricacao, 
    capacidade_kg, 
    tipo_veiculo
)
VALUES
    ('ABC1D23', 'Sprinter', 'Mercedes-Benz', 2022, 1500.00, 'VAN'),
    ('DEF4G56', 'Delivery 9.170', 'Volkswagen', 2023, 3500.00, 'CAMINHAO'),
    ('GHI7J89', 'CG 160', 'Honda', 2024, 150.00, 'MOTO');
    

INSERT INTO entrega (
    id_pedido,
    id_entregador,
    id_veiculo
)
VALUES
    (1, 1, 1),
    (2, 2, 2),
    (3, 3, 3);
    
    
UPDATE entrega
SET
    status_entrega = 'EM_TRANSITO',
    data_saida = NOW()
WHERE id_entrega = 1;

UPDATE entrega
SET
    status_entrega = 'ENTREGUE',
    data_entrega = NOW()
WHERE id_entrega = 1;

UPDATE entrega
SET
    status_entrega = 'EM_TRANSITO',
    data_saida = NOW()
WHERE id_entrega = 2;

UPDATE entrega
SET
    status_entrega = 'FALHA_ENTREGA',
    data_entrega = NULL
WHERE id_entrega = 2;