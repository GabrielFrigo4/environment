# Arquitetura Híbrida Host/Guest (FreeBSD e Bhyve)

Este guia documenta o isolamento de ferramentas baseadas em Go e runtimes dependentes de chamadas do Linux que exigem suporte a epoll e HTTP/2, executadas a partir de uma estação de trabalho FreeBSD.

---

## 1. Topologia da Infraestrutura

1. **Host Soberano (FreeBSD):**
    - Atua como estação de trabalho principal, gerenciador de janelas KDE sob Wayland, ZFS nativo (`zroot`) e terminal PTY.
    - Firewall PF configurado com NAT para a subrede virtual `192.168.8.0/24`.
    - Servidor NFSv3 exportando `/home/gabrielf` com a flag `-mapall=gabrielf`.
2. **Guest Linux (Debian em Bhyve):**
    - Executa no endereço estático `192.168.8.2` sob hypervisor Bhyve.
    - UID e GID sincronizados em 1001 com montagem automática de `/home/gabrielf` via NFS.
    - Hospeda ferramentas como o binário `agy` em `/usr/local/bin/agy`.

---

## 2. Wrappers de Integração Transparente no Shell

A camada de shell no host expõe funções utilitárias para interagir diretamente com o guest sem necessidade de gestão manual de sessões:

- `linux-host` (aliases: `linux`, `lx`, `debian`, `deb`): Executa comandos no guest com resolução automática de diretório correspondente e fallback para `/home/gabrielf`.
- `agy-lx` (aliases: `agy`, `agy-bh`): Despacha o agente Antigravity na máquina virtual repassando todos os argumentos.
- `agy-compat` (alias: `agy-cp`): Executa o binário utilizando o emulador de binários Linux do FreeBSD (`/compat/linux`) com afinidade e limites de processo controlados.
- `update-linux` (aliases: `uplx`, `updeb`): Executa rotina de atualização de pacotes no guest via SSH, integrando-se ao comando global `upall`.
