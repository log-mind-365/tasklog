import Cocoa
import FlutterMacOS

class MainFlutterWindow: NSWindow {
  override func awakeFromNib() {
    let flutterViewController = FlutterViewController()
    let windowFrame = self.frame
    self.contentViewController = flutterViewController
    self.setFrame(windowFrame, display: true)

    RegisterGeneratedPlugins(registry: flutterViewController)

    super.awakeFromNib()

    // Set window size constraints (desktop dimensions)
    let minWidth: CGFloat = 900
    let minHeight: CGFloat = 600
    let initialWidth: CGFloat = 1200
    let initialHeight: CGFloat = 800

    // Set minimum size only (allow resizing)
    self.minSize = NSSize(width: minWidth, height: minHeight)

    // Set initial window size and center it
    self.setContentSize(NSSize(width: initialWidth, height: initialHeight))
    self.center()
  }
}
