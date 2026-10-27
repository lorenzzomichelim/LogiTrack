# LogiTrack — Sistema de Gerenciamento Logístico

Projeto de banco de dados relacional desenvolvido em MySQL 8 para uma empresa fictícia, a **NexCargo Transportes**.

O objetivo é organizar informações relacionadas a clientes, pedidos, produtos, centros de distribuição, estoque e entregas, utilizando recursos do SQL para automatizar operações e gerar relatórios.

## Tecnologias utilizadas

- MySQL 8
- MySQL Workbench
- SQL

## Funcionalidades

- Cadastro de clientes, produtos e pedidos.
- Controle de estoque por centro de distribuição.
- Gerenciamento de entregas, entregadores e veículos.
- Cálculo automático do valor total dos pedidos.
- Atualização automática do estoque ao inserir, alterar ou excluir itens.
- Bloqueio de operações com estoque insuficiente.
- Consultas e relatórios por meio de VIEWs.
- Operações reutilizáveis utilizando Stored Procedures.

## Modelagem do banco de dados

O banco possui nove tabelas relacionadas:

`cliente`, `produto`, `pedido`, `item_pedido`, `centro_distribuicao`, `estoque`, `entregador`, `veiculo` e `entrega`.

### Diagrama de relacionamentos

![Diagrama do banco de dados](imagens/diagrama_logitrack.png)

## VIEWs

| VIEW | Finalidade |
|---|---|
| vw_relatorio_entregas | Relatório detalhado das entregas |
| vw_faturamento_cliente | Faturamento por cliente |
| vw_clientes_acima_1000 | Clientes com faturamento superior a R$ 1.000 |
| vw_entregas_pendentes | Consulta de entregas pendentes |
| vw_resumo_entregas | Resumo das situações das entregas |

## Triggers

O projeto utiliza sete triggers para automatizar o cálculo do valor total dos pedidos, controlar as movimentações de estoque e impedir a alteração do centro de distribuição de pedidos que já possuem itens.

## Stored Procedures

Foram implementadas três procedures:

- `sp_cadastrar_pedido`: cadastra um pedido.
- `sp_adicionar_item_pedido`: adiciona um produto ao pedido.
- `sp_atualizar_status_entrega`: atualiza a situação de uma entrega.

## Como executar

**Pré-requisito:** MySQL 8.

Execute os arquivos SQL na seguinte ordem:

1. `01_estrutura.sql` — Criação do banco e das tabelas.
2. `02_dados.sql` — Inserção dos dados iniciais.
3. `03_views.sql` — Criação das VIEWs.
4. `04_triggers.sql` — Criação das triggers.
5. `05_procedures.sql` — Criação das procedures.

Após a execução, o banco estará disponível para consultas e operações.

## Objetivo acadêmico

Projeto desenvolvido para colocar em prática conhecimentos de modelagem relacional, SQL, relacionamentos, JOINs, VIEWs, triggers e stored procedures.
