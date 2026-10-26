# DimDim — Clientes e Pedidos | Checkpoint CI/CD

Projeto Java novo para o checkpoint, sem reaproveitar as Sprints. API REST com Spring Boot 3.5.7, Java 17, Maven e PostgreSQL 16. Relação: um cliente tem vários pedidos. Testes JUnit/MockMvc com H2 em modo PostgreSQL; produção usa PostgreSQL real e valida o DDL de script.sql.

## Identificação acadêmica

- **Instituição:** FIAP
- **Curso:** Análise e Desenvolvimento de Sistemas
- **Disciplina:** DevOps Tools & Cloud Computing
- **Professor:** João Menk
- **Avaliação:** 3º Checkpoint do 2º Semestre — Pipelines CI/CD
- **Projeto:** DimDim — Clientes e Pedidos

| Integrante | RM |
|---|---|
| Hebert Lopes do Santos | 563192 |
| Nicolas Monteiro Ramiro | 562380 |
| Marcus Vinícius Vila Nova da Silva | 558771 |
| Gabriel Robertoni Padilha | 566293 |
| Bruno Ferreira | 563489 |

## Objetivo e arquitetura

Gerenciar clientes e pedidos por API REST, mantendo relacionamento de um cliente para muitos pedidos. A integração no Azure DevOps liga Task, branch, PR, Build com testes e Release automática.

**Caminho recomendado para a entrega:** VM Ubuntu como estação de trabalho/agente, Azure Repos para código, CI gerando JAR, Release clássica publicando esse JAR no Azure App Service e PostgreSQL Flexible Server para os dados. App Service e banco são criados por script. A configuração inicial do Boards, agente, conexão Azure e Release é descrita nos guias.

**Alternativa para testes:** aplicação e PostgreSQL em Docker na própria VM. Consulte o professor antes de adotar essa alternativa como destino final, pois o PDF cita App Service ou ACR/ACI.

## Ordem para começar

1. [INICIE-AQUI.md](INICIE-AQUI.md): atualizar o Git já existente e começar na VM.
2. [GUIA-AZURE-DEVOPS.md](GUIA-AZURE-DEVOPS.md): Boards, Repos, agente, Build e políticas.
3. [GUIA-APPSERVICE.md](GUIA-APPSERVICE.md): infraestrutura, DDL e Release para App Service.
4. [ROTEIRO-VIDEO.md](ROTEIRO-VIDEO.md): gravação do fluxo completo e evidências de CRUD.
5. [VALIDACAO.md](VALIDACAO.md): verificações executadas e limitações.

## Links da entrega

Preencha esta tabela com os endereços reais após configurar os serviços. O código não depende desses campos.

| Item | Endereço |
|---|---|
| Projeto Azure DevOps | A preencher após criação |
| Aplicação no App Service | A preencher após implantação |
| Vídeo no YouTube | A preencher após gravação |

O nome do grupo para o arquivo final deve ser confirmado pelos integrantes. O título DimDim é o nome do projeto, não um nome de grupo confirmado.

## Arquivos principais

| Caminho | Finalidade |
|---|---|
| `src/main/` | API Java e configuração por ambiente |
| `src/test/` | Seis testes automatizados |
| `pom.xml` | Dependências e build Maven |
| `script.sql` | DDL com duas tabelas relacionadas |
| `azure-pipeline.yml` | CI: compilar, testar e publicar artefato drop |
| `scripts/` | Criação de recursos, deploy e evidências |
| `json/` | Corpos de requisição de criação e atualização |
| `DimDim.postman_collection.json` | Dez operações, com captura dos IDs |
| `Dockerfile` e `docker-compose.yml` | Execução em containers para testes |

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

Para o caminho App Service, configure as variáveis de conexão PostgreSQL, `BASE_URL` e `DB_MODE=paas` conforme [GUIA-APPSERVICE.md](GUIA-APPSERVICE.md). Depois, na pasta do repositório, na VM:

```bash
python3 scripts/demonstrar-crud.py
```

Sem `DB_MODE=paas`, o script usa a aplicação local e consulta o PostgreSQL em Docker.

O script cria registros próprios, mostra cada resposta, consulta as duas tabelas diretamente com psql e pausa a cada etapa. Ao final exclui apenas os registros que criou. Se interrompido, os registros já criados permanecem no banco.

## Observações de ambiente

Aplicação acadêmica de demonstração, sem autenticação: use apenas dados de teste. No caminho Docker, HTTP na porta 8080 e banco sem porta pública, com volume persistente. No caminho App Service, acesso externo por HTTPS e PostgreSQL gerenciado com TLS. Não use como serviço público de produção sem autenticação, TLS e política de backup. Acesso do agente ao Docker permite administrar a VM: restrinja quem altera as pipelines.

A VM e os discos podem gerar cobrança. A localização e o tamanho dependem da disponibilidade da assinatura. Parar/desalocar a VM não exclui todos os custos de disco/IP. Recursos podem ser removidos pelo portal após a correção do professor, quando não forem mais necessários.
