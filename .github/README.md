# The App Fair app template

This repository is a [Day](https://daybrite.dev) project template: an ordinary Day app with
`{{placeholders}}` in it, which `day new` renders.

```bash
day new app Some-App --template https://github.com/appfair/day-appfair
```

The root `README.md` is the one a scaffolded app gets, so it reads as an app's README and carries
placeholders. This file is the template's; `day new` prunes a template's `.github/` along with
its `.git`.

## What a scaffolded app starts with

The app that Day's
[built-in template](https://github.com/daybrite/day/tree/main/crates/day-cli/templates/app)
scaffolds, with the App Fair's additions. The source layout, the features and lints tables, the
resources, and the walkthrough follow the built-in template: a Welcome page, a list of items with
an editor, and settings, in English and French.

The App Fair adds:

- The GPL version 2 text, `license = "GPL-2.0-or-later"` in `Cargo.toml`, and the
  `GPL-2.0-or-later` notice on every source file.
- The App Fair group in the app's settings, from the
  [`day-piece-appfair`](https://github.com/appfair/day-piece-appfair) crate: the dependency in
  `Cargo.toml.hbs` and `.provider(&day_piece_appfair::APP_FAIR)` in `src/lib.rs`. The
  walkthrough opens the group at the route `settings/appfair` and captures it.
- `Day-appfair.toml`, the `appfair` flavor. `Day.toml` holds the app's own id, and the flavor
  holds the one id the App Fair publishes under on every store, `org.appfair.app.<token>` with
  the token's hyphens removed (so Play and HarmonyOS accept it as-is), which
  `day --flavor appfair` reads.
- A CI workflow that runs
  [appfair-lint](https://github.com/appfair/appfair-apps/tree/main/.github/actions/appfair-lint)
  on every push and builds every target the app declares. The lint's `appfair-module` rule
  checks for the dependency and the provider line, so a scaffolded app passes it from its first
  push.
- A store listing in both languages, weekly Dependabot updates, and the App Fair's wording on the
  Welcome page, in the File menu, and in the README.

`Cargo.toml.hbs` writes Day and its pieces out as crates.io requirements instead of using
`{{day_dep}}`, because a tagged App Fair release builds from crates.io and the lint refuses a
`path` or `git` source for the module. `day patch --local <checkout>` points a development build
at a checkout.

The workflow also publishes the web build to the app's Pages, so a push to the default branch
puts the app at `https://<owner>.github.io/<repo>/`. That needs Settings → Pages → Source =
GitHub Actions once, or the job fails. `website/site.toml` turns it into the full project site
(daybrite/daysite), with the app under `/webapp/`.

The Welcome page's prose is markdown held in the translation, so a translator can stress a
different word, and it links to appfair.org.

## Native projects

Apple builds need **Xcode 27 or newer**. The template carries no `.xcodeproj` folders: Day
derives `build/day/xcode/<macos|ios>/DayApp.xcodeproj/project.xcproj` when preparing, building,
or opening the app. Swift sources, plists, and `.xcconfig` files remain template inputs.
The generated project derives both English and French from `resource/locales/`.

Use `day open -t macos-appkit` or `day open -t ios-uikit` to prepare and open Xcode.
A scaffolded app can opt into a persistent project with
`day project add-target macos-appkit,ios-uikit --persist-native-project` using Day's
built-in project template; no `--template` argument is needed for this opt-in.

Android and HarmonyOS also use generated projects: `build/android/` for Gradle and
`build/day/harmony/project/` for hvigor. The template carries neither build scaffold. Its one
Android file is `platform/android/AndroidManifest.xml`, the optional overlay Day merges into the
generated manifest. Use `day open -t android-material` or `day open -t harmony-arkui` to prepare
and open the project. For manual customization, run
`day project add-target android-material,harmony-arkui --persist-native-project`.

## Template conventions

| in this repository | in the scaffolded app |
|---|---|
| `Cargo.toml.hbs` | `Cargo.toml`. The `.hbs` keeps cargo from reading the template as a package |
| `AGENTS.md.hbs` | `AGENTS.md`. The `.hbs` keeps the file from applying to this repository |
| `_gitignore` | `.gitignore` |
| `_github/workflows/ci.yml` | `.github/workflows/ci.yml`. This repository's `.github/` stays here |
| `_github/dependabot.yml` | `.github/dependabot.yml`: weekly Dependabot updates for the crates and the pinned actions |
| `Day-appfair.toml` | the same, with `{{repo_no_hyphens}}` rendered into the App Fair id |
| `_vscode/` | `.vscode/` |
| `platform/<os>/` | only the host sources and configuration the chosen targets need |
| `store/` | only when a chosen target ships to a store |

Every UTF-8 file is rendered, contents and path, so `src/{{snake}}.rs` works. An unknown
placeholder fails the scaffold rather than rendering empty, and so does a GitHub Actions
expression written as `${{ … }}`: write it `$\{{ … }}`, as `_github/workflows/ci.yml` does.
Binary files copy verbatim.

The placeholders used here are `{{title}}`, `{{name}}`, `{{repo}}`, `{{repo_no_hyphens}}`,
`{{id}}`, `{{pascal}}`, `{{targets_toml}}`, `{{first_target}}`, `{{app_clippy_lints}}`, and
`{{deploy_web}}`. The full set is in
[Day's CLI documentation](https://daybrite.dev/docs/reference/cli).

Keep placeholders out of Rust code that rustfmt lays out by line length. A long app name would
move a line break, and the fresh scaffold would fail `cargo fmt --check`.

## One Fluent rule

`resource/locales/<tag>/app.ftl` holds the strings. A pattern line may not begin with `*`, `[`,
`.` or `}`: Fluent reserves those, and a value that opens with one is dropped from the catalog,
which surfaces as a missing `res::str::…` function at compile time. Write `This is
**{{title}}**` rather than `**{{title}}** is`.

## Checking a change

Scaffold outside this checkout, then check the app the way its CI does:

```bash
cd "$(mktemp -d)"
day new app Fair-Starter --template /path/to/day-appfair --no-input
cd Fair-Starter
cargo fmt --check && cargo clippy --all-targets -- -D warnings && cargo test
day lint
python3 /path/to/appfair-apps/.github/actions/appfair-lint/appfair_lint.py --path .
day launch -t macos-appkit --script dayscript/demo.yaml
day launch -t macos-appkit --locale fr --script dayscript/demo.yaml
```

To see what the App Fair adds, scaffold the built-in template beside it
(`day new app Plain-Starter --no-input`) and diff the two directories. When the built-in
template changes, that diff shows what to bring over.

`.github/workflows/template.yml` scaffolds the app on every push and pull request and runs
`day lint`, rustfmt, and appfair-lint on it. It then hands the generated app to
`daybrite/actions/.github/workflows/dayapp.yml` for all eight targets in both languages and both
appearances. Its `setup-command` input scaffolds the app and marks the project generated rather
than checked in.

A push to the default branch publishes the generated app's web-dom build to this repository's
Pages, <https://appfair.github.io/day-appfair/>, which needs Settings → Pages → Source = GitHub
Actions once.
