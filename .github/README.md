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

Three sections (Welcome, The App Fair, Settings) in English and French, a walkthrough that drives
them on every toolkit, a store listing in both languages, the AGPL and the App Fair distribution
exception, and a CI workflow that builds every target the app declares.

`Day.toml` holds the app's own id. `Day-appfair.toml` beside it holds the one id the App Fair
publishes under on every store, `org.appfair.app.<token>` with the token's hyphens removed (so Play
and HarmonyOS accept it as-is), which `day --flavor appfair` reads. The scaffolded CI builds that flavor alongside the app's own and
runs [appfair-lint](https://github.com/appfair/appfair-apps/tree/main/.github/actions/appfair-lint)
on every push.

It also publishes the web build to the app's Pages, so a push to the default branch puts the app
at `https://<owner>.github.io/<repo>/`. That needs Settings → Pages → Source = GitHub Actions
once, or the job fails. A `website/site.toml` turns it into the full project site
(daybrite/daysite), with the app under `/webapp/`.

The Welcome page's prose is markdown held in the translation, so a translator can stress a
different word, and it links to appfair.org. The second section is a heading, a paragraph and
three links; replace it with your app.

## Apple projects

Use a Day CLI with automatic Xcode project generation and **Xcode 27 or newer** for
Apple builds. This template deliberately carries no `.xcodeproj` folders. Day derives
`build/day/xcode/<macos|ios>/DayApp.xcodeproj/project.xcproj` when preparing, building,
or opening the app. Swift sources, plists, and `.xcconfig` files remain template inputs.
The generated project derives both English and French from `resource/locales/`.

Use `day open -t macos-appkit` or `day open -t ios-uikit` to prepare and open Xcode.
A scaffolded app can opt into a persistent project with
`day project add-target macos-appkit,ios-uikit --persist-native-project` using Day's
built-in project template; no `--template` argument is needed for this opt-in.

Android and HarmonyOS also use generated projects: `build/android/` for Gradle and
`build/day/harmony/project/` for hvigor. The template carries neither build scaffold.
Use `day open -t android-mdc` or `day open -t harmony-arkui` to prepare and open the
project. VS Code's **Open in Android Studio** uses the generated Gradle path too.
For manual customization, run `day project add-target android-mdc,harmony-arkui
--persist-native-project` on one line. Existing native projects remain supported.
A Day CLI with Android/HarmonyOS project generation is required.

## Template conventions

| in this repository | in the scaffolded app |
|---|---|
| `Cargo.toml.hbs` | `Cargo.toml`. The `.hbs` keeps cargo from reading the template as a package |
| `_gitignore` | `.gitignore` |
| `_github/workflows/ci.yml` | `.github/workflows/ci.yml`. This repository's `.github/` stays here |
| `_github/dependabot.yml` | `.github/dependabot.yml`: weekly Dependabot updates for the crates and the pinned actions |
| `Day-appfair.toml` | the same, with `{{repo}}` / `{{ident}}` rendered into the App Fair ids |
| `_vscode/` | `.vscode/` |
| `platform/<os>/` | only the host sources and configuration the chosen targets need |
| `store/` | only when a chosen target ships to a store |

Every UTF-8 file is rendered, contents and path, so `src/{{snake}}.rs` works. An unknown
placeholder fails the scaffold rather than rendering empty. Binary files copy verbatim.

The placeholders used here are `{{title}}`, `{{repo}}`, `{{id}}`, `{{targets_toml}}`,
`{{targets_list}}`, `{{first_target}}`, `{{day_dep}}`, and `{{day_build_dep}}`. The full set is in
[Day's CLI documentation](https://daybrite.dev/docs/cli).

## One Fluent rule

`resource/locales/<tag>/app.ftl` holds the strings. A pattern line may not begin with `*`, `[`,
`.` or `}`: Fluent reserves those, and a value that opens with one is dropped from the catalog,
which surfaces as a missing `res::str::…` function at compile time. Write `This is
**{{title}}**` rather than `**{{title}}** is`.

## Checking a change

```bash
day new app Fair-Starter --template . --no-input --toolkit macos-appkit --toolkit ios-uikit
cd fair-starter && day lint && day build -p macos-appkit
day launch -p macos-appkit --script dayscript/demo.yaml
DAY_LOCALE=fr day launch -p macos-appkit --script dayscript/demo.yaml
```

`.github/workflows/template.yml` runs that on every push and pull request, then hands the
generated app to `daybrite/actions/.github/workflows/dayapp.yml` for all eight targets in both
languages and both appearances. Its `setup-command` input scaffolds the app and marks the project
generated rather than checked in.

A push to the default branch publishes the generated app's web-dom build to this repository's
Pages, <https://appfair.github.io/day-appfair/>, which needs Settings → Pages → Source = GitHub
Actions once.
