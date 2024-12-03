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

Caso receba erro de permissão relacionado ao Gemfile.lock

   ```
   tech-interview-backend-entry-level-main-test-1   | There was an error while trying to write to /rails/Gemfile.lock. It is likely
   tech-interview-backend-entry-level-main-test-1   | that you need to grant write permissions for that path.
   tech-interview-backend-entry-level-main-test-1 exited with code 23
   ```

Rode no seu console: `chmod 666 Gemfile.lock`, esse comnando ajuste as permissões do arquivo.

***É possível rodar manualmente `rails s` e `bundle exec rspec` em caso de haver algum problema com o docker.***