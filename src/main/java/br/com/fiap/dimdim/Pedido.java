package br.com.fiap.dimdim;
import jakarta.persistence.*;
import java.math.BigDecimal;
@Entity @Table(name="pedidos") public class Pedido {
 @Id @GeneratedValue(strategy=GenerationType.IDENTITY) public Long id;
 @ManyToOne(optional=false) @JoinColumn(name="cliente_id",nullable=false) public Cliente cliente;
 @Column(nullable=false,length=200) public String descricao;
 @Column(nullable=false,precision=12,scale=2) public BigDecimal valor;
}
