#!/usr/bin/env bash
set -euo pipefail

project_dir=$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")" && pwd)
source_dir="$project_dir/build/localsend"
source_commit=d01fdb14c978fa8b2b13e29a50cc0feaefe5c1b9

mkdir -p "$project_dir/build" "$project_dir/bin"

if [[ ! -d "$source_dir/.git" ]]; then
    git clone --filter=blob:none https://github.com/localsend/localsend.git "$source_dir"
fi

git -C "$source_dir" fetch --depth 1 origin "$source_commit"
git -C "$source_dir" checkout --detach "$source_commit"
git -C "$source_dir" reset --hard "$source_commit"
git -C "$source_dir" apply "$project_dir/online-status.patch"
cargo build --release --locked --manifest-path "$source_dir/cli/Cargo.toml"
install -m 0755 "$source_dir/target/release/localsend-cli" "$project_dir/bin/localsend-cli"

printf 'Built %s\n' "$project_dir/bin/localsend-cli"
