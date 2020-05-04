import TerminalCalendarCore
import XCTest
import Fakery

func getId() -> Int {
    return Faker().number.randomInt(min: 100000000, max: 12 * 100000000)
}

class ZoomExtractorTests: XCTestCase {
    var faker: Faker!
    var id: String = ""
    
    override func setUp() {
        faker = Faker()
        id = String(faker.number.randomInt(min: 100000000, max: 12 * 100000000))
    }
    func testFindZoomLink() throws {
        let content = "https://text.zoom.us/j/\(id)"
        let links = findZoomLinks(content)
        XCTAssertFalse(links.isEmpty)
        XCTAssertEqual(links.count, 1)
        
        let foundLink = links[0]
        
        XCTAssertEqual(foundLink.id, String(id))
        XCTAssertFalse(foundLink.hasPassword)
        XCTAssertEqual(foundLink.password, "")
        XCTAssertEqual(foundLink.link, "zoommtg://zoom.us/join?action=join&confno=\(id)")
    }
    
    func testFindZoomLinkWithPassword() throws {
        let password = faker.internet.password(minimumLength: 20, maximumLength: 100)
        let domain = faker.internet.domainWord()
        let content = "https://\(domain).zoom.us/j/\(id)?pwd=\(password)"
        let links = findZoomLinks(content)
        XCTAssertFalse(links.isEmpty)
        XCTAssertEqual(links.count, 1)
        
        let foundLink = links[0]
        
        XCTAssertEqual(foundLink.id, String(id))
        XCTAssertTrue(foundLink.hasPassword)
        XCTAssertEqual(foundLink.password!, password)
        XCTAssertEqual(foundLink.link, "zoommtg://zoom.us/join?action=join&confno=\(id)&pwd=\(password)")
    }
}

