# 📜 Princípios de Engenharia & Filosofia Soberana

> _"Rule of Separation: Separate policy from mechanism; separate engine from interface."_<br>
> — Eric S. Raymond, _The Art of UNIX Programming_ (2003)

Para assegurar longevidade, manutenibilidade, transparência e excelência técnica, toda contribuição a este repositório obedece aos **22 Princípios de Engenharia** (17 Princípios UNIX de Eric S. Raymond + 5 Regras de Soberania & Antifragilidade) e às práticas canônicas de **Clean Code**.

---

## 🏛️ Os 22 Princípios de Design

### 1. Regra da Modularidade (_Rule of Modularity_)

> _Escreva partes simples conectadas por interfaces limpas._
> O sistema deve ser estruturado em componentes atômicos, desacoplados e autocontidos com responsabilidade única e interfaces previsíveis.

### 2. Regra da Clareza (_Rule of Clarity_)

> _Clareza é melhor que esperteza._
> Priorize legibilidade absoluta sobre "one-liners" crípticos ou truques sintáticos obscuros. Código é lido muito mais frequentemente do que é escrito.

### 3. Regra da Composição (_Rule of Composition_)

> _Projete programas para serem conectados a outros programas._
> Utilize formatos de dados abertos, textos simples e fluxos limpos de entrada/saída (stdin/stdout) para viabilizar encadeamento em pipelines.

### 4. Regra da Separação (_Rule of Separation_)

> _Separe a política do mecanismo; separe o motor da interface._
> Mantenha a lógica central (motor) desacoplada das políticas de apresentação, formato de saída e interfaces com o usuário.

### 5. Regra da Simplicidade (_Rule of Simplicity_)

> _Projete para a simplicidade; adicione complexidade apenas onde estritamente necessário._
> A complexidade acidental é a principal fonte de falhas e custos de manutenção. Combata o inchaço técnico e dependências desnecessárias.

### 6. Regra da Parcimônia (_Rule of Parsimony_)

> _Escreva um programa grande apenas quando estiver claro por demonstração que nada mais resolverá._
> Resolva o problema com o menor volume de código e dependências possível. Rejeite hipertrofia arquitetural.

### 7. Regra da Transparência (_Rule of Transparency_)

> _Projete para a visibilidade para tornar inspeção e depuração fáceis._
> Estruturas de dados claras, fluxos explícitos e observabilidade nativa facilitam diagnóstico imediato sem necessidade de depuradores invasivos.

### 8. Regra da Robustez (_Rule of Robustness_)

> _A robustez é filha da transparência e da simplicidade._
> Valide invariantes e pré-requisitos antes da execução. Garanta tratamento determinístico de exceções e resiliência em cenários adversos.

### 9. Regra da Representação (_Rule of Representation_)

> _Dobre o conhecimento em dados para que a lógica do programa possa ser estúpida e robusta._
> Prefira tabelas, estruturas declarativas e representações formais de dados a longas cadeias condicionais de decisão procedimental.

### 10. Regra do Menor Espanto (_Rule of Least Surprise_)

> _No design de interfaces, sempre faça a coisa menos surpreendente._
> Respeite padrões estabelecidos, convenções canônicas da linguagem/plataforma e expectativas intuitivas do usuário/integrador.

### 11. Regra do Silêncio (_Rule of Silence_)

> _Quando um programa não tem nada surpreendente a dizer, ele não deve dizer nada._
> Comandos e ferramentas operam de forma silenciosa no sucesso, emitindo mensagens apenas quando houver informações acionáveis ou erros em `stderr`.

### 12. Regra do Reparo (_Rule of Repair_)

> _Quando você precisar falhar, falhe ruidosamente e o mais rápido possível._
> Adote princípios de _fail-fast_. Interrompa o fluxo e reporte com clareza o motivo da falha, evitando que erros silenciosos corrompam o estado do sistema.

### 13. Regra da Economia (_Rule of Economy_)

> _O tempo do programador é caro; economize-o em preferência ao tempo da máquina._
> Invista em automação repetível (`Makefile`, scripts de auditoria, linters) para liberar a mente humana para o raciocínio criativo.

### 14. Regra da Geração (_Rule of Generation_)

