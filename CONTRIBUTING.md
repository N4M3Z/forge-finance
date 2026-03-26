# Contributing

Contributions are welcome. Fork the repo, branch from `main`, and open a pull request.

## Module Structure

```
agents/           Agent definitions (PascalCase .md files)
skills/           Skill definitions (PascalCase directories with SKILL.md)
rules/            Behavioral rules (always-on session instructions)
docs/decisions/   Architecture Decision Records
templates/        ADR and filing templates
docs/cz/          Czech tax XML schemas (XSD)
```

## Conventions

- Conventional Commits: `type: description` (lowercase, no trailing period, no scope)
- Types: `feat`, `fix`, `docs`, `chore`, `refactor`, `test`
- Czech legal terms in backticks, English equivalents in prose
- Every numeric value cites its statutory origin
- `.mdschema` files enforce structure in agents/, skills/, rules/, and docs/decisions/

## Validation

```sh
make test     # validate module structure
make lint     # schema + shell linting
```

## License

EUPL-1.2. By contributing, you agree to license your contributions under the same terms.
