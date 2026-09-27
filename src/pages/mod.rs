// SPDX-License-Identifier: AGPL-3.0-only WITH App-Fair-Distribution-Exception

mod page;
mod settings;
mod welcome;

pub(crate) use page::page;
pub(crate) use settings::{apply_startup, settings_body, settings_page};
pub(crate) use welcome::welcome_page;
