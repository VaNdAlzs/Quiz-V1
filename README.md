# Quiz Script para FiveM

Este script de Quiz para FiveM permite que os jogadores respondam a perguntas periódicas e sejam recompensados por respostas corretas. Inclui um sistema de ranking com interface gráfica (UI) para mostrar os melhores jogadores.

---

## Funcionalidades

- Perguntas automáticas enviadas a cada X segundos (configurável).
- Tempo limitado para responder a cada pergunta.
- Recompensas configuráveis em dinheiro ou itens.
- Sistema de ranking com armazenamento em base de dados (MySQL).
- Interface gráfica para visualizar o ranking com comando dedicado.
- Suporte para frameworks ESX e QBCore.
- Notificações via OkOkNotify ou chat padrão.
- Logs das respostas no Discord através de webhook.
- Reset semanal do ranking 

---

## Configuração

No ficheiro `config.lua` podes definir:

- Framework a usar: `"esx"` ou `"qbcore"`.
- Intervalo entre perguntas (`QuestionInterval`).
- Tempo limite para responder (`AnswerTimeLimit`).
- Tipo e valor da recompensa.
- Webhook do Discord para logs.
- Uso do OkOkNotify para notificações.

---

## Comandos

- `/answer <resposta>` — Responder à pergunta atual.
- `/quizrank` — Abrir a UI do ranking dos jogadores.

---

## Requisitos

- Base de dados MySQL com a tabela `quiz_ranking`:

```sql
CREATE TABLE IF NOT EXISTS quiz_ranking (
    identifier VARCHAR(64) NOT NULL PRIMARY KEY,
    name VARCHAR(64) NOT NULL,
    points INT NOT NULL DEFAULT 0
);
