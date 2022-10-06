
import Foundation

public extension Int {
    
    func secondsToTime() -> String {
        
        let (h,m) = (self / 3600, (self % 3600) / 60)
        
        let h_string = h < 10 ? "\(h)" : "\(h)"
        let m_string =  m < 10 ? "\(m)" : "\(m)"
        return "\(h_string) h \(m_string) m"
    }
    
}
