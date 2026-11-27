# 🚀 Bootstrap & Automação de Templates no BastilleBSD

> Instalação, inicialização de releases base do FreeBSD e automação reprodutível através de templates e Bastillefiles.

---

## 🧭 Instalação & Configuração Inicial

O BastilleBSD é distribuído diretamente pela árvore de pacotes oficial do FreeBSD (`sysutils/bastille`):

```sh
doas pkg install --yes sysutils/bastille
```

### Arquivo de Configuração: `/usr/local/etc/bastille/bastille.conf`

O arquivo define armazenamento (com integração nativa a clones ZFS COW sobre `zroot/bastille`), diretórios de releases/templates e a interface de loopback padrão (`bastille0`):

```text
bastille_prefix="/usr/local/bastille"
bastille_backupsdir="${bastille_prefix}/backups"
bastille_cachedir="${bastille_prefix}/cache"
bastille_jailsdir="${bastille_prefix}/jails"
bastille_releasesdir="${bastille_prefix}/releases"
bastille_templatesdir="${bastille_prefix}/templates"

bastille_zfs_enable="YES"
bastille_zfs_zpool="zroot"
bastille_zfs_prefix="bastille"

bastille_network_loopback="bastille0"
bastille_network_shared=""
```

Após ajustar a configuração, habilite o serviço no `/etc/rc.conf`:

```sh
doas sysrc bastille_enable="YES"
```

---

## 📦 Bootstrapping de Releases Base

Antes de criar qualquer container, o Bastille faz o _bootstrap_ da release oficial do FreeBSD em um dataset ZFS imutável e lista as bases disponíveis no host:

```sh
doas bastille bootstrap 15.1-RELEASE update
doas bastille list release
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

Conteúdo do `Bastillefile` (instala `nginx` e `curl`, copia a configuração, habilita o serviço e valida a resposta HTTP):

```dockerfile
PKG nginx curl

CP nginx.conf /usr/local/etc/nginx/nginx.conf

SYSRC nginx_enable=YES
SERVICE nginx start

CMD curl -I http://localhost
```

### Aplicando o Template em um Container:

Aplique o template diretamente ao container alvo (`web01`):

```sh
doas bastille template web01 my-templates/nginx
```
