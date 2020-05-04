//
//  File.swift
//
//
//  Created by Terry Dellino on 2020-04-28.
//

import Foundation

public class ZoomLink {
    public var id: String
    public var password: String?
    public var link: String {
        let zoomlink = "zoommtg://zoom.us/join?action=join&confno=\(id)"
        if let pwd = password, self.hasPassword == true {
            return "\(zoomlink)&pwd=\(pwd)"
        }
        return zoomlink
    }

    public var hasPassword: Bool {
        if let pwd = password {
            return !pwd.isEmpty
        }
        return false
    }

    public init(id: String, password: String?) {
        self.id = id
        self.password = password
    }
}

extension ZoomLink: Equatable {
    public static func == (lhs: ZoomLink, rhs: ZoomLink) -> Bool {
        return lhs.id == rhs.id && lhs.password == rhs.password
    }
}

private func getRegexValue(text: String, match: NSTextCheckingResult, component: String) -> String {
    let nsrange = match.range(withName: component)
    if nsrange.location != NSNotFound,
        let range = Range(nsrange, in: text) {
        return "\(text[range])"
    }
    return ""
}

public func findZoomLinks(_ content: String?) -> [ZoomLink] {
    var foundLinks: [ZoomLink] = []

    if content == nil {
        return foundLinks
    }
    let text = content!

//    let pattern = #"https\:\/\/[\w]*\.zoom.us\/\w\/(?<id>\d{9,11})(\?pwd=(?<pwd>[\w|\d]*)\")*"#
    let pattern = #"https\:\/\/[\w]*\.zoom.us\/\w\/(?<id>\d{9,11})(\?pwd=(?<pwd>[\w|\d]*))*"#
    let nsrange = NSRange(text.startIndex ..< text.endIndex, in: text)

    do {
        let regex = try NSRegularExpression(pattern: pattern, options: [])
        for match in regex.matches(in: text, options: [], range: nsrange) {
            let id = getRegexValue(text: text, match: match, component: "id")
            let pwd = getRegexValue(text: text, match: match, component: "pwd")
            foundLinks.append(ZoomLink(id: id, password: pwd))
        }

    } catch {
        print("invalid regex: \(error.localizedDescription)")
    }

    return foundLinks
}
