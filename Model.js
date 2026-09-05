function emptyStatus() {
  return {
    installed: false,
    version: "",
    configured: false,
    cameras: 0,
    enabledCameras: 0,
    layout: "",
    grid: "",
    quality: ""
  }
}

function parseStatus(raw) {
  var text = String(raw || "").trim()
  var status = emptyStatus()
  if (text === "") return status
  try {
    var data = JSON.parse(text)
  } catch (e) {
    return status
  }
  if (!data || typeof data !== "object") return status
  status.installed = true
  status.version = String(data.version || "")
  status.configured = data.configured === true
  status.cameras = Number(data.cameras || 0)
  status.enabledCameras = Number(data.enabled_cameras || 0)
  status.layout = String(data.layout || "")
  status.grid = String(data.grid || "")
  status.quality = String(data.quality || "")
  return status
}
