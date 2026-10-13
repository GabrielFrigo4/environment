# 🖥️ Arquitetura Bhyve Linux Runtime: Guia & Runbooks

> Documentação canônica do subsistema de virtualização Bhyve no FreeBSD, fornecendo um motor de execução Linux isolado e nativo para o Google Antigravity CLI (`agy`), contêineres OCI e ferramentas dependentes do kernel Linux.

---

## 🧭 Visão Geral

O runtime virtualizado no Bhyve resolve o desafio histórico de executar ferramentas modernas com dependências estritas do kernel Linux em estações de trabalho FreeBSD, preservando 100% da soberania do OpenZFS, rede Packet Filter (PF) e ambiente de desktop KDE.

---

## 📚 Índice da Série de Runbooks

| Runbook                                                                            | Foco Arquitetural e Operacional  | Tópicos Principais                                                                                   |
| :--------------------------------------------------------------------------------- | :------------------------------- | :--------------------------------------------------------------------------------------------------- |
| **[`01-arquitetura-e-paradigma.md`](01-arquitetura-e-paradigma.md)**               | Paradigma Híbrido & Fundamentos  | Tese soberana, 4 pilares técnicos, diagnóstico forense Go/Linuxulator e matriz de expansão.          |
| **[`02-provisionamento-e-host-tuning.md`](02-provisionamento-e-host-tuning.md)**   | Provisionamento & Tuning do Host | Instalação no host, governança ZFS ARC, firewall PF com NAT, template da VM e NFSv3.                 |
| **[`03-operacao-ciclo-de-vida-e-shell.md`](03-operacao-ciclo-de-vida-e-shell.md)** | Ciclo de Vida, Snapshots & Shell | Comandos `vm-bhyve`, snapshots atômicos ZFS, despacho `lx`/`agy`, propagação de TTY e rotina `uplx`. |

---

## ⚡ Comandos Rápidos de Referência

```sh
# Gestão da Máquina Virtual (Host FreeBSD)
vm list                  # Exibir status da VM
sudo vm start debian     # Iniciar VM em modo headless
sudo vm stop debian      # Parar VM graciosamente via ACPI
sudo vm console debian   # Acessar console serial nmdm (~. para sair)

# Despacho Interativo via Shell
lx uname -a              # Executar comando isolado no Linux guest
lx                       # Abrir shell interativo na mesma pasta
agy status               # Executar o Google Antigravity CLI no runtime Linux
uplx                     # Atualizar o sistema operacional guest (Debian)
```
