package br.com.fiap.dimdim;
import jakarta.persistence.*;
@Entity @Table(name="clientes") public class Cliente {
 @Id @GeneratedValue(strategy=GenerationType.IDENTITY) public Long id;
 @Column(nullable=false,length=120) public String nome;
 @Column(nullable=false,unique=true,length=180) public String email;
}
