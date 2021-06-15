import NanoBASICEngine

class NanoBASIC: BASICPlayer {
    var subroutineStack: Stack<Int> = Stack<Int>() // subroutine line index stack
    var variableTable: [String: Int16] = [String: Int16]() // variables
    var statements: StatementList
    var statementIndex: Int = 0
    
    init(filename: String) {
        do {
            let contents = try String(contentsOfFile: filename)
            let tokens = try tokenize(text: contents)
            //print(tokens)
            let parser = Parser(tokens: tokens)
            statements = try parser.parse()
        } catch {
            statements = []
            print(error)
        }
    }
}

if CommandLine.arguments.count < 2 {
    print("Expected a filename to run as an argument.")
} else {
    var runtime = NanoBASIC(filename: CommandLine.arguments[1])
    do {
        try runtime.interpret()
    } catch {
        print(error)
    }
}
