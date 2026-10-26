package br.com.fiap.dimdim;
import org.junit.jupiter.api.*;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.boot.test.autoconfigure.web.servlet.AutoConfigureMockMvc;
import org.springframework.boot.test.context.SpringBootTest;
import org.springframework.test.context.ActiveProfiles;
import org.springframework.test.web.servlet.MockMvc;
import com.fasterxml.jackson.databind.ObjectMapper;
import static org.springframework.test.web.servlet.request.MockMvcRequestBuilders.*;
import static org.springframework.test.web.servlet.result.MockMvcResultMatchers.*;
@SpringBootTest @AutoConfigureMockMvc @ActiveProfiles("test") class ApiTest {
 @Autowired MockMvc mvc; @Autowired ObjectMapper json;
 @Autowired ClienteRepository clientes; @Autowired PedidoRepository pedidos;
 @BeforeEach void limpar(){pedidos.deleteAll();clientes.deleteAll();}
 long criarCliente() throws Exception {return json.readTree(mvc.perform(post("/api/clientes").contentType("application/json").content("{\"nome\":\"Bruno\",\"email\":\"bruno@exemplo.com\"}")).andExpect(status().isCreated()).andExpect(header().exists("Location")).andReturn().getResponse().getContentAsString()).get("id").asLong();}
 @Test void crudCliente() throws Exception {
 long id=criarCliente();
 mvc.perform(get("/api/clientes/"+id)).andExpect(status().isOk()).andExpect(jsonPath("$.nome").value("Bruno"));
 mvc.perform(put("/api/clientes/"+id).contentType("application/json").content("{\"nome\":\"Novo nome\",\"email\":\"novo@exemplo.com\"}")).andExpect(status().isOk()).andExpect(jsonPath("$.nome").value("Novo nome"));
 mvc.perform(get("/api/clientes")).andExpect(jsonPath("$.length()").value(1));
 mvc.perform(delete("/api/clientes/"+id)).andExpect(status().isNoContent());
 mvc.perform(get("/api/clientes/"+id)).andExpect(status().isNotFound());
 }
 @Test void crudPedidoERelacionamento() throws Exception {
 long c=criarCliente();String body="{\"clienteId\":"+c+",\"descricao\":\"Inicial\",\"valor\":150.00}";
 long id=json.readTree(mvc.perform(post("/api/pedidos").contentType("application/json").content(body)).andExpect(status().isCreated()).andExpect(jsonPath("$.cliente.id").value(c)).andReturn().getResponse().getContentAsString()).get("id").asLong();
 mvc.perform(get("/api/pedidos/"+id)).andExpect(status().isOk());
 mvc.perform(put("/api/pedidos/"+id).contentType("application/json").content(body.replace("Inicial","Atualizado"))).andExpect(status().isOk()).andExpect(jsonPath("$.descricao").value("Atualizado"));
 mvc.perform(get("/api/pedidos")).andExpect(jsonPath("$.length()").value(1));
 mvc.perform(delete("/api/clientes/"+c)).andExpect(status().isConflict());
 mvc.perform(delete("/api/pedidos/"+id)).andExpect(status().isNoContent());
 mvc.perform(get("/api/pedidos/"+id)).andExpect(status().isNotFound());
 mvc.perform(delete("/api/clientes/"+c)).andExpect(status().isNoContent());
 }
 @Test void rejeitaDadosInvalidos() throws Exception {
 mvc.perform(post("/api/clientes").contentType("application/json").content("{\"nome\":\"\",\"email\":\"errado\"}")).andExpect(status().isBadRequest());
 mvc.perform(post("/api/pedidos").contentType("application/json").content("{\"clienteId\":1,\"descricao\":\"Teste\",\"valor\":-1}")).andExpect(status().isBadRequest());
 }
 @Test void rejeitaEmailDuplicado() throws Exception {criarCliente();mvc.perform(post("/api/clientes").contentType("application/json").content("{\"nome\":\"Outro\",\"email\":\"bruno@exemplo.com\"}")).andExpect(status().isConflict());}
 @Test void rejeitaClienteInexistente() throws Exception {mvc.perform(post("/api/pedidos").contentType("application/json").content("{\"clienteId\":99999,\"descricao\":\"Teste\",\"valor\":1}")).andExpect(status().isNotFound());}
 @Test void versaoVisivel() throws Exception {mvc.perform(get("/api/versao")).andExpect(status().isOk()).andExpect(jsonPath("$.mensagem").isNotEmpty());}
}
