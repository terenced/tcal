//
//  File.swift
//
//
//  Created by Terry Dellino on 2020-04-28.
//

import Foundation

class ZoomLink {
    var id: String
    var password: String?
    var link: String {
        let zoomlink = "zoommtg://zoom.us/join?action=join&confno=\(id)"
        if let pwd = password, pwd != "" {
            return "\(zoomlink)&pwd=\(pwd)"
        }
        return zoomlink
    }

    var hasPassword: Bool {
        return password != nil
    }

    init(id: String, password: String?) {
        self.id = id
        self.password = password
    }
}

extension ZoomLink: Equatable {
    static func == (lhs: ZoomLink, rhs: ZoomLink) -> Bool {
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

func findZoomLinks(_ content: String?) -> [ZoomLink] {
    var foundLinks: [ZoomLink] = []

    if content == nil {
        return foundLinks
    }
    let text = content!

    let pattern = #"https\:\/\/[\w]*\.zoom.us\/\w\/(?<id>\d{9,11})(\?pwd=(?<pwd>[\w|\d]*)\")*"#
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
