# DimDim — Clientes e Pedidos | Checkpoint CI/CD

Projeto Java novo para o checkpoint, sem reaproveitar as Sprints. API REST com Spring Boot 3.5.7, Java 17, Maven e PostgreSQL 16. Relação: um cliente tem vários pedidos. Testes JUnit/MockMvc com H2 em modo PostgreSQL; produção usa PostgreSQL real e valida o DDL de script.sql.

## Comece aqui

Leia **GUIA-APPSERVICE.md** para o destino de implantação previsto no PDF, combinado com **GUIA-AZURE-DEVOPS.md** para Boards/Repos/CI/agente. É necessário configurar sua organização, agente, Boards, políticas e Release; esses recursos não são criados apenas com o push do Git.

Este pacote não foi implantado na sua assinatura e não inclui evidências fictícias. O status de verificação local está em VALIDACAO.md.

## Executar na VM Ubuntu 24.04

```bash
bash scripts/02-preparar-vm-existente.sh
# Saia do SSH e entre novamente.
cp .env.example .env
chmod 600 .env
nano .env
# Substitua o valor de DB_PASSWORD. Não suba .env para o Git.
mvn -B clean verify
IMAGE_TAG=local docker compose -p dimdim up -d --build --wait
curl http://localhost:8080/actuator/health
curl http://localhost:8080/api/versao
```

A senha deve ser a mesma no .env e na variável secreta da Release. Alterar POSTGRES_PASSWORD após inicializar um volume não muda a senha existente do PostgreSQL.

## Endpoints

| Recurso | Rotas |
|---|---|
| Clientes | GET/POST /api/clientes; GET/PUT/DELETE /api/clientes/{id} |
| Pedidos | GET/POST /api/pedidos; GET/PUT/DELETE /api/pedidos/{id} |
| Versão para o vídeo | GET /api/versao |
| Saúde | GET /actuator/health |

Corpos JSON em json/. clienteId deve ser o ID real retornado na criação de cliente. DELETE não leva corpo. Respostas: criação 201; consulta/atualização 200; exclusão 204; inválidos 400; ausentes 404; conflito 409. Exclua pedidos antes dos clientes.

## Evidências de CRUD no banco

Na pasta do repositório, na VM:

```bash
python3 scripts/demonstrar-crud.py
```

O script cria registros próprios, mostra cada resposta, consulta as duas tabelas diretamente com psql e pausa a cada etapa. Ao final exclui apenas os registros que criou. Se interrompido, os registros já criados permanecem no banco.

## Observações de ambiente

Aplicação acadêmica de demonstração: API sem autenticação, HTTP na porta 8080, sem dados pessoais reais. Banco sem porta pública e com volume persistente. Não use como serviço público de produção sem autenticação, TLS e política de backup. Acesso do agente ao Docker permite administrar a VM: restrinja quem altera as pipelines.

A VM e os discos podem gerar cobrança. A localização e o tamanho dependem da disponibilidade da assinatura. Parar/desalocar a VM não exclui todos os custos de disco/IP. Recursos podem ser removidos pelo portal após a correção do professor, quando não forem mais necessários.
