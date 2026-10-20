# Contratos de Runtimes e Ambientes Específicos

Este documento define regras de compatibilidade e mitigação para peculiaridades de runtimes modernos, terminais virtuais e emuladores.

---

## 1. Resolução Case-Insensitive e Aliases no PowerShell

Definir aliases com o mesmo identificador da função subjacente gera chamadas recursivas infinitas em runtimes insensíveis à caixa. Funções e aliases devem ter nomes distintos, registrando aliases via `Set-Alias -Force -Option AllScope`.

---

## 2. Sincronização de PATH no Windows com NuShell

O Windows NT mantém a variável nativa `Path`, enquanto o NuShell trata identificadores de ambiente com sensibilidade à caixa. Configure `$env.ENV_CONVERSIONS` para ambas as chaves e sincronize ambas com o caminho limpo:

```nushell
$env.Path = $_cleaned_path
$env.PATH = $_cleaned_path
```

---

## 3. Injeção de Credenciais Git em Subprocessos

Quando o runtime isolar variáveis de autenticação em subprocessos, injete o helper explicitamente via parâmetro de configuração do Git:

```nushell
let gh_bin = (get-gh-cmd)
if ($gh_bin | is-not-empty) {
	let helper_arg = $"credential.[https://github.com.helper](https://github.com.helper)=!\"($gh_bin)\" auth git-credential"
	^$git_bin -C $target -c $helper_arg pull --ff-only
}
```

---

## 4. Dinâmica de Cursores em GUI, PTY e Raw TTY

A ergonomia visual de editores e shells diferencia a capacidade do terminal:

- **GUI e Emuladores Gráficos (PTY):** O cursor opera em modo dinâmico e piscante (`blink`). Em terminais VT/PTY, use códigos ímpares DECSCUSR (`\e[1 q` bloco, `\e[3 q` sublinhado, `\e[5 q` barra vertical) e intervalos em `guicursor` (`blinkwait700-blinkoff400-blinkon250`).
- **Raw TTY de Console:** O cursor opera em modo estático (`noblink`). Em consoles virtuais Linux (`TERM=linux`), aplique sequências como `\e[?2c` até `\e[?6c` e reemita `\e%G\e[?16;238;0c` ao retornar ao prompt para recuperar caracteres UTF-8 e evitar anomalias cromáticas.

---

## 5. Bypass de Timeouts DSR e DA1 no Console vt(4) do FreeBSD

No kernel do FreeBSD, a rotina `termteken_respond()` no console virtual nativo `/dev/ttyv*` não responde a consultas de status do dispositivo (`DSR \e[5n`, `OSC 11`) ou atributos primários (`DA1 \e[c`).

- **Inicialização do NeoVim:** Exporte `NVIM_NOTTYFAST=1` quando `RAW_TTY=1` para evitar erro de timeout de DSR no `defaults.lua`.
- **Finalização do NeoVim:** Interponha no wrapper um respondedor transparente para responder imediatamente a `\e[c` e `\e[5n`, evitando atrasos de encerramento de até 1000ms.

---

## 6. Governança de Bootstrap do GNU Emacs

- **Fila Unificada Elpaca:** Evite chamadas intermediárias a `(elpaca-wait)` quando pacotes posteriores dependerem de submódulos compartilhados.
- **Cura de Builds Desatualizados:** Valide a integridade dos links entre `sources/<pkg>` e `builds/<pkg>` no bootstrap, removendo a pasta construída caso arquivos novos do upstream não tenham links associados.
- **Preservação de Tecla Escape:** Não associe `<escape>` diretamente no `global-map` sem preservar a tradução do terminal em emuladores e GUI.
