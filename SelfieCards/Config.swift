import Foundation

enum Config {
    /// Set this to your backend URL. For simulator + local backend use http://localhost:3000
    /// and add App Transport Security exception in Info.plist.
    static var apiBaseURL: String {
        #if DEBUG
        return "http://localhost:3000"
        #else
        return "https://card-app-tau-neon.vercel.app"
        #endif
    }
}
