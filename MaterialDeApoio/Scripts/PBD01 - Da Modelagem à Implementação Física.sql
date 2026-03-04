/*
Projeto de Banco de Dados
Prof.ª M.ª Mariana Meirelles de Mello Oliveira
Semestre: 2026.1
Data: 24/02/2026

Aula 01: Da Modelagem à Implementação Física
*/

/*
OBJETIVO DO SCRIPT (Aula 01)
- Criar o banco físico a partir do modelo conceitual e lógico.
- Garantir integridade básica (PK, FK, UNIQUE e CHECK).
- Pode ser executado mais de uma vez sem erro,
  sem apagar o banco nem as tabelas (por isso usamos IF NOT EXISTS).
*/

CREATE DATABASE IF NOT EXISTS gestao_eventos;
USE gestao_eventos;

/* ============================================================
   TABELA: organizacao
   - Representa a organização responsável pelos eventos.
   - Uma organização pode organizar vários eventos (1:N).
   ============================================================ */
   
CREATE TABLE IF NOT EXISTS organizacao (
    idOrganizacao INT AUTO_INCREMENT PRIMARY KEY,   
    nome VARCHAR(100) NOT NULL,                      
    telefone VARCHAR(20) NOT NULL                    
) ENGINE=InnoDB;

/*
ENGINE=InnoDB - O que é?
É um mecanismo de armazenamento (storage engine). ENGINE=InnoDB garante que nossas chaves estrangeiras realmente funcionem e que o banco mantenha integridade.
Garante: 
	- Integridade referencial
	- Suporte a transações
	- Consistência
	- Confiabilidade
*/

/* ============================================================
   TABELA: bairro
   - Representa os bairros onde eventos ocorrem e onde moradores residem.
   - Um bairro pode ter vários eventos e vários moradores (1:N).
   ============================================================ */
   
CREATE TABLE IF NOT EXISTS bairro (
    idBairro INT AUTO_INCREMENT PRIMARY KEY,         
    nome VARCHAR(100) NOT NULL                        
) ENGINE=InnoDB;

/* ============================================================
   TABELA: morador
   - Morador possui CPF único no sistema.
   - Cada morador deve residir em exatamente um bairro (participação total),
     por isso fk_idBairro é NOT NULL.
   ============================================================ */
   
CREATE TABLE IF NOT EXISTS morador (
    idMorador INT AUTO_INCREMENT PRIMARY KEY,         
    nome VARCHAR(100) NOT NULL,                       
    cpf VARCHAR(14) NOT NULL UNIQUE,                  
    fk_idBairro INT NOT NULL,                         
    CONSTRAINT fk_morador_bairro
	FOREIGN KEY (fk_idBairro) REFERENCES bairro(idBairro)
) ENGINE=InnoDB;

/* ============================================================
   TABELA: evento
   - Cada evento pertence a 1 organização e ocorre em 1 bairro.
   - Uma organização pode ter vários eventos e um bairro pode sediar vários eventos.
   - qtd_vagas deve ser maior que 0 (regra simples de validação).
   ============================================================ */
   
CREATE TABLE IF NOT EXISTS evento (
    idEvento INT AUTO_INCREMENT PRIMARY KEY,          
    titulo VARCHAR(100) NOT NULL,                     
    data_evento DATE NOT NULL,                        
    qtd_vagas INT NOT NULL,                           
    fk_idOrganizacao INT NOT NULL,                    
    fk_idBairro INT NOT NULL,                         
    CONSTRAINT fk_evento_organizacao
    FOREIGN KEY (fk_idOrganizacao) REFERENCES organizacao(idOrganizacao),
    CONSTRAINT fk_evento_bairro
    FOREIGN KEY (fk_idBairro) REFERENCES bairro(idBairro),
    CONSTRAINT chk_evento_qtd_vagas
    CHECK (qtd_vagas > 0)
) ENGINE=InnoDB;

/*
CHECK: regra simples para não permitir vagas inválidas.
Uma constraint CHECK impõe uma regra booleana que deve ser satisfeita por cada linha da tabela. Faz validação antes de um dado ser inserido no banco.
CHECK valida o valor isoladamente dentro da linha. Se a regra depende de outra linha ou tabela, precisamos de TRIGGER.
(Obs.: em versões antigas do MySQL, CHECK pode ser ignorado) 
*/

/* ============================================================
   TABELA: inscricao
   - Entidade associativa que resolve o N:N entre morador e evento.
   - Uma inscrição pertence a exatamente 1 morador e 1 evento (FKs NOT NULL).
   - Regra: um morador NÃO pode se inscrever duas vezes no mesmo evento:
     UNIQUE (fk_idMorador, fk_idEvento).
   - data_hora registra o momento da inscrição (faz sentido ter DEFAULT agora).
   ============================================================ */
   
CREATE TABLE IF NOT EXISTS inscricao (
    idInscricao INT AUTO_INCREMENT PRIMARY KEY,       
    data_hora DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP, 
    fk_idMorador INT NOT NULL,                        
    fk_idEvento INT NOT NULL,                         
    CONSTRAINT uq_inscricao_evento_morador
	UNIQUE (fk_idMorador, fk_idEvento),
    CONSTRAINT fk_inscricao_morador
	FOREIGN KEY (fk_idMorador) REFERENCES morador(idMorador),
    CONSTRAINT fk_inscricao_evento
	FOREIGN KEY (fk_idEvento) REFERENCES evento(idEvento)
) ENGINE=InnoDB;

/* ============================================================
   OBSERVAÇÕES 
   1) NOT NULL no físico vem da participação mínima 1 no modelo (cardinalidade).
   2) UNIQUE no CPF e na inscrição implementa regras do negócio.
   3) CHECK em qtd_vagas reforça validação (e depois podemos evoluir para TRIGGER para controlar limite de vagas durante as inscrições).
   ============================================================ */
   
