# Guia de execução — Bruno Ferreira RM 563489

## 1. Preparar o código e a VM

Extraia o ZIP. Use uma VM Ubuntu 24.04 x64 com pelo menos 2 vCPUs e 4 GB de RAM. Se já tem VM, use scripts/02-preparar-vm-existente.sh nela. Para criar uma nova por script (requisito do trabalho), envie o projeto ao Cloud Shell Bash, entre na pasta e execute:

```bash
az account show -o table
export SSH_SOURCE_CIDR=SEU_IP_PUBLICO/32
bash scripts/01-criar-vm.sh
```

A VM padrão tem usuário azureuser. Se mudar ADMIN no script, ajuste também o usuário no cloud-init.yml. Confirme assinatura antes de criar. A API ficará em http://IP_PUBLICO:8080. SSH é liberado só para o CIDR informado; PostgreSQL não tem porta pública.

Entre com `ssh azureuser@IP_PUBLICO`. Aguarde `sudo cloud-init status --wait` e confira `docker compose version`, `mvn -version`, `java -version`. Faça novo login para carregar grupo Docker. Mostre no Portal Azure os recursos criados pelo script.

## 2. Criar Azure DevOps e subir Git

Crie projeto privado **DimDim-Checkpoint**, versionamento Git, processo **Agile**. No Boards, crie uma Task **Implementar DimDim no Azure DevOps**, atribua a você e altere para Active. Anote o ID.

Crie Repos vazio. Na VM (ou no computador), dentro da pasta extraída:

```bash
git init -b main
git add .
git commit -m "Projeto inicial DimDim"
git remote add origin https://dev.azure.com/SUA_ORGANIZACAO/DimDim-Checkpoint/_git/DimDim-Checkpoint
git push -u origin main
```

Use o URL exato do seu Repos. Autentique pelo método oferecido pelo Azure DevOps; não coloque tokens na URL nem nos arquivos. Não envie .env.

## 3. Agente na VM

Em Organization settings > Agent pools, crie **DimDimPool**, tipo Self-hosted. Autorize esse pool no projeto. Em New agent > Linux x64, siga os comandos de download atuais apresentados pelo Azure DevOps (não há URL antiga fixada neste pacote).

Instale em uma pasta fora do repositório, por exemplo ~/azagent. Execute config.sh como azureuser, com URL da organização e pool DimDimPool. Use PAT temporário apenas com escopo Agent Pools (Read & manage), conforme necessário para registro. Digite quando solicitado e não grave no Git. O agente deve executar como azureuser, com acesso ao Docker.

Depois do registro:

```bash
sudo ./svc.sh install azureuser
sudo ./svc.sh start
```

Confirme Online no pool. Reinicie o serviço após alterações de grupo/permissão. Neste projeto CI e Release usam o mesmo pool com um único agente na VM de destino. Assim a Release implanta na VM correta. Não coloque outra VM nesse pool sem adicionar demanda para fixar o destino.

## 4. Pipeline de Build (CI)

Pipelines > New pipeline > Azure Repos Git > seu repositório > Existing Azure Pipelines YAML file > /azure-pipeline.yml.

Salve com nome **DimDim-CI**, autorize o pool se solicitado e execute Run pipeline. Confirme compilação, testes publicados na aba Tests e artefato **drop**. O ZIP não precisa incluir target/: Maven gera o JAR.

## 5. Release clássica (CD)

Use Pipelines > Releases > New pipeline > Empty job. Se Releases clássicas estiverem desabilitadas, um administrador precisa habilitar a criação de Release clássica nas configurações de Pipelines da organização/projeto. Não substitua silenciosamente pelo deploy manual: o enunciado pede Release.

1. Add an artifact: tipo Build, pipeline **DimDim-CI**, default version Latest. Defina Source alias exatamente **ci**.
2. No raio do artefato, habilite Continuous deployment trigger e filtre a branch main.
3. Renomeie Stage para **Azure-VM** e mantenha implantação automática após criar a release, sem aprovação manual.
4. Em Tasks > Agent job selecione **DimDimPool**. Habilite o download do artefato ci.
5. Em Variables crie **DB_PASSWORD** com cadeado (secreta), uma senha forte. Use a mesma senha em toda implantação deste banco.
6. Adicione tarefa **Bash**, tipo Inline, e use:

```bash
set -euo pipefail
bash "$(System.DefaultWorkingDirectory)/ci/drop/scripts/deploy.sh"
```

