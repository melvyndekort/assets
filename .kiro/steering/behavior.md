# assets

> For global standards, way-of-workings, and pre-commit checklist, see `~/.kiro/steering/behavior.md`

## Role

Web developer and DevOps engineer.

## What This Does

Static resources site. Deployed to Cloudflare Pages via Terraform.

## Repository Structure

- `src/` — Static assets
- `terraform/` — Cloudflare Pages project, DNS
- `Makefile` — `init`, `plan`, `apply`, `decrypt`, `encrypt`

## Terraform Details

- Backend: S3 key `assets.tfstate` in `mdekort-tfstate-075673041815`
- Providers: Cloudflare `~> 5.0`
- Secrets: KMS context `target=assets`

## Related Repositories

- `~/src/melvyndekort/tf-cloudflare` — DNS and API tokens
