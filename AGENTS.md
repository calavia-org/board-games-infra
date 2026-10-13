# board-games-infra — Agent Instructions

> **MANDATORY READ**: This repository is governed by [`~/Development/Github/AGENTS.md`](../AGENTS.md) (organization-wide rules). Per-repo rules below provide project-specific details and **cannot override** organization rules.

## Project Overview

Terraform infrastructure for the calavia-org board-games project: AWS EKS cluster, VPC, RDS Postgres, ElastiCache Redis, ALB ingress, cert-manager, external-dns, monitoring, and AWS Secrets Manager rotation.

## Repository Layout

```
.
├── calavia-eks-infra/          # Root Terraform module + environments
│   ├── environments/
│   │   ├── production/
│   │   └── staging/
│   └── modules/                # Reusable Terraform modules (VPC, EKS, RDS, ...)
├── docs/                       # Environment setup and usage docs
├── scripts/                    # Helper scripts (AWS cost analysis, hooks, utils)
├── .devcontainer/              # Codespaces / dev container setup
├── .github/workflows/          # CI workflows
├── requirements.txt            # Python deps for helper scripts
└── AGENTS.md
```

## Tech Stack

- **Infrastructure as Code**: Terraform (AWS provider)
- **Cloud**: AWS (EKS, RDS, ElastiCache, ALB, WAF, Route53, Secrets Manager)
- **Cost visibility**: Infracost
- **Security scanning**: Trivy, TFLint
- **Dev environment**: devcontainer

## Environment Setup

See `docs/ENVIRONMENT-SETUP.md` and `docs/PRECOMMIT.md` on the `setup` branch while PR #1 is open.

## Linting & Formatting

```bash
pre-commit run --all-files
```

## Testing

```bash
terraform validate
tflint
trivy config .
```

## Commits & Branches

- All commits follow [Conventional Commits](https://www.conventionalcommits.org/) (`feat:`, `fix:`, `chore:`, `docs:`, `refactor:`, `perf:`, `test:`, `build:`, `ci:`).
- Branches use conventional prefixes: `feat/`, `fix/`, `chore/`, `docs/`, `refactor/`, `test/`, `style/`, `perf/`, `ci/`, `major/`.
- Never commit directly to `main`/`master` — every change goes through a PR with squash merge only.

## CI/CD

- PR checks: `.github/workflows/pr-check-and-test.yml` calls the org reusable `calavia-org/workflows-lib/.github/workflows/pr-check-and-test.yml@v0` (pre-commit + report). The `setup` branch also carries `.github/workflows/infrastructure-validation.yml` for Terraform-specific validation.
- Release: none — this repository has no versioned artifact.

## Key Commands

| Task | Command |
|------|---------|
| Validate Terraform | `terraform validate` |
| Run linting | `pre-commit run --all-files` |
| Run Trivy | `trivy config calavia-eks-infra` |
| Infracost breakdown | `infracost breakdown --path calavia-eks-infra` |

## Gotchas & Special Cases

- The full infrastructure code currently lives on the `setup` branch (open PR #1); `main` is a stub until that PR merges. This `AGENTS.md` applies to the repository as a whole.
- Helper scripts under `scripts/` include bash wrappers for `terraform validate`, `tflint`, and `trivy`.
- `.terraform.lock.hcl` files must be committed for reproducible applies.

## References

- **README.md**: high-level architecture overview
- **docs/USAGE.md**: usage instructions
- **docs/ENVIRONMENT-SETUP.md**: environment setup
- **Related repos**: `calavia-org/board-games`

---

**Last Updated**: 2026-10-12
**Maintained By**: calavia-org
