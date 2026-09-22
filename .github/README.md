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

`Day.toml` holds the app's own id. `Day-appfair.toml` beside it holds the ids the App Fair
publishes under, `org.appfair.app.<token>` with Play's and HarmonyOS's hyphen-free spelling, which
`day --flavor appfair` reads. The scaffolded CI builds that flavor alongside the app's own and
runs [appfair-lint](https://github.com/appfair/appfair-apps/tree/main/.github/actions/appfair-lint)
on every push.

It also publishes the web build to the app's Pages, so a push to the default branch puts the app
at `https://<owner>.github.io/<repo>/`. That needs Settings → Pages → Source = GitHub Actions
once, or the job fails. A `website/site.toml` turns it into the full project site
(daybrite/daysite), with the app under `/webapp/`.

The Welcome page's prose is markdown held in the translation, so a translator can stress a
different word, and it links to appfair.org. The second section is a heading, a paragraph and
three links; replace it with your app.

## Template conventions

| in this repository | in the scaffolded app |
|---|---|
| `Cargo.toml.hbs` | `Cargo.toml`. The `.hbs` keeps cargo from reading the template as a package |
| `_gitignore` | `.gitignore` |
| `_github/workflows/ci.yml` | `.github/workflows/ci.yml`. This repository's `.github/` stays here |
| `Day-appfair.toml` | the same, with `{{repo}}` / `{{ident}}` rendered into the App Fair ids |
| `_vscode/` | `.vscode/` |
| `platform/<os>/` | only the host projects the chosen targets need |
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
