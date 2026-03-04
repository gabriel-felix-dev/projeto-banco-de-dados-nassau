/*
Projeto de Banco de Dados
Prof.ª M.ª Mariana Meirelles de Mello Oliveira
Semestre: 2026.1
Data: 03/03/2026

Aula 02: Atividade - JOIN na Prática
*/

/* Questão 01: Eventos com detalhes completos

- Liste todos os eventos, mostrando:
	titulo (Evento)
	data_evento (Data)
	nome da organização (Organização)
	nome do bairro do evento (Bairro)
- Ordene por data_evento (ASC).
*/

SELECT e.titulo 'Evento', e.data_evento 'Data Evento', o.nome 'Organizacao', b.nome 'Bairro'
FROM evento e
	INNER JOIN organizacao o
	ON o.fk_idOrganizacao = e.idOrganizacao
		INNER JOIN bairro b
		ON b.fk_idBairro = e.idBairro;

/* Questão 02: Inscrições com contexto do local

- Liste as inscrições mostrando:
	nome do morador
	título do evento
	bairro do morador
	bairro do evento
- Ordene por título do evento e nome do morador.
*/

/* Questão 03: Quantos eventos cada organização realiza (incluindo organizações sem evento)

- Liste:
	nome da organização
	quantidade de eventos (Qtd Eventos)
- Inclua organizações com 0 eventos.
- Ordene do maior para o menor.
*/

/* Questão 04: Eventos ativos com inscritos (contagem)

- Liste:
	título do evento
	data do evento
	Qtd Inscritos
- Inclua eventos ativos com 0 inscritos.
- Ordene por data do evento.
*/

/* Questão 05: Vagas restantes por evento

- Liste:
	título do evento
	qtd_vagas
	Qtd Inscritos
	Vagas Restantes 
- Inclua eventos com 0 inscritos.
- Ordene por Vagas Restantes asc.
*/