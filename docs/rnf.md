# Requisitos do Sistema

## Requisitos Não Funcionais (RNF)

### RNF01 — Responsividade (Mobile-First)
O sistema deve ser desenvolvido com foco total em dispositivos móveis, garantindo que a interface se adapte perfeitamente a diferentes tamanhos de tela (Android e iOS), conforme definido no protótipo.

### RNF02 — Segurança de Dados (LGPD)
Os dados sensíveis dos usuários (senhas e informações pessoais) devem ser armazenados utilizando criptografia e seguir as diretrizes da Lei Geral de Proteção de Dados (LGPD).

### RNF03 — Tempo de Resposta
O processamento da imagem do descarte e a atribuição dos pontos não devem ultrapassar 5 segundos para garantir uma boa experiência ao usuário no momento do descarte físico.

### RNF04 — Disponibilidade
O sistema deve estar disponível para uso 24/7, garantindo que os usuários possam registrar descartes ou validar cupons em qualquer horário de funcionamento da universidade.

### RNF05 — Usabilidade e Acessibilidade
A interface deve possuir contraste adequado e elementos intuitivos, permitindo que o usuário realize o fluxo principal (login -> descarte -> resgate) com o mínimo de cliques possível.

### RNF06 — Persistência de Dados
O saldo de Eco Pontos e os cupons gerados devem ser armazenados em um banco de dados persistente, garantindo que nenhuma informação seja perdida caso o aplicativo seja fechado ou a conexão caia.

### RNF07 — Escalabilidade
A arquitetura do sistema deve permitir o aumento do volume de usuários e registros de descarte sem perda de performance, prevendo o crescimento da base de alunos da universidade.

### RNF08 — Integridade do Banco de Dados
O sistema deve utilizar transações ACID para garantir que a dedução de pontos e a geração de cupons ocorram de forma atômica (ou o processo é concluído totalmente, ou é revertido em caso de erro).

### RNF09 — Performance de Busca no Ranking
A consulta ao Leaderboard (Ranking) deve ser otimizada para carregar os top 50 usuários em menos de 2 segundos, mesmo com milhares de registros no banco de dados.

### RNF10 — Autenticação de Sessão
O sistema deve utilizar tokens de acesso (como JWT) para manter o usuário logado com segurança, exigindo nova autenticação apenas após longos períodos de inatividade.
