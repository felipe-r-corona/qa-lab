# QA Lab: Modular Performance Testing & Orchestration

This repository contains scripts, systemd units, and documentation for Felipe's modular, audit-proof QA lab.

## Structure

- `scripts/`: Shell scripts for orchestration and automation
- `systemd/`: Service and timer units for resilient scheduling
- `docs/`: Architecture notes, setup guides, and runner config
- `tests/`: Optional test harnesses and dry-run scripts
- `.github/workflows/`: CI/CD pipelines for validation and hygiene

## Goals

- 🔒 Privilege hygiene and secure orchestration
- 🔁 Modular reuse and auditability
- 🧪 Reliable performance testing and health checks

## Setup

Clone the repo and wire into your lab VM:

```bash
git clone https://github.com/felipe-r-corona/qa-lab.git

