# Virtualização Sob Demanda no FreeBSD (Bhyve e Linuxulator)

Este guia documenta os runtimes Linux opcionais sob demanda a partir de uma estação de trabalho FreeBSD (onde terminal, editores e agentes executam **nativamente no host** por padrão).

---

## 1. Topologia Opcional Host/Guest

1. **Host Soberano (FreeBSD):**
    - Atua como estação de trabalho principal (KDE sob Wayland), execução nativa de ferramentas e agentes (`agy`), ZFS (`zroot`) e terminal PTY.
    - Firewall PF com NAT configurável para a sub-rede virtual (ex.: `192.168.8.0/24`) e exportação NFSv3 opcional de `${HOME}` (`-mapall=<user>`).
2. **Guest Linux Opcional (Debian em Bhyve):**
    - Executa sob demanda via `vm-bhyve` em IP virtual configurado (`BHYVE_LINUX_IP` / `LINUX_HOST_IP`), com UID/GID alinhados e montagem NFS em `${HOME}` para workloads ou containers Linux.

---

## 2. Wrappers de Integração Sob Demanda no Shell

A camada de shell no host expõe funções utilitárias opcionais para delegar comandos específicos sem gestão manual de sessões:

- `linux-host` (aliases: `linux`, `lx`, `debian`, `deb`): Executa comandos no guest com resolução automática de diretório correspondente e fallback para `${HOME}`.
- `agy-bhyve` (alias: `agy-lx`): Despacho opcional de `agy` para o guest Bhyve; ativado como padrão de `agy()` com `SHELL_RUNTIME=bhyve` (`runtime bhyve` / `install.sh -r bhyve`) ou fallback de `auto` quando não houver binário local e `BHYVE_LINUX_IP`/`LINUX_HOST_IP` estiver definido.
- `agy-compat` (alias: `agy-cp`) & `linux-compat` (`compat-run`): Executa o binário via Linuxulator (`/compat/linux`) confinado dinamicamente aos E-cores (`cpuset` via `kern.sched.topology_spec`) e limites Go controlados (`GOMAXPROCS=2`, `GOGC=50`, `GOMEMLIMIT=2GiB`), padrão de `agy()` no FreeBSD quando `SHELL_RUNTIME=auto|compat`.
- `update-linux` (aliases: `uplx`, `updeb`): Atualiza pacotes no guest via SSH, integrando-se ao comando global `upall`.
