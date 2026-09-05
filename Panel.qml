import QtQuick
import Quickshell
import Quickshell.Io
import qs.Commons
import qs.Ui
import "Model.js" as Model

Panel {
  id: root
  moduleName: "io.github.cytracon.cctv-lite"
  manageIpc: false

  property var anchorItem: null
  property var hostWidget: null

  readonly property string sourceUrl: "https://github.com/cytracon/cctv-lite"
  readonly property string appBin: Quickshell.env("HOME") + "/.local/bin/cctv-lite"
  readonly property color foreground: bar ? bar.foreground : Color.foreground
  readonly property color dim: Qt.darker(foreground, 1.55)
  readonly property string fontFamily: bar ? bar.fontFamily : Style.font.family

  property bool installed: false
  property bool configured: false
  property string liveVersion: ""
  property string camerasLabel: "—"
  property string layoutLabel: "—"
  property string gridLabel: "—"
  property string qualityLabel: "—"
  property int actionIndex: 0
  property bool cursorActive: false

  function open() {
    cursorActive = false
    actionIndex = 0
    refresh()
    root.controller.show()
    Qt.callLater(function() { keyCatcher.forceActiveFocus() })
  }

  function close() {
    root.controller.hide()
  }

  function toggle() {
    if (root.opened) root.close()
    else root.open()
  }

  function switchPanel(direction) {
    if (root.bar && typeof root.bar.switchPanelFrom === "function")
      return root.bar.switchPanelFrom(root.hostWidget || root, direction)
    return false
  }

  function refresh() {
    statusProc.running = false
    statusProc.running = true
  }

  function applyStatus(raw) {
    var status = Model.parseStatus(raw)
    root.installed = status.installed
    root.configured = status.configured
    root.liveVersion = status.version
    root.camerasLabel = status.installed ? (String(status.enabledCameras) + " / " + String(status.cameras)) : "—"
    root.layoutLabel = status.layout || "—"
    root.gridLabel = status.grid || "—"
    root.qualityLabel = status.quality || "—"
  }

  function launchApp() {
    if (!root.installed) {
      installApp()
      return
    }
    Quickshell.execDetached([root.appBin])
    root.close()
  }

  function installApp() {
    Quickshell.execDetached([
      "omarchy-launch-floating-terminal-with-presentation",
      "omarchy", "install", "cctv-lite"
    ])
    root.close()
  }

  function openSource() {
    Quickshell.execDetached(["omarchy-launch-browser", root.sourceUrl])
    root.close()
  }

  function activateCursor() {
    if (actionIndex === 0) launchApp()
    else openSource()
  }

  Process {
    id: statusProc
    command: [root.appBin, "--status"]
    stdout: StdioCollector {
      waitForEnd: true
      onStreamFinished: root.applyStatus(text)
    }
    onExited: function(code) {
      if (code !== 0) {
        root.installed = false
        root.liveVersion = ""
      }
    }
  }

  KeyboardPanel {
    id: panel
    anchorItem: root.anchorItem
    owner: root.hostWidget || root
    bar: root.bar
    open: root.opened
    focusTarget: keyCatcher
    contentWidth: panel.fittedContentWidth(Style.space(420))
    contentHeight: panel.fittedContentHeight(column.implicitHeight)

    PanelKeyCatcher {
      id: keyCatcher
      anchors.fill: parent
      onMoveRequested: function(dx, dy) {
        root.cursorActive = true
        if (dy > 0) root.actionIndex = 1
        else if (dy < 0) root.actionIndex = 0
      }
      onActivateRequested: root.activateCursor()
      onCloseRequested: root.close()
      onTabRequested: function(direction) { root.switchPanel(direction) }
      onTextKey: function(t) {
        if (t === "o" || t === "O") root.launchApp()
        else if (t === "i" || t === "I") root.installApp()
        else if (t === "s" || t === "S") root.openSource()
      }

      Column {
        id: column
        width: parent.width
        spacing: Style.space(12)

        PanelHero {
          width: parent.width
          title: "CCTV Lite"
          meta: root.installed ? (root.liveVersion || "0.2.0") : "Not installed in ~/.local"
          foreground: root.foreground
          fontFamily: root.fontFamily
        }

        Column {
          width: parent.width
          spacing: Style.spacing.labelGap
          InfoPair { label: "Configured"; value: root.installed ? (root.configured ? "yes" : "no") : "—" }
          InfoPair { label: "Cameras"; value: root.camerasLabel }
          InfoPair { label: "Layout"; value: root.layoutLabel }
          InfoPair { label: "Grid"; value: root.gridLabel }
          InfoPair { label: "Quality"; value: root.qualityLabel }
        }

        PanelSeparator { foreground: root.foreground }

        ActionRow {
          width: parent.width
          title: root.installed ? "Open CCTV Lite" : "Install CCTV Lite"
          hint: root.installed ? "Right-click the bar icon, or press O" : "Installs the GTK viewer. Press I"
          selected: root.cursorActive && root.actionIndex === 0
          enabled: true
          onClicked: root.launchApp()
        }

        ActionRow {
          width: parent.width
          title: "Source"
          hint: "github.com/cytracon/cctv-lite"
          selected: root.cursorActive && root.actionIndex === 1
          enabled: true
          onClicked: root.openSource()
        }
      }
    }
  }

  component InfoPair: Row {
    property string label: ""
    property string value: ""
    width: parent.width
    spacing: Style.space(8)
    Text {
      textFormat: Text.PlainText
      text: label
      color: root.foreground
      opacity: 0.6
      font.family: root.fontFamily
      font.pixelSize: Style.font.bodySmall
    }
    Item {
      width: Math.max(0, parent.width - parent.children[0].implicitWidth - parent.children[2].implicitWidth - parent.spacing * 2)
      height: 1
    }
    Text {
      textFormat: Text.PlainText
      text: value
      color: root.foreground
      font.family: root.fontFamily
      font.pixelSize: Style.font.bodySmall
      elide: Text.ElideRight
    }
  }

  component ActionRow: CursorSurface {
    id: action
    property string title: ""
    property string hint: ""
    property bool selected: false
    property bool enabled: true
    signal clicked()

    hasCursor: selected
    foreground: root.foreground
    implicitHeight: actionColumn.implicitHeight + Style.spacing.rowPaddingX
    opacity: enabled ? 1 : 0.55

    MouseArea {
      anchors.fill: parent
      hoverEnabled: true
      enabled: action.enabled
      cursorShape: action.enabled ? Qt.PointingHandCursor : Qt.ArrowCursor
      onClicked: action.clicked()
    }

    Column {
      id: actionColumn
      anchors.left: parent.left
      anchors.right: parent.right
      anchors.verticalCenter: parent.verticalCenter
      anchors.leftMargin: Style.space(10)
      anchors.rightMargin: Style.space(10)
      spacing: Style.space(2)
      Text {
        textFormat: Text.PlainText
        width: parent.width
        text: action.title
        color: root.foreground
        font.family: root.fontFamily
        font.pixelSize: Style.font.body
      }
      Text {
        textFormat: Text.PlainText
        width: parent.width
        text: action.hint
        color: root.dim
        font.family: root.fontFamily
        font.pixelSize: Style.font.caption
        wrapMode: Text.WordWrap
      }
    }
  }
}
