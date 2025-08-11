-- README.md
-- Projeto 01 - SQL: Análise de Vendas
-- --------------------------------------------------------
-- Objetivo
-- Construir um projeto SQL simples e completo que mostre: modelagem
de uma tabela de vendas, consultas analíticas (joins, CTEs, agregações),
indicadores de negócio e scripts prontos para rodar localmente.

-- Tecnologias
-- • Banco relacional: PostgreSQL (ou SQLite / SQL Server com pequenas adaptações)
-- • SQL (DDL + DML + Queries analíticas)

-- Conteúdo deste arquivo
-- 1) Dataset (CSV) — abaixo como comentário (dataset_vendas.csv)
-- 2) DDL — criação da tabela 'vendas'
-- 3) DML — inserts de exemplo (10 linhas)
-- 4) Consultas analíticas prontas (ex.: top produtos, receita por mês, clientes recorrentes,
--    taxa de conversão por canal, ticket médio, churn simples)

-- INSTRUÇÕES RÁPIDAS DE EXECUÇÃO (Postgres)
-- 1. Crie um banco: createdb portfolio_vendas
-- 2. No psql conectado ao banco, cole e execute este arquivo.
-- 3. Teste as queries na seção 'QUERIES ANALÍTICAS'.

-- -------------------------
-- 1) dataset_vendas.csv (exemplo)
-- -------------------------
-- order_id,order_date,customer_id,customer_name,product_id,product_name,category,quantity,unit_price,total_price,channel
-- 1001,2024-01-03,501,Rafael M,2001,Camiseta Básica,Roupas,2,29.90,59.80,site
-- 1002,2024-01-05,502,Ana S,2002,Calça Jeans,Roupas,1,119.90,119.90,marketplace
-- 1003,2024-01-08,503,João P,2003,Tênis Corrida,Calçados,1,249.90,249.90,site
-- 1004,2024-02-02,501,Rafael M,2004,Meia Esportiva,Acessórios,3,9.90,29.70,loja_fisica
-- 1005,2024-02-10,504,Mariana L,2001,Camiseta Básica,Roupas,1,29.90,29.90,site
-- 1006,2024-03-12,505,Pedro F,2005,Jaqueta Inverno,Roupas,1,299.90,299.90,marketplace
-- 1007,2024-03-15,502,Ana S,2003,Tênis Corrida,Calçados,1,249.90,249.90,site
-- 1008,2024-03-21,506,Lucas R,2006,Bermuda Praia,Roupas,2,69.90,139.80,site
-- 1009,2024-04-02,507,Sofia G,2007,Boné Casual,Acessórios,1,39.90,39.90,loja_fisica
-- 1010,2024-04-18,503,João P,2008,Relógio Digital,Acessórios,1,159.90,159.90,marketplace

-- -------------------------
-- 2) DDL — criação da tabela 'vendas'
-- -------------------------
CREATE TABLE IF NOT EXISTS vendas (
    order_id INTEGER PRIMARY KEY,
    order_date DATE NOT NULL,
    customer_id INTEGER NOT NULL,
    customer_name VARCHAR(100),
    product_id INTEGER NOT NULL,
    product_name VARCHAR(150),
    category VARCHAR(80),
    quantity INTEGER NOT NULL,
    unit_price NUMERIC(10,2) NOT NULL,
    total_price NUMERIC(12,2) NOT NULL,
    channel VARCHAR(50)
);

-- -------------------------
-- 3) DML — Inserts de exemplo
-- -------------------------
INSERT INTO vendas (order_id, order_date, customer_id, customer_name, product_id, product_name, category, quantity, unit_price, total_price, channel) VALUES
(1001,'2024-01-03',501,'Rafael M',2001,'Camiseta Básica','Roupas',2,29.90,59.80,'site'),
(1002,'2024-01-05',502,'Ana S',2002,'Calça Jeans','Roupas',1,119.90,119.90,'marketplace'),
(1003,'2024-01-08',503,'João P',2003,'Tênis Corrida','Calçados',1,249.90,249.90,'site'),
(1004,'2024-02-02',501,'Rafael M',2004,'Meia Esportiva','Acessórios',3,9.90,29.70,'loja_fisica'),
(1005,'2024-02-10',504,'Mariana L',2001,'Camiseta Básica','Roupas',1,29.90,29.90,'site'),
(1006,'2024-03-12',505,'Pedro F',2005,'Jaqueta Inverno','Roupas',1,299.90,299.90,'marketplace'),
(1007,'2024-03-15',502,'Ana S',2003,'Tênis Corrida','Calçados',1,249.90,249.90,'site'),
(1008,'2024-03-21',506,'Lucas R',2006,'Bermuda Praia','Roupas',2,69.90,139.80,'site'),
(1009,'2024-04-02',507,'Sofia G',2007,'Boné Casual','Acessórios',1,39.90,39.90,'loja_fisica'),
(1010,'2024-04-18',503,'João P',2008,'Relógio Digital','Acessórios',1,159.90,159.90,'marketplace')
ON CONFLICT (order_id) DO NOTHING; -- Postgres: evita duplicates se executar de novo

