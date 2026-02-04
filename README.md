# Шаблон для создания питон проекта на nix через flake

### Список шаблонов:
- template: общий шаблон который можно допиливать

Использование шаблона:
```bash
nix flake init -t github:yorunikakeru/python_template#${template}
```

Для добавления библиотек в зависимости добавляем в buildInputs 
```nix
        buildInputs = [
          python
          pkg.<library name>
        ];

```

