---
name: antifragile-engineering
description: >-
    Runbook cognitivo para sistemas antifrágeis e auto-cura no ecossistema soberano.
    Usar ao implementar resolução dinâmica em cascata, auto-reparo de permissões,
    mitigação de falhas silenciosas e suporte adaptativo multiplataforma.
---

# 🛡️ Antifragile Engineering — Sistemas Resilientes e Auto-Cura

> _"Some things benefit from shocks; they thrive and grow when exposed to volatility, randomness, disorder, and stressors and love adventure, risk, and uncertainty. [...] Let us call what is non-fragile and gains from disorder 'antifragile'."_<br>
> — Nassim Nicholas Taleb, _Antifragile: Things That Gain from Disorder_ (2012)

Esta skill estabelece os princípios arquiteturais e modelos cognitivos para softwares, ferramentas de terminal, loaders e rotinas de automação no ecossistema soberano. O software não apenas sobrevive a perturbações e caminhos corrompidos, mas **auto-descobre recursos em tempo de voo, repara suas permissões e repara ativamente o ambiente da sessão**.

---

## 🏛️ Espectro da Resiliência Sistêmica

| Dimensão                   | 🔴 Frágil                              | 🟡 Robusto                         | 🟢 Antifrágil (Canônico)                                                    |
| :------------------------- | :------------------------------------- | :--------------------------------- | :-------------------------------------------------------------------------- |
| **Localização de Arquivo** | Caminho fixo hardcoded                 | Fallback estático secundário       | Cascata dinâmica de inspeção (Env $\rightarrow$ Contexto $\rightarrow$ XDG) |
| **Permissões POSIX**       | Rejeitado pelo utilitário (`ssh`, etc) | Exibe erro alertando o operador    | **Auto-cura defensiva em voo** (`chmod 0600`) antes do comando              |
| **Variáveis de Sessão**    | Interrupção por referência nula        | Aplica valor default               | Localiza o recurso e **injeta o caminho descoberto no ambiente corrente**   |
| **Encaminhamento**         | Alias estático sem flags adicionais    | Função simples com repasse parcial | **Argument forwarding irrestrito** (`"$@"`) e delegação dinâmica            |
| **Falha de Recurso**       | Stacktrace com encerramento abrupto    | Retorna código de erro limpo       | Aciona canais secundários de contingência com degradação graciosa           |

---

## 📐 Pilares de Engenharia e Roteador Cognitivo

Para procedimentos operacionais e referências detalhadas, consulte os manuais modulares:

- [references/pillars.md](references/pillars.md): Os 8 pilares da engenharia antifrágil (descoberta em cascata, auto-cura de permissões, reexportação de ambiente, argumentos dinâmicos, clone out-of-the-box, elevação idempotente, `shift` seguro e recarga de perfis multi-shell).
- [references/runtimes.md](references/runtimes.md): Contratos para PowerShell, NuShell, cursores emulados versus consoles puros (GUI/PTY `blink` e Raw TTY `noblink`), bypass de timeouts DSR/DA1 no FreeBSD `vt(4)` e bootstrap do GNU Emacs.
- [references/anti-patterns.md](references/anti-patterns.md): Casos de estudo comparando códigos frágeis com as correções antifrágeis canônicas.

---

## 🛠️ Padrão Mínimo de Despacho com Resolução em Cascata

Abaixo está o modelo padrão para conexões resilientes com auto-cura e preservação de argumentos:

```sh
connect_server() {
	_ip="${SERVER_IP:-127.0.0.1}"
	_user="${SERVER_USER:-root}"
	_key="$(_resolve_vault_key "${SERVER_KEY:-}" "id_ed25519")"

	if [ -n "${_key}" ]; then
		export SERVER_KEY="${_key}"
		ssh -i "${_key}" "${_user}@${_ip}" "$@"
	else
		ssh "${_user}@${_ip}" "$@"
	fi
}
```
