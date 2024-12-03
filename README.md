# Desafio técnico e-commerce
## Lógica do Carrinho de Compras

Este projeto tem como objetivo implementar a lógica de um carrinho de compras

## Funcionalidades

- Adicionar itens ao carrinho.
- Remover itens do carrinho.
- Atualizar a quantidade de itens no carrinho.
- Calcular o total do carrinho.
- Marcar carrinho como abandonado após 3 horas sem alteração.
- Descartar carrinho abandonado após 7 dias.

## Tecnologias Utilizadas

- **Ruby**: 3.3.1
- **Rails**
- **PostgreSQL**
- **Redis**
- **Sidekiq**
- **RSpec**
- **Docker**

## Rodar aplicação com Docker

1. **Construa e inicie os containers:**

   ```bash
   make down
   make build
   make up
   make test 

***É possível rodar manualmente `rails s` e `bundle exec rspec` em caso de haver algum problema com o docker.***