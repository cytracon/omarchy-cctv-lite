# CCTV Lite — Omarchy plugin

**What it is.** [CCTV Lite](https://github.com/cytracon/cctv-lite) is a live multi-camera viewer for a local NVR (Hikvision-style RTSP). Watch cameras in a grid with sub/main streams. Host, password, and camera names stay on this machine.

This plugin is the bar UI for that viewer: camera count and layout, then a launch into CCTV Lite. If the viewer is missing, the panel runs `omarchy install cctv-lite` (app + this plugin). No camera credentials in this plugin.

Layout follows the official Omarchy plugin template: `manifest.json`, `BarWidget.qml`, `Panel.qml`, `Model.js`.

## Install

One command installs the **viewer and this plugin**:

```bash
omarchy install cctv-lite
```

Or add the widget first, then click **Install CCTV Lite** in the panel:

```sh
omarchy plugin add https://github.com/cytracon/omarchy-cctv-lite.git --enable
```

```sh
omarchy bar move io.github.cytracon.cctv-lite --section right
```

## Usage

Click **CV** to open or close the panel. Escape closes it. Right-click opens the viewer (or installs if missing). In the panel: **I** install, **O** open, **S** source.

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
- CCTV Lite at `$HOME/.local/bin/cctv-lite` (installed by the panel or by `omarchy install cctv-lite`).
- `omarchy-launch-floating-terminal-with-presentation` and `omarchy-launch-browser` (ship with Omarchy).

## Security

- No camera host, password, or RTSP URLs in this repository
- Left-click toggles the panel
- Right-click runs `$HOME/.local/bin/cctv-lite`, or installs CCTV Lite if missing
- Install runs `omarchy install cctv-lite` in a floating terminal
- “Source” opens `https://github.com/cytracon/cctv-lite` via `omarchy-launch-browser`

Omarchy plugins run unsandboxed. Review `BarWidget.qml`, `Panel.qml`, and `Model.js` before enabling.

## License

MIT for this plugin. CCTV Lite remains MIT.
