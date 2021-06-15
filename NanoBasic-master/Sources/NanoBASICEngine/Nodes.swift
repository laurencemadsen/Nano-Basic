//
//  Nodes.swift
//  NanoBASIC Nodes — Nodes representing actions in a BASIC program
//
//  Copyright (c) 2019 David Kopec
//  MIT License (see LICENSE)
//
// This file defines the nodes that the parser can create. Nodes are meaningful chunks of a
// program for the interpreter to interpret. For example, generally each statement will become a node.

//  NOTE: This file is complete—you should not need to modify it.

import Foundation

// All statements in NanoBASIC have a line number that precedes them
// The range is for debugging purposes
public protocol Statement {
    var line: Int16 {get}  // what line number is it?
    var range: Range<String.Index> {get}  // where in the text was it declared
}

// An array of Statements is just a StatementList
public typealias StatementList = [Statement]

// A LET statement
public struct VarSet: Statement {
    public let name: String
    public let value: Expression
    public let line: Int16
    public let range: Range<String.Index>
}

// A GOTO statement
// gotoLine is where it is supposed to shift control of the program to
public struct GoToCall: Statement {
    public let gotoLine: Int16
    public let line: Int16
    public let range: Range<String.Index>
}

// A GOSUB statement
// gotoLine is where it is supposed to shift control of the program to
public struct GoSubCall: Statement {
    public let gotoLine: Int16
    public let line: Int16
    public let range: Range<String.Index>
}

// A RETURN statement
public struct ReturnStatement: Statement {
    public let line: Int16
    public let range: Range<String.Index>
}

// String literal and expressions are the two things
// that a PRINT statements can print
public protocol Printable {}
extension String: Printable {}

// A PRINT statement with all the things that it is meant to print (comma separated)
public struct PrintStatement: Statement {
    let printables: [Printable]
    public let line: Int16
    public let range: Range<String.Index>
}

// An IF statement
// thenStatement is what statement will be executed if the booleanExpression is true
public struct IfStatement: Statement {
    let booleanExpression: BooleanExpression
    let thenStatement: Statement
    public let line: Int16
    public let range: Range<String.Index>
}

// The BooleanExpression used by an IF statement
public struct BooleanExpression: CustomDebugStringConvertible {
    let operation: Token
    let left: Expression
    let right: Expression
    public let range: Range<String.Index>
    public var debugDescription: String {
        return "\(operation) -> (\(left), \(right))"
    }
}

// Represents a mathematical expression
public protocol Expression: Printable {
    var range: Range<String.Index> {get}
}

// A mathematical expressions with two operands like +, -, *, and /
public struct BinaryOperation: Expression, CustomDebugStringConvertible {
    let operation: Token
    let left: Expression
    let right: Expression
    public let range: Range<String.Index>
    public var debugDescription: String {
        return "\(operation) -> (\(left), \(right))"
    }
}

// A mathematical expression with one operand, like negate (-)
public struct UnaryOperation: Expression, CustomDebugStringConvertible {
    let operation: Token
    let value: Expression
    public let range: Range<String.Index>
    public var debugDescription: String {
        return "\(operation) -> \(value)"
    }
}

// An actual integer written in NanoBASIC code
public struct NumberLiteral: Expression {
    let number: Int16
    public let range: Range<String.Index>
}

// The name of a variable written in NanoBASIC code
public struct VarName: Expression {
    let string: String
    public let range: Range<String.Index>
}
