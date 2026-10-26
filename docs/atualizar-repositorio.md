# Atualizar a versão anterior do pacote

Faça backup de mudanças suas e preserve a pasta .git. Na cópia local do repositório, remova os guias/arquivos antigos que foram reorganizados:

```bash
git rm --ignore-unmatch GUIA-AZURE-DEVOPS.md GUIA-APPSERVICE.md INICIE-AQUI.md ROTEIRO-VIDEO.md VALIDACAO.md DimDim.postman_collection.json scripts/deploy.sh scripts/consultar-banco.sh
```

Agora copie o conteúdo da pasta dimdim-pipelines deste ZIP para a raiz do repositório existente. Não copie a pasta externa como subpasta. Confira que README.md e pom.xml estão na raiz e que docs/ e postman/ estão presentes. Preserve alterações próprias comparando os arquivos antes de substituir.

```bash
git status
git diff --stat
git add .
git diff --cached --stat
git commit -m "Organiza checkpoint no padrão da Sprint 3"
git push
```

Se main já estiver protegida, faça esse commit em uma branch e conclua via PR. Não use force push. A documentação e a organização foram alteradas; a API e seus seis testes permanecem os mesmos.
