# Começar com o pacote corrigido

## 1. Atualize o repositório que você já criou

Não crie outro repositório nem rode git init novamente no repositório existente.

1. Extraia o ZIP atualizado fora da pasta do seu repositório.
2. Faça backup das alterações locais que você mesmo realizou. Se já alterou código, infraestrutura ou documentação, compare antes de substituir esses arquivos.
3. Copie o **conteúdo de dimdim-pipelines** para a raiz do repositório local já existente, substituindo os arquivos deste pacote. Mantenha a pasta .git que já existe. Não coloque uma pasta dimdim-pipelines dentro da raiz.
4. Confirme que README.md, pom.xml, script.sql e azure-pipeline.yml estão diretamente na raiz.
5. No terminal da raiz do repositório, execute:

```bash
git status
git diff --stat
git add .
git diff --cached --stat
git commit -m "Completa integrantes e guias do checkpoint CI/CD"
git push
```

Revise os arquivos listados antes de confirmar o commit. Não envie .env, senhas, tokens ou chaves privadas. O ZIP inclui .gitignore e .gitattributes, mas o Git não remove automaticamente segredos que já estavam versionados.

Se você só usou o navegador e ainda não tem uma cópia local, clone primeiro:

```bash
git clone URL_REAL_DO_REPOSITORIO checkpoint-dimdim
cd checkpoint-dimdim
```

Depois copie os arquivos extraídos para essa pasta e faça o commit acima. Use a URL exata de Clone do seu repositório. O nome local checkpoint-dimdim é apenas uma pasta.

Se main já estiver protegida, faça essa atualização em uma branch e conclua via PR seguindo as políticas; não use push --force nem desative políticas para contornar a proteção.

**Se você subiu apenas no GitHub:** para este trabalho ainda é necessário importar o projeto em Azure DevOps > Repos > Import repository. O CI entregue usa Azure Repos. O GitHub sozinho não atende esse requisito.

## 2. Comece o projeto na VM Ubuntu 24.04

Entre na VM por SSH. Se ainda não há VM, use scripts/01-criar-vm.sh pelo Cloud Shell seguindo GUIA-AZURE-DEVOPS.md, passo 1. Esse script atende a evidência de criação de infraestrutura por CLI. Não crie uma segunda VM sem necessidade.

Na VM já existente:

```bash
sudo apt-get update
sudo apt-get install -y git
# Troque a URL abaixo pela URL de Clone do Azure Repos.
git clone URL_REAL_DO_AZURE_REPOS checkpoint-dimdim
cd checkpoint-dimdim
bash scripts/02-preparar-vm-existente.sh
```

Se a pasta já estiver clonada, entre nela e atualize com git pull --ff-only, com a árvore de trabalho limpa. Não execute clone dentro dela.

Saia do SSH e entre novamente, para atualizar o grupo Docker. Volte à pasta:

```bash
cd ~/checkpoint-dimdim
java -version
mvn -version
docker compose version
mvn -B clean verify
```

Resultado esperado: **BUILD SUCCESS** e **6 testes sem falhas**. Se falhar, corrija antes de configurar o vídeo. Os testes usam H2 e não dependem de um banco externo.

## 3. Configure o Azure DevOps

Siga GUIA-AZURE-DEVOPS.md:

- Passo 2: Task no Boards, atribuída a você e em Active. Se o Repos já existe, não reinicialize o Git.
- Passo 3: pool DimDimPool e agente self-hosted na VM, executando como usuário normal.
- Passo 4: pipeline CI apontando para azure-pipeline.yml, com execução manual bem-sucedida, Tests publicados e artefato drop.

## 4. Crie banco e aplicação e configure a Release

Siga **GUIA-APPSERVICE.md**, do começo ao fim. Esse é o caminho recomendado pelo pacote para as opções do PDF:

- App Service e PostgreSQL PaaS criados por script.
- script.sql executado no PostgreSQL antes de iniciar a aplicação.
- Azure CLI instalado na VM e Service Connection configurada.
- Release clássica com artefato ci, gatilho automático para main e tarefa Azure CLI.
- Release manual validada; endpoint externo e saúde acessíveis.

Não misture esse caminho com a Release Docker na VM descrita como alternativa no outro guia. Não é necessário criar .env nem executar Docker para o deploy em App Service.

## 5. Prepare as políticas e grave o vídeo

Configure o passo 6 do GUIA-AZURE-DEVOPS.md: branch criada a partir da Task e políticas de main. Antes do merge de demonstração, abra **ROTEIRO-VIDEO.md** e comece a gravar. Grave alteração real no Java, PR, CI/CD automático e CRUD com SELECT no banco em nuvem.

## 6. Finalize a entrega

Preencha os links reais no README e monte o PDF <nomeGrupo>_pipelines.pdf, com nomes/RMs e links. O nome do grupo ainda precisa ser escolhido/confirmado; não use um nome inventado pelo pacote. Confira o acesso do professor. Não encerre nem remova os recursos antes do período necessário para a correção.
