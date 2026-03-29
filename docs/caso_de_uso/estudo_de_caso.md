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

## UC11 — Navegar no Painel Principal (Home)

### Ator Principal
Usuário

### Objetivo
Prover acesso centralizado a todas as funcionalidades do aplicativo (Descarte, Recompensas, Ranking, Perfil e Suporte).

### Pré-condições
- Usuário autenticado.

### Pós-condições
- Dados atualizados.
  
### Fluxo Principal
1. O sistema exibe o saldo atual de Eco Pontos.
2. O sistema apresenta os botões de atalho: "Registrar Descarte", "Recompensas","Ranking", "Sobre" e "Suporte".
3. O usuário seleciona a função desejada.
4. O sistema redireciona o usuário para a tela correspondente.

### Fluxos Alternativos
- **A1 — Falha na consulta:**  
  O sistema exibe mensagem de erro ao tentar carregar o saldo.

### RF Relacionados
- RF07, RF08, RF11, RF12, RF13, RF14

### RNF Relacionados
- RNF05, RNF06

### RN Relacionadas
- Nenhuma

## UC12 — Capturar Imagem para Descarte

### Ator Principal
Usuário

### Objetivo
Utilizar a câmera do dispositivo para fotografar o resíduo e iniciar o processo de reciclagem.

### Pré-condições
- Usuário autenticado.

### Pós-condições
- A imagem é capturada e armazenada temporariamente para o processo de validação.
  
### Fluxo Principal
1. O usuário aciona a câmera através do aplicativo.
2. O usuário enquadra o resíduo (ex: garrafa pet, lata ou embalagem) e tira a foto.
3. O usuário confirma o envio da imagem para processamento.
4. O sistema inicia a validação da imagem.
   
### Fluxos Alternativos
- **A1 — Permissão de câmera negada:**  
  O sistema solicita acesso às configurações do aparelho.
- **A2 - Usuário cancela a captura:**
  O sistema retorna ao painel principal.

### RF Relacionados
- RF04

### RNF Relacionados
- RNF01, RNF03

### RN Relacionadas
- RN03

## UC13 — Validar Descarte e Exibir Conteúdo Educativo

### Ator Principal
Sistema

### Objetivo
Confirmar a veracidade do descarte e educar o usuário sobre o material identificado.

### Pré-condições
- Foto do resíduo capturada com sucesso.

### Pós-condições
- Descarte registrado no histórico do usuário.
- Eco Pontos adicionados ao saldo do usuário de forma persistente.
  
### Fluxo Principal
1. O sistema processa a imagem enviada.
2. O sistema identifica o material (ex: Plástico BOPP).
3. O sistema exibe a mensagem "Descarte realizado com sucesso!".
4. O sistema apresenta um texto técnico sobre a importância da reciclagem daquele material específico.
5. O sistema informa a quantidade de pontos ganhos (+1 Eco Ponto).
   
### Fluxos Alternativos
- **A1 — Material não identificado:**  
  O sistema informa que o item não foi reconhecido e não atribui pontos.
- **A2 - Foto ilegível:**
  O sistema solicita nova captura.

### RF Relacionados
- RF05, RF06

### RNF Relacionados
- RNF03, RNF06
  
### RN Relacionadas
- RN03, RN04

## UC14 — Listar e Selecionar Recompensas

### Ator Principal
Usuário

### Objetivo
Visualizar as opções de cupons disponíveis nos parceiros da universidade.

### Pré-condições
- Usuário autenticado.

### Pós-condições
- O sistema identifica a recompensa selecionada e prepara a tela de resgate.
  
### Fluxo Principal
1. O usuário acessa a seção "Recompensas".
2. O sistema lista os parceiros.
3. O sistema exibe a porcentagem de desconto e o custo em pontos para cada item.
4. O usuário clica no botão "Resgatar" do benefício escolhido.
   
### Fluxos Alternativos
- **A1 — Falha na consulta:**  
  O sistema exibe mensagem de erro ao carregar lista de parceiros.

### RF Relacionados
- RF08, RF09

### RNF Relacionados
- RNF05, RNF08
  
### RN Relacionadas
- Nenhuma

## UC15 — Confirmar Resgate e Gerar Cupom

### Ator Principal
Usuário / Sistema

### Objetivo
Finalizar a troca de pontos por um benefício e gerar o código de validação.

### Pré-condições
- Usuário possuir saldo de pontos superior ou igual ao custo da recompensa.

### Pós-condições
- Saldo de Eco Pontos atualizado (dedução).
- Código de cupom único gerado e disponível para visualização.
  
### Fluxo Principal
1. O usuário confirma o desejo de trocar seus pontos.
2. O sistema deduz os pontos do saldo total.
3. O sistema exibe a tela "Cupom Gerado!".
4. O sistema apresenta o código alfanumérico (ex: F4JKEL5) para uso presencial.
5. O sistema informa as regras de validação presencial.
   
### Fluxos Alternativos
- **A1 — Saldo Insuficiente:**  
  O sistema exibe mensagem informando que faltam pontos para o resgate.
