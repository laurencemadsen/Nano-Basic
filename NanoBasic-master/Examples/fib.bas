REM Printing the Fibonacci numbers less than 100
REM A is LAST
20 LET A = 0
REM B is NEXT
30 LET B = 1
31 PRINT A
REM C is LAST + NEXT
35 LET C = A + B
40 LET A = B
50 LET B = C
60 IF B > 100 THEN GOTO 80
70 GOTO 31
80 PRINT A