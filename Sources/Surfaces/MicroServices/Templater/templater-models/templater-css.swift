import Foundation

public func injectCSS(
    into html: String,
    platform: TemplaterPlatform,
    resources: URL
) throws -> String {
    let cssURL = resources
        .appendingPathComponent("Templates")
        .appendingPathComponent(platform.rawValue)
        .appendingPathComponent("styles.css")
    
    let styles = try String(contentsOf: cssURL)   

    if let headRange = html.range(of: #"<head[^>]*>"#, options: .regularExpression) {
        var result = html
        result.replaceSubrange(
            headRange,
            with: "\(html[headRange])\n<style>\(styles)</style>"
        )
        return result
    } else {
        return "<style>\(styles)</style>\n" + html
    }
}
