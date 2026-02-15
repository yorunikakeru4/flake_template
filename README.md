# Шаблон для создания питон проекта на nix через flake

## Список шаблонов:

Использование шаблона:

```bash
nix flake init -t github:yorunikakeru/flake_template#${template}
```

Список templates:

- python
- rust
- go
- elixir
- lua
- js
- php
- nvim

Template nvim подтягивает помимо nvim ещё и конфигурацию из codeberg (codeberg.org/yorunikakeru/dotfiles)

Для добавления библиотек в зависимости Python добавляем в buildInputs

```nix
buildInputs = [
  python
  pkg.<library name>
];

```
