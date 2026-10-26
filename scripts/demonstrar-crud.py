#!/usr/bin/env python3
"""Execute na VM. Faz SELECT após cada operação e pausa para gravar evidências."""
import json, os, subprocess, urllib.request, uuid
base=os.environ['BASE_URL']
for key in ['PGHOST','PGUSER','PGDATABASE','PGPASSWORD']:
 if not os.getenv(key): raise SystemExit('Configure '+key+' conforme o README antes de demonstrar o CRUD.')
def call(method,path,data=None):
 req=urllib.request.Request(base+'/api'+path,data=json.dumps(data).encode() if data else None,headers={'Content-Type':'application/json'},method=method)
 with urllib.request.urlopen(req) as r:
  raw=r.read(); print(method,path,'HTTP',r.status,raw.decode()); return json.loads(raw) if raw else None
def evidence():
 subprocess.run(['psql','-v','ON_ERROR_STOP=1','-f','docs/consultas-evidencia.sql'],check=True)
 input('Evidência exibida. Enter para continuar...')
email='demo-'+uuid.uuid4().hex[:8]+'@exemplo.com'
c=call('POST','/clientes',{'nome':'Bruno Demo','email':email});evidence()
call('GET','/clientes/'+str(c['id']));evidence()
call('PUT','/clientes/'+str(c['id']),{'nome':'Bruno Atualizado','email':email});evidence()
p=call('POST','/pedidos',{'clienteId':c['id'],'descricao':'Pedido de demonstração','valor':150});evidence()
call('GET','/pedidos/'+str(p['id']));evidence()
call('PUT','/pedidos/'+str(p['id']),{'clienteId':c['id'],'descricao':'Pedido atualizado','valor':250});evidence()
call('DELETE','/pedidos/'+str(p['id']));evidence()
call('DELETE','/clientes/'+str(c['id']));evidence()
print('CRUD das duas tabelas concluído.')
