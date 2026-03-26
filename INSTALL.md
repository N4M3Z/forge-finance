# forge-finance

> Tax law rules, document analysis, and filing workflows for Czech personal income tax.

*This file follows the [install.md](https://github.com/mintlify/install-md) standard — structured instructions for AI agents to execute autonomously. Human readers: see [README.md](README.md) for conventional documentation.*

I want you to install forge-finance for me. Execute all the steps below autonomously.

## OBJECTIVE

Deploy forge-finance skills, rules, and agents to all configured AI coding providers.

## DONE WHEN

Running `/TaxReturn 2025` opens the tax return preparation workflow.

## TODO

- [ ] Ensure forge CLI is available
- [ ] Install the module
- [ ] Configure Fakturoid credentials
- [ ] Verify the installation

## Steps

### forge CLI

You need the `forge` binary. If `forge --help` is not available:

```sh
cargo build --release --manifest-path path/to/forge-cli/Cargo.toml
ln -sf path/to/forge-cli/target/release/forge ~/.local/bin/forge
```

### Install

```sh
forge install path/to/forge-finance
```

This assembles and deploys skills, rules, and agents to `.claude/`, `.gemini/`, `.codex/`, and `.opencode/`.

### Configure Fakturoid

Create `.env` in the module root with your OAuth credentials:

```sh
FAKTUROID_CLIENT_ID=<your-oauth-client-id>
FAKTUROID_CLIENT_SECRET=<your-oauth-client-secret>
```

Register an OAuth app at Fakturoid Settings > API using the Client Credentials flow.

### Verify

Confirm skills are deployed:

```sh
ls .claude/skills/TaxReturn/SKILL.md
ls .claude/skills/Fakturoid/SKILL.md
ls .claude/agents/TaxAdvisor.md
ls .claude/rules/PersonalTaxIncome.md
```

EXECUTE NOW: Complete the above TODO list to achieve: `/TaxReturn 2025` opens the tax return preparation workflow.
