# The App Fair app template

This repository is a [Day](https://daybrite.dev) project template. It is an ordinary Day app with
`{{placeholders}}` in it, which `day new` renders:

```bash
day new app Some-App --template https://github.com/appfair/day-appfair
```

The root `README.md` is the README a scaffolded app gets, which is why it reads as one and
carries placeholders. This file is the template's own, and `day new` never copies it: the loader
prunes a template's `.github/` along with its `.git`.

## What a scaffolded app starts with

A three-section app — Welcome, The App Fair, Settings — in **English and French**, with a
walkthrough that drives it on every toolkit, a store listing in both languages, the AGPL and its
App Fair distribution exception, and a CI workflow that builds every target the app declares and
runs the walkthrough in both languages.

The Welcome page's prose is markdown held in the translation, so a translator can stress a
different word, and it links out to appfair.org. The second section is deliberately small: a
heading, a paragraph, and three links. Replace it with your app.

## Template conventions

| in this repository | in the scaffolded app |
|---|---|
| `Cargo.toml.hbs` | `Cargo.toml` — the `.hbs` keeps cargo from reading the template as a package |
| `_gitignore` | `.gitignore` |
| `_github/workflows/ci.yml` | `.github/workflows/ci.yml` — this repository's own `.github/` is its own CI |
| `_vscode/` | `.vscode/` |
| `platform/<os>/` | only the host projects the chosen targets need |
| `store/` | only when a chosen target ships to a store |

Every UTF-8 file is rendered — contents *and* path — so `src/{{snake}}.rs` works. An unknown
placeholder is an error rather than empty output. Binary files copy verbatim.

The placeholders used here are `{{title}}`, `{{repo}}`, `{{id}}`, `{{targets_toml}}`,
`{{targets_list}}`, `{{first_target}}`, `{{day_dep}}` and `{{day_build_dep}}`; the full set is in
[Day's CLI documentation](https://daybrite.dev/docs/cli).

## Fluent, and one rule worth knowing

`resource/locales/<tag>/app.ftl` holds the strings. A pattern line may not **begin** with `*`,
`[`, `.` or `}` — Fluent reserves those, and a value that opens with one is silently dropped from
the catalogue, which shows up as a missing `res::str::…` function at compile time. Write
`This is **{{title}}**` rather than `**{{title}}** is`.

## Checking a change

```bash
day new app Fair-Starter --template . --no-input --toolkit macos-appkit --toolkit ios-uikit
cd fair-starter && day lint && day build -p macos-appkit
day launch -p macos-appkit --script dayscript/demo.yaml
DAY_LOCALE=fr day launch -p macos-appkit --script dayscript/demo.yaml
```

`.github/workflows/template.yml` runs that on every push and pull request, then hands the
generated app to `daybrite/actions/.github/workflows/dayapp.yml` — the workflow every Day app
uses — which builds all eight primary targets and runs the walkthrough in both languages and both
appearances. The app is scaffolded there through that workflow's `setup-command` input, which is
also what tells it the project is generated rather than checked in.
