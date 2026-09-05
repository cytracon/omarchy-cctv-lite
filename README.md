# CCTV Lite — Omarchy plugin

Omarchy Quattro bar widget for **[CCTV Lite](https://github.com/cytracon/cctv-lite)** `0.2.0`.

This listing is a **Quickshell bar plugin**. It does **not** ship the GTK viewer and does **not** contain camera credentials. Left-click opens a panel with camera count and layout; right-click launches CCTV Lite when `~/.local/bin/cctv-lite` is present.

Layout follows the official Omarchy plugin template: `manifest.json`, `BarWidget.qml`, `Panel.qml`, `Model.js`.

## Install

```sh
omarchy plugin add https://github.com/cytracon/omarchy-cctv-lite.git --enable
```

The widget lands in the right bar section.

```sh
omarchy bar move io.github.cytracon.cctv-lite --section right
```

## Usage

Click **CV** to open or close the panel. Escape closes it. Right-click launches CCTV Lite. In the panel: **O** open, **S** source.

## Remove

```sh
omarchy plugin remove io.github.cytracon.cctv-lite
```

Removal deletes only the plugin checkout. It does **not** uninstall CCTV Lite or touch `~/.config/cctv-lite/`.

## Install CCTV Lite (the app)

User-local. On Omarchy:

```bash
omarchy install cctv-lite
```

That writes `~/.local/bin/cctv-lite`. Camera host, password, and names stay in `~/.config/cctv-lite/config.yaml` on the machine. They are not part of this plugin.

## External dependencies

- Omarchy Quattro shell (Quickshell). No extra QML modules.
- Optional: the CCTV Lite GTK app at `$HOME/.local/bin/cctv-lite`.
- `omarchy-launch-browser` for the source link (ships with Omarchy).

## Security

- No install hooks, daemons, privilege escalation, or network clients
- No camera host, password, or RTSP URLs in this repository
- Left-click only toggles the panel
- Right-click runs the fixed path `$HOME/.local/bin/cctv-lite` when that file exists
- “Source” opens `https://github.com/cytracon/cctv-lite` via `omarchy-launch-browser`

Omarchy plugins run unsandboxed. Review `BarWidget.qml`, `Panel.qml`, and `Model.js` before enabling.

## License

MIT for this plugin. CCTV Lite remains MIT.
