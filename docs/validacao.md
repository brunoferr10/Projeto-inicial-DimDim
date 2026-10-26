# Verificação do pacote

Verificado em 26/10/2026:

- Maven clean verify: BUILD SUCCESS, Java 17.
- 6 testes automatizados: 0 falhas, 0 erros e 0 ignorados.
- Testes HTTP com MockMvc e persistência H2 em modo PostgreSQL: CRUD de clientes/pedidos, relacionamento, exclusão de cliente vinculado, campos inválidos, e-mail duplicado, cliente inexistente e endpoint de versão.
- Sintaxe dos scripts Bash, Python, JSON, POM e arquivos YAML verificada.

Não executado neste ambiente: Docker Compose, PostgreSQL real, provisionamento Azure, registro de agente e pipelines na sua organização. O funcionamento integrado deve ser confirmado na sua assinatura seguindo os guias. Os testes H2 não substituem a demonstração de CRUD no PostgreSQL em nuvem.

O código fonte é entregue sem target/ e sem credenciais. A pipeline gera o JAR e publica o artefato drop para a Release.

## Organização conforme referência da Sprint 3

README consolidado em etapas numeradas, scripts de configuração e consulta, coleção em postman/ e evidências em docs/. O código Java e seus testes não foram alterados nesta revisão. A sintaxe Bash/Python/YAML/JSON, os links locais, os nomes/RMs e a integridade do ZIP foram conferidos. A arquitetura SVG foi renderizada e inspecionada. Os novos scripts Azure ainda precisam de validação na assinatura do grupo.
