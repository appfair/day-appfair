// SPDX-License-Identifier: GPL-2.0-or-later

mod page;
mod settings;
mod welcome;

pub(crate) use page::page;
pub(crate) use settings::{apply_startup, settings_body, settings_page};
pub(crate) use welcome::welcome_page;
