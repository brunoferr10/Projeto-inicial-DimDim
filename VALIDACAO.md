# Verificação do pacote

Verificado em 26/10/2026:

- Maven clean verify: BUILD SUCCESS, Java 17.
- 6 testes automatizados: 0 falhas, 0 erros e 0 ignorados.
- Testes HTTP com MockMvc e persistência H2 em modo PostgreSQL: CRUD de clientes/pedidos, relacionamento, exclusão de cliente vinculado, campos inválidos, e-mail duplicado, cliente inexistente e endpoint de versão.
- Sintaxe dos scripts Bash, Python, JSON, POM e arquivos YAML verificada.

Não executado neste ambiente: Docker Compose, PostgreSQL real, provisionamento Azure, registro de agente e pipelines na sua organização. O funcionamento integrado deve ser confirmado na sua assinatura seguindo os guias. Os testes H2 não substituem a demonstração de CRUD no PostgreSQL em nuvem.

O código fonte é entregue sem target/ e sem credenciais. A pipeline gera o JAR e publica o artefato drop para a Release.
