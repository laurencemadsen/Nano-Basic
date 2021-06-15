//
//  Interpreter.swift
//  NanoBASIC Interpreter — Runs a statement list
//
//  Copyright (c) 2019 David Kopec
//  MIT License (see LICENSE)
//
//  The interpreter is responsible for processing the nodes that come
//  from the parser. In many interpreters, this structure will be represented as
//  an abstract syntax tree. Because NanoBASIC is extremely linear, the data structure
//  that the interpreter receives is just an array of statements. The interpreter translates
//  the meaning of each statement node into Swift code that can be run "live."

import Foundation

public enum InterpreterError: Error, LocalizedError {
    case InterpreterError(explanation: String, statement: Statement?)
    
    public var errorDescription: String? {
        switch self {
        case .InterpreterError(let explanation, let statement):
            return "\(explanation) at token:\(String(describing: statement))"
        }
    }
}

// A generic stack
public class Stack<T> {
    private var container: [T] = [T]()
    public var isEmpty: Bool { return container.isEmpty }
    public func push(_ thing: T) { container.append(thing) }
    public func pop() -> T? {
        guard container.count > 0 else { return nil }
        return container.removeLast()
    }
    public init(){}
}

// A protocol-oriented way of defining the actual language runtime, a BASICPlayer
// has to keep track of where RETURN statements should go to (subroutineStack),
// what the values of any variables are (variableTable) at any given time,
// all of the statements in the program (statements),
// and which statement we are currently looking at (statementIndex)
public protocol BASICPlayer {
    var subroutineStack: Stack<Int> {get set} // subroutine line index stack
    var variableTable: [String: Int16] {get set} // variables
    var statements: StatementList {get set}
    var statementIndex: Int {get set}
}

extension BASICPlayer {
    
    // returns the index of a line number using a binary search
    // assumes the statements array is sorted
    private func findLineIndex(lineNumber: Int16) -> Int? {
        var low = 0
        var high = statements.count - 1
        while low <= high {
            let mid = (low + high) / 2
            if statements[mid].line < lineNumber {
                low = mid + 1
            } else if statements[mid].line > lineNumber {
                high = mid - 1
            } else {
                return mid
            }
        }
        return nil
    }
    
    // Look at a statement, run the appropriate Swift code for what the statement
    // represents
    public mutating func interpret(statement: Statement) throws {
        switch (statement) {
        case let printStatement as PrintStatement: // print everything tab separated using print()
            for (index, printable) in printStatement.printables.enumerated() {
                if let expr = printable as? Expression {
                    if index != printStatement.printables.count - 1 {
                        print("\(evaluate(expression: expr))", terminator: "\t")
                    } else {
                        print("\(evaluate(expression: expr))")
                    }
                } else if let str = printable as? String {
                    if index != printStatement.printables.count - 1 {
                        print(str, terminator: "\t")
                    } else {
                        print(str)
                    }
                }
            }
            statementIndex += 1
        // YOU FILL IN HERE the other cases: LET, IF, GOTO, GOSUB, RETURN
        //LET
        case let varset as VarSet:
            variableTable[varset.name.lowercased()] = evaluate(expression: varset.value) //gets and sets the new variable
            statementIndex += 1 // go to next line
          

        //IF
         case let ifStatement as IfStatement:
            if evaluate(booleanExpression: ifStatement.booleanExpression) {
                switch (ifStatement.thenStatement) {
                case let goto as GoToCall:
                    try interpret(statement: goto)
                case let bigIf as IfStatement:
                    try interpret(statement: bigIf)
                default:
                    let currentIndex = statementIndex
                    try interpret(statement: ifStatement.thenStatement)
                    statementIndex = currentIndex + 1
                }
            } else {
                statementIndex += 1
            }

        //GOTO
        case let goto as GoToCall:
            if let gtline = findLineIndex(lineNumber: goto.gotoLine) {
                statementIndex = gtline //next line
            }

        //GOSUB
        case let gosub as GoSubCall:
            subroutineStack.push(statementIndex + 1) // adding the return after GOSUB
            if let gsline = findLineIndex(lineNumber: gosub.gotoLine) {
                statementIndex = gsline //next line
            }

        //RETURN
        case  _ as ReturnStatement:
            statementIndex = 0 //reset the statementIndex
            statementIndex += subroutineStack.pop()! //going to where GOSUB sent it

        default:
            break
        }
    }
    
    // interpret all the statements, initially by going through them sequentially
    // later statements may change the order of execution
    mutating public func interpret() throws {
        while statementIndex < statements.count {
            try interpret(statement: statements[statementIndex])
        }
    }
    
    // evaluation a boolean expression by checking its respective operator and
    // evaluating each of the two operands
   public func evaluate(booleanExpression: BooleanExpression) -> Bool {
        switch booleanExpression.operation {
        case .lessThan:
             return evaluate(expression: booleanExpression.left) < evaluate(expression: booleanExpression.right)
        case .greaterThan:
             return evaluate(expression: booleanExpression.left) > evaluate(expression: booleanExpression.right)
        case .lessThanEqual:
             return evaluate(expression: booleanExpression.left) <= evaluate(expression: booleanExpression.right)
        case .greaterThanEqual:
            return evaluate(expression: booleanExpression.left) >= evaluate(expression: booleanExpression.right)
        case .equal:
            return evaluate(expression: booleanExpression.left) == evaluate(expression: booleanExpression.right)
        case .notEqual:
            return evaluate(expression: booleanExpression.left) != evaluate(expression: booleanExpression.right)
        default:
            return false
        }
   }
    
    // evaluate an Expression by using Swift's built-in arithmetic facilities
    public func evaluate(expression: Expression) -> Int16 {
        switch expression {
        case let binop as BinaryOperation:
            switch binop.operation {
            case .plus:
                return evaluate(expression: binop.left) + evaluate(expression: binop.right)
            case .minus:
                return evaluate(expression: binop.left) - evaluate(expression: binop.right)
            case .multiply:
                return evaluate(expression: binop.left) * evaluate(expression: binop.right)
            case .divide:
                return evaluate(expression: binop.left) / evaluate(expression: binop.right)
            default:
                return 0
            }
            
        case let unop as UnaryOperation:
            switch unop.operation {
            case .minus:
                return -evaluate(expression: unop.value)
            default:
                return 0
            }
        case let name as VarName: // lookup a variable in variableTable
            // should check if variable actually in variableTable
            // since this is undefined behavior, our implementation treats undefined variables as 0
            return variableTable[name.string.lowercased()] ?? 0
        case let num as NumberLiteral:
            return num.number
        default:
            return 0
        }
    }
}
