# {{title}}

An [App Fair](https://appfair.org) app, built with [Day](https://daybrite.dev): one Rust codebase,
drawn with each platform's native widgets.

This app was scaffolded from the App Fair's template:

```bash
day new app {{repo}} --template https://github.com/appfair/day-appfair
```

## Run it

Day compiles one toolkit backend per binary, so name a target when you build or launch;
`Day.toml` lists the app's targets.

```sh
day doctor                     # check the toolchains for your targets
day launch -t {{first_target}}  # build + run
day launch -t {{first_target}} --script dayscript/demo.yaml   # walk through the app
day launch -t {{first_target}} --locale fr                    # in French
```

A bare `cargo build` or `cargo test` uses the crate's default `mock` backend, which is also what
rust-analyzer checks.

## What it does

Welcome and Items share adaptive navigation: the item list and editor sit side by side on a wide
window and stack on a phone. Give an item a name, a type and a color, and mark it done; every
change is saved as you make it, and Undo and Redo step back through them. Search narrows the
list, a swipe or the context menu marks an item done, dragging reorders it, and the Items tab
counts what is left to do. Settings holds the appearance, the language, the app's own setting for
completed items, and the App Fair group; About shows the app's name and version. On desktop both
open from the app menu; on a phone, Settings is a section. The app reopens on the section you
last visited.

## The App Fair group

Every App Fair app carries the App Fair group in its settings. The group says what the App Fair
Project is, links to the donation page, and lists the other App Fair apps on the store for the
platform the app runs on. It comes from the
[`day-piece-appfair`](https://github.com/appfair/day-piece-appfair) crate: `Cargo.toml` depends
on it, and `src/lib.rs` names its provider where the app declares its settings.

```rust
.provider(&day_piece_appfair::APP_FAIR)
```

Keep both lines. The `appfair-module` rule of
[appfair-lint](https://github.com/appfair/appfair-apps/tree/main/.github/actions/appfair-lint)
checks for them on every push and when the app is submitted. The rule also reads the committed
`Cargo.lock`, which has to take the crate from crates.io, so commit a lock before the first push
([Release dependency policy](#release-dependency-policy)). The id `appfair` belongs to this
group: give the app's own settings groups other ids.

The walkthrough opens the group the way a user does, from the card on the settings root on a
phone and from the Settings window on a desktop, and captures it.

## The code

- `src/lib.rs` sets up the window, the routes, the navigation, the menus, and the settings.
- `src/model.rs` holds the items and the selection they share, with the unit tests.
- `src/pages.rs` builds the Welcome page, the item list, and the editor.
- `resource/locales/` holds every string the app shows, in English and French.
- `dayscript/demo.yaml` walks through the app on every target and takes the screenshots.
- `Day.toml` holds the app's identity, targets, and window size, and `Day-appfair.toml` holds
  the id the App Fair publishes under.
- `platform/` holds the app-owned native files. Day generates the native projects under
  `build/`, and `day open -t <target>` opens one in its IDE
  ([native projects](https://daybrite.dev/docs/how-to/native-projects)).
- `store/` and `website/` hold the store listing and the website settings.
- `.github/workflows/ci.yml` runs appfair-lint, then builds and tests every target through the
  shared [Day workflow](https://daybrite.dev/docs/how-to/github-actions).
  `.github/dependabot.yml` opens weekly pull requests for the crates and the CI actions.

`day lint` checks routes, element ids, and locale coverage. Apple builds need Xcode 27 or newer.

## License

This app is free software under the [GNU General Public License, version 2 or later](LICENSE.txt).
App-owned source files carry this notice.

```
// SPDX-License-Identifier: GPL-2.0-or-later
```

Keep `LICENSE.txt` beside the app, and keep the notice on files you add. To publish under
different terms, replace the file and the notices before your first release. The App Fair
publishes what the repository declares.

## One-time repository setup

Three settings, each done once, all of them on this repository:

1. **Pages**: Settings → Pages → Source = **GitHub Actions**. The workflow publishes the site and
   the web build there.
2. **Let tags deploy it.** Turning Pages on creates a `github-pages` environment that admits the
   default branch alone, so a release tag cannot deploy and the site would only ever update on a
   push to `main`. Add a tag rule:

   ```sh
   gh api -X POST /repos/<owner>/<repo>/environments/github-pages/deployment-branch-policies \
     -f name='v*' -f type=tag
   ```

   or Settings → Environments → `github-pages` → Deployment branches and tags → Add rule →
   `v*`, type **Tag**. Without it, marking a release Latest rebuilds nothing.
3. **Install the App Fair app**: <https://github.com/apps/app-fair-publisher> → Install → this
   repository. It asks for `Contents: Read and write`, which is how the catalog attaches the
   packages it signed to your release beside your own.

## Publishing through the App Fair

The App Fair Project builds, signs, and submits the apps in its catalog. When this app is ready,
tag a release and open a pull request against
[`appfair/appfair-apps`](https://github.com/appfair/appfair-apps) naming the tag and its commit.

`Day-appfair.toml` sets one shared App Fair ID for all stores, derived from the repository
token by removing hyphens without changing case. For example, `App-Name` uses
`org.appfair.app.AppName`. The commented Android and HarmonyOS sections can be enabled
if separate store IDs are needed. `Day.toml` keeps the app's own ID for builds without the
`appfair` flavor.

The store listings' screenshots come from that release: the workflow attaches the walkthrough's
captures as `screenshots.zip` with `gallery.json` beside it, and the App Fair takes the ones
`store/storefront.toml` `[storefront…screenshots]` names, in that order, for every locale and device the
walkthrough ran on. Name the screens each listing should show there before you tag.

## Release dependency policy

Tagged App Fair releases use external Rust dependencies from crates.io and a checked-in
`Cargo.lock`. First-party crates within this repository remain workspace/path dependencies.
The tag workflow selects `day-deps: release`: it checks the lock with `cargo metadata --locked`,
rejects Git/local source overrides, preserves every resolved version, and installs the published
Day CLI matching the locked framework. It never updates or regenerates a release lock.
Development/main and scheduled compatibility builds may resolve different versions.

Prepare the release lock in a clean checkout without machine-local `.cargo` patches, run the
app's tests against that crates.io graph, and include the validated lock in the release commit
before tagging. Missing published dependencies must be released first; a Git fallback is not
permitted. After local patched development, regenerate/validate the crates.io lock in isolation
so the release does not inherit machine-local sources. App Fair submission rebuilds use the
same pinned lock and CLI. Committing or pushing still requires the maintainer's permission.
