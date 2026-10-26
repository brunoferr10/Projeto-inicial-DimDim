# Roteiro de gravação — Checkpoint Pipelines CI/CD

## Antes de começar

Grave em pelo menos 720p e explique o que está demonstrando. Prepare as abas do Azure DevOps, Azure Portal, aplicação e terminal. Não mostre PAT, senhas, chaves SSH ou App Settings com valores sensíveis. Evite cortes que escondam a sequência do PR, Build e Release.

A gravação de ponta a ponta começa **antes da alteração de código**. Não faça o merge primeiro para depois apenas mostrar a pipeline pronta.

Condições antes da gravação:

- Projeto em Azure Repos, Task em Active e branch feature/checkpoint vinculada.
- Políticas de main: revisor, Work Item obrigatório e revisor padrão conforme enunciado.
- CI e Release já testados manualmente, com sucesso.
- Gatilho CI em main, gatilho de Release no artefato e stage automático habilitados.
- App Service e banco PaaS criados via script, com DDL aplicado.
- Conexão psql funcionando na VM e variáveis de conexão configuradas sem exibir senhas.

## Cena 1 — Apresentação

Fala sugerida: “Este é o projeto DimDim de gerenciamento de clientes e pedidos, desenvolvido em Java com Spring Boot. Vamos demonstrar a integração do Boards, Repos e Pipelines, com build, testes e implantação automática no Azure.”

Mostre o README com os cinco integrantes. Mostre as duas tabelas relacionadas em script.sql. Apresente a Task e seu vínculo com a branch. Mostre as políticas da main e a página do Azure Portal com os recursos criados pelos scripts do repositório.

## Cena 2 — Alteração real no código

Na VM, na raiz do repositório, com a árvore limpa:

```bash
git fetch origin
git switch feature/checkpoint
```

Se a branch existe só no remoto, use `git switch --track origin/feature/checkpoint`. Confirme a branch com git status.

Abra src/main/java/br/com/fiap/dimdim/ApiController.java e altere a mensagem do endpoint /api/versao de **DimDim em nuvem** para **DimDim atualizado pelo CI/CD**. Mostre o diff:

```bash
git diff
mvn -B clean verify
git add src/main/java/br/com/fiap/dimdim/ApiController.java
git commit -m "Atualiza mensagem da API AB#NUMERO_REAL_DA_TASK"
git push -u origin feature/checkpoint
```

Substitua NUMERO_REAL_DA_TASK pelo número real. Não altere só README: o professor exige alteração em código visível no teste da aplicação.

## Cena 3 — PR e merge

Abra PR de feature/checkpoint para main. Mostre a Task vinculada e os arquivos alterados. Aprove conforme as políticas configuradas e o enunciado. Conclua o PR **sem apagar a branch** e com a opção de concluir o Work Item associado. Mostre o PR concluído e a Task finalizada.

## Cena 4 — CI automático

Mostre que o Build iniciou por causa do merge, sem clicar em Run pipeline. Abra os logs de compilação e execução dos testes. Mostre a aba Tests, os seis testes aprovados e o artefato drop com target/app.jar. Não confunda o Build manual de preparação com essa execução automática.

## Cena 5 — Release automática

Mostre a Release criada automaticamente a partir do Build concluído, o número/ID do Build de origem e o stage de implantação. Abra os logs da tarefa Azure CLI e confirme sucesso. A Release usa o JAR gerado pelo CI, não um novo build manual.

Abra a URL externa HTTPS do App Service no navegador ou terminal:

```bash
curl -fsS https://SEU_APP.azurewebsites.net/api/versao
curl -fsS https://SEU_APP.azurewebsites.net/actuator/health
```

Mostre a mensagem atualizada e saúde UP. Substitua SEU_APP pelo nome real.

## Cena 6 — CRUD completo e evidências no banco PaaS

Na VM, configure as variáveis conforme a seção 8 do README antes de gravar a tela de terminal que poderia expor credenciais. Use PGHOST, PGUSER, PGDATABASE, PGSSLMODE e PGPASSWORD do banco real. Na raiz:

```bash
export BASE_URL=https://SEU_APP.azurewebsites.net
python3 scripts/demonstrar-crud.py
```

O script pausa após cada operação e mostra SELECT nas duas tabelas com psql conectado diretamente ao banco em nuvem. Explique e mostre:

1. Cliente criado — POST 201; registro no SELECT.
2. Cliente consultado — GET 200; dados confirmados no SELECT.
3. Cliente atualizado — PUT 200; alteração confirmada no SELECT.
4. Pedido criado vinculado ao cliente — POST 201; relação confirmada no SELECT.
5. Pedido consultado — GET 200; registro confirmado no SELECT.
6. Pedido atualizado — PUT 200; alteração confirmada no SELECT.
7. Pedido excluído — DELETE 204; ausência confirmada no SELECT.
8. Cliente excluído — DELETE 204; ausência confirmada no SELECT.

Não apague o cliente antes do pedido: a FK impede. Se preferir executar a coleção Postman, altere baseUrl para o App Service e mantenha os SELECTs após cada operação. O script de demonstração utiliza IDs retornados pela API e não presume que o primeiro registro será 1.

## Cena 7 — Encerramento e entrega

Mostre o repositório com código, DDL, scripts de infraestrutura, JSONs, YAML e documentação. Confirme o acesso do professor no projeto e na organização sem expor credenciais. O PDF contém uma indicação ambígua entre administrador e Contributor; siga a orientação confirmada com o professor.

Publique o vídeo no YouTube com acesso permitido ao avaliador e teste o link. Preencha os links reais no README. Prepare o PDF final com nome do grupo, cinco integrantes/RMs, URL Azure DevOps e URL YouTube. O representante faz o upload no Teams.

## Conferência da gravação

Antes de enviar, assista ao vídeo e confirme: alteração Java visível, Task vinculada, PR aprovado, branch preservada, CI/CD automáticos, testes publicados, recursos no Portal e todas as operações CRUD com SELECT diretamente no banco PaaS. Se faltar uma evidência, regrave a sequência necessária com clareza.
