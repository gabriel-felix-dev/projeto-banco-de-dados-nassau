CREATE DATABASE gestao_eventos;

USE gestao_eventos;

CREATE TABLE organizacao(
    idOrganizacao INT PRIMARY KEY AUTO_INCREMENT,
    nome VARCHAR (100) NOT NULL,
    telefone VARCHAR(100) NOT NULL
);
CREATE TABLE bairro(
    idBairro INT PRIMARY KEY AUTO_INCREMENT,
    nome VARCHAR (100) NOT NULL,
);
CREATE TABLE morador(
    idMorador INT PRIMARY KEY AUTO_INCREMENT,
    nome VARCHAR (100) NOT NULL,
    cpf VARCHAR(11) NOT NULL,
    FK_idBairro INT NOT NULL,
    CONSTRAINT fk_morador_bairro FOREING KEY (FK_idBairro) REFERENCES bairro (idBairro)
);
CREATE TABLE evento(
    idEvento INT PRIMARY KEY AUTO_INCREMENT,
    titulo VARCHAR (100) NOT NULL,
    data_evento DATE NOT NULL, 
    qtd_vagas INT NOT NULL,
    FK_idOrganizacao INT NOT NULL,
    CONSTRAINT fk_evento_organizacao FOREING KEY (FK_idOrganizacao) REFERENCES organizacao (idOrganizacao),
    FK_idBairro INT NOT NULL,
    CONSTRAINT fk_evento_bairro FOREING KEY (FK_idBairro) REFERENCES bairro (idBairro)
);
CREATE TABLE inscricao(
    idInscricao INT PRIMARY KEY AUTO_INCREMENT,
    data_evento DATE NOT NULL, 
    FK_idMorador INT NOT NULL,
    CONSTRAINT fk_inscricao_morador FOREING KEY (FK_idMorador) REFERENCES morador (idMorador),
    FK_idEvento INT NOT NULL,
    CONSTRAINT fk_inscricao_evento FOREING KEY (FK_idEvento) REFERENCES evento (idEvento)
);
