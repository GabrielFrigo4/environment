# 🖥️ Arquitetura Bhyve Linux Runtime: Guia & Runbooks

> Documentação canônica do subsistema de virtualização sob demanda Bhyve no FreeBSD, fornecendo um motor de execução Linux isolado para contêineres OCI, compilação cruzada, despacho opcional (`agy-lx`) e ferramentas dependentes do kernel Linux.

---

## 🧭 Visão Geral

Enquanto o shell, os editores e os agentes de IA operam nativamente no host FreeBSD por padrão, o runtime virtualizado opcional no Bhyve resolve cargas que exigem o kernel Linux diretamente, preservando a soberania do OpenZFS, rede Packet Filter (PF) e ambiente de desktop KDE.

---

## 📚 Índice da Série de Runbooks

| Runbook                                                                            | Foco Arquitetural e Operacional  | Tópicos Principais                                                                                      |
| :--------------------------------------------------------------------------------- | :------------------------------- | :------------------------------------------------------------------------------------------------------ |
| **[`01-arquitetura-e-paradigma.md`](01-arquitetura-e-paradigma.md)**               | Paradigma Híbrido & Fundamentos  | Tese soberana, 4 pilares técnicos, histórico de contenção Go/Linuxulator e matriz de workloads.         |
| **[`02-provisionamento-e-host-tuning.md`](02-provisionamento-e-host-tuning.md)**   | Provisionamento & Tuning do Host | Instalação no host, governança ZFS ARC, firewall PF com NAT, template da VM e NFSv3.                    |
| **[`03-operacao-ciclo-de-vida-e-shell.md`](03-operacao-ciclo-de-vida-e-shell.md)** | Ciclo de Vida, Snapshots & Shell | Comandos `vm-bhyve`, snapshots atômicos ZFS, despacho `lx`/`agy-lx`, propagação de TTY e rotina `uplx`. |

---

## ⚡ Comandos Rápidos de Referência

```sh
vm list
sudo vm start debian
sudo vm stop debian
sudo vm console debian

lx uname -a
lx
agy-lx status
uplx
```
