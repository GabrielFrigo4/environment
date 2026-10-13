# 🔬 Diagnóstico e Anatomia da Falha (Go Runtime vs. FreeBSD Linuxulator)

Análise técnica da incompatibilidade estrutural entre o runtime da linguagem Go (Google Antigravity CLI) e a camada de emulação Linuxulator do FreeBSD, motivando a transição para virtualização via Bhyve.

---

## 1. Causas Raiz do Colapso no Linuxulator

* **Syscalls de Rede Incompatíveis (HTTP/2):**
  O cliente gRPC/HTTP do runtime do Go forçava negociação HTTP/2 com chamadas de socket (`setsockopt`) não implementadas pelo subsistema Linuxulator do kernel FreeBSD, disparando rajadas contínuas de mensagens de erro no `dmesg`.

* **Spin-Loop no `fsnotify` (`projects.go`):**
  O Linuxulator traduz chamadas `inotify` e `epoll` para o subsistema nativo `kqueue` do FreeBSD. Ao registrar descritores de arquivo em modo não-bloqueante (`IN_NONBLOCK`), as chamadas `read()` subsequentes retornavam `EAGAIN`. Na ausência de tratamento de *backoff* ou *sleep* adaptativo no código do `projects.go`, a aplicação entrava em um ciclo fechado (*spin-loop*) com frequência estimada em ~300.000 iterações por segundo.

* **Exaustão de Memória e Degradação do GC:**
  Esse loop alocava centenas de milhares de instâncias da estrutura `os.SyscallError` no heap da linguagem. O coletor de lixo (*Garbage Collector*) do Go não conseguia acompanhar a taxa de alocação de ponteiros efêmeros, provocando saturação rápida de memória Swap e competindo diretamente pela memória física (*wired memory*) alocada pelo ZFS ARC.

* **Saturação de I/O de Disco (ZFS TXG Throttle):**
  A gravação descontrolada de logs de diagnóstico em disco (~97 MB em questão de segundos) saturava a esteira de transações de escrita do ZFS (*Transaction Groups - TXG*), travando a responsividade geral do subsistema de armazenamento.

* **Disputa e Interrupção por Sinais (`SIGURG`):**
  A geração massiva de sinais assíncronos de preempção do Go (`SIGURG`) interrompia chamadas `nanosleep` e gerava contenção extrema nos mutexes do kernel (`futex`).

---

## 2. Ação das Mitigações Paliativas no `agy-compat` (/compat/linux)

O estudo detalhado das variáveis internas do Go permitiu mitigar parcialmente os sintomas no Linuxulator:

* **`http2client=0` + `netdns=go`:** Forçou o cliente HTTP a operar estritamente em HTTP/1.1 e utilizou o resolvedor DNS interno em Go, cessando erros de socket no kernel.
* **`asyncpreemptoff=1`:** Desativou o envio massivo de sinais assíncronos `SIGURG`.
* **`GOMAXPROCS=2` + `cpuset -l` + `nice -n 16`:** Confinou a execução a 2 núcleos de CPU com prioridade rebaixada no escalonador ULE, impedindo o congelamento do desktop FreeBSD.
* **`--log-file /dev/null`:** Eliminou o estrangulamento de gravação de transações síncronas no ZFS.
* **`GOMEMLIMIT="1GiB"` + `GOGC=8`:** Forçou coletas de lixo ultra-agressivas, reduzindo o ritmo do vazamento de ~500 MB/min para ~14 MB/min.
* **Limitação Residual Inerente:** A fragmentação de memória e limitações do suporte a `madvise` pelo Linuxulator mantinham uma perda contínua de ~14 MB/min, inviabilizando sessões prolongadas de trabalho.

---

## 3. Resolução Arquitetural Definitiva via Bhyve + NFSv3

A execução isolada no Debian virtualizado resolveu 100% dos problemas de raiz:

1. **Kernel Linux Nativo:** Execução sob kernel Debian 6.12/systemd com suporte pleno a `epoll`, `inotify` e sockets HTTP/2. Zero vazamento de memória e **0.0% de uso de CPU em repouso**.
2. **Espelhamento Transparente via NFSv3:** A exportação total de `/home/gabrielf` com a opção `-mapall=gabrielf` no host e montagem no guest garante que todas as operações em disco sejam gravadas nativamente com a identidade e permissões corretas no ZFS.
3. **Transparência de Ambiente:** A injeção da variável `HOME=/home/gabrielf` permite que o agente leia e atualize credenciais (`~/.gemini`), configurações (`~/.config`) e histórico sem qualquer duplicação de dados.
