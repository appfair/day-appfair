// SPDX-License-Identifier: AGPL-3.0-only WITH App-Fair-Distribution-Exception
//! Generates typed `res::` constants from `resource/` (https://daybrite.dev/docs/resources).
fn main() {
    day_build::generate_resources().expect("day-build: resource codegen");
}
