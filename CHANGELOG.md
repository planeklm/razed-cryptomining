# Changelog

## [2026-10-07] - Mining fix

### Fixed
- Guard the per-player mining thread so toggle-spam can't multiply earnings loops.
- Miner purchase now charges first and checks the removal succeeded before inserting the miner row.
