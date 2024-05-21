CREATE DATABASE hotel;
USE hotel;

CREATE TABLE cliente(
  cod_cliente INT NOT NULL AUTO_INCREMENT,
  nome_cliente VARCHAR(255) NOT NULL,
  telefone VARCHAR(15),
  sexo ENUM("M", "F", "O"),
  CPF VARCHAR(14),
  passaporte VARCHAR(20),
  documento TEXT,
  PRIMARY KEY (cod_cliente)
);

INSERT INTO cliente (nome_cliente, telefone, sexo, CPF, passaporte, documento) VALUES
  ('João da Silva', '(81) 98744-3772', 'M', '123.456.789-01', 'AB123456', 'RG'),
  ('Maria Santos', '(81) 99082-5345', 'F', '987.654.321-01', 'CD789012', 'RG'),
  ('Lucas Oliveira', '(54) 99741-3554', 'M', '029.433.950-72', 'XY876543', 'RG');

SELECT * FROM cliente;

CREATE TABLE nacionalidade(
  cod_sigla VARCHAR(2) NOT NULL,
  nome VARCHAR(80),
  PRIMARY KEY (cod_sigla)
);

INSERT INTO nacionalidade (cod_sigla, nome) VALUES
  ('BR', 'Brasileiro'),
  ('US', 'Americana');

SELECT * FROM nacionalidade;

CREATE TABLE tem(
  fk_cod_sigla VARCHAR(2) NOT NULL,
  fk_cod_cliente INT NOT NULL
);

ALTER TABLE tem
  ADD FOREIGN KEY (fk_cod_sigla)
  REFERENCES nacionalidade (cod_sigla);

ALTER TABLE tem
  ADD FOREIGN KEY (fk_cod_cliente)
  REFERENCES cliente (cod_cliente);

DESCRIBE tem;

INSERT INTO tem (fk_cod_sigla, fk_cod_cliente) VALUES
  ('BR', '1'), -- João da Silva
  ('US', '2'); -- Maria Santos

SELECT * FROM tem;

CREATE TABLE tipo_quarto(
  cod_tipo_quarto INT NOT NULL AUTO_INCREMENT,
  descricao_tipo ENUM('Standard', 'Master', 'Deluxe', 'Master Superior'),
  valor_tipo_quarto DECIMAL(10, 2),
  PRIMARY KEY (cod_tipo_quarto)
);

INSERT INTO tipo_quarto (descricao_tipo, valor_tipo_quarto) VALUES
  ('Standard', 150.00),
  ('Master', 250.00),
  ('Deluxe', 350.00),
  ('Master Superior', 450.00);

SELECT * FROM tipo_quarto;

CREATE TABLE quarto(
  numero_quarto INT NOT NULL AUTO_INCREMENT,
  andar INT,
  PRIMARY KEY (numero_quarto)
);

ALTER TABLE quarto
  ADD COLUMN fk_cod_tipo_quarto INT NOT NULL;

ALTER TABLE quarto
  ADD FOREIGN KEY (fk_cod_tipo_quarto)
  REFERENCES tipo_quarto (cod_tipo_quarto);

DESCRIBE quarto;

INSERT INTO quarto (numero_quarto, andar, fk_cod_tipo_quarto) VALUES
  ('10', '2', '1'),
  ('33', '5', '2');

SELECT * FROM quarto;

CREATE TABLE operadora(
  cod_operadora INT NOT NULL AUTO_INCREMENT,
  nome_operadora VARCHAR(60),
  PRIMARY KEY (cod_operadora)
);

INSERT INTO operadora (nome_operadora) VALUES
  ('Visa'),
  ('MasterCard');

SELECT * FROM operadora;

CREATE TABLE reserva(
  numero_reserva INT NOT NULL AUTO_INCREMENT,
  numero_cartao VARCHAR(19),
  quantidade_dia INT,
  data_reserva DATE,
  data_inicio DATE,
  status ENUM('Pendente', 'Confirmada', 'Cancelada', 'Concluída'),
  PRIMARY KEY (numero_reserva)
);

ALTER TABLE reserva
  ADD COLUMN fk_cod_cliente INT NOT NULL;

ALTER TABLE reserva
  ADD FOREIGN KEY (fk_cod_cliente)
  REFERENCES cliente (cod_cliente);

ALTER TABLE reserva
  ADD COLUMN fk_cod_tipo_quarto INT NOT NULL;

ALTER TABLE reserva
  ADD FOREIGN KEY (fk_cod_tipo_quarto)
  REFERENCES tipo_quarto (cod_tipo_quarto);

ALTER TABLE reserva
  ADD COLUMN fk_cod_operadora INT NOT NULL;

ALTER TABLE reserva
  ADD FOREIGN KEY (fk_cod_operadora)
  REFERENCES operadora (cod_operadora);

DESCRIBE reserva;

INSERT INTO reserva
  (numero_cartao, quantidade_dia, data_reserva, data_inicio, status, fk_cod_cliente, fk_cod_tipo_quarto, fk_cod_operadora)
VALUES
  ('4024 0071 7376 5651', '5', '2023-10-15', '2023-10-20', 'Confirmada', '1', '1', '1'),
  ('5136 0568 3724 1148', '10', '2023-11-01', '2023-11-04', 'Pendente', '2', '2', '2');

SELECT * FROM reserva;

UPDATE cliente
SET nome_cliente = 'Rafael Nascimento'
WHERE cod_cliente = '3';

DELETE FROM cliente
WHERE cod_cliente = '3';

DELETE FROM cliente
WHERE cod_cliente = 1;

SELECT * FROM cliente;

SELECT cliente.nome_cliente, nacionalidade.nome
FROM cliente
INNER JOIN tem ON cliente.cod_cliente = tem.fk_cod_cliente
INNER JOIN nacionalidade ON tem.fk_cod_sigla = nacionalidade.cod_sigla;