> _Evite trabalho manual repetitivo; escreva programas para escrever programas quando viável._
> Utilize geradores de código, scaffolds de templates e metaprogramação responsável para evitar duplicações mecânicas.

### 15. Regra da Otimização (_Rule of Optimization_)

> _Crie o protótipo antes de polir. Faça funcionar antes de otimizar._
> Otimização prematura é a raiz de muitos males. Meça gargalos com profilometria real antes de refatorar código em prol de desempenho.

### 16. Regra da Diversidade (_Rule of Diversity_)

> _Desconfie de todas as afirmações sobre 'a única maneira verdadeira'._
> Mantenha soluções abertas a diferentes plataformas, ambientes e cenários de integração, garantindo portabilidade e interoperabilidade.

### 17. Regra da Extensibilidade (_Rule of Extensibility_)

> _Projete para o futuro, pois ele chegará mais cedo do que você imagina._
> Mantenha protocolos desacoplados e esquemas versionados para que o sistema possa acomodar novas funcionalidades sem quebrar compatibilidade reversa.

### 18. Regra da Soberania do Usuário (_Rule of User Sovereignty_)

> _O usuário é o proprietário supremo de seus dados, código e infraestrutura._
> Rejeite aprisionamento tecnológico (_vendor lock-in_), telemetria invasiva e dependências de nuvens proprietárias. Priorize soluções auto-hospedadas e auditáveis.

### 19. Regra da Autonomia Reentrante (_Rule of Reentrant Autonomy_)

> _Toda rotina e operação deve ser idempotente, permitindo reinício a qualquer instante sem corrupção._
> Se um script ou processo for interrompido abruptamente, sua reexecução posterior deve restaurar ou continuar o estado de forma limpa e segura.

### 20. Regra do Hermetismo de Produção (_Rule of Production Hermeticity_)

> _Artefatos de governança e IA são descartáveis; a produção é estritamente soberana._
> A remoção de `.agents/` (`rm -rf .agents`) ou diretórios de IA não pode quebrar nenhum build, pipeline ou execução de produção.

### 21. Regra do Desacoplamento Dev-Hub (_Rule of Dev-Hub Decoupling_)

> _A bancada de desenvolvimento gera a verdade; a produção consome artefatos imutáveis._
> Desenvolva de forma centralizada e propague versões através do Git, sem modificar diretamente árvores de trabalho em ambientes de produção.

### 22. Regra da Antifragilidade & Resiliência Ativa (_Rule of Antifragile Resilience_)

> _O sistema melhora com estresse, variações e desordem, auto-curando-se continuamente._
> Incorpore mecanismos defensivos de auto-recuperação, detecção dinâmica de ferramentas e fallbacks elegantes para absorver choques sem entrar em colapso.

---

## 🧼 Diretrizes de Clean Code & Arquitetura de Comentários

1. **Autoexplicabilidade:** Código limpo não requer comentários narrativos. Escolha nomes precisos e construa pequenos blocos modulares.
2. **Zero Comentários Narrativos:** Evite comentários parafraseando o código. O código expressa sua intenção por meio de nomes semânticos e organização em blocos.
3. **Banners Arquiteturais em Três Camadas:**
    - **Header Banner:** 64 hífens (`# ----------------------------------------------------------------`).
    - **Seção Estrutural:** Régua de 32 caracteres com igualdade (`### ================================`).
    - **Subseção Interna:** Régua de 32 caracteres com hífen (`### --------------------------------`).
4. **Formatação Contínua:** Execute sempre `make format` e `make lint` para manter a conformidade do código e documentação.
5. **Escapes ANSI & Banimento de Octal:** Não use notação octal (`\033`, `\001`) para sequências de escape ANSI ou bytes. Utilize sempre `$'\e'` (em Makefiles: `_e=$$'\e';`) ou hexadecimal (`\x1b`). Notação octal é exclusiva para permissões de arquivos POSIX (`chmod 0755`, `chmod 0644`, `umask 022`).
6. **Matriz de Shells Suportada:** Automação e scripts de shell visam `zsh`, `bash`, FreeBSD `sh` e OpenBSD `ksh`. Shells ultra-restritos de recuperação (Debian `dash`, NetBSD `sh`) estão fora de escopo.