7. Na tarefa Bash, em Environment variables, mapeie explicitamente:

```text
DB_PASSWORD = $(DB_PASSWORD)
IMAGE_TAG = $(Release.Artifacts.ci.BuildId)
```

Variáveis secretas não são exportadas automaticamente para o Bash. Se sua interface não apresentar Environment variables, use a tarefa Bash pela opção YAML de definição equivalente ou a alternativa abaixo no próprio Inline (sem habilitar set -x):

```bash
set -euo pipefail
export DB_PASSWORD='$(DB_PASSWORD)'
export IMAGE_TAG='$(Release.Artifacts.ci.BuildId)'
bash "$(System.DefaultWorkingDirectory)/ci/drop/scripts/deploy.sh"
```

Na alternativa Inline, use senha forte hexadecimal (ex.: saída de `openssl rand -hex 24`), pois aspas na senha quebram essa interpolação. Prefira sempre o mapeamento de ambiente quando disponível.

Salve com nome **DimDim-CD**. Execute Create release manualmente e confirme stage verde e http://IP:8080/api/versao. A Release baixa o JAR aprovado do CI e constrói a imagem com ele; não recompila o código. Nome Compose fixo dimdim conserva o volume entre releases. Não execute docker compose down -v: apaga o banco.

## 6. Branch e políticas

Antes de proteger main, conclua o primeiro push. Abra a Task no Boards > Development > Create branch, nome **feature/checkpoint**, base main. Confirme que o vínculo foi criado.

Repos > Branches > main > Branch policies:

- Require a minimum number of reviewers: 1. Habilite a possibilidade de o solicitante aprovar a própria alteração, conforme pedido do professor. Não bloqueie o voto do último autor se isso impedir sua aprovação individual.
- Check for linked work items: Required.
- Automatically included reviewers: adicione seu usuário, identificado com seu RM, como Required.

Opcionalmente adicione Build validation com DimDim-CI. Em Azure Repos, validação de PR é configurada na política, não pelo campo pr do YAML.

## 7. Gravar fluxo completo sem cortar as evidências

```bash
git fetch origin
git checkout feature/checkpoint
# Se a branch foi criada só no portal: git checkout -b feature/checkpoint origin/feature/checkpoint
```

Em ApiController.java mude a mensagem **DimDim em nuvem** para **DimDim atualizado pelo CI/CD**. É alteração real no código e será visível no endpoint.

```bash
mvn -B clean verify
git add src/main/java/br/com/fiap/dimdim/ApiController.java
git commit -m "Atualiza mensagem publicada AB#SEU_ID_DA_TASK"
git push -u origin feature/checkpoint
```

Substitua SEU_ID_DA_TASK pelo número real. Abra PR feature/checkpoint -> main. Confira Work Item vinculado, aprove e Complete. Desmarque Delete source branch e marque Complete associated work items. Mostre a Task concluída.

Mostre CI disparando automaticamente pelo merge, resultados de testes, artefato, Release automática, logs e endpoint externo com a nova mensagem. Rode `python3 scripts/demonstrar-crud.py` na VM e grave cada CRUD com os SELECTs diretamente no PostgreSQL em nuvem. Confirme as respostas reais; não pule falhas.

## 8. Acesso do professor e entrega

Adicione pf0841@fiap.com.br à organização com Basic e ao projeto. O PDF menciona administrador e Contributor no mesmo trecho: confirme com o professor o grupo esperado. Garanta acesso efetivo antes da entrega.

Crie <nomeGrupo>_pipelines.pdf com capa, nome do grupo, nomes completos/RMs confirmados, URL do projeto e URL do vídeo YouTube. Vídeo com no mínimo 720p e explicação, incluindo etapas 6 e 7, recursos no Portal, CRUD e banco. Envie pelo representante no Teams. O PDF final depende dos links e integrantes reais e não é gerado com URLs inventadas.

## Diagnóstico rápido

- Pipeline aguardando agente: verifique pool online, autorização e capacidade de jobs da organização.
- Docker permission denied: novo login e reinício do serviço do agente após usermod.
- Banco unhealthy: confira o volume e a senha usada na primeira inicialização. Não apague volume para contornar sem preservar dados.
- Release não dispara: raio do artefato ci, branch main, Build verde e artefato drop publicado.
- HTTP externo não responde: teste localhost na VM; depois confira NSG, porta 8080 e IP público.
- Script SQL alterado após primeiro deploy: initdb roda apenas no volume vazio. Mudanças posteriores exigem migração SQL explícita.
