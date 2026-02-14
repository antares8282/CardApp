import Foundation

enum CardType: String, CaseIterable, Identifiable {
    case christmas
    case birthday
    case valentines

    var id: String { rawValue }

    var displayName: String {
        switch self {
        case .christmas: return "Christmas"
        case .birthday: return "Birthday"
        case .valentines: return "Valentine's"
        }
    }
}
