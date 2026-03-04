CREATE DATABASE IF NOT EXISTS gestao_eventos;

USE gestao_eventos;

CREATE TABLE IF NOT EXISTS organizacao(
    idOrganizacao INT AUTO_INCREMENT PRIMARY KEY ,
    nome VARCHAR (100) NOT NULL,
    telefone VARCHAR(20) NOT NULL
) ENGINE=InnoDB;

CREATE TABLE IF NOT EXISTS bairro(
    idBairro INT AUTO_INCREMENT PRIMARY KEY,
    nome VARCHAR (100) NOT NULL
) ENGINE=InnoDB;

CREATE TABLE IF NOT EXISTS morador(
    idMorador INT AUTO_INCREMENT PRIMARY KEY,
    nome VARCHAR (100) NOT NULL,
    cpf VARCHAR(14) NOT NULL UNIQUE,
    fk_idBairro INT NOT NULL,
    CONSTRAINT fk_morador_bairro 
    FOREIGN KEY (fk_idBairro) REFERENCES bairro (idBairro)
) ENGINE=InnoDB;

CREATE TABLE IF NOT EXISTS evento(
    idEvento INT AUTO_INCREMENT PRIMARY KEY,
    titulo VARCHAR (100) NOT NULL,
    data_evento DATE NOT NULL, 
    qtd_vagas INT NOT NULL,
    fk_idOrganizacao INT NOT NULL,
    fk_idBairro INT NOT NULL,
    CONSTRAINT fk_evento_organizacao 
    FOREIGN KEY (fk_idOrganizacao) REFERENCES organizacao (idOrganizacao),
    CONSTRAINT fk_evento_bairro 
    FOREIGN KEY (fk_idBairro) REFERENCES bairro (idBairro),
    CONSTRAINT chk_evento_qtd_vagas
    CHECK (qtd_vagas > 0)
) ENGINE=InnoDB;

CREATE TABLE IF NOT EXISTS inscricao(
    idInscricao INT AUTO_INCREMENT PRIMARY KEY,
    data_hora DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP, 
    fk_idMorador INT NOT NULL,
    fk_idEvento INT NOT NULL,
    CONSTRAINT uq_inscricao_evento_morador
    UNIQUE (fk_idMorador, fk_idEvento),
    CONSTRAINT fk_inscricao_morador 
    FOREIGN KEY (fk_idMorador) REFERENCES morador (idMorador),
    CONSTRAINT fk_inscricao_evento 
    FOREIGN KEY (fk_idEvento) REFERENCES evento (idEvento)
) ENGINE=InnoDB;
