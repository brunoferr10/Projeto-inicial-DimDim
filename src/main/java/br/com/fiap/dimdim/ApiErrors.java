package br.com.fiap.dimdim;
import org.springframework.web.bind.annotation.*;
import org.springframework.dao.DataIntegrityViolationException;
import org.springframework.http.*;
@RestControllerAdvice public class ApiErrors {
 @ExceptionHandler(DataIntegrityViolationException.class)
 public ResponseEntity<ProblemDetail> conflito(){return ResponseEntity.status(409).body(ProblemDetail.forStatusAndDetail(HttpStatus.CONFLICT,"E-mail duplicado ou cliente vinculado a pedidos. Exclua os pedidos antes do cliente."));}
}
