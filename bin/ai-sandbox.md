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

**Globale (statica)** — attualmente vuota. Le directory di credenziali
(`~/.ssh`, `~/.aws`, `~/.docker`, …) non sono bloccate: l'agente deve
operare con l'identità dell'utente (git push, gh CLI, AWS CLI). Il
valore del layer globale è come punto di estensione per path che non
hanno mai senso esporre (es. `~/.config/gcloud` se non si lavora su GCP).

**Dinamica (per progetto)** — calcolata al momento del lancio da:
- file/directory gitignored (`git ls-files --ignored`)
- file cifrati con git-crypt (`git crypt status`)

L'assunzione è: se è gitignored è probabilmente un secret o un
artefatto che l'agente non ha bisogno di leggere. Se è cifrato con
git-crypt è esplicitamente sensibile.

**Esplicita (per progetto)** — via `.ai-sandbox` nella git root,
`AI_SANDBOX_BLOCK_PATHS` per bloccare file tracked che contengono
secrets (legacy config, tfvars, ecc.).

### 2. Ambiente ereditato integralmente

Il processo riceve l'intero ambiente della shell corrente, senza
filtri. L'agente deve poter impersonare l'utente: SSH, AWS CLI,
direnv vars, token — tutto deve funzionare esattamente come in
una shell normale.

Il file `.envrc` rimane bloccato in lettura (vedi blacklist di
progetto), ma le variabili che imposterebbe sono già nell'env
grazie all'hook direnv della shell che ha lanciato il sandbox.

### Strategia per OS

- **Linux** → firejail (`--noprofile` + `--blacklist` per path)
- **macOS** → docker run con mount selettivi (stub, non ancora implementato)

## Config di progetto (.ai-sandbox)

File bash sorgibile nella git root del progetto. Controlla:

```bash
AI_SANDBOX_ALLOW_PATHS=()   # path gitignored che l'agente può leggere
AI_SANDBOX_BLOCK_PATHS=()   # path tracked da bloccare comunque
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

Nota: firejail blocca sia file che directory via bind mount. Per i file,
`--blacklist` rende il contenuto inaccessibile (`cat` fallisce con
"Permission denied"), ma `ls file` usa `stat` e rimane accessibile.
I test usano `cat` per i file e `ls` per le directory per verificare
l'accesso al contenuto, non la sola presenza del path.

## Compromessi accettati

| Gap | Motivazione |
|-----|-------------|
| Docker socket non protetto | Complessità sproporzionata al rischio nel threat model |
| `ls file` passa anche su file blacklistati | Firejail blocca la lettura del contenuto; `ls` usa solo `stat`. Per i secrets il contenuto è protetto, non la presenza del path |
| Ambiente shell non filtrato | L'agente deve impersonare l'utente; filtrare l'env spezza SSH, AWS CLI, direnv vars senza proteggere da exfiltrazione via filesystem (credenziali già accessibili tramite file) |
| `~/.config` non bloccata | Troppo ampia; i secrets reali sotto `~/.config` (gcloud, ecc.) vanno aggiunti esplicitamente a `GLOBAL_BLACKLIST` |
| macOS non implementato | Stub documentato; richiede un'immagine Docker con i tool pre-installati |
| Rete non ristretta | L'esfiltrazione via rete è fuori dal threat model dichiarato |
