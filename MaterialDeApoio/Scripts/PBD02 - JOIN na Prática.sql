/*
Projeto de Banco de Dados
Prof.ª M.ª Mariana Meirelles de Mello Oliveira
Semestre: 2026.1
Data: 03/03/2026

Aula 02: JOIN na Prática
*/

USE gestao_eventos;

-- Listar participantes e os eventos em que estão 
-- inscritos

SELECT m.nome 'Participante', e.titulo 'Evento'
FROM morador m
	INNER JOIN inscricao i
    ON i.fk_idMorador = m.idMorador
		INNER JOIN evento e
        ON e.idEvento = i.fk_idEvento;
        
-- Listar apenas evento ativos com os seus organizadores

SELECT e.titulo 'Evento', o.nome 'Organização'
FROM evento e
	INNER JOIN organizacao o
    ON o.idOrganizacao = e.fk_idOrganizacao
WHERE e.data_evento  >= curdate();

-- Quantos participantes cada evento possui?

SELECT e.titulo 'Evento', 
	   count(i.idinscricao) 'Qtd Inscritos'
FROM evento e
	LEFT JOIN inscricao i
    ON i.fk_idEvento = e.idEvento
GROUP BY e.titulo;
       
 /*
COUNT(coluna) mede quantidade de registros não nulos relacionados.
COUNT(*) mede quantidade de linhas retornadas pela consulta.
*/
