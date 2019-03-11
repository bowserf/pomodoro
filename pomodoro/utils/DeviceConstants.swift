import UIKit

enum DeviceType: Int {
    case iPad
    case iPhone

    case unknownDevice
}

enum DeviceModelScreen: Int {
    case iPad_Normal
    case iPad_Pro_New
    case iPad_Pro

    case iPhone4
    case iPhone5
    case iPhone6
    case iPhone6Plus
    case iPhoneX
    case iPhoneXR

    case unknown_MODEL


    func deviceType() -> DeviceType {
        switch self {
        case .iPad_Normal, .iPad_Pro_New, .iPad_Pro:
            return .iPad
        case .iPhone4, .iPhone5, .iPhone6, .iPhone6Plus, .iPhoneX, .iPhoneXR:
            return .iPhone
        case .unknown_MODEL:
            return .unknownDevice
        }
    }

    func screenHeight() -> CGFloat {
        switch self {
        case .iPhone4:      return 480
        case .iPhone5:      return 568
        case .iPhone6:      return 667
        case .iPhone6Plus:  return 736
        case .iPhoneX:      return 812
        case .iPhoneXR:     return 896
        case .iPad_Normal:  return 1024
        case .iPad_Pro_New: return 1112
        case .iPad_Pro:     return 1366

        case .unknown_MODEL:    return DeviceConstants.screenHeight()
        }
    }

    static func deviceModelList() -> [DeviceModelScreen] {
        var models = [DeviceModelScreen]()

        var i = 0
        while let model = DeviceModelScreen(rawValue: i) {
            models.append(model)
            i += 1
        }

        return models
    }
}

struct DeviceConstants {

    static func deviceType() -> DeviceType {
        switch UIDevice.current.userInterfaceIdiom {
        case .pad:      return .iPad
        case .phone:    return .iPhone
        default:        return .unknownDevice
        }
    }

    static func deviceModelScreen() -> DeviceModelScreen {
        let currentDeviceType = DeviceConstants.deviceType()
        let validModels = DeviceModelScreen.deviceModelList().filter({ $0.deviceType() == currentDeviceType })

        let currentScreenHeight = DeviceConstants.screenHeight()
        if let model = validModels.filter({ $0.screenHeight() == currentScreenHeight }).first {
            return model
        }

        if UIDevice.current.model.hasPrefix("iPod") {
            return .iPhone5
        }

        return .unknown_MODEL
    }

    static func screenHeight() -> CGFloat {
        return max(UIScreen.main.bounds.height, UIScreen.main.bounds.width)
    }
}
