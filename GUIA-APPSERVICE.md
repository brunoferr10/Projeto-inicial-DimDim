# Destino de implantação previsto no PDF: App Service + PostgreSQL PaaS

**Use este caminho para seguir as opções de hospedagem citadas pelo professor.** A VM continua como ambiente de trabalho e agente DimDimPool; o aplicativo vai para App Service e o banco para PostgreSQL gerenciado. O caminho Docker na VM é uma alternativa técnica para demonstração/local; não presuma que substitui as opções do PDF sem confirmação do professor.

## 1. Criar recursos por script

Execute no Cloud Shell Bash, na raiz do projeto. Confirme a assinatura com az account show. Os serviços geram cobrança; disponibilidade/quota variam. Use nomes únicos minúsculos, com letras, números e hífen.

```bash
export RG=rg-dimdim-rm563489
export LOCATION=canadacentral
export APP_NAME=dimdim-rm563489-SEU_SUFIXO
export PG_SERVER=pg-dimdim-rm563489-SEU_SUFIXO
read -rsp 'Senha forte PostgreSQL: ' DB_PASSWORD; echo
export DB_PASSWORD
bash scripts/03-criar-appservice.sh
```

Não cole senhas nos arquivos, não habilite set -x, nem grave a tela enquanto digita credenciais. O script configura senha como App Setting do Azure, não no Git. Esse caminho não utiliza Docker em produção; os arquivos Docker permanecem úteis para testar na VM.

## 2. Executar o DDL no banco PaaS

Instale psql no Cloud Shell ou na VM (`sudo apt-get install -y postgresql-client`). Use o mesmo DB_PASSWORD e nomes do passo anterior na sessão onde executará psql. Se executar na VM, autentique o Azure CLI primeiro. Como o comando será executado dentro do Azure, a regra AllowAzureServices permite acesso; conexões de computador externo exigem regra restrita ao seu IP.

```bash
export PGHOST="$PG_SERVER.postgres.database.azure.com"
export PGUSER=dimdimadmin
export PGDATABASE=dimdim
export PGSSLMODE=require
export PGPASSWORD="$DB_PASSWORD"
psql -v ON_ERROR_STOP=1 -f script.sql
psql -c '\dt'
```

A regra AllowAzureServices abrange endereços de serviços Azure de outras assinaturas, com autenticação obrigatória. Para um ambiente de produção, restrinja por rede privada ou endereços de saída efetivos do aplicativo.

## 3. CI e Release

Siga GUIA-AZURE-DEVOPS.md para Boards, Repos, agente, CI, políticas e PR. **Substitua apenas a implantação Docker do passo 5 pelo procedimento abaixo.** Não configure as duas alternativas na mesma Release.

Project settings > Service connections > New service connection > Azure Resource Manager. Prefira Workload identity federation; selecione a assinatura correta e escopo do grupo de recursos. Nome **sc-dimdim-azure**. Autorize somente a pipeline necessária. Se não tiver permissão para criar a conexão, o administrador da assinatura deve conceder as permissões necessárias.

Crie Release clássica DimDim-CD com artefato Build DimDim-CI, alias **ci**, Continuous deployment trigger habilitado para main e stage automático. Agent pool DimDimPool. Em Variables, crie **RG** e **APP_NAME** com os valores reais (não secretos). A senha do banco já está no App Service: a Release não precisa recebê-la.

Adicione tarefa **Azure CLI**, versão 2, Azure subscription **sc-dimdim-azure**, Script type Bash, Script location Inline script:

```bash
set -euo pipefail
export RG='$(RG)'
export APP_NAME='$(APP_NAME)'
bash "$(System.DefaultWorkingDirectory)/ci/drop/scripts/deploy-appservice.sh"
```

Use somente nomes Azure válidos nos campos RG e APP_NAME. A VM do agente precisa do Azure CLI: instale pela orientação oficial para Ubuntu antes de executar essa tarefa:
https://learn.microsoft.com/cli/azure/install-azure-cli-linux?pivots=apt

Execute uma Release manual, depois mostre o CI/CD automático após o merge do PR. O script implanta exatamente o JAR do artefato do CI em App Service. Verifique https://SEU_APP.azurewebsites.net/api/versao e /actuator/health.

## 4. CRUD e SELECT no PaaS

A coleção Postman é a mesma; mude baseUrl para https://SEU_APP.azurewebsites.net. Execute cada operação e, após cada uma, rode diretamente no PostgreSQL:

```bash
psql -c 'SELECT * FROM clientes ORDER BY id;' -c 'SELECT * FROM pedidos ORDER BY id;'
```

Para automatizar as pausas e a consulta PaaS no script de demonstração:

```bash
export BASE_URL=https://SEU_APP.azurewebsites.net
export DB_MODE=paas
# Configure PGHOST, PGUSER, PGDATABASE, PGSSLMODE e PGPASSWORD como acima.
python3 scripts/demonstrar-crud.py
```

Mostre as duas tabelas no banco PaaS durante o vídeo, a aplicação externa, os recursos criados pelo script, o PR e os resultados reais das pipelines. Remova PGPASSWORD da sessão com `unset PGPASSWORD DB_PASSWORD` após concluir os comandos. Não gere o PDF final sem os links e integrantes confirmados.
