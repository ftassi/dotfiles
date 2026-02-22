# ai-sandbox

Secure wrapper for AI coding tools (Claude Code, Codex, Aider, …).

## Il problema

Quando un agente AI lavora su un progetto, ha accesso al filesystem
dell'utente. Il rischio principale non è un agente malevolo, ma
**l'esfiltrazione accidentale**: l'agente legge un file sensibile
(chiavi SSH, credenziali AWS, secrets cifrati) e lo include nel
contesto senza che l'utente se ne accorga.

Il threat model è deliberatamente stretto: strumenti fidati usati
da un utente consapevole, non un agente ostile che cerca attivamente
di esfiltrare dati.

## Come funziona

Lo script avvolge il comando dell'agente in due layer di protezione:

### 1. Filesystem blacklist

Costruita in tre strati sovrapposti:

**Globale (statica)** — directory sempre bloccate, indipendentemente
dal progetto: `~/.ssh`, `~/.aws`, `~/.gnupg`, `~/.docker`,
`~/.composer`. Non sovrascrivibile da config di progetto.

**Dinamica (per progetto)** — calcolata al momento del lancio da:
- file/directory gitignored (`git ls-files --ignored`)
- file cifrati con git-crypt (`git crypt status`)

L'assunzione è: se è gitignored è probabilmente un secret o un
artefatto che l'agente non ha bisogno di leggere. Se è cifrato con
git-crypt è esplicitamente sensibile.

**Esplicita (per progetto)** — via `.ai-sandbox` nella git root,
`AI_SANDBOX_BLOCK_PATHS` per bloccare file tracked che contengono
secrets (legacy config, tfvars, ecc.).

### 2. Environment clearenv + whitelist

Il processo viene lanciato con `env -i` (ambiente pulito) e
riceve solo le variabili in `ENV_WHITELIST`: PATH, HOME, LANG,
TERM e poche altre. `AWS_*`, `GITHUB_TOKEN`, `DATABASE_URL` e
simili vengono strippati.

Il progetto può estendere la whitelist via `AI_SANDBOX_ALLOW_ENV`
o bloccare variabili globali via `AI_SANDBOX_BLOCK_ENV`.

### Strategia per OS

- **Linux** → firejail (`--noprofile` + `--blacklist` per path)
- **macOS** → docker run con mount selettivi (stub, non ancora implementato)

## Config di progetto (.ai-sandbox)

File bash sorgibile nella git root del progetto. Controlla:

```bash
AI_SANDBOX_ALLOW_PATHS=()   # path gitignored che l'agente può leggere
AI_SANDBOX_BLOCK_PATHS=()   # path tracked da bloccare comunque
AI_SANDBOX_ALLOW_ENV=()     # variabili extra da passare
AI_SANDBOX_BLOCK_ENV=()     # variabili globali da strippare
```

Generare un template commentato con: `ai-sandbox.sh init [dir]`

## Decisioni di design

### ~/.config non è nella blacklist globale

`~/.config` contiene prevalentemente config di strumenti senza
secrets (`gh`, `codex`, `nvim`, ecc.). Bloccarla con una voce
unica rompe i CLI che l'agente deve usare. Il commento nello script
suggerisce come aggiungere voci mirate se necessario (es.
`~/.config/gcloud`).

### GLOBAL_TOOL_ALLOWLIST

Alcune directory di progetto sono gitignored per convenzione ma
indispensabili al tool AI per funzionare: `.claude/` (AGENT.md,
settings di sessione), `.codex/`, `.aider/`, `.continue/`.

Senza questa lista, la blacklist dinamica le blocherebbe. La
allowlist globale le salva a livello di script, senza richiedere
configurazione per ogni progetto.

La regola: se una directory serve all'agente *per funzionare* (non
per lavorare sul progetto), va qui.

### Docker socket lasciato libero

Il socket Docker non è ristretto. Un agente potrebbe teoricamente
montare path sensibili via `docker run -v`. La scelta è accettare
questo gap: il threat model è esfiltrazione accidentale da strumenti
fidati, non un agente che cerca attivamente escape path. Aggiungere
un docker-socket-proxy aumenterebbe la complessità senza proteggere
contro la distrazione, che è il rischio reale.

### firejail --noprofile

`--noprofile` disabilita i profili app-specifici di firejail.
Il sandbox costruisce la blacklist esplicitamente per avere
controllo totale su cosa viene bloccato. I profili di sistema
(es. `default.profile`) non vengono caricati.

Nota: firejail non può bloccare singoli **file** dentro `$HOME`,
solo directory. Questa è una limitazione nota della versione
attuale (0.9.72). I test usano `should_warn` per i casi ambigui.

## Compromessi accettati

| Gap | Motivazione |
|-----|-------------|
| Docker socket non protetto | Complessità sproporzionata al rischio nel threat model |
| File singoli in `$HOME` non blacklistabili | Limitazione firejail; bloccare le directory parent è sufficiente per i secrets noti |
| `~/.config` non bloccata | Troppo ampia; i secrets reali sotto `~/.config` (gcloud, ecc.) vanno aggiunti esplicitamente |
| macOS non implementato | Stub documentato; richiede un'immagine Docker con i tool pre-installati |
| Rete non ristretta | L'esfiltrazione via rete è fuori dal threat model dichiarato |
