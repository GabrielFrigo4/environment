# 🛡️ Devfs Rulesets & Segurança em Jails

> Governança de isolamento de dispositivos de hardware (`devfs`), mitigação de privilégios de superusuário e blindagem de segurança no FreeBSD.

---

## 🧭 O Risco de Dispositivos de Hardware em Ambientes Compartilhados

No modelo de segurança UNIX, a abstração _"tudo é um arquivo"_ estende-se aos dispositivos de hardware no sistema de arquivos especial `devfs` (`/dev`).

Se uma Jail tiver acesso irrestrito ao diretório `/dev`:

1. **Comprometimento de Memória:** Acesso a `/dev/mem` ou `/dev/kmem` permitiria que um invasor lesse ou alterasse diretamente a memória do kernel do host, escapando do confinamento.
2. **Espionagem e Sobrescrita de Disco:** Acesso a `/dev/ada0`, `/dev/nvd0` ou nós GEOM permitiria modificar partições físicas ou roubar chaves de pools ZFS.
3. **Interceptação de Tráfego:** Acesso a `/dev/bpf` permitiria capturar pacotes de todas as interfaces físicas e virtuais da máquina.

Para neutralizar esses vetores, o FreeBSD emprega o subsistema de **regras de filtragem do sistema de arquivos de dispositivos (`devfs rulesets`)**.

---

## 📐 O Ruleset Padrão de Jails: Ruleset 4

O sistema operacional define conjuntos de regras canônicos em `/etc/defaults/devfs.rules`. O **Ruleset 4 (`devfsrules_jail`)** é o perfil padrão seguro aplicado a Jails convencionais:

```text
[devfsrules_jail=4]
add include $devfsrules_hide_all
add include $devfsrules_unhide_basic
add path zfs unhide
```

Esse perfil:

- Oculta todos os nós de dispositivos (`hide all`).
- Revela apenas primitivas fundamentais seguras:
    - Dispositivos nulos e geradores de entropia: `null`, `zero`, `random`, `urandom`.
    - Dispositivos de terminal de controle: `tty`, `ptmx`, nós de pseudoterminal `pts/*`.
    - Dispositivos de I/O padrão: `stdin`, `stdout`, `stderr`.

---

## 🔧 Criando Rulesets Customizados em `/etc/devfs.rules`

Quando uma Jail necessita de dispositivos adicionais (por exemplo, acesso a aceleração de vídeo, placas de som ou soquetes BPF controlados), deve-se criar um ruleset derivado em `/etc/devfs.rules`:

```text
# ================================================================
# Arquivo: /etc/devfs.rules
# ================================================================

# Ruleset 10: Jail para ferramentas de rede ou monitoramento
[devfsrules_jail_network=10]
add include $devfsrules_jail
# Permite Berkeley Packet Filter estritamente na jail
add path 'bpf*' unhide

# Ruleset 20: Jail com acesso a GPU para transcodificação de mídia
[devfsrules_jail_gpu=20]
add include $devfsrules_jail
# Expor nós DRM Intel para aceleração de vídeo por hardware
add path 'dri*' unhide
add path 'drm*' unhide
```

### Ativação do Arquivo de Regras no Host:

Adicione ao `/etc/rc.conf` do host:

```sh
devfs_system_ruleset="devfsrules_common"
devfs_load_rulesets="YES"
```

E recarregue as regras:

```sh
sudo service devfs restart
```

---

## 🔒 Flags de Controle e Parâmetros de Isolamento

Além do `/dev`, o `/etc/jail.conf` permite modular os privilégios concedidos ao superusuário enjaulado:

| Parâmetro           | Padrão |             Recomendação             | Descrição                                                                                                                   |
| :------------------ | :----: | :----------------------------------: | :-------------------------------------------------------------------------------------------------------------------------- |
| `allow.raw_sockets` |  `0`   |       `1` apenas se necessário       | Permite uso de utilitários como `ping` e `traceroute`. Em VNET, isso é gerenciado com segurança pela própria pilha virtual. |
| `allow.chflags`     |  `0`   |                 `0`                  | Impede que usuários na Jail alterem flags imutáveis do sistema de arquivos (`chflags uchg`).                                |
| `allow.sysvipc`     |  `0`   |                 `0`                  | IPC System V compartilhado (filas de mensagens e memória compartilhada). Deixe `0` para isolamento total de processos.      |
| `allow.mount`       |  `0`   |                 `0`                  | Impede montagem de filesystems arbitrários dentro da jail.                                                                  |
| `allow.mount.zfs`   |  `0`   | `0` (ou `1` para datasets delegados) | Permite delegar administração de datasets ZFS específicos diretamente para a jail (`zfs jail`).                             |

---

## ⚡ Verificação & Auditoria

Para inspecionar quais dispositivos estão efetivamente visíveis dentro da Jail:

```sh
# Inspecionar nós montados no devfs da jail ativa
sudo jexec web01 ls -la /dev

# Conferir ruleset ativo aplicado na jail
sudo devfs -m /usr/jails/web01/dev rule show
```
