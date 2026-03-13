# Requisitos do Sistema

## Regras de Negócio (RN)

### RN01 — Validação de Cadastro
Para que o cadastro seja efetuado, o usuário deve obrigatoriamente aceitar os Termos e Condições e fornecer um e-mail com formato válido.

### RN02 — Expiração do Código de Segurança
O código de verificação enviado para recuperação de senha tem validade estrita de 10 minutos. Após esse período, o código torna-se inválido e um novo deve ser solicitado.

### RN03 — Verificação de Foto de Descarte
O registro de pontos só será validado se a foto capturada (RF04) for processada com sucesso. Fotos ilegíveis ou que não contenham resíduos recicláveis não gerarão pontuação.

### RN04 — Cálculo de Pontuação Diferenciada
A quantidade de Eco Pontos atribuída deve seguir uma tabela de pesos baseada na complexidade da reciclagem do material (ex: Metais podem valer mais que Papel).

### RN05 — Saldo Insuficiente para Resgate
O sistema deve impedir a geração de cupons (RF09) caso o saldo de Eco Pontos do usuário seja inferior ao valor exigido pela recompensa selecionada.

### RN06 — Unicidade e Expiração de Cupons
Cada cupom gerado é único e atrelado ao CPF/ID do usuário. O cupom deve possuir uma data de validade definida pela barraca parceira no momento da configuração.

### RN07 — Validação Presencial de Recompensas
O desconto na barraca da universidade só será concedido mediante a apresentação do código ativo no aplicativo e validação por parte do atendente.

### RN08 — Critérios de Desempate no Ranking
Em caso de empate na pontuação do Ranking (RF11), o critério de desempate será a data do último descarte realizado (usuário que descartou mais recentemente fica à frente).

### RN09 — Limite de Tentativas de Login
Após 5 tentativas de login incorretas, a conta deverá ser bloqueada temporariamente para garantir a segurança do usuário contra ataques de força bruta.

### RN10 — Integridade da Alteração de Senha
Para a troca de senha em ambiente logado (RF16), o sistema deve exigir que a nova senha seja diferente da senha atual e possua no mínimo 8 caracteres.
