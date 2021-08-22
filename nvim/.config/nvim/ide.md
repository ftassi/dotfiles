## Definition of done

- Code navigation
    - [*] Fuzzy find files
    - [*] Find in tree
    - [*] Fuzzy find classes
    - [*] Fuzzy find symbols
    - [*] Goto definition
    - [*] Goto reference
    - [ ] prev / next diagnostic
    - [ ] prev / next git hunk
    - [ ] prev / next git file
    - [ ] prev / next git change
- Gutter
    - [ ] child / parent implementations
    - [*] Git Status

- Refactoring
    - [*] Rename variable
    - [*] Rename class
    - [*] Rename method
    - [-] Find Usage //Not really find usage but find references. incoming calls and outgoing calls seems to be misssing in any php language server
    - [ ] Extract Method
    - [ ] Extract variable
    - [ ] Extract interface
    - [ ] Move Class
    - [ ] Generate fields based from constructor
    - [ ] Some phpdoc help (don't really need much, maybe a snippet could word too)
    - [ ] Introduce variable
    - [ ] Introduce field
    - [ ] Introduce parameter
    - [ ] Introduce constant
- Dev Workflow
    - [ ] Local history
    - [*] Git history
    - [*] Git add/stage/remove (index management)
    - [ ] Git pull/push/merge/rebase (remote management)
    - [ ] Git branch management
    - [*] Execute tests from ide

- Other stuff
    - [*] Find/Replace by regexp in file
    - [ ] Find/Replace by regexp in project
    - [ ] Code formatting
    - [ ] Copy class full namespace (copy reference in phpstorm)
- Refactoring nice to have
    - [ ] Move element up (move to parent class)
    - [ ] Move element down

- Fine tuning
    - [ ] Telescope find implementations result formatting: full namespace

## Todo
- keybind telescope.builtin.current_buffer_fuzzy_find
- keybind telescope.builtin.git_files
- keybind *builtin.git_bcommits()*
## Notes

telescope.builtin.file_browser could replace nerdtree entirely?

## Links

- Improve dev workflow https://alpha2phi.medium.com/new-neovim-plugins-to-improve-development-workflow-33419d74e9ac
- Note taking in vim https://alpha2phi.medium.com/vim-neovim-managing-notes-and-todo-list-8ae8e3db6464
- Complete php ide setup (may be a bit outdated though) https://thevaluable.dev/vim-php-ide/ 
