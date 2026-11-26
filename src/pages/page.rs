// SPDX-License-Identifier: GPL-2.0-or-later

use crate::res;
use day::prelude::*;

/// Replace this placeholder with your app's second page.
pub(crate) fn page() -> impl Piece {
    column((
        spacer(),
        label(res::str::page_placeholder())
            .align(TextAlign::Center)
            .color(Color::hex(0x808080))
            .id("page-placeholder"),
        spacer(),
    ))
    .align(HAlign::Center)
    .grow()
    .padding(24.0)
}
