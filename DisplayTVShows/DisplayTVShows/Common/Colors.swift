import UIKit

enum Colors {
    case tableViewBackgroundColor
    case white
    case searchBorder
    case navBarTintColor
    case black
    var value: UIColor {
        switch self {
        case .tableViewBackgroundColor:
            return UIColor.init(red: 62, green: 133, blue: 167)
        case .white:
            return UIColor.white
        case .searchBorder:
            return UIColor.purple
        case .navBarTintColor:
            return UIColor(
                red: 33/255, green: 28/255, blue: 88/255, alpha: 1)
        case .black:
            return UIColor.black
        }
    }
}

extension UIColor {
    convenience init(red: Int, green: Int, blue: Int) {
        let newRed = CGFloat(red)/255
        let newGreen = CGFloat(green)/255
        let newBlue = CGFloat(blue)/255

        self.init(red: newRed, green: newGreen, blue: newBlue, alpha: 1.0)
    }
}
