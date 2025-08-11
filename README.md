# Projeto 01 - SQL: Análise de Vendas

## Objetivo  
Construir um projeto SQL simples e completo que demonstre a modelagem de uma tabela de vendas, consultas analíticas usando joins, CTEs, agregações, indicadores de negócio, e scripts prontos para rodar localmente.

---

## Tecnologias  
- Banco de dados relacional: PostgreSQL (ou qualquer outro compatível com SQL padrão)  
- SQL (DDL, DML e Queries analíticas)

---

## Dataset  
O dataset usado é fictício e contém dados de pedidos de vendas com as seguintes colunas:  
`order_id, order_date, customer_id, customer_name, product_id, product_name, category, quantity, unit_price, total_price, channel`

Exemplo do dataset no arquivo `dataset_vendas.csv` (que acompanha este projeto):

| order_id | order_date | customer_id | customer_name | product_id | product_name    | category   | quantity | unit_price | total_price | channel     |
|----------|------------|-------------|---------------|------------|-----------------|------------|----------|------------|-------------|-------------|
| 1001     | 2024-01-03 | 501         | Rafael M      | 2001       | Camiseta Básica | Roupas     | 2        | 29.90      | 59.80       | site        |
| 1002     | 2024-01-05 | 502         | Ana S         | 2002       | Calça Jeans     | Roupas     | 1        | 119.90     | 119.90      | marketplace |
| ...      | ...        | ...         | ...           | ...        | ...             | ...        | ...      | ...        | ...         | ...         |

---

## Passo a passo para executar o projeto

1. Crie um banco PostgreSQL (ou similar):  
   ```bash
   createdb portfolio_vendas



--------------------------------------------------------------------------------------
--------------------------------------------------------------------------------------




Acesse o banco e execute o script SQL vendas.sql:

psql -d portfolio_vendas -f vendas.sql


--------------------------------------------------------------------------------------
--------------------------------------------------------------------------------------


    Explore as queries analíticas disponíveis no script para analisar os dados.

Principais queries analíticas incluídas

    Receita total e ticket médio geral

    Receita e quantidade por mês

    Top 5 produtos por receita

    Clientes com maior lifetime value (LTV) simples

    Taxa de repetição de clientes (cohort simplificado)

    Receita por canal de venda

    Crescimento de receita mês a mês (com função janela)

    Produtos com aumento recente nas vendas (query mais avançada)

Resultados esperados (exemplos simulados)

    Receita total geral: R$ 1.389,70

    Ticket médio: R$ 138,97

    Top produto: "Tênis Corrida" com R$ 499,80 em receita

    Taxa de repetição de clientes: 40%

Próximos passos e melhorias

    Normalizar o modelo criando tabelas dimensão (dim_cliente, dim_produto, dim_tempo) e fato_vendas

    Criar views materializadas para KPIs críticos

    Implementar procedures para carga incremental e validação de dados

    Adicionar testes automatizados com dbt ou outras ferramentas

    Expandir dataset para benchmarks e análises mais robustas

    Migrar para formatos Parquet/Delta e integrar com Lakehouse (Databricks)

Contato

Este projeto foi desenvolvido para portfólio de Engenharia de Dados Júnior.
Para dúvidas ou sugestões, entre em contato: raphaelmazoflynx@gmail.com