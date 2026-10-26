# Ordem para executar

1. Extraia o ZIP. A raiz é a pasta dimdim-pipelines, onde está pom.xml.
2. Use Ubuntu 24.04 na VM; prepare-a com scripts/02-preparar-vm-existente.sh, saia do SSH e entre novamente. Para evidenciar criação via script, há scripts/01-criar-vm.sh.
3. Siga GUIA-AZURE-DEVOPS.md nos passos 2, 3 e 4: Boards, Git, agente e Build.
4. Siga GUIA-APPSERVICE.md para criar App Service + PostgreSQL, executar script.sql e configurar a Release. Esse é o destino recomendado conforme as opções do PDF. A VM serve de ambiente de trabalho/agente.
5. Volte ao GUIA-AZURE-DEVOPS.md nos passos 6 a 8 para políticas, branch, PR, vídeo e entrega.

Não basta fazer push no Git: as configurações de conta do Azure DevOps e a Release precisam ser feitas uma vez. A alternativa Docker na própria VM está documentada, mas confirme com o professor antes de usá-la como destino final em lugar das opções do PDF.

Para testar apenas na VM antes de configurar tudo, consulte a seção Executar na VM do README.md.
