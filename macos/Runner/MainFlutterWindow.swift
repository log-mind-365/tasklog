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

    // Set window size constraints (mobile-like dimensions)
    let windowWidth: CGFloat = 400
    let windowHeight: CGFloat = 900

    // Set minimum and maximum size to lock the window size
    self.minSize = NSSize(width: windowWidth, height: windowHeight)
    self.maxSize = NSSize(width: windowWidth, height: windowHeight)

    // Set initial window size and center it
    self.setContentSize(NSSize(width: windowWidth, height: windowHeight))
    self.center()

    // Optional: Make window non-resizable
    self.styleMask.remove(.resizable)
  }
}
