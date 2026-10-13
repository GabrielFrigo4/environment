# 📜 Os 22 Princípios UNIX & Clean Code em Profundidade

> Análise técnica e fundamentação teórica dos 22 princípios canônicos que regem o Universal Environment de Gabriel Frigo.

---

## 🧭 Introdução

O documento [`PRINCIPLES.md`](../../PRINCIPLES.md) funciona como a constituição técnica do ecossistema. Ele estabelece os limites éticos, arquiteturais e de qualidade aos quais todo código submetido deve se conformar.

Abaixo, os princípios são agrupados em suas dimensões fundamentais de engenharia:

---

## 🏛️ Dimensão 1: Arquitetura & Soberania (Princípios 1 a 5)

### 1. Separação Estrita de Responsabilidades

Cada repositório do Quarteto possui um único domínio de atuação: o Setup provisiona o SO, o Shell provê a experiência interativa, o Vault guarda segredos e o Profile governa preferências do usuário. Misturar esses papéis introduz acoplamento tóxico.

### 2. Isolamento de Privilégios

Superusuário (`root`/`sudo`) é privilégio exclusivo do repositório `Setup`. Nenhum dotfile de shell ou perfil de usuário deve requerer permissões administrativas para operar no dia a dia.

### 3. Soberania e Independência

Cada repositório Git é autônomo. O repositório Environment é uma bancada de orquestração; se um desenvolvedor clonar apenas o `Shell` ou o `Profile`, eles devem funcionar de forma completa e independente.

### 4. Interfaces Mínimas

A comunicação entre repositórios ocorre por contratos mínimos e bem definidos: variáveis de ambiente padrão, caminhos canônicos no filesystem e saídas textuais padronizadas.

### 5. Portabilidade e Padrões Abertos

Prioridade absoluta para especificações abertas: POSIX `/bin/sh` estrito, OpenZFS, XDG Base Directory, SSH OpenSSH e Markdown compatível com GitHub Flavored Markdown (GFM).

---

## ⚡ Dimensão 2: Execução & Performance (Princípios 6 a 10)

### 6. Idempotência e Determinismo

Executar um script uma vez ou cem vezes consecutivas deve produzir exatamente o mesmo estado final no sistema. Toda operação deve verificar se a modificação já foi feita antes de realizá-la.

### 7. Desempenho e Latência (< 64ms)

No terminal interativo, atrasos acima de 100ms são percebidos pelo cérebro humano como lentidão perceptível. O Universal Shell impõe um teto estrito de **64 milissegundos** para inicialização a frio e menos de **16 milissegundos** para renderização de prompt.

### 8. Resiliência e Tolerância a Falhas

Scripts devem falhar rápido e de forma inteligível quando pré-requisitos essenciais não forem atendidos, mas devem degradar graciosamente com mensagens claras quando recursos secundários estiverem ausentes.

### 9. Composição em Vez de Acoplamento

Scripts pequenos e focados conectados via pipes UNIX e subcomandos, em oposição a monólitos monolíticos cheios de branches condicionais globais.

### 10. Clareza e Legibilidade (Clean Code)

Código deve ser autoexplicativo. Nomes de variáveis e funções devem revelar intenção. Comentários narrativos que apenas repetem o que o código faz em inglês/português são expressamente proibidos.

---

## 🛡️ Dimensão 3: Segurança & Governança (Princípios 11 a 16)

### 11. Automação e Reprodutibilidade

Zero etapas manuais não documentadas. A estação de trabalho deve ser reconstruível a partir do zero a qualquer momento através de scripts automatizados.

### 12. Segurança em Profundidade

Criptografia de ponta a ponta no Vault, permissões mínimas no sistema de arquivos (0700/0600), filtragem rigorosa de nós no `/dev` das Jails e firewall PF ativo por padrão.

### 13. Gestão Declarativa

Configurações devem descrever o _estado desejado_ do sistema, não uma sequência caótica de passos imperativos.

### 14. Evolução Incremental

Grandes melhorias são decompostas em entregas atômicas e testáveis, sem desestabilizar o fluxo de trabalho cotidiano.

### 15. Observabilidade e Diagnóstico

Saídas visuais claras com a biblioteca `_ui_*`, códigos de retorno semânticos e comandos dedicados de verificação (`make doctor`, `benchmark.sh`, `skills.py`).

### 16. Minimalismo e Remoção Ativa (Zero-Bloat)

Código não utilizado, dependências órfãs e arquivos de configuração descontinuados devem ser agressivamente removidos. Complexidade desnecessária é tratada como débito técnico urgente.

---

## 🧪 Dimensão 4: Qualidade & Hermetismo (Princípios 17 a 22)

### 17. Testabilidade e Verificação

Toda funcionalidade crítica deve ter testes automatizados via Makefile (`make test`, `make audit`, `make ci`), impedindo regressões silenciosas.

### 18. Documentação como Código

Toda arquitetura e runbook vive dentro do repositório Git sob controle de versão, formatada com Prettier e com rastreabilidade histórica completa.

### 19. Recuperabilidade

Falhas de sistema ou corrupções devem ser contornáveis de imediato via snapshots OpenZFS (`zfs rollback`) ou backups declarativos.

### 20. Coerência Estética e Convenções

Banners superiores padronizados com 64 hífens, seções internas delimitadas a 32 caracteres com `### `, identação de 4 espaços para shell scripts e indentação estrita de Markdown.

### 21. Paridade de Identidade e Permissões

Garantia de que arquivos mantêm coerência de UID/GID 1001 e permissões POSIX canônicas no Git Index (`0755` para executáveis, `0644` para configurações).

### 22. Hermetismo de Produção & Invariante `rm -rf .agents`

O ecossistema é 100% soberano e independente de ferramentas de IA. Código de produção não depende de arquivos dentro de `.agents/` ou `skills/`. Se essas pastas forem destruídas, o repositório opera com 100% de integridade.
