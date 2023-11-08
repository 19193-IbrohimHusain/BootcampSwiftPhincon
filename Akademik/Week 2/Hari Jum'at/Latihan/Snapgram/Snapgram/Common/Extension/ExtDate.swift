import Foundation

extension Date {
    func timeAgoString() -> String {
        let now = Date()
        let calendar = Calendar.current
        
        let components = calendar.dateComponents([.hour, .minute, .second], from: self, to: now)
        
        let formatter = DateComponentsFormatter()
        formatter.unitsStyle = .abbreviated
        formatter.maximumUnitCount = 1
        
        if let timeAgoString = formatter.string(from: components) {
            return timeAgoString + " ago"
        } else {
            return "Just now"
        }
    }
}
