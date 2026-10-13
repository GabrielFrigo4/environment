# 🚀 Bootstrap & Automação de Templates no BastilleBSD

> Instalação, inicialização de releases base do FreeBSD e automação reprodutível através de templates e Bastillefiles.

---

## 🧭 Instalação & Configuração Inicial

O BastilleBSD é distribuído diretamente pela árvore de pacotes oficial do FreeBSD:

```sh
# Instalação via gerenciador de pacotes pkg
sudo pkg install -y sysutils/bastille
```

### Arquivo de Configuração: `/usr/local/etc/bastille/bastille.conf`

O arquivo de configuração define os parâmetros centrais de armazenamento, rede e comportamento do daemon. Em ambientes baseados em ZFS, certifique-se de configurar:

```text
# ================================================================
# Configuração Canônica do BastilleBSD
# ================================================================
bastille_prefix="/usr/local/bastille"
bastille_backupsdir="${bastille_prefix}/backups"
bastille_cachedir="${bastille_prefix}/cache"
bastille_jailsdir="${bastille_prefix}/jails"
bastille_releasesdir="${bastille_prefix}/releases"
bastille_templatesdir="${bastille_prefix}/templates"

# Integração Nativa com ZFS (Clones COW instantâneos)
bastille_zfs_enable="YES"
bastille_zfs_zpool="zroot"
bastille_zfs_prefix="bastille"

# Rede Padrão
bastille_network_loopback="bastille0"
bastille_network_shared=""
```

Após ajustar a configuração, habilite o serviço no `/etc/rc.conf`:

```sh
sudo sysrc bastille_enable="YES"
```

---

## 📦 Bootstrapping de Releases Base

Antes de criar qualquer container, o Bastille precisa fazer o _bootstrap_ de uma release do FreeBSD. Esse processo baixa os binários do sistema operacional oficial e os armazena em um dataset ZFS de leitura imutável:

```sh
# Fazer bootstrap da release atual do FreeBSD
sudo bastille bootstrap 14.2-RELEASE update

# Listar as bases instaladas e disponíveis no host
sudo bastille list release
```

Quando um container é criado a partir dessa release, o Bastille realiza um clone instantâneo em ZFS (_Copy-on-Write_), consumindo zero megabytes adicionais de disco até que arquivos comecem a ser modificados dentro do container.

---

## 📝 Automação Declarativa com Bastillefiles

Um **Bastillefile** é o equivalente ao `Dockerfile` para containers FreeBSD. Ele descreve a receita de provisionamento de forma legível, determinística e versionável em Git.

### Diretivas Canônicas do Bastillefile:

| Diretiva  | Descrição                                     | Exemplo                               |
| :-------- | :-------------------------------------------- | :------------------------------------ |
| `PKG`     | Instala pacotes via FreeBSD `pkg`             | `PKG nginx curl git`                  |
| `SYSRC`   | Modifica parâmetros do `/etc/rc.conf` da jail | `SYSRC nginx_enable=YES`              |
| `SERVICE` | Gerencia estado de serviços                   | `SERVICE nginx start`                 |
| `CP`      | Copia arquivos do template para o container   | `CP nginx.conf /usr/local/etc/nginx/` |
| `CMD`     | Executa comandos arbitrários no container     | `CMD chown -R www:www /usr/local/www` |
| `OVERLAY` | Aplica árvores completas de arquivos          | `OVERLAY usr/local/etc/`              |

### Exemplo Prático: Template de Servidor Web Nginx

Estrutura do diretório do template em `/usr/local/bastille/templates/my-templates/nginx/`:

```text
nginx/
├── Bastillefile
└── nginx.conf
```

Conteúdo do `Bastillefile`:

```dockerfile
# Instalar servidor Nginx
PKG nginx curl

# Copiar arquivo de configuração pré-testado
CP nginx.conf /usr/local/etc/nginx/nginx.conf

# Habilitar e iniciar o daemon
SYSRC nginx_enable=YES
SERVICE nginx start

# Testar saúde da instalação
CMD curl -I http://localhost
```

### Aplicando o Template em um Container:

```sh
# Aplicar template diretamente ao container web01
sudo bastille template web01 my-templates/nginx
```
