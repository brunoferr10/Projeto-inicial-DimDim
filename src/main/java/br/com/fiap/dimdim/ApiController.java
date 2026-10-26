package br.com.fiap.dimdim;
import jakarta.validation.Valid;
import jakarta.validation.constraints.*;
import java.math.BigDecimal;
import java.net.URI;
import java.util.*;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;
import org.springframework.web.server.ResponseStatusException;
import static org.springframework.http.HttpStatus.NOT_FOUND;
@RestController @RequestMapping("/api") public class ApiController {
 private final ClienteRepository clientes; private final PedidoRepository pedidos;
 public ApiController(ClienteRepository c,PedidoRepository p){clientes=c;pedidos=p;}
 public record ClienteInput(@NotBlank @Size(max=120) String nome,@NotBlank @Email @Size(max=180) String email){}
 public record PedidoInput(@NotNull Long clienteId,@NotBlank @Size(max=200) String descricao,@NotNull @DecimalMin("0.01") @Digits(integer=10,fraction=2) BigDecimal valor){}
 private Cliente cliente(Long id){return clientes.findById(id).orElseThrow(()->new ResponseStatusException(NOT_FOUND,"Cliente não encontrado"));}
 private Pedido pedido(Long id){return pedidos.findById(id).orElseThrow(()->new ResponseStatusException(NOT_FOUND,"Pedido não encontrado"));}
 @GetMapping("/versao") public Map<String,String> versao(){return Map.of("versao","1.0.0","mensagem","DimDim em nuvem");}
 @GetMapping("/clientes") public List<Cliente> listarClientes(){return clientes.findAll();}
 @GetMapping("/clientes/{id}") public Cliente buscarCliente(@PathVariable Long id){return cliente(id);}
 @PostMapping("/clientes") public ResponseEntity<Cliente> criarCliente(@Valid @RequestBody ClienteInput input){Cliente c=new Cliente();c.nome=input.nome();c.email=input.email();c=clientes.saveAndFlush(c);return ResponseEntity.created(URI.create("/api/clientes/"+c.id)).body(c);}
 @PutMapping("/clientes/{id}") public Cliente atualizarCliente(@PathVariable Long id,@Valid @RequestBody ClienteInput input){Cliente c=cliente(id);c.nome=input.nome();c.email=input.email();return clientes.saveAndFlush(c);}
 @DeleteMapping("/clientes/{id}") public ResponseEntity<Void> excluirCliente(@PathVariable Long id){Cliente c=cliente(id);clientes.delete(c);clientes.flush();return ResponseEntity.noContent().build();}
 @GetMapping("/pedidos") public List<Pedido> listarPedidos(){return pedidos.findAll();}
 @GetMapping("/pedidos/{id}") public Pedido buscarPedido(@PathVariable Long id){return pedido(id);}
 @PostMapping("/pedidos") public ResponseEntity<Pedido> criarPedido(@Valid @RequestBody PedidoInput input){Pedido p=new Pedido();preencher(p,input);p=pedidos.saveAndFlush(p);return ResponseEntity.created(URI.create("/api/pedidos/"+p.id)).body(p);}
 @PutMapping("/pedidos/{id}") public Pedido atualizarPedido(@PathVariable Long id,@Valid @RequestBody PedidoInput input){Pedido p=pedido(id);preencher(p,input);return pedidos.saveAndFlush(p);}
 @DeleteMapping("/pedidos/{id}") public ResponseEntity<Void> excluirPedido(@PathVariable Long id){pedidos.delete(pedido(id));pedidos.flush();return ResponseEntity.noContent().build();}
 private void preencher(Pedido p,PedidoInput i){p.cliente=cliente(i.clienteId());p.descricao=i.descricao();p.valor=i.valor();}
}
