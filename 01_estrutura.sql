CREATE DATABASE IF NOT EXISTS logitrack;

USE logitrack;

CREATE TABLE IF NOT EXISTS cliente (
	id_cliente INT PRIMARY KEY AUTO_INCREMENT,
    nome VARCHAR(100) NOT NULL,
    cpf CHAR(11) UNIQUE NOT NULL, 
    email VARCHAR(150) UNIQUE NOT NULL,
    telefone VARCHAR(15),
    cep CHAR(8) NOT NULL,
    logradouro VARCHAR(150) NOT NULL,
    numero VARCHAR(10) NOT NULL,
    complemento VARCHAR(100),
    bairro VARCHAR(100) NOT NULL,
    cidade VARCHAR(100) NOT NULL,
    estado CHAR(2) NOT NULL,
    data_cadastro DATETIME DEFAULT CURRENT_TIMESTAMP
);

CREATE TABLE IF NOT EXISTS produto (
	id_produto INT PRIMARY KEY AUTO_INCREMENT,
    nome VARCHAR(150) NOT NULL,
    descricao TEXT NOT NULL,
    sku VARCHAR(50) UNIQUE NOT NULL,
    preco DECIMAL(10,2) NOT NULL CHECK (preco > 0),
    peso_kg DECIMAL(8,3) NOT NULL CHECK (peso_kg > 0),
    ativo BOOLEAN DEFAULT TRUE,
    data_cadastro DATETIME DEFAULT CURRENT_TIMESTAMP
);


CREATE TABLE IF NOT EXISTS centro_distribuicao (
	id_centro INT PRIMARY KEY AUTO_INCREMENT,
    nome VARCHAR(100) NOT NULL,
    cep CHAR(8) NOT NULL,
    logradouro VARCHAR(150) NOT NULL,
    numero VARCHAR(10) NOT NULL,
    bairro VARCHAR(100) NOT NULL,
    cidade VARCHAR(100) NOT NULL,
    estado CHAR(2) NOT NULL,
    capacidade_maxima INT NOT NULL CHECK (capacidade_maxima > 0),
    ativo BOOLEAN DEFAULT TRUE
);


CREATE TABLE IF NOT EXISTS pedido (
	id_pedido INT PRIMARY KEY AUTO_INCREMENT,
    id_cliente INT NOT NULL,
    FOREIGN KEY (id_cliente) REFERENCES cliente(id_cliente),
	id_centro INT NOT NULL,
    FOREIGN KEY (id_centro) REFERENCES centro_distribuicao(id_centro),
    data_pedido DATETIME DEFAULT CURRENT_TIMESTAMP,
    status_pedido VARCHAR(30) NOT NULL 
    CHECK (status_pedido IN ('PENDENTE', 'PROCESSANDO', 'ENVIADO', 'CANCELADO')) DEFAULT 'PENDENTE',
    valor_total DECIMAL(10,2) NOT NULL DEFAULT 0.00,
	CHECK (valor_total >= 0)
);
	
    
CREATE TABLE IF NOT EXISTS item_pedido (
	id_item INT PRIMARY KEY AUTO_INCREMENT,
    id_pedido INT NOT NULL,
    FOREIGN KEY (id_pedido) REFERENCES pedido(id_pedido),
    id_produto INT NOT NULL,
    FOREIGN KEY (id_produto) REFERENCES produto(id_produto),
    quantidade INT NOT NULL CHECK (quantidade > 0),
    preco_unitario DECIMAL (10,2) NOT NULL CHECK (preco_unitario > 0),
    UNIQUE (id_pedido, id_produto)
);


CREATE TABLE IF NOT EXISTS estoque (
	id_estoque INT PRIMARY KEY AUTO_INCREMENT,
    id_centro INT NOT NULL,
    FOREIGN KEY (id_centro) REFERENCES centro_distribuicao(id_centro),
    id_produto INT NOT NULL,
    FOREIGN KEY (id_produto) REFERENCES produto(id_produto),
    quantidade INT NOT NULL DEFAULT 0 CHECK (quantidade >= 0),
    ultima_atualizacao DATETIME
    DEFAULT CURRENT_TIMESTAMP
    ON UPDATE CURRENT_TIMESTAMP,
    UNIQUE (id_centro, id_produto)
);

CREATE TABLE IF NOT EXISTS entregador (
	id_entregador INT PRIMARY KEY AUTO_INCREMENT,
    nome VARCHAR(100) NOT NULL,
    cpf CHAR(11) UNIQUE NOT NULL,
    telefone VARCHAR(15) NOT NULL,
    cnh VARCHAR(11) UNIQUE NOT NULL,
    categoria_cnh VARCHAR(5) NOT NULL
    CHECK (categoria_cnh IN ('A', 'B', 'AB', 'C','D', 'E', 'AC', 'AD', 'AE')),
    data_validade_cnh DATE NOT NULL,
    ativo BOOLEAN DEFAULT TRUE,
    data_cadastro DATETIME DEFAULT CURRENT_TIMESTAMP
);

CREATE TABLE IF NOT EXISTS veiculo (
	id_veiculo INT PRIMARY KEY AUTO_INCREMENT,
    placa VARCHAR(7) UNIQUE NOT NULL,
    modelo VARCHAR(100) NOT NULL,
    marca VARCHAR(50) NOT NULL,
    ano_fabricacao YEAR NOT NULL,
    capacidade_kg DECIMAL(10,2) NOT NULL check (capacidade_kg > 0),
    tipo_veiculo VARCHAR(30) NOT NULL
		CHECK (tipo_veiculo IN ('MOTO', 'CARRO', 'VAN', 'CAMINHAO')),
    status_veiculo VARCHAR(30) NOT NULL DEFAULT 'DISPONIVEL' 
		CHECK (status_veiculo IN ('DISPONIVEL', 'EM_ENTREGA', 'MANUTENCAO', 'INATIVO'))
);

CREATE TABLE IF NOT EXISTS entrega (
    id_entrega INT PRIMARY KEY AUTO_INCREMENT,
    id_pedido INT UNIQUE NOT NULL,
    FOREIGN KEY (id_pedido) REFERENCES pedido(id_pedido),
    id_entregador INT NOT NULL,
    FOREIGN KEY (id_entregador) REFERENCES entregador(id_entregador),
    id_veiculo INT NOT NULL,
    FOREIGN KEY (id_veiculo) REFERENCES veiculo(id_veiculo),
    data_saida DATETIME,
    data_entrega DATETIME,
    CHECK (
        data_entrega IS NULL
        OR (
            data_saida IS NOT NULL
            AND data_entrega >= data_saida
        )
    ),
    status_entrega VARCHAR(30) NOT NULL DEFAULT 'PENDENTE'
        CHECK (status_entrega IN (
            'PENDENTE',
            'EM_TRANSITO',
            'ENTREGUE',
            'FALHA_ENTREGA',
            'CANCELADA'
        ))
);