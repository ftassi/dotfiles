#!/usr/bin/env python3
"""
Hook per proteggere file sensibili leggendo i pattern da settings.json.
Blocca Read, Edit, MultiEdit, Write su file che matchano i pattern deny.
"""

import sys
import json
from pathlib import Path
from fnmatch import fnmatch


def load_deny_patterns():
    """Carica i pattern deny da settings.json."""
    settings_path = Path.home() / '.claude' / 'settings.json'
    try:
        with open(settings_path) as f:
            settings = json.load(f)
        return settings.get('permissions', {}).get('deny', [])
    except (FileNotFoundError, json.JSONDecodeError, KeyError):
        return []


def extract_pattern(deny_rule, tool_name):
    """
    Estrae il pattern da una regola deny come 'Read(**/.env)'.
    Ritorna il pattern solo se la regola è per il tool specificato.
    """
    prefix = f'{tool_name}('
    if deny_rule.startswith(prefix) and deny_rule.endswith(')'):
        return deny_rule[len(prefix):-1]
    return None


def matches_pattern(file_path, pattern):
    """
    Verifica se il path matcha il pattern glob.
    Gestisce pattern con ** per directory ricorsive.
    """
    file_path = str(file_path)

    # Rimuove ./ iniziale se presente
    if pattern.startswith('./'):
        pattern = pattern[2:]

    # Per pattern che iniziano con **/, prova a matchare su ogni suffisso del path
    if pattern.startswith('**/'):
        suffix_pattern = pattern[3:]  # Rimuove **/
        path_parts = file_path.split('/')
        for i in range(len(path_parts)):
            partial_path = '/'.join(path_parts[i:])
            if fnmatch(partial_path, suffix_pattern):
                return True
            # Prova anche solo il filename per pattern semplici
            if fnmatch(path_parts[-1], suffix_pattern):
                return True

    # Match diretto
    if fnmatch(file_path, pattern):
        return True

    # Match sul solo filename
    if fnmatch(Path(file_path).name, pattern):
        return True

    return False


def main():
    try:
        data = json.load(sys.stdin)
        tool_name = data.get('tool_name')
        tool_input = data.get('tool_input', {})
        file_path_str = tool_input.get('file_path')

        if not file_path_str:
            sys.exit(0)

        file_path = Path(file_path_str)
        deny_rules = load_deny_patterns()

        for rule in deny_rules:
            pattern = extract_pattern(rule, tool_name)
            if pattern and matches_pattern(file_path, pattern):
                result = {
                    "decision": "block",
                    "reason": (
                        f"SECURITY_POLICY_VIOLATION: Accesso a '{file_path}' bloccato.\n"
                        f"Pattern: {rule}\n"
                        f"I file che matchano questo pattern possono contenere credenziali o dati sensibili."
                    )
                }
                print(json.dumps(result))
                sys.exit(0)

    except (json.JSONDecodeError, KeyError) as e:
        # In caso di errore, lascia passare (fail open)
        # Puoi cambiare in sys.exit(2) per fail close
        pass

    sys.exit(0)


if __name__ == "__main__":
    main()
