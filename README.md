# Ensemblr Homebrew tap

The Homebrew cask for [Ensemblr](https://www.ensemblr.dev) — a macOS
orchestrator for Pi and Claude Code, where every stream of work gets its own git
worktree and an agent can drive the app itself.

## Install

```sh
brew install --cask ensemblr-hq/tap/ensemblr
```

Or tap first, then install:

```sh
brew tap ensemblr-hq/tap
brew install --cask ensemblr
```

Or, in a `brew bundle` `Brewfile`:

```ruby
tap "ensemblr-hq/tap"
cask "ensemblr"
```

Ensemblr is Apple silicon only and needs macOS Monterey or newer — the cask
declares both, so `brew` refuses rather than installing something that cannot
run.

## Updating

Ensemblr updates itself: the app checks for a new release on launch and installs
it in place, so the cask is marked `auto_updates true` and an ordinary
`brew upgrade` leaves it alone. That is deliberate — two updaters writing the
same bundle is how an install gets corrupted.

To make Homebrew take the newest release instead of the in-app updater:

```sh
brew upgrade --cask --greedy ensemblr
```

## Uninstall

```sh
brew uninstall --cask ensemblr
```

That removes the app and leaves your data alone. To take the application data
with it:

```sh
brew uninstall --zap --cask ensemblr
```

Two things `zap` deliberately does **not** touch:

- **Your workspace root** (`~/Ensemblr` unless you moved it). It holds your
  cloned repositories, worktrees and archived workspace contexts — your work,
  not Ensemblr's state.
- **The Keychain item** `dev.ensemblr.app.secret-store`, which Homebrew cannot
  reach. Remove it in Keychain Access, or:

  ```sh
  security delete-generic-password -s dev.ensemblr.app.secret-store
  ```

  Repeat until it reports no matching item — the store holds one entry per
  secret.

## Which builds live here

The stable channel only, tracking the `v*` releases of
[`ensemblr-hq/ensemblr`](https://github.com/ensemblr-hq/ensemblr/releases). The
nightly canary build is a separate channel with its own bundle id and never
bumps this cask; download it from the
[`nightly` release](https://github.com/ensemblr-hq/ensemblr/releases/tag/nightly)
if you want it.

The cask's `version` and `sha256` are bumped by the release workflow in the main
repository, not by hand.

## Issues

File them against [`ensemblr-hq/ensemblr`](https://github.com/ensemblr-hq/ensemblr/issues).
