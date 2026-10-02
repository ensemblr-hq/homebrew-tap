cask "ensemblr" do
  arch arm: "arm64", intel: "x64"

  version "0.2.2"
  sha256 arm:   "8b793613dafb886722af9dc67caa9a56918f59759a84efd79d330eb656211395",
         intel: "96af34ece4762f73d4eb45283a14748bb4a67967d3624839c251ae2c00e10e7e"

  url "https://github.com/ensemblr-hq/ensemblr/releases/download/v#{version}/Ensemblr-#{version}-#{arch}.dmg"
  name "Ensemblr"
  desc "Orchestrator for multi-agent coding workflows in isolated git worktrees"
  homepage "https://www.ensemblr.dev/"

  # Every Ensemblr release is published as a prerelease, so `:github_latest`
  # finds nothing at all. Accept prereleases and let the leading `v` drop the
  # rolling `nightly` tag, which ships the canary channel under its own bundle
  # id and must never bump this cask.
  livecheck do
    url :url
    regex(/^v(\d+(?:\.\d+)+(?:-[\da-z.]+)?)$/i)
    strategy :github_releases do |json, regex|
      json.map do |release|
        next if release["draft"]

        match = release["tag_name"]&.match(regex)
        next if match.blank?

        match[1]
      end
    end
  end

  # Everything Ensemblr does with GitHub shells out to `gh` — cloning a
  # repository, the backlog board, the remote branch list, `gh pr create` and
  # `gh pr merge` — and it resolves the binary from the login-shell PATH it
  # captures, so a Homebrew-installed `gh` is the one it finds. Homebrew can put
  # it on disk but cannot sign it in; `gh auth login` stays the user's step.
  depends_on formula: "gh"
  # Electron 44 dropped Monterey, so Ventura is the floor the app can actually
  # launch on.
  depends_on macos: :ventura

  app "Ensemblr.app"

  # The workspace root (`~/Ensemblr` by default) is deliberately absent: it holds
  # the user's cloned repositories, worktrees and archived workspace contexts,
  # not application state. The Keychain item `dev.ensemblr.app.secret-store` is
  # out of `zap`'s reach and is documented as a manual step instead.
  zap trash: [
    "~/.config/ensemblr",
    "~/Library/Application Support/dev.ensemblr.app",
    "~/Library/Application Support/Ensemblr",
    "~/Library/Caches/dev.ensemblr.app",
    "~/Library/Caches/dev.ensemblr.app.ShipIt",
    "~/Library/HTTPStorages/dev.ensemblr.app",
    "~/Library/Preferences/dev.ensemblr.app.plist",
    "~/Library/Saved Application State/dev.ensemblr.app.savedState",
  ]
end
