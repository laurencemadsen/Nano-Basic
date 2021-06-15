import XCTest
import class Foundation.Bundle

final class NanoBASICTests: XCTestCase {
    
    func testPrint1() throws {
        guard #available(macOS 10.13, *) else {
            return
        }
        
        let fooBinary = productsDirectory.appendingPathComponent("NanoBASIC")
        
        let process = Process()
        process.arguments = ["Examples/print1.bas"]
        process.executableURL = fooBinary
        
        let pipe = Pipe()
        process.standardOutput = pipe
        
        process.launch()
        process.waitUntilExit()
        
        let data = pipe.fileHandleForReading.readDataToEndOfFile()
        let output = String(data: data, encoding: .utf8)
        
        XCTAssertEqual(output, "Hello World\n")
    }
    
    func testPrint2() throws {
        guard #available(macOS 10.13, *) else {
            return
        }
        
        let fooBinary = productsDirectory.appendingPathComponent("NanoBASIC")
        
        let process = Process()
        process.arguments = ["Examples/print2.bas"]
        process.executableURL = fooBinary
        
        let pipe = Pipe()
        process.standardOutput = pipe
        
        process.launch()
        process.waitUntilExit()
        
        let data = pipe.fileHandleForReading.readDataToEndOfFile()
        let output = String(data: data, encoding: .utf8)
        
        XCTAssertEqual(output, "4\n12\n30\n7\n100\t9\n")
    }
    
    func testPrint3() throws {
        guard #available(macOS 10.13, *) else {
            return
        }
        
        let fooBinary = productsDirectory.appendingPathComponent("NanoBASIC")
        
        let process = Process()
        process.arguments = ["Examples/print3.bas"]
        process.executableURL = fooBinary
        
        let pipe = Pipe()
        process.standardOutput = pipe
        
        process.launch()
        process.waitUntilExit()
        
        let data = pipe.fileHandleForReading.readDataToEndOfFile()
        let output = String(data: data, encoding: .utf8)
        
        XCTAssertEqual(output, "E is\t-31\n")
    }
    
    func testVariables() throws {
        guard #available(macOS 10.13, *) else {
            return
        }
        
        let fooBinary = productsDirectory.appendingPathComponent("NanoBASIC")
        
        let process = Process()
        process.arguments = ["Examples/variables.bas"]
        process.executableURL = fooBinary
        
        let pipe = Pipe()
        process.standardOutput = pipe
        
        process.launch()
        process.waitUntilExit()
        
        let data = pipe.fileHandleForReading.readDataToEndOfFile()
        let output = String(data: data, encoding: .utf8)
        
        XCTAssertEqual(output, "15\n")
    }
    
    func testGOTO() throws {
        guard #available(macOS 10.13, *) else {
            return
        }
        
        let fooBinary = productsDirectory.appendingPathComponent("NanoBASIC")
        
        let process = Process()
        process.arguments = ["Examples/goto.bas"]
        process.executableURL = fooBinary
        
        let pipe = Pipe()
        process.standardOutput = pipe
        
        process.launch()
        process.waitUntilExit()
        
        let data = pipe.fileHandleForReading.readDataToEndOfFile()
        let output = String(data: data, encoding: .utf8)
        
        XCTAssertEqual(output, "Josh\nDave\nNanoBASIC ROCKS\n")
    }
    
    func testGOSUB() throws {
        guard #available(macOS 10.13, *) else {
            return
        }
        
        let fooBinary = productsDirectory.appendingPathComponent("NanoBASIC")
        
        let process = Process()
        process.arguments = ["Examples/gosub.bas"]
        process.executableURL = fooBinary
        
        let pipe = Pipe()
        process.standardOutput = pipe
        
        process.launch()
        process.waitUntilExit()
        
        let data = pipe.fileHandleForReading.readDataToEndOfFile()
        let output = String(data: data, encoding: .utf8)
        
        XCTAssertEqual(output, "10\n")
    }
    
    func testIf1() throws {
        guard #available(macOS 10.13, *) else {
            return
        }
        
        let fooBinary = productsDirectory.appendingPathComponent("NanoBASIC")
        
        let process = Process()
        process.arguments = ["Examples/if1.bas"]
        process.executableURL = fooBinary
        
        let pipe = Pipe()
        process.standardOutput = pipe
        
        process.launch()
        process.waitUntilExit()
        
        let data = pipe.fileHandleForReading.readDataToEndOfFile()
        let output = String(data: data, encoding: .utf8)
        
        XCTAssertEqual(output, "10\n40\n50\n60\n70\n100\n")
    }
    
    func testIf2() throws {
        guard #available(macOS 10.13, *) else {
            return
        }
        
        let fooBinary = productsDirectory.appendingPathComponent("NanoBASIC")
        
        let process = Process()
        process.arguments = ["Examples/if2.bas"]
        process.executableURL = fooBinary
        
        let pipe = Pipe()
        process.standardOutput = pipe
        
        process.launch()
        process.waitUntilExit()
        
        let data = pipe.fileHandleForReading.readDataToEndOfFile()
        let output = String(data: data, encoding: .utf8)
        
        XCTAssertEqual(output, "GOOD\n")
    }
    
    func testFib() throws {
        guard #available(macOS 10.13, *) else {
            return
        }
        
        let fooBinary = productsDirectory.appendingPathComponent("NanoBASIC")
        
        let process = Process()
        process.arguments = ["Examples/fib.bas"]
        process.executableURL = fooBinary
        
        let pipe = Pipe()
        process.standardOutput = pipe
        
        process.launch()
        process.waitUntilExit()
        
        let data = pipe.fileHandleForReading.readDataToEndOfFile()
        let output = String(data: data, encoding: .utf8)
        
        XCTAssertEqual(output, "0\n1\n1\n2\n3\n5\n8\n13\n21\n34\n55\n89\n")
    }
    
    func testFactorial() throws {
        guard #available(macOS 10.13, *) else {
            return
        }
        
        let fooBinary = productsDirectory.appendingPathComponent("NanoBASIC")
        
        let process = Process()
        process.arguments = ["Examples/factorial.bas"]
        process.executableURL = fooBinary
        
        let pipe = Pipe()
        process.standardOutput = pipe
        
        process.launch()
        process.waitUntilExit()
        
        let data = pipe.fileHandleForReading.readDataToEndOfFile()
        let output = String(data: data, encoding: .utf8)
        
        XCTAssertEqual(output, "120\n")
    }
    
    func testGCD() throws {
        guard #available(macOS 10.13, *) else {
            return
        }

        let fooBinary = productsDirectory.appendingPathComponent("NanoBASIC")

        let process = Process()
        process.arguments = ["Examples/gcd.bas"]
        process.executableURL = fooBinary

        let pipe = Pipe()
        process.standardOutput = pipe

        process.launch()
        process.waitUntilExit()

        let data = pipe.fileHandleForReading.readDataToEndOfFile()
        let output = String(data: data, encoding: .utf8)

        XCTAssertEqual(output, "7\n")
    }

    /// Returns path to the built products directory.
    var productsDirectory: URL {
      #if os(macOS)
        for bundle in Bundle.allBundles where bundle.bundlePath.hasSuffix(".xctest") {
            return bundle.bundleURL.deletingLastPathComponent()
        }
        fatalError("couldn't find the products directory")
      #else
        return Bundle.main.bundleURL
      #endif
    }

    static var allTests = [
        ("testPrint1", testPrint1),
        ("testPrint2", testPrint2),
        ("testPrint3", testPrint3),
        ("testVariables", testVariables),
        ("testGOTO", testGOTO),
        ("testGOSUB", testGOSUB),
        ("testIf1", testIf1),
        ("testIf2", testIf2),
        ("testFib", testFib),
        ("testFactorial", testFactorial),
        ("testGCD", testGCD),
    ]
}
