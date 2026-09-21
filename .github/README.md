# The App Fair app template

This repository is a [Day](https://daybrite.dev) project template: an ordinary Day app with
`{{placeholders}}` in it, which `day new` renders.

```bash
day new app Some-App --template https://github.com/appfair/day-appfair
```

The root `README.md` is the one a scaffolded app gets, which is why it reads as an app's README
and carries placeholders. This file is the template's, and `day new` never copies it: the loader
prunes a template's `.github/` along with its `.git`.

## What a scaffolded app starts with

Three sections (Welcome, The App Fair, Settings) in English and French, a walkthrough that drives
them on every toolkit, a store listing in both languages, the AGPL and the App Fair distribution
exception, and a CI workflow that builds every target the app declares.

That workflow also publishes the web build to the app's own Pages, so a push to the default branch
puts the app at `https://<owner>.github.io/<repo>/`. The repository needs Settings → Pages →
Source = GitHub Actions once; until it is set, that one job fails. A `website/site.toml` turns the
same job into the full project site (daybrite/daysite), with the app under `/webapp/`.

The Welcome page's prose is markdown held in the translation, so a translator can stress a
different word, and it links to appfair.org. The second section is a heading, a paragraph, and
three links. Replace it with your app.

## Template conventions

| in this repository | in the scaffolded app |
|---|---|
| `Cargo.toml.hbs` | `Cargo.toml`. The `.hbs` keeps cargo from reading the template as a package |
| `_gitignore` | `.gitignore` |
| `_github/workflows/ci.yml` | `.github/workflows/ci.yml`. This repository's `.github/` stays here |
| `_vscode/` | `.vscode/` |
| `platform/<os>/` | only the host projects the chosen targets need |
| `store/` | only when a chosen target ships to a store |

Every UTF-8 file is rendered, contents and path, so `src/{{snake}}.rs` works. An unknown
placeholder is an error rather than empty output. Binary files copy verbatim.

The placeholders used here are `{{title}}`, `{{repo}}`, `{{id}}`, `{{targets_toml}}`,
`{{targets_list}}`, `{{first_target}}`, `{{day_dep}}`, and `{{day_build_dep}}`. The full set is in
[Day's CLI documentation](https://daybrite.dev/docs/cli).

## One Fluent rule

`resource/locales/<tag>/app.ftl` holds the strings. A pattern line may not begin with `*`, `[`,
`.`, or `}`: Fluent reserves those, and a value that opens with one is dropped from the catalog,
which shows up as a missing `res::str::…` function at compile time. Write `This is **{{title}}**`
rather than `**{{title}}** is`.

## Checking a change

```bash
day new app Fair-Starter --template . --no-input --toolkit macos-appkit --toolkit ios-uikit
cd fair-starter && day lint && day build -p macos-appkit
day launch -p macos-appkit --script dayscript/demo.yaml
DAY_LOCALE=fr day launch -p macos-appkit --script dayscript/demo.yaml
```

`.github/workflows/template.yml` runs that on every push and pull request, then hands the
generated app to `daybrite/actions/.github/workflows/dayapp.yml`, which builds all eight primary
targets and runs the walkthrough in both languages and both appearances. That workflow's
`setup-command` input scaffolds the app, and marks the project generated rather than checked in.

A push to the default branch also publishes the generated app's web-dom build to this
repository's Pages, so what the template produces can be opened at
<https://appfair.github.io/day-appfair/>. It needs one repository setting: Settings → Pages →
Source = GitHub Actions.
