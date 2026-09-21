# SPDX-License-Identifier: AGPL-3.0-only WITH App-Fair-Distribution-Exception
# {{title}}: UI strings (https://daybrite.dev/docs/localization). Add a locale by dropping a
# sibling folder and translating it; the generated res::locales catalog picks up every locale
# directory by itself. This starter ships English and French.

app_title = {{title}}

nav_welcome = Welcome
nav_navigate = The App Fair
nav_settings = Settings

# The Welcome page. `welcome_body` is rendered as markdown, so the emphasis and the links live
# in the translation and a translator is free to stress a different word. Each paragraph is one
# line: Fluent keeps the line breaks you write. A paragraph may not START with `*`, `[`, `.`
# or `}` — Fluent reserves those, and a value that opens with one is dropped from the catalog.
welcome_title = Welcome to {{title}}
welcome_body =
    This is **{{title}}**, an [App Fair](https://appfair.org) app: free software, built from source you can read, and distributed through the App Fair Project.

    The App Fair builds every app itself from a tagged commit, compares what it built against the release the maintainer published, and signs it with the project's own keys. Nothing else is added along the way.

    Read more at [appfair.org](https://appfair.org), or open [**Settings**](#settings) to change the appearance and the language.

# The second section.
navigate_title = The App Fair Project
navigate_body =
    Apps here are licensed under the [AGPL](https://www.gnu.org/licenses/agpl-3.0.html), with an exception that lets them be distributed through the app stores. Both texts ship beside this app, in LICENSE.txt and LICENSE-EXCEPTIONS.txt.
navigate_links = Where to go next
link_home = The App Fair
link_docs = Documentation
link_source = Source on GitHub

# Settings.
section_general = General
settings_appearance = Appearance
settings_language = Language
appearance_system = System
appearance_light = Light
appearance_dark = Dark

# Menus and commands.
menu_file = File
cmd_appfair = Visit the App Fair
