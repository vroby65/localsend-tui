# LocalSend TUI

An interactive terminal client for [LocalSend](https://localsend.org/), built
from the official `localsend-cli`. This project pins an upstream revision and
adds periodic device discovery so devices that come online later are found and
offline devices disappear from the list.

## Download and run

Download the latest build for your Linux architecture, extract it, and start
the TUI:

```bash
case "$(uname -m)" in
  x86_64)  arch=x86_64 ;;
  aarch64|arm64) arch=aarch64 ;;
  *) echo "Unsupported architecture: $(uname -m)" >&2; exit 1 ;;
esac
curl -fL "https://github.com/vroby65/localsend-tui/releases/latest/download/localsend-tui-linux-${arch}.tar.gz" -o localsend-tui.tar.gz
tar -xzf localsend-tui.tar.gz
./localsend-tui
```

Direct downloads: [x86_64 Linux](https://github.com/vroby65/localsend-tui/releases/latest/download/localsend-tui-linux-x86_64.tar.gz) · [ARM64 Linux](https://github.com/vroby65/localsend-tui/releases/latest/download/localsend-tui-linux-aarch64.tar.gz).
The ARM64 build requires a 64-bit operating system.

See [all releases](https://github.com/vroby65/localsend-tui/releases).

## Requirements

- Git
- Rust and Cargo
- An internet connection for the initial source and dependency download

## Build

```bash
./build.sh
```

The launcher builds the pinned LocalSend source, applies
[`online-status.patch`](online-status.patch), and puts the executable in
`bin/localsend-cli`. The source checkout and binary are kept in the ignored
`build/` and `bin/` directories.

## Use the interactive TUI

```bash
./localsend-tui
```

The TUI stays open to receive files. It scans the local network for new devices
every 15 seconds and checks known devices every 5 seconds. Device status changes
are written to the log; unreachable devices are removed from the online device
list and appear again when reachable.

To send files:

1. Press `D` to open the discovered device list.
2. Select a recipient with the arrow keys and press `Enter`.
3. Use the arrow keys and `Enter` to browse folders.
4. Press `Space` to select files. Press `Enter` on a file to start sending it.

Press `Esc` to go back or cancel a selection.

## Receive files

For a first transfer from an unpaired device, press `Y` when the request appears
in the log. Press `P` to accept and pair the sender; later transfers from that
device are accepted automatically.

The receiving computer must allow inbound TCP and UDP traffic on port `53317`
from the local network. Without that firewall rule, other devices cannot reach
the receiver.

## Send from the command line

```bash
./localsend-tui send file.pdf photo.jpg
./localsend-tui send --to 192.168.178.35 file.pdf
```

Transfers use the official LocalSend protocol.

## Upstream and license

This project is an unofficial wrapper and patch for LocalSend. It uses the
LocalSend source at commit
[`d01fdb1`](https://github.com/localsend/localsend/commit/d01fdb14c978fa8b2b13e29a50cc0feaefe5c1b9),
licensed under Apache-2.0. The patch changes upstream discovery behavior; see
the patch and upstream license in [`LICENSE`](LICENSE).
