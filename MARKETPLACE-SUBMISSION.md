# Marketplace submission

Submit at:
https://github.com/omacom/omarchy-plugin-marketplace/issues/new?template=submit-plugin.yml

Title:

```
[Plugin]: CCTV Lite
```

Body (keep headings and checklist exactly):

```
### Repository URL

https://github.com/cytracon/omarchy-cctv-lite

### Category

System

### Tags

bar, system, security

### Suggest a missing tag

_No response_

### Maintainer notes

What it is: CCTV Lite is a live NVR camera grid (Hikvision-style RTSP). This plugin only shows camera count/layout and opens the viewer. No credentials in the plugin.

Plugin ID: `io.github.cytracon.cctv-lite`.

This is an Omarchy Quattro bar-widget (Quickshell) for CCTV Lite 0.2.0 on Omarchy/Arch. It does not ship the GTK viewer and does not run installers. `omarchy plugin add` only clones this repo. CCTV Lite itself is installed separately with `omarchy install cctv-lite` (user-local `~/.local`).

The panel reads `$HOME/.local/bin/cctv-lite --status` (no secrets) and can launch that same fixed path. Source opens https://github.com/cytracon/cctv-lite via `omarchy-launch-browser`. No camera credentials in this repository. MIT license. `omarchy plugin validate` passed locally.

Layout matches the official Omarchy plugin template: `BarWidget.qml` + `Panel.qml` + `Model.js`.

### Submission checklist

- [x] The repository is public and contains installation and removal instructions.
- [x] I have documented the plugin license and any external dependencies.
- [x] I confirm that I own or have permission to submit this plugin and its preview assets.
- [x] The plugin does not overwrite user configuration without explicit consent.
- [x] I understand that approval is for listing and is not a security review.
```
