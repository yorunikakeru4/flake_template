# Nix flake templates

## Список шаблонов:

Использование шаблона:

```bash
nix flake init -t github:yorunikakeru/flake_template#${template}
```

Список templates:

- base
- python-dev
- go-dev
- rust-dev
- rust-build
- elixir-dev
- lua-dev
- cpp-dev
- cpp-build
- c-sharp-dev
- android-dev
- android-build
- php-dev
- js-dev
- nix-dev
- nvim

Template nvim подтягивает помимо nvim ещё и конфигурацию из codeberg (codeberg.org/yorunikakeru/dotfiles)

Для добавления библиотек в зависимости Python добавляем в buildInputs

```nix
buildInputs = [
  python
  pkg.<library name>
];

```
