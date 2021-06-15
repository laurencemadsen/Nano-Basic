# Nano-Basic

This program was an assignment for a class which allowed me to showcase my in-depth knowledge of the Swift language and create a fun and interesting program. Since not all the code written is mine I've included below the assignment description and objective as well as instructions to build and run the tests.

## Building NanoBASIC and Running Programs
You can run a source file through the NanoBASIC interpreter by first building NanoBASIC:

swift build
and then from the repository's main directory running

.build/debug/NanoBASIC Examples/print1.bas
Where Examples/print1.bas is replaced by the filename of your program. Some sample programs are included in the Examples directory of the repository. The examples that come with the repository should be left unchanged for the unit tests to work.

## Testing NanoBASIC
Before you try running the tests, you should first build NanoBASIC. From the main repository directory run:

swift build
Tests should be run from the command-line (they depend on the build directory), not Xcode and you can run NanoBASIC's unit tests by running

swift test
from the main directory of this repository."


## Description

Because describing even a simple programming language takes a lot of room, we have described the NanoBASIC language itself in a separate document available in the project GitHub repository called language_guide.md. Please read the language guide before beginning the project.

The language implementation is split between four files (found in Sources/NanoBASICEngine) that represent the main pieces of a simple language interpreter. It is strongly suggested that you read all four of the source code files completely before attempting to write any code. Here is a brief summary of each of the four pieces of an interpreter/the four files.

Tokenizer.swift – The tokenizer takes a string of source code (the contents of a source code file basically) and turns it into tokens. The tokens represent all of the smallest individual chunks of a program that can be processed. The valid tokens in a programming language are specified by a grammar. We have a grammar file in the repository as well. It is grammar.txt. Please keep it open as you read Tokenizer.swift and Parser.swift.

Parser.swift – The parser takes the tokens from the tokenizer and tries to convert them into structures that are meaningful for interpreting the program. The particular parsing technique being used in Parser.swift is recursive descent. In recursive descent, generally each non-terminal defined in the grammar becomes a function. That function is responsible for checking that the tokens it is analyzing follow a production rule specified in the grammar. In other words, generally one recursive descent function = one production rule from the grammar. The parser checks the tokens by looking at them sequentially. If the token that is being analyzed is expected to be a part of another production rule, the recursive descent parser just calls the function representing that other production rule. The recursive descent functions return respective nodes (for example an ifStatement function will return an IfStatement node) when they are successful.

Nodes.swift – This file defines the nodes that the parser can create. Nodes are meaningful chunks of a program for the interpreter to interpret. For example, generally each statement will become a node.

Interpreter.swift – The interpreter is responsible for processing the nodes that come from the parser. In many interpreters, this structure will be represented as an abstract syntax tree. Because NanoBASIC is extremely linear, the data structure that the interpreter receives is just an array of statements. The interpreter translates the meaning of each statement node into Swift code that can be run "live."

You'll note that the current tokenizer keeps track of the ranges of characters in the original source code that contained the token, as does the parser's nodes. This can be useful for debug purposes.

## Objective

You are being provided a working Tokenizer. The file Tokenizer.swift should be complete. In addition, the file Nodes.swift is also complete. You are also being provided the rest of the interpreter partially working (Parser.swift, Interpreter.swift). Arithmetic expressions are working. Print statements are working along with comments and String literals. You are expected to make the rest of NanoBASIC work.

Your final program should be able to interpret all of the provided NanoBASIC example programs in the Examples directory by passing all of the included functional tests. The provided source code already passes the first two tests (testPrint1() and testPrint2()). You may not modify any of the provided tests, but you may add additional tests if you would like.  We have clearly marked the functions that you need to fill-in with "YOU FILL IN HERE" comments.  There should not be any need to modify the rest of the source code, but you can add additional utility functions if you would like.