- **A2 — Falha na geração do cupom:**
  O sistema exibe erro técnico.

### RF Relacionados
- RF09, RF10

### RNF Relacionados
- RNF08
  
### RN Relacionadas
- RN05, RN06, RN07


## UC16 — Visualizar Ranking de Usuários (Leaderboard)

### Ator Principal
Usuário.

### Objetivo
Permitir que o usuário visualize a classificação geral de pontos entre os alunos/participantes.

### Pré-condições
- Usuário autenticado no sistema.

### Pós-condições
- Ranking atualizado exibido na tela.

### Fluxo Principal
1. O usuário acessa a opção de "Ranking" no menu principal.
2. O sistema consulta a base de dados de todos os usuários.
3. O sistema exibe uma lista contendo: Nome, Pontos acumulados e a posição (Rank).
4. O usuário visualiza sua posição em relação aos outros participantes.

### Fluxos Alternativos
- **A1 — Falha na consulta:**
  O sistema exibe mensagem de erro técnico.

### RF Relacionados
- RF11

### RNF Relacionados
- RNF09

### RN Relacionadas
- RN08


## UC17 — Consultar Conteúdo Educativo

### Ator Principal
Usuário.

### Objetivo
Informar o usuário sobre a importância e os métodos corretos de descarte de resíduos.

### Pré-condições
- Usuário autenticado.

### Pós-condições
- Conhecimento ambiental reforçado via interface didática.

### Fluxo Principal
1. O usuário acessa a tela de "Importância do descarte correto".
2. O sistema exibe ilustrações comparativas de descarte.
3. O sistema apresenta um texto explicativo sobre os impactos ambientais.
4. O usuário seleciona o botão "Mais Informações" para aprofundar o tema.

### Fluxos Alternativos
- **A1 — Falha ao carregar conteúdo:**
  O sistema exibe uma mensagem de indisponibilidade de rede.

### RF Relacionados
- RF05, RF12

### RNF Relacionados
- RNF05

### RN Relacionadas
- Nenhuma.


## UC18 — Interagir com Chatbot de Suporte (IA)

### Ator Principal
Usuário.

### Objetivo
Sanar dúvidas imediatas sobre o uso do aplicativo ou regras de descarte através de inteligência artificial.

### Pré-condições
- Usuário autenticado.

### Pós-condições
- Resposta gerada pela IA exibida na interface de chat.

### Fluxo Principal
1. O usuário acessa a tela "Tire suas dúvidas com a IA".
2. O usuário digita uma pergunta ou problema no campo de mensagem.
3. O sistema (IA) processa a dúvida e envia uma resposta automática.
4. O usuário visualiza a solução proposta pelo chatbot.

### Fluxos Alternativos
- **A1 — IA não compreende a dúvida:**
  O sistema sugere que o usuário tente outra pergunta ou utilize o suporte via e-mail.

### RF Relacionados
- RF13

### RNF Relacionados
- RNF03

### RN Relacionadas
- Nenhuma.


## UC19 — Enviar E-mail para Suporte Técnico

### Ator Principal
Usuário.

### Objetivo
Permitir o contato direto com a equipe humana para problemas não resolvidos pela IA.

### Pré-condições
- Usuário autenticado e com conexão à internet.

### Pós-condições
- Chamado de suporte enviado com sucesso para a equipe técnica.

### Fluxo Principal
1. O usuário acessa a opção "Escreva o e-mail para o suporte".
2. O usuário descreve detalhadamente o problema no campo de texto.
3. O usuário anexa uma imagem comprobatória, se necessário.
4. O usuário clica no ícone de envio para despachar a mensagem.

### Fluxos Alternativos
- **A1 — Campo de mensagem vazio:**
  O sistema impede o envio e solicita que o usuário descreva o problema.

### RF Relacionados
- RF14

### RNF Relacionados
- RNF04

### RN Relacionadas
- Nenhuma.


## UC20 — Visualizar e Gerenciar Perfil do Usuário

### Ator Principal
Usuário.

### Objetivo
Visualizar informações da conta e realizar ajustes nas configurações pessoais.

### Pré-condições
- Usuário autenticado.

### Pós-condições
- Dados do perfil exibidos e alterações salvas no sistema.

### Fluxo Principal
1. O usuário acessa a tela de "Informações" do perfil.
2. O sistema exibe a foto atual, o nome e o e-mail cadastrado.
3. O usuário seleciona as opções "Editar Foto de Perfil", "Alterar Senha" ou "Sair da Conta".
4. O sistema processa a ação escolhida e atualiza as informações se necessário.

### Fluxos Alternativos
- **A1 — Dados Inválidos na Alteração:**
  O sistema solicita correção conforme regras de segurança.

### RF Relacionados
- RF15, RF16

### RNF Relacionados
- RNF02

### RN Relacionadas
- RN10

----
## Imagens

<img width="541" height="512" alt="image" src="https://github.com/user-attachments/assets/b05dfb25-744d-4d04-984e-418dca825360" />


<img width="617" height="292" alt="image" src="https://github.com/user-attachments/assets/de36e88e-f214-4c40-97c5-dca628d0c155" />