-- -------------------------
-- 4) QUERIES ANALÍTICAS (com explicações)
-- -------------------------

-- A) Receita total e ticket médio
-- Receita total geral e ticket médio por pedido
SELECT
  SUM(total_price) AS receita_total,
  AVG(total_price) AS ticket_medio
FROM vendas;

-- B) Receita e quantidade por mês (ano-mês)
SELECT
  to_char(order_date, 'YYYY-MM') AS ano_mes,
  COUNT(*) AS qtd_pedidos,
  SUM(total_price) AS receita_mes,
  AVG(total_price) AS ticket_medio
FROM vendas
GROUP BY 1
ORDER BY 1;

-- C) Top 5 produtos por receita
SELECT
  product_id,
  product_name,
  SUM(total_price) AS receita_produto,
  SUM(quantity) AS total_vendido
FROM vendas
GROUP BY product_id, product_name
ORDER BY receita_produto DESC
LIMIT 5;

-- D) Clientes com maior lifetime value (LTV) simples
SELECT
  customer_id,
  customer_name,
  COUNT(*) AS pedidos,
  SUM(total_price) AS receita_total
FROM vendas
GROUP BY customer_id, customer_name
ORDER BY receita_total DESC
LIMIT 10;

-- E) Taxa de repetição de clientes (cohort simplificado)
WITH clientes_total AS (
  SELECT DISTINCT customer_id FROM vendas
),
clientes_multiplos AS (
  SELECT customer_id
  FROM vendas
  GROUP BY customer_id
  HAVING COUNT(*) > 1
)
SELECT
  (SELECT COUNT(*) FROM clientes_multiplos)::NUMERIC / (SELECT COUNT(*) FROM clientes_total) AS taxa_repeticao
;

-- F) Receita por canal de venda
SELECT
  channel,
  COUNT(*) AS pedidos,
  SUM(total_price) AS receita,
  AVG(total_price) AS ticket_medio
FROM vendas
GROUP BY channel
ORDER BY receita DESC;

-- G) Exemplo de CTE + janela: crescimento de receita mês a mês (MM-1)
WITH receita_por_mes AS (
  SELECT
    date_trunc('month', order_date) AS mes,
    SUM(total_price) AS receita
  FROM vendas
  GROUP BY 1
)
SELECT
  mes,
  receita,
  LAG(receita) OVER (ORDER BY mes) AS receita_mes_anterior,
  CASE WHEN LAG(receita) OVER (ORDER BY mes) IS NULL THEN NULL
       ELSE ROUND((receita - LAG(receita) OVER (ORDER BY mes)) / LAG(receita) OVER (ORDER BY mes) * 100,2)
  END AS crescimento_pct
FROM receita_por_mes
ORDER BY mes;

-- H) Query mais avançada: identificar produtos com aumento de vendas recentes
WITH vendas_month AS (
  SELECT
    product_id,
    product_name,
    date_trunc('month', order_date) AS mes,
    SUM(quantity) AS qty
  FROM vendas
  GROUP BY 1,2,3
),
ranked AS (
  SELECT
    product_id,
    product_name,
    mes,
    qty,
    ROW_NUMBER() OVER (PARTITION BY product_id ORDER BY mes DESC) AS rn
  FROM vendas_month
)
SELECT
  r1.product_id,
  r1.product_name,
  r1.mes AS mes_atual,
  r1.qty AS qtd_atual,
  r2.mes AS mes_anterior,
  r2.qty AS qtd_anterior,
  (r1.qty - r2.qty) AS dif_qtd,
  CASE WHEN r2.qty IS NULL THEN NULL ELSE (r1.qty::NUMERIC - r2.qty::NUMERIC) / NULLIF(r2.qty,0) * 100 END AS pct_aumento
FROM ranked r1
LEFT JOIN ranked r2
  ON r1.product_id = r2.product_id AND r1.rn = 1 AND r2.rn = 2
WHERE r1.rn = 1
ORDER BY pct_aumento DESC NULLS LAST;

-- -------------------------
-- 5) SUGESTÕES DE MELHORIAS E PRÓXIMOS PASSOS (para o README do GitHub)
-- -------------------------
-- • Normalizar modelos criando tabelas dimensões (dim_cliente, dim_produto, dim_tempo) e uma tabela fato_vendas.
-- • Criar views materializadas para KPIs críticos.
-- • Implementar procedures para carga incremental (ETL) e validação de qualidade dos dados.
-- • Adicionar testes (ex.: dbt tests, assert SQL) e dataset maior para benchmarks.
-- • Converter para formato Parquet/Delta e integrar com Databricks (próximo projeto do portfólio).

-- FIM