/* INSERÇÃO DE DADOS */
   
INSERT INTO bairro (nome) VALUES
	('Centro'), ('Manaíra'), ('Bancários'), ('Tambaú'), ('Mangabeira'),
	('Altiplano'), ('Bessa'), ('Brisamar'), ('Cristo'), ('Estados'), 
    ('Expedicionários'), ('Geisel'), ('Jaguaribe'), ('Jardim Oceania'), ('João Agripino'),
	('Miramar'), ('Pedro Gondim'), ('Planalto'), ('Portal do Sol'), ('Róger'), 
    ('Torre'), ('Treze de Maio'), ('Valentina'), ('Varadouro'), ('Cruz das Armas');

INSERT INTO organizacao (nome, telefone) VALUES
	('Associação Cultural Centro', '83999990001'),
	('ONG Juventude Ativa', '83999990002'),
	('Projeto Social Mangabeira', '83999990003'),
	('Instituto Vida Nova', '83988880001'),
	('Associação Comunitária Bessa', '83988880002'),
	('Projeto Jovem Futuro', '83988880003'),
	('Fundação Cultural Torre', '83988880004'),
	('Movimento Social Cristo', '83988880005'),
	('ONG Esperança Viva', '83988880006'),
	('Centro Educacional Miramar', '83988880007'),
	('Projeto Social Valentina', '83988880008'),
	('Grupo Cultural Róger', '83988880009'),
	('Instituto Desenvolvimento JP', '83988880010'),
	('Ação Solidária Bancários', '83988880011'),
	('Instituto Inclusão Social', '83988880012'),
	('Movimento Arte & Cultura', '83988880013'),
	('Associação Vida Melhor', '83988880014'),
	('Projeto Bairro Ativo', '83988880015');

INSERT INTO morador (nome, cpf, fk_idBairro) VALUES
('Ana Beatriz Souza', '111.111.111-11', 1),
('Carlos Henrique Lima', '222.222.222-22', 2),
('Juliana Martins', '333.333.333-33', 3),
('Pedro Almeida', '444.444.444-44', 4),
('Mariana Costa', '555.555.555-55', 5),
('Lucas Fernandes', '666.666.666-66', 2),
('Fernanda Oliveira', '777.777.777-77', 3),
('Rafael Andrade', '900.000.000-01', 6),
('Beatriz Nascimento', '900.000.000-02', 7),
('Thiago Ribeiro', '900.000.000-03', 8),
('Larissa Gomes', '900.000.000-04', 9),
('Gabriel Melo', '900.000.000-05', 10),
('Camila Duarte', '900.000.000-06', 11),
('Vinícius Araújo', '900.000.000-07', 12),
('Amanda Rocha', '900.000.000-08', 13),
('Bruno Cavalcanti', '900.000.000-09', 14),
('Isabela Freitas', '900.000.000-10', 15),
('Leonardo Barros', '900.000.000-11', 16),
('Patrícia Sales', '900.000.000-12', 17),
('Eduardo Martins', '900.000.000-13', 18),
('Natália Soares', '900.000.000-14', 19),
('Felipe Moura', '900.000.000-15', 20),
('Daniela Pires', '900.000.000-16', 21),
('Rodrigo Farias', '900.000.000-17', 22),
('Tatiane Lima', '900.000.000-18', 23),
('Gustavo Vieira', '900.000.000-19', 24),
('Vanessa Batista', '900.000.000-20', 25);

INSERT INTO evento (titulo, data_evento, qtd_vagas, fk_idOrganizacao, fk_idBairro) VALUES
	('Feira Cultural do Centro', '2026-03-15', 50, 1, 1),
	('Ação Social Manaíra', '2026-03-20', 30, 2, 2),
	('Oficina de Artes Mangabeira', '2026-04-10', 20, 3, 5),
	('Encontro Jovem Bancários', '2026-04-25', 40, 2, 3),
	('Festival Gastronômico do Altiplano', '2026-05-01', 60, 4, 6),
	('Mutirão Solidário do Bessa', '2026-05-05', 45, 5, 7),
	('Workshop de Tecnologia Brisamar', '2026-05-10', 35, 6, 8),
	('Seminário Cultural do Cristo', '2026-05-15', 50, 7, 9),
	('Feira de Empreendedorismo dos Estados', '2026-05-20', 55, 8, 10),
	('Mostra Artística de Miramar', '2026-05-25', 70, 9, 16),
	('Corrida Comunitária Torre', '2026-06-01', 80, 10, 21),
	('Palestra Educacional Valentina', '2026-06-05', 40, 11, 23),
	('Encontro Ambiental Jaguaribe', '2026-06-10', 35, 12, 13),
	('Oficina de Música Geisel', '2026-06-15', 25, 13, 12),
	('Festival Junino Mangabeira', '2026-06-20', 100, 3, 5),
	('Ação Social Portal do Sol', '2026-07-01', 45, 14, 19),
	('Capacitação Profissional Róger', '2026-07-05', 30, 15, 20),
	('Feira Literária Centro Histórico', '2026-07-10', 60, 1, 1),
	('Mutirão de Saúde Expedicionários', '2026-07-15', 50, 8, 11),
	('Festival Esportivo João Agripino', '2026-07-20', 75, 6, 15);

INSERT INTO inscricao (fk_idMorador, fk_idEvento) VALUES
	(1,1),(2,1),(3,2),(4,2),(5,3),(6,4),(7,4),
	(8,5),(9,5),(10,6),(11,6),(12,7),
	(13,8),(14,9),(15,10),
	(16,5),(17,6),(18,7),(19,8),(20,9);
