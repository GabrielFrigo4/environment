# 🖥️ Arquitetura Bhyve Linux Runtime: Guia e Runbooks

Documentação canônica do subsistema de virtualização Bhyve no FreeBSD, fornecendo um motor de execução Linux isolado e nativo para o Google Antigravity CLI (`agy`) e ferramentas dependentes de syscalls avançadas do kernel Linux.

---

## 📚 Índice da Série de Runbooks

1. **[01-inventario-e-ports.md](01-inventario-e-ports.md):** Inventário de pacotes do host FreeBSD, mídia ISO Debian e binários locais.
2. **[02-host-tuning-zfs-e-pf.md](02-host-tuning-zfs-e-pf.md):** Governança de memória ZFS ARC, firewall PF com NAT e configurações de sysctl.
3. **[03-bhyve-debian-vm.md](03-bhyve-debian-vm.md):** Criação da VM Debian 13.7, template Bhyve, modo headless e espelhamento NFSv3.
4. **[04-antigravity-cli-dual-exec.md](04-antigravity-cli-dual-exec.md):** Estratégia de despacho do Shell (`linux-host`, `agy-lx`, `agy-compat`) e conformidade POSIX.
5. **[05-diagnostico-anatomia-falha.md](05-diagnostico-anatomia-falha.md):** Diagnóstico aprofundado das incompatibilidades do runtime Go no Linuxulator.
6. **[06-operacao-manutencao-e-snapshots.md](06-operacao-manutencao-e-snapshots.md):** Gestão do ciclo de vida da VM, snapshots no ZFS e rotina `update-linux` (`uplx`, `updeb`).
