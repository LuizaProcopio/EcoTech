## UC01 — Realizar Login

### Ator Principal
Usuário

### Objetivo
Permitir que o usuário acesse o sistema EcoTech.

### Pré-condições
- Usuário deve possuir cadastro ativo.

### Pós-condições
- Sessão iniciada com sucesso.
  
### Fluxo Principal
1. O usuário informa e-mail e senha.
2. O sistema valida as credenciais.
3. O sistema autentica o usuário.
4. O sistema redireciona para o painel principal..

### Fluxos Alternativos
- **A1 — Senha incorreta:**  
  O sistema exibe mensagem de erro.

- **A2 — Usuário não cadastrado:**  
  O sistema informa que o usuário não existe.

### RF Relacionados
- RF01

### RNF Relacionados
- RNF02
- RNF10

### RN Relacionadas
- RN09


## UC02 — Recuperar Senha

### Ator Principal
Usuário

### Objetivo
Permitir que o usuário recupere o acesso à sua conta.

### Pré-condições
- Usuário possuir e-mail cadastrado.

### Pós-condições
- Senha redefinida com sucesso.
  
### Fluxo Principal
1. O usuário seleciona a opção "Esqueci minha senha".
2. O sistema solicita o e-mail cadastrado.
3. O sistema envia um código de verificação.
4. O usuário informa o código recebido.
5. O usuário define uma nova senha.
6. O sistema atualiza a senha no banco de dados.

### Fluxos Alternativos
- **A1 — Código inválido:**  
  O sistema solicita um novo código.

- **A2 — Código expirado:**  
  O sistema informa que o código expirou.

### RF Relacionados
- RF02

### RNF Relacionados
- RNF02

### RN Relacionadas
- RN02


## UC03 — Cadastrar Usuário

### Ator Principal
Usuário

### Objetivo
Permitir a criação de uma nova conta no sistema.

### Pré-condições
- Usuário não possuir cadastro anterior.

### Pós-condições
- Conta criada no sistema.
  
### Fluxo Principal
1. O usuário acessa a tela de cadastro.
2. O usuário informa nome, e-mail e senha.
3. O usuário aceita os termos de uso.
4. O sistema valida os dados informados.
5. O sistema registra o usuário.

### Fluxos Alternativos
- **A1 — E-mail já cadastrado:**  
  O sistema informa erro.

- **A2 — Dados inválidos:**  
  O sistema solicita correção.

### RF Relacionados
- RF03

### RNF Relacionados
- RNF02

### RN Relacionadas
- RN01



## UC04 — Registrar Descarte de Resíduo

### Ator Principal
Usuário

### Objetivo
Registrar o descarte de resíduos recicláveis através de imagem.

### Pré-condições
- Usuário autenticado.

### Pós-condições
- Descarte registrado no sistema.
  
### Fluxo Principal
1. O usuário acessa a função de descarte.
2. O usuário tira uma foto do resíduo.
3. O sistema processa a imagem.
4. O sistema identifica o material.
5. O sistema registra o descarte.

### Fluxos Alternativos
- **A1 — Foto ilegível:**  
  O sistema solicita nova captura.

- **A2 — Material não reciclável:**  
  O sistema informa que não há pontuação.

### RF Relacionados
- RF04

### RNF Relacionados
- RNF03

### RN Relacionadas
- RN03


## UC05 — Receber Feedback Educativo

### Ator Principal
Sistema

### Objetivo
Informar o usuário sobre o material descartado.

### Pré-condições
- Descarte registrado

### Pós-condições
- Informações exibidas ao usuário.
  
### Fluxo Principal
1. O sistema identifica o material reciclável.
2. O sistema consulta a base de conhecimento ambiental.
3. O sistema exibe informações e dicas de reciclagem.

### Fluxos Alternativos
- **A1 — Material não identificado:**  
  O sistema informa ao usuário.

### RF Relacionados
- RF05

### RNF Relacionados
- RNF05

### RN Relacionadas
- Nenhuma


## UC06 — Atribuir Eco Pontos

### Ator Principal
Sistema

### Objetivo
Creditar pontos ao usuário após descarte validado.

### Pré-condições
- Descarte validado com sucesso.

### Pós-condições
- Pontos adicionados à conta do usuário.
  
### Fluxo Principal
1. O sistema identifica o tipo de material descartado.
2. O sistema consulta a tabela de pontuação.
3. O sistema calcula os pontos.
4. O sistema adiciona os pontos ao saldo do usuário.

### Fluxos Alternativos
- **A1 — Falha no processamento:**  
  O sistema cancela a pontuação.

### RF Relacionados
- RF06

### RNF Relacionados
- RNF06

### RN Relacionadas
- RN04


## UC07 — Visualizar Dashboard de Pontuação

### Ator Principal
Usuário

### Objetivo
Permitir que o usuário visualize seu saldo de Eco Pontos.

### Pré-condições
- Usuário autenticado.

### Pós-condições
- Pontuação exibida.
  
### Fluxo Principal
1. O usuário acessa o dashboard.
2. O sistema consulta o saldo de pontos.
3. O sistema exibe o saldo acumulado.

### Fluxos Alternativos
- **A1 — Falha na consulta:**  
  O sistema exibe mensagem de erro.

### RF Relacionados
- RF07

### RNF Relacionados
- RNF06

### RN Relacionadas
- Nenhuma


## UC08 — Resgatar Cupom de Desconto

### Ator Principal
Usuário

### Objetivo
Permitir a troca de Eco Pontos por recompensas.

### Pré-condições
- Usuário possuir pontos suficientes.

### Pós-condições
- Cupom gerado.
  
### Fluxo Principal
1. O usuário acessa a lista de recompensas.
2. O usuário seleciona um benefício.
3. O sistema verifica o saldo de pontos.
4. O sistema gera o cupom.
5. O sistema deduz os pontos da conta.

### Fluxos Alternativos
- **A1 — Saldo insuficiente:**  
  O sistema impede o resgate.

- **A2 — Falha na geração do cupom:**  
  O sistema exibe erro.

### RF Relacionados
- RF09

### RNF Relacionados
- RNF08

### RN Relacionadas
- RN05
- RN06


## UC09 — Visualizar Ranking de Usuários

### Ator Principal
Usuário

### Objetivo
Comparar pontuação com outros usuários.

### Pré-condições
- Usuário autenticado.

### Pós-condições
- Ranking exibido.
  
### Fluxo Principal
1. O usuário acessa a tela de ranking.
2. O sistema consulta a pontuação dos usuários.
3. O sistema exibe o leaderboard.

### Fluxos Alternativos
- **A1 — Falha na consulta:**  
  O sistema exibe erro.


### RF Relacionados
- RF11

### RNF Relacionados
- RNF09

### RN Relacionadas
- RN08


## UC10 — Editar Perfil

### Ator Principal
Usuário

### Objetivo
Permitir que o usuário atualize suas informações pessoais.

### Pré-condições
- Usuário autenticado.

### Pós-condições
- Dados atualizados.
  
### Fluxo Principal
1. O usuário acessa a tela de perfil.
2. O usuário altera seus dados.
3. O sistema valida as informações.
4. O sistema salva as alterações.

### Fluxos Alternativos
- **A1 — Dados inválidos:**  
  O sistema solicita correção.

### RF Relacionados
- RF15

### RNF Relacionados
- RNF02

### RN Relacionadas
- Nenhuma
