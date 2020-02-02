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
            return UIColor(red: 62/255, green: 133/255, blue: 167/255, alpha: 1)
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
