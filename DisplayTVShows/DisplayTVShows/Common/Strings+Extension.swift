import UIKit

extension String {
    var removingWhitespaces: String {
        return self.components(separatedBy: CharacterSet.whitespaces).joined()
    }
    
    func htmlAttributedString() -> NSMutableAttributedString? {
        guard let data = self.data(
            using: String.Encoding.utf16, allowLossyConversion: false) else { return nil }
        guard let html = try? NSMutableAttributedString(
            data: data,
            options: [.documentType: NSAttributedString.DocumentType.html],
            documentAttributes: nil) else { return nil }
        html.addAttributes(
            [.font: Fonts.value,
             .foregroundColor: Colors.black.value],
            range: NSRange(location: 0, length: html.length))
        return html
    }
}
