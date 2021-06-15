//
//  Tokenizer.swift
//  NanoBASIC Tokenizer — Converts BASIC source into tokens
//
//  Copyright (c) 2019 David Kopec
//  MIT License (see LICENSE)
//
//  The tokenizer takes a string of source code (the contents of a source code
//  file basically) and turns it into tokens. The tokens represent all of the
//  smallest individual chunks of a program that can be processed. The valid
//  tokens in a programming language are specified by a grammar. We have a grammar
//  file in the repository as well. It is grammar.txt. Please keep it open as you
//  read Tokenizer.swift and Parser.swift.

//  NOTE: This file is complete—you should not need to modify it.

import Foundation

public enum TokenizerError: Error, LocalizedError {
    case UnexpectedSymbol(lineNumber: Int, closeTo: String, range: Range<String.Index>)
    
    public var errorDescription: String? {
        switch self {
        case .UnexpectedSymbol(let lineNumber, let closeTo, _):
            return "Unexpected symbol at line \(lineNumber) close to:\(closeTo)"
        }
    }
}

// All possible token types
// Note we can't use Swift keywords as token types, hence
// ifT, letT, returnT, etc. (T for token)
// Every token is associated with the range of characters where it was found
// in the original source code.
// A few special tokens (variable, number, string) are also associated
// with custom values.
public enum Token {
    case print(Range<String.Index>)
    case ifT(Range<String.Index>)
    case then(Range<String.Index>)
    case goto(Range<String.Index>)
    case letT(Range<String.Index>)
    case gosub(Range<String.Index>)
    case returnT(Range<String.Index>)
    case comma(Range<String.Index>)
    case equal(Range<String.Index>)
    case notEqual(Range<String.Index>)
    case lessThan(Range<String.Index>)
    case lessThanEqual(Range<String.Index>)
    case greaterThan(Range<String.Index>)
    case greaterThanEqual(Range<String.Index>)
    case plus(Range<String.Index>)
    case minus(Range<String.Index>)
    case multiply(Range<String.Index>)
    case divide(Range<String.Index>)
    case openParen(Range<String.Index>)
    case closeParen(Range<String.Index>)
    case variable(Range<String.Index>, String)
    case number(Range<String.Index>, Int16)
    case string(Range<String.Index>, String)
    case EOF // indicates we ran out of tokens
    
    public var range: Range<String.Index> {
        switch self {
        case .print(let range):
            return range
        case .ifT(let range):
            return range
        case .then(let range):
            return range
        case .goto(let range):
            return range
        case .letT(let range):
            return range
        case .gosub(let range):
            return range
        case .returnT(let range):
            return range
        case .comma(let range):
            return range
        case .equal(let range):
            return range
        case .notEqual(let range):
            return range
        case .lessThan(let range):
            return range
        case .lessThanEqual(let range):
            return range
        case .greaterThan(let range):
            return range
        case .greaterThanEqual(let range):
            return range
        case .plus(let range):
            return range
        case .minus(let range):
            return range
        case .multiply(let range):
            return range
        case .divide(let range):
            return range
        case .openParen(let range):
            return range
        case .closeParen(let range):
            return range
        case .variable(let range, _):
            return range
        case .number(let range, _):
            return range
        case .string(let range, _):
            return range
        case .EOF:
            return "".startIndex..<"".endIndex // dummy range
        }
        
    }
}

// Every conversion is composed of a regular expression
// and a closure that knows how to construct a token
let conversions: [(String, (Range<String.Index>, String) -> Token?)] =
    [("rem.*", {_, _ in nil }),  // comments
     ("[ \t\n\r]", {_, _ in nil }),  // whitespace
     ("print", {r, _ in .print(r) }),
     ("if", {r, _ in .ifT(r) }),
     ("then", {r, _ in .then(r) }),
     ("goto", {r, _ in .goto(r) }),
     ("let", {r, _ in .letT(r) }),
     ("gosub", {r, _ in .gosub(r) }),
     ("return", {r, _ in .returnT(r) }),
     (",", {r, _ in .comma(r) }),
     ("=", {r, _ in .equal(r) }),
     ("<>", {r, _ in .notEqual(r) }),
     ("><", {r, _ in .notEqual(r) }),
     ("<=", {r, _ in .lessThanEqual(r) }),
     (">=", {r, _ in .greaterThanEqual(r) }),
     ("<", {r, _ in .lessThan(r) }),
     (">", {r, _ in .greaterThan(r) }),
     ("\\+", {r, _ in .plus(r) }),
     ("-", {r, _ in .minus(r) }),
     ("\\*", {r, _ in .multiply(r) }),
     ("/", {r, _ in .divide(r) }),
     ("\\(", {r, _ in .openParen(r) }),
     ("\\)", {r, _ in .closeParen(r) }),
     ("\"[a-zA-Z0-9 ]*\"", {r, str in .string(r, String(str.dropFirst().dropLast())) }), // don't include quote characters
     ("[A-Z]", {r, str in .variable(r, str) }),
     ("-?[0-9]+", {r, str in .number(r, Int16(str)!) })]

// Take a string of text and convert it into an array of tokens by applying
// regular expressions to search for specific tokens and using transform closures (see above)
// to convert the respective text into the respective token
public func tokenize(text: String) throws -> [Token] {
    var tokens: [Token] = []
    var remaining = text
    var tokenRange: Range<String.Index> = text.startIndex..<text.startIndex
    // keep going while there is still text to search
    while remaining.count > 0 {
        var found = false
        // try every possible regular expression sequentially
        for (regExpStr, creator) in conversions {
            // ^ is for matching at the start of the string
            if let foundRange = remaining.range(of: "^\(regExpStr)", options: [.regularExpression, .caseInsensitive]) {
                found = true
                let distance = remaining.distance(from: foundRange.lowerBound, to: foundRange.upperBound)
                let tokenEnd: String.Index = text.index(tokenRange.upperBound, offsetBy: distance) 
                tokenRange = tokenRange.upperBound..<tokenEnd
                let foundString = remaining[foundRange]
                if let token = creator(tokenRange, String(foundString)) {
                    tokens.append(token)
                }
                
                remaining.removeSubrange(foundRange)
                break
            }
        }
        // if not a single regular expression matched, we have an unknown symbol
        if !found {
            // get line of error
            let rangeBefore = text.startIndex...tokenRange.upperBound
            let textUpTo = String(text[rangeBefore])
            let lineNumber = textUpTo.split(separator: "\n", omittingEmptySubsequences: false).count
            let closeTo = String(remaining.split(separator: "\n").first!)
            let errorRange = tokenRange.upperBound..<text.index(tokenRange.upperBound, offsetBy: closeTo.count)
            throw TokenizerError.UnexpectedSymbol(lineNumber: lineNumber, closeTo: closeTo, range: errorRange)
        }
    }
    return tokens
}
