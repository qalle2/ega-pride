DECLARE SUB drawflag (drawcommands$)
DECLARE FUNCTION deletespaces$ (old$)
DECLARE FUNCTION runround% (correct%)
DECLARE FUNCTION formatratio$ (a%, b%)
DECLARE FUNCTION getchoice$ (choices$)
DECLARE SUB printgradtext (text$, y%)
DECLARE SUB printcentered (text$, y%)
DECLARE SUB titlescreen ()
DECLARE SUB readflagdata ()
DECLARE SUB printbottomtext (text$)
DEFINT A-Z

CONST MAXFLAGS = 35  ' maximum number of flags
CONST CHOICECNT = 3  ' number of choices
CONST ROUNDCNT = 10  ' how many rounds
CONST PI = 3.141593

' 0 = normal operation
' 1 = just show the first flag and quit
' 2 = show all flags
CONST DEBUGMODE = 0

DIM SHARED names$(MAXFLAGS - 1)         ' names of flags
DIM SHARED drawcommands$(MAXFLAGS - 1)  ' commands for drawing flags
DIM SHARED flagcount                    ' how many flags

DIM corranswers(ROUNDCNT - 1)  ' correct answers

' Flag data (name followed by draw commands).
' Try to minimise overdraw.
' Commands and arguments (see drawflag sub for details):
'   HRE yhc    = Horizontal REctangle (filled, full width)
'   DHR yhcc   = Dithered Horizontal Rectangle (filled, full width)
'   REC xwyhc  = RECtangle (filled)
'   DRE xwyhcc = Dithered REctangle (filled)
'   LIN xyxyc  = LINe
'   CLI xyc    = Continue LIne (from end of previous line)
'   CIR xyrc   = CIRcle
'   ARC xyrcaa = ARC (aa: start/end angle)
'   FIL xycc   = FILl (cc: fill color, color to stop at)
'   DFI xyccc  = Dithered FIll (ccc: fill color 1/2, color to stop at)
' Terminators:
'   "-" as command = end this flag's data
'   "-" as name    = end all flag data
DATA abrosexual
DATA HRE,  0,36, 2
DATA HRE, 36,36,10
DATA HRE, 72,36,15
DATA HRE,108,36,12
DATA HRE,144,36, 4
DATA -
DATA agender
DATA HRE,  0,26, 0
DATA HRE, 26,26, 7
DATA HRE, 52,26,15
DATA HRE, 78,26,10
DATA HRE,104,26,15
DATA HRE,130,26, 7
DATA HRE,156,26, 0
DATA -
DATA aromantic
DATA HRE,  0,36, 2
DATA HRE, 36,36,10
DATA HRE, 72,36,15
DATA HRE,108,36, 7
DATA HRE,144,36, 0
DATA -
DATA aromantic asexual
DATA DHR,  0,36,12,14
DATA HRE, 36,36,14
DATA HRE, 72,36,15
DATA DHR,108,36, 9,11
DATA DHR,144,36, 1, 3
DATA -
DATA asexual
DATA HRE,  0,45, 0
DATA HRE, 45,45, 7
DATA HRE, 90,45,15
DATA HRE,135,45, 5
DATA -
DATA autism
DATA DHR,0,179,12,14
' arcs
DATA ARC,106,90,20,15, 45,315
DATA ARC,106,90,40,15, 45,315
DATA ARC,213,90,20,15,225,135
DATA ARC,213,90,40,15,225,135
' lines between arcs
DATA LIN,116,105,195, 61,15
DATA LIN,126,119,205, 75,15
DATA LIN,116, 75,195,119,15
DATA LIN,126, 61,205,105,15
' split circles with vertical lines
DATA LIN,106, 58,106, 72,15
DATA LIN,106,108,106,122,15
DATA LIN,213, 58,213, 72,15
DATA LIN,213,108,213,122,15
' fill band from left to right
DATA FIL, 85, 90,13,15
DATA FIL,107, 70,12,15
DATA FIL,107,110, 9,15
DATA FIL,159, 90,11,15
DATA FIL,212, 70,11,15
DATA FIL,212,110,14,15
DATA FIL,234, 90,10,15
' undo vertical lines
DATA LIN,106, 58,106, 72,13
DATA LIN,106,108,106,122,13
DATA LIN,213, 58,213, 72,11
DATA LIN,213,108,213,122,14
' undo diagonal lines on blue part of band
DATA LIN,143,90,159,99,11
DATA LIN,160,80,178,90,11
DATA -
DATA bear
' stripes
DATA HRE,  0,26, 6
DATA DHR, 26,26,12,14
DATA HRE, 52,26,14
DATA DHR, 78,26,14,15
DATA HRE,104,26,15
DATA HRE,130,26, 8
DATA HRE,156,26, 0
' pawprint - largest part
DATA LIN, 59,33,76,33,0
DATA CLI, 96,43, 0
DATA CLI,106,43, 0
DATA CLI,118,37, 0
DATA CLI,125,37, 0
DATA CLI,131,43, 0
DATA CLI,131,46, 0
DATA CLI,121,56, 0
DATA CLI, 91,71, 0
DATA CLI, 71,91, 0
DATA CLI, 63,91, 0
DATA CLI, 60,88, 0
DATA CLI, 60,60, 0
DATA CLI, 48,48, 0
DATA CLI, 48,44, 0
DATA CLI, 59,33, 0
DATA FIL, 60,34, 0, 0
' pawprint - 1st small part from left
DATA LIN,31,73,42,73,0
DATA CLI,52,78, 0
DATA CLI,52,87, 0
DATA CLI,50,89, 0
DATA CLI,46,89, 0
DATA CLI,38,85, 0
DATA CLI,31,78, 0
DATA CLI,31,73, 0
DATA FIL,32,74, 0, 0
' pawprint - 2nd small part from left
DATA LIN,27,49,34,49,0
DATA CLI,50,57, 0
DATA CLI,50,64, 0
DATA CLI,47,67, 0
DATA CLI,37,67, 0
DATA CLI,27,57, 0
DATA CLI,27,49, 0
DATA FIL,28,50, 0, 0
' pawprint - 3rd small part from left
DATA LIN,26,23,37,23,0
DATA CLI,51,30, 0
DATA CLI,51,36, 0
DATA CLI,45,42, 0
DATA CLI,42,42, 0
DATA CLI,34,38, 0
DATA CLI,26,30, 0
DATA CLI,26,23, 0
DATA FIL,27,24, 0, 0
' pawprint - 4th small part from left
DATA LIN,48,13,68,13,0
DATA CLI,76,17, 0
DATA CLI,76,25, 0
DATA CLI,72,29, 0
DATA CLI,65,29, 0
DATA CLI,43,18, 0
DATA CLI,48,13, 0
DATA FIL,49,14, 0, 0
' pawprint - 5th small part from left
DATA LIN, 85,19,95,19,0
DATA CLI,111,27, 0
DATA CLI,111,35, 0
DATA CLI,107,39, 0
DATA CLI,101,39, 0
DATA CLI, 85,31, 0
DATA CLI, 85,19, 0
DATA FIL, 86,20, 0, 0
DATA -
DATA bigender
DATA DHR,  0,26, 7,13
DATA DHR, 26,26,13,15
DATA DHR, 52,26, 9,15
DATA HRE, 78,26,15
DATA DHR,104,26, 9,15
DATA DHR,130,26,11,15
DATA DHR,156,26, 9,11
DATA -
DATA bisexual
DATA DHR,  0,72,4, 5
DATA DHR, 72,36,8,13
DATA HRE,108,72,9
DATA -
DATA demiboy
DATA HRE,  0,26, 8
DATA HRE, 26,26, 7
DATA DHR, 52,26,11,15
DATA HRE, 78,26,15
DATA DHR,104,26,11,15
DATA HRE,130,26, 7
DATA HRE,156,26, 8
DATA -
DATA demigirl
DATA HRE,  0,26, 8
DATA HRE, 26,26, 7
DATA DHR, 52,26,12,15
DATA HRE, 78,26,15
DATA DHR,104,26,12,15
DATA HRE,130,26, 7
DATA HRE,156,26, 8
DATA -
DATA demiromantic
DATA HRE,  0, 75,       15
DATA HRE, 75, 30,        2
DATA HRE,105, 75,        7
DATA LIN,  0,  0,137,90, 0
DATA CLI,  0,179,        0
DATA FIL,  0, 90,        0,0
DATA -
DATA demisexual
DATA HRE,  0, 75,       15
DATA HRE, 75, 30,        5
DATA HRE,105, 75,        7
DATA LIN,  0,  0,137,90, 0
DATA CLI,  0,179,        0
DATA FIL,  0, 90,        0,0
DATA -
DATA disability
DATA HRE,  0,180,         8
' 1st stripe from bottom
DATA LIN,  0, 38,251,179,12
DATA CLI,215,179,        12
DATA CLI,  0, 59,        12
DATA FIL,  0, 39,        12,12
' 2nd stripe
DATA LIN,  0, 15,291,179,14
DATA CLI,252,179,        14
DATA CLI,  0, 39,        14
DATA FIL,  0, 16,        14,14
' 3rd stripe
DATA LIN, 15,  0,319,172,15
DATA CLI,319,179,        15
DATA CLI,291,179,        15
DATA CLI,  0, 15,        15
DATA FIL, 15,  1,        15,15
' 4th stripe
DATA LIN, 56,  0,319,149,11
DATA CLI,319,172,        11
DATA CLI, 15,  0,        11
DATA FIL, 56,  1,        11,11
' 5th stripe
DATA LIN, 97,  0,319,125,10
DATA CLI,319,149,        10
DATA CLI, 56,  0,        10
DATA FIL, 97,  1,        10,10
DATA -
DATA gay men
DATA HRE,  0,36, 2
DATA HRE, 36,36,10
DATA HRE, 72,36,15
DATA DHR,108,36, 9,11
DATA DHR,144,36, 1, 5
DATA -
DATA genderfluid
DATA HRE,  0,36,12
DATA HRE, 36,36,15
DATA HRE, 72,36,13
DATA DHR,108,36, 0, 8
DATA HRE,144,36, 9
DATA -
DATA genderqueer
DATA DHR,  0,60, 9,13
DATA HRE, 60,60,15
DATA HRE,120,60, 2
DATA -
DATA intersex
DATA HRE,  0,180,   14
DATA CIR,160, 90,61, 5
DATA CIR,160, 90,45, 5
DATA FIL,160, 45,    5, 5
DATA -
DATA leather
' stripes
DATA HRE, 20,20, 9
DATA HRE, 60,20, 9
DATA HRE, 80,20,15
DATA HRE,100,20, 9
DATA HRE,140,20, 9
' heart
DATA ARC, 86,24, 24,   4,330,200
DATA ARC, 50,46, 24,   4, 45,290
DATA LIN,110,24,106,75,4
DATA CLI, 50,66,       4
DATA FIL,105,74,       4,  4
DATA -
DATA lesbian
DATA HRE,  0,36, 4
DATA DHR, 36,36,12,14
DATA HRE, 72,36,15
DATA DHR,108,36, 7,13
DATA HRE,144,36, 5
DATA -
DATA non-binary
DATA HRE,  0,45,14
DATA HRE, 45,45,15
DATA DHR, 90,45, 9,13
DATA DHR,135,45, 0, 8
DATA -
DATA non-human unity
' stripes
DATA HRE,  0,60, 2
DATA HRE, 60,60,15
DATA DHR,120,60, 1,5
' white circle
DATA CIR,160, 95,73,15
DATA FIL,160, 50,15,15
DATA FIL,160,125,15,15
' black circle
DATA CIR,160,95,43,0
DATA CIR,160,95,50,0
DATA FIL,204,95, 0,0
' outer edges of heptagram, clockwise from top
DATA LIN,163, 59,169, 78,0
DATA CLI,191, 69,        0
DATA LIN,195, 74,180, 90,0
DATA CLI,203,100,        0
DATA LIN,202,105,176,105,0
DATA CLI,183,126,        0
DATA LIN,176,129,159,112,0
DATA CLI,143,129,        0
DATA LIN,136,126,143,105,0
DATA CLI,117,105,        0
DATA LIN,116, 99,139, 90,0
DATA CLI,123, 74,        0
DATA LIN,128, 69,150, 79,0
DATA CLI,156, 58,        0
' quadrilaterals around central heptagon, clockwise from top
DATA LIN,160, 69,163, 82,0
DATA CLI,160, 84,        0
DATA CLI,156, 82,        0
DATA CLI,159, 69,        0
DATA LIN,182, 79,175, 88,0
DATA CLI,171, 87,        0
DATA CLI,170, 84,        0
DATA CLI,182, 79,        0
DATA LIN,190,101,175,101,0
DATA CLI,174, 98,        0
DATA CLI,176, 94,        0
DATA CLI,190,101,        0
DATA LIN,173,118,163,108,0
DATA CLI,165,105,        0
DATA CLI,170,105,        0
DATA CLI,173,118,        0
DATA LIN,145,118,148,105,0
DATA CLI,153,105,        0
DATA CLI,155,108,        0
DATA CLI,145,118,        0
DATA LIN,129,100,142, 94,0
DATA CLI,145, 97,        0
DATA CLI,143,101,        0
DATA CLI,129,100,        0
DATA LIN,137,79,149, 84, 0
DATA CLI,147, 87,        0
DATA CLI,144, 88,        0
DATA CLI,137, 80,        0
' inner edges of heptagram (central heptagon)
DATA LIN,160, 88,166,90,0
DATA CLI,167, 96,       0
DATA CLI,162,101,       0
DATA CLI,156,101,       0
DATA CLI,151, 96,       0
DATA CLI,153, 90,       0
DATA CLI,159, 88,       0
' fill heptagram
DATA FIL,160,60,0,0
' edges of triangle
DATA LIN,160, 37,218,125,0
DATA CLI,101,125,        0
DATA CLI,159, 37,        0
DATA LIN,160, 46,208,121,0
DATA CLI,111,121,        0
DATA CLI,159, 46,        0
' fill triangle, clockwise from top
DATA FIL,160, 38,0,0
DATA FIL,175, 65,0,0
DATA FIL,190, 90,0,0
DATA FIL,217,124,0,0
DATA FIL,185,122,0,0
DATA FIL,160,124,0,0
DATA FIL,135,122,0,0
DATA FIL,103,124,0,0
DATA FIL,130, 90,0,0
DATA FIL,145, 65,0,0
DATA -
DATA omnisexual
DATA DHR,  0,36,12,15
DATA DHR, 36,36,12,13
DATA DHR, 72,36, 0, 5
DATA HRE,108,36, 9
DATA DHR,144,36, 9,15
DATA -
DATA pansexual
DATA DHR,  0,60,12,13
DATA HRE, 60,60,14
DATA DHR,120,60, 9,11
DATA -
DATA polyamory
' horizontal stripes
DATA DRE, 72,248, 0,60, 9,11
DATA REC, 72,248,60,60,12
DATA DHR,120, 60,       0, 5
' white (2 lines)
DATA LIN,72,  0,144,60,15
DATA CLI, 0,179,       15
DATA FIL, 0,  0,       15,15
' heart (2 arcs, 2 lines)
DATA ARC, 50,45, 23,   12, 0,270
DATA ARC, 50,75, 23,   12,90,359
DATA LIN, 62,28,103,60,12
DATA CLI, 62,92,       12
DATA FIL,100,60,       12,12
DATA DFI,100,60,       12,14, 15
DATA -
DATA polysexual
DATA HRE,  0,60,13
DATA HRE, 60,60,10
DATA DHR,120,60, 9,11
DATA -
DATA queer
DATA HRE,  0,20, 0
DATA DHR, 20,20,11,15
DATA DHR, 40,20, 9,11
DATA DHR, 60,20,10,14
DATA HRE, 80,20,15
DATA DHR,100,20,12,14
DATA HRE,120,20,12
DATA DHR,140,20,12,15
DATA HRE,160,20, 0
DATA -
DATA rainbow
DATA HRE,  0,30,12
DATA DHR, 30,30,12,14
DATA HRE, 60,30,14
DATA HRE, 90,30, 2
DATA HRE,120,30, 9
DATA HRE,150,30, 5
DATA -
DATA rainbow-progress
' horizontal stripes
DATA REC, 54,266,  0,30,12
DATA DRE, 81,239, 30,30,12,14
DATA REC,108,212, 60,30,14
DATA REC,108,212, 90,30,10
DATA REC, 81,239,120,30, 9
DATA REC, 54,266,150,30, 5
' chevrons are 27 px wide and 23 px tall
' white triangle
DATA LIN, 0, 45,54,90,15
DATA CLI, 0,135,      15
DATA FIL,53, 90,      15,15
' pink chevron
DATA LIN, 0, 22,81,90,15
DATA CLI, 0,158,      15
DATA DFI,80, 90,      12,15,15
' blue chevron
DATA LIN,  0, 22, 81,90,11
DATA CLI,  0,158,       11
DATA LIN,  0,  0,108,90,11
DATA CLI,  0,179,       11
DATA FIL,107, 90,       11,11
' brown chevron
DATA LIN,  0,  0,108,90,6
DATA CLI,  0,179,       6
DATA LIN, 27,  0,135,90,6
DATA CLI, 27,179,       6
DATA CLI,  0,179,       6
DATA FIL,134, 90,       6,6
' black chevron
DATA LIN, 27,  0,135,90,0
DATA CLI, 27,179,       0
DATA LIN, 54,  0,162,90,0
DATA CLI, 54,179,       0
DATA FIL,161, 90,       0,0
DATA -
DATA rainbow-progress-intersex
' horizontal stripes
DATA REC, 54,266,  0,30,12
DATA DRE, 81,239, 30,30,12,14
DATA REC,108,212, 60,30,14
DATA REC,108,212, 90,30,10
DATA REC, 81,239,120,30, 9
DATA REC, 54,266,150,30, 5
' chevrons are 22 px wide and 18 px tall
' yellow triangle
DATA LIN, 0, 18,80,90,14
DATA CLI, 0,162,      14
DATA FIL,79, 90,      14,14
' white chevron
DATA LIN,  0, 18, 80,90,15
DATA CLI,  0,162,       15
DATA LIN,  0,  0,102,90,15
DATA CLI,  0,179,       15
DATA FIL,101, 90,       15,15
' pink chevron
DATA LIN, 22,  0,124, 90,15
DATA CLI, 22,179,        15
DATA LIN,  0,180, 22,180,15
DATA DFI,123, 90, 12,    15,15
DATA LIN,  0,180, 22,180, 0
' cyan chevron
DATA LIN, 22,  0,124,90,11
DATA CLI, 22,179,       11
DATA LIN, 44,  0,146,90,11
DATA CLI, 44,179,       11
DATA CLI, 22,179,       11
DATA FIL,145, 90,       11,11
' brown chevron
DATA LIN, 44,  0,146,90,6
DATA CLI, 44,179,       6
DATA LIN, 66,  0,168,90,6
DATA CLI, 66,179,       6
DATA CLI, 44,179,       6
DATA FIL,167, 90,       6,6
' black chevron
DATA LIN, 66,  0,168,90,0
DATA CLI, 66,179,       0
DATA LIN, 88,  0,190,90,0
DATA CLI, 88,179,       0
DATA FIL,169, 90,       0,0
' circle
DATA CIR,30,90,19,5
DATA CIR,30,90,24,5
DATA FIL,50,90, 5,5
DATA -
DATA sapphic
' horizontal stripes
DATA DHR,  0,60,12,15
DATA HRE, 60,60,15
DATA DHR,120,60,12,15
' center of flower
DATA CIR,160,92,5,12
DATA FIL,160,92,  12,12
DATA CIR,160,92,3,14
DATA FIL,160,92,  14,14
' top petal
DATA LIN,153,62,166,62,13
DATA CLI,170,64,13
DATA CLI,174,68,13
DATA CLI,174,75,13
DATA CLI,164,85,13
DATA CLI,155,85,13
DATA CLI,145,75,13
DATA CLI,145,68,13
DATA CLI,149,64,13
DATA CLI,153,62,13
DATA FIL,153,63,13,13
' left petal
DATA LIN,133,78,139,78,13
DATA CLI,147,82,13
DATA CLI,152,87,13
DATA CLI,152,93,13
DATA CLI,150,95,13
DATA CLI,132,95,13
DATA CLI,128,91,13
DATA CLI,128,83,13
DATA CLI,133,78,13
DATA FIL,133,79,13,13
' right petal
DATA LIN,187,78,181,78,13
DATA CLI,173,82,13
DATA CLI,168,87,13
DATA CLI,168,93,13
DATA CLI,170,95,13
DATA CLI,188,95,13
DATA CLI,192,91,13
DATA CLI,192,83,13
DATA CLI,187,78,13
DATA FIL,187,79,13,13
' bottom left petal
DATA LIN,145, 98,156,98,13
DATA CLI,158,100,13
DATA CLI,158,107,13
DATA CLI,155,113,13
DATA CLI,154,114,13
DATA CLI,148,117,13
DATA CLI,140,117,13
DATA CLI,136,113,13
DATA CLI,136,107,13
DATA CLI,138,103,13
DATA CLI,141,100,13
DATA CLI,145, 98,13
DATA FIL,145, 99,13,13
' bottom right petal
DATA LIN,175, 98,164,98,13
DATA CLI,162,100,13
DATA CLI,162,107,13
DATA CLI,165,113,13
DATA CLI,166,114,13
DATA CLI,172,117,13
DATA CLI,180,117,13
DATA CLI,184,113,13
DATA CLI,184,107,13
DATA CLI,182,103,13
DATA CLI,179,100,13
DATA CLI,175, 98,13
DATA FIL,175, 99,13,13
DATA -
DATA transgender
DATA HRE,  0,36,11
DATA DHR, 36,36,12,15
DATA HRE, 72,36,15
DATA DHR,108,36,12,15
DATA HRE,144,36,11
DATA -
DATA -

RANDOMIZE TIMER

CALL readflagdata

IF CHOICECNT > flagcount THEN PRINT "Too many choices.": END
IF ROUNDCNT > flagcount THEN PRINT "Too many rounds.": END

highscore = 0

SCREEN 7

IF DEBUGMODE = 1 THEN
    CALL drawflag(drawcommands$(0)): END
ELSEIF DEBUGMODE = 2 THEN
    FOR i = 0 TO flagcount - 1
        CLS
        CALL drawflag(drawcommands$(i))
        CALL printbottomtext(names$(i))
        DO: LOOP UNTIL INKEY$ = ""
        k$ = INPUT$(1)
    NEXT
    END
END IF

CALL titlescreen
k$ = getchoice$(" Q")
IF k$ = "Q" THEN SCREEN 0: END

DO
    ' main loop

    ' get correct answers (all different)
    FOR i = 0 TO ROUNDCNT - 1
        DO
            corranswers(i) = INT(RND * flagcount)
            inuse = 0
            FOR j = 0 TO i - 1
                IF corranswers(j) = corranswers(i) THEN inuse = 1: EXIT FOR
            NEXT
        LOOP WHILE inuse
    NEXT

    ' run quiz rounds
    score = 0
    FOR round = 0 TO ROUNDCNT - 1
        score = score + runround%(corranswers(round))
    NEXT

    ' print score and describe it
    CLS
    s$ = "You got " + formatratio(score, ROUNDCNT) + " points."
    CALL printcentered(s$, 3)
    ' if score >= ROUNDCNT * x/y, then score * y >= ROUNDCNT * x
    IF score * 10 >= ROUNDCNT * 9 THEN  ' >= 90%
        grade$ = "Very good!"
    ELSEIF score * 10 >= ROUNDCNT * 7 THEN  ' >= 70%
        grade$ = "Good!"
    ELSEIF score * 10 >= ROUNDCNT * 5 THEN  ' >= 50%
        grade$ = "An OK score."
    ELSE
        grade$ = "Please try again :("
    END IF
    CALL printcentered(grade$, 4)

    ' update high score; congratulate if both high score and a good score
    IF score > highscore AND score * 10 >= ROUNDCNT * 7 THEN  ' >= 70%
        highscore = score
        CALL printcentered("New high score!", 6)
    ELSE
        IF score > highscore THEN highscore = score
        s$ = "High score: " + formatratio(highscore, ROUNDCNT)
        CALL printcentered(s$, 6)
    END IF

    CALL printcentered("Space = new game", 8)
    CALL printcentered("    Q = quit    ", 9)
    k$ = getchoice$(" Q")
    IF k$ = "Q" THEN EXIT DO
LOOP

SCREEN 0

FUNCTION deletespaces$ (old$)
' delete spaces from the string
DEFINT A-Z

new$ = ""
FOR i = 1 TO LEN(old$)
    c$ = MID$(old$, i, 1)
    IF c$ <> " " THEN new$ = new$ + c$
NEXT
deletespaces$ = new$

END FUNCTION

SUB drawflag (drawcommands$)
' Draw a flag by Draw Commands.
'   Draw Commands = a string with zero or more Blocks
'     Block       = a Command followed by zero or more Arguments
'       Command   = "AAA"-"ZZZ", in UPPER CASE
'       Argument  = integer as 2 bytes; count depends on Command
' Commands and their Arguments:
'   HRE yhc    = Horizontal REctangle (filled, full width)
'   DHR yhcc   = Dithered Horizontal Rectangle (filled, full width)
'   REC xwyhc  = RECtangle (filled)
'   DRE xwyhcc = Dithered REctangle (filled)
'   LIN xyxyc  = LINe
'   CLI xyc    = Continue LIne (from end of previous line)
'   CIR xyrc   = CIRcle
'   ARC xyrcaa = ARC (aa: start/end angle)
'   FIL xycc   = FILl (cc: fill color, color to stop at)
'   DFI xyccc  = Dithered FIll (ccc: fill color 1/2, color to stop at)
' Arguments:
'   x, y = X position, Y position
'   w, h = Width, Height
'   r    = Radius
'   c    = Color
'   a    = angle (degrees CCW from right)
' Flag width is always 320.
' Flag height is 182 if it needs to be divisible by 7, otherwise 180.

DEFINT A-Z
DIM args(5)  ' Arguments

dci = 1
WHILE dci < LEN(drawcommands$)
    ' Command
    c$ = MID$(drawcommands$, dci, 3)
    dci = dci + 3

    ' number of Arguments
    SELECT CASE c$
        CASE "HRE", "CLI": argc = 3
        CASE "DHR", "CIR", "FIL": argc = 4
        CASE "REC", "LIN", "DFI": argc = 5
        CASE "DRE", "ARC": argc = 6
        CASE ELSE: PRINT "Unknown draw command: "; c$: END
    END SELECT

    ' Arguments
    FOR j = 0 TO argc - 1
        args(j) = CVI(MID$(drawcommands$, dci, 2))
        dci = dci + 2
    NEXT
    IF dci > LEN(drawcommands$) + 1 THEN
        PRINT "Unexpected end of draw commands."
        END
    END IF

    ' execute Command
    IF c$ = "HRE" OR c$ = "DHR" THEN
        LINE (0, args(0))-(319, args(0) + args(1) - 1), args(2), BF
        IF c$ = "DHR" THEN
            FOR y = args(0) TO args(0) + args(1) - 1
                IF (y AND 1) THEN pattern = &H5555 ELSE pattern = &HAAAA
                LINE (0, y)-(319, y), args(3), , pattern
            NEXT
        END IF
    ELSEIF c$ = "REC" OR c$ = "DRE" THEN
        x2 = args(0) + args(1) - 1
        y2 = args(2) + args(3) - 1
        LINE (args(0), args(2))-(x2, y2), args(4), BF
        LINE (args(0), args(2))-(x2, y2), args(4), BF
        IF c$ = "DRE" THEN
            FOR y = args(2) TO y2
                IF (y AND 1) THEN pattern = &H5555 ELSE pattern = &HAAAA
                LINE (args(0), y)-(x2, y), args(5), , pattern
            NEXT
        END IF
    ELSEIF c$ = "LIN" THEN
        LINE (args(0), args(1))-(args(2), args(3)), args(4)
    ELSEIF c$ = "CLI" THEN
        LINE -(args(0), args(1)), args(2)
    ELSEIF c$ = "CIR" THEN
        CIRCLE (args(0), args(1)), args(2), args(3)
    ELSEIF c$ = "ARC" THEN
        a1! = args(4) * PI / 180
        a2! = args(5) * PI / 180
        CIRCLE (args(0), args(1)), args(2), args(3), a1!, a2!
    ELSEIF c$ = "FIL" THEN
        PAINT (args(0), args(1)), args(2), args(3)
    ELSEIF c$ = "DFI" THEN
        ' create fill pattern for 8*2 pixels:
        '   bytes 1-4 = blue/green/red/intensity of top    8*1 pixels
        '   bytes 5-8 = blue/green/red/intensity of bottom 8*1 pixels
        pattern$ = STRING$(8, &H0)
        FOR i = 0 TO 3
            pow = 2 ^ i
            bp1set = (args(2) AND pow) > 0
            bp2set = (args(3) AND pow) > 0
            IF bp1set AND bp2set THEN
                MID$(pattern$, i + 1, 1) = CHR$(&HFF)
                MID$(pattern$, i + 5, 1) = CHR$(&HFF)
            ELSEIF bp1set OR bp2set THEN
                MID$(pattern$, i + 1, 1) = CHR$(&H55)
                MID$(pattern$, i + 5, 1) = CHR$(&HAA)
            END IF
        NEXT
        PAINT (args(0), args(1)), pattern$, args(4)
    ELSE
        PRINT "Unknown draw command: "; c$
        END
    END IF
WEND

END SUB

FUNCTION formatratio$ (a%, b%)
' e.g. formatratio$(2, 5) = "2/5"
DEFINT A-Z

formatratio$ = LTRIM$(STR$(a%)) + "/" + LTRIM$(STR$(b%))

END FUNCTION

FUNCTION getchoice$ (choices$)
' wait until user presses one of the specified keys;
' choices$ must be in UPPER CASE
DEFINT A-Z

DO: LOOP UNTIL INKEY$ = ""
DO
    k$ = UCASE$(INPUT$(1))
LOOP UNTIL INSTR(choices$, k$)
getchoice$ = k$

END FUNCTION

SUB printbottomtext (text$)
' print a string on lines 24-25
DEFINT A-Z

FOR i = 0 TO 1
    LOCATE 24 + i, 1: PRINT SPACE$(40);
    LOCATE 24 + i, 1: PRINT MID$(text$, i * 40 + 1, 40);
NEXT

END SUB

SUB printcentered (text$, y%)
' print centered text
DEFINT A-Z

LOCATE y%, (40 - LEN(text$)) \ 2 + 1
PRINT text$

END SUB

SUB printgradtext (text$, y%)
' print centered gradient text
DEFINT A-Z

' center text
LOCATE y%, (40 - LEN(text$)) \ 2 + 1

colr = 9
FOR i = 1 TO LEN(text$)
    c$ = MID$(text$, i, 1)
    COLOR colr: PRINT c$;
    IF c$ <> " " THEN
        colr = colr + 1
        IF colr = 16 THEN colr = 9
    END IF
NEXT

COLOR 7: PRINT
END SUB

SUB readflagdata
' read flag data
DEFINT A-Z

PRINT "Reading flag data..."

flagcount = 0
DO
    READ item$  ' name or final terminator
    IF item$ = "-" THEN EXIT DO
    IF flagcount = MAXFLAGS THEN PRINT "Please increase MAXFLAGS.": END
    names$(flagcount) = item$
    drawcom$ = ""
    DO
        READ item$  ' Command, Argument or Flag Terminator
        IF item$ = "-" THEN EXIT DO
        IF LEFT$(item$, 1) >= "A" AND LEFT$(item$, 1) <= "Z" THEN
            drawcom$ = drawcom$ + item$
        ELSE
            drawcom$ = drawcom$ + MKI$(CINT(VAL(item$)))
        END IF
    LOOP
    drawcommands$(flagcount) = drawcom$
    flagcount = flagcount + 1
LOOP

END SUB

FUNCTION runround% (correct%)
' Run one round of the quiz. Return 1 if correct, 0 if incorrect.
' correct%: correct answer (index to names$, drawcommands$)
DEFINT A-Z
DIM choices(CHOICECNT - 1)  ' indexes to names$ and drawcommands$

CLS
CALL drawflag(drawcommands$(correct))

' randomise choices (all different, must contain correct answer)
DO
    hascorrect = 0
    FOR i = 0 TO CHOICECNT - 1
        DO
            choices(i) = INT(RND * flagcount)
            inuse = 0
            FOR j = 0 TO i - 1
                IF choices(j) = choices(i) THEN inuse = 1: EXIT FOR
            NEXT
        LOOP WHILE inuse
        IF choices(i) = correct THEN hascorrect = 1
    NEXT
LOOP UNTIL hascorrect

' print question
quest$ = ""
FOR i = 0 TO CHOICECNT - 1
    quest$ = quest$ + LTRIM$(STR$(i + 1)) + "=" + names$(choices(i)) + ", "
NEXT
quest$ = quest$ + "Q=quit?"
CALL printbottomtext(quest$)

choice$ = getchoice$(LEFT$("123456789", CHOICECNT) + "Q")

' react to choice
IF choice$ = "Q" THEN
    SCREEN 0: END
ELSEIF choices(VAL(choice$) - 1) = correct THEN
    CALL printbottomtext("Correct. Press any key to continue.")
    runround% = 1
ELSE
    s$ = "No, that was the " + names$(correct) + " flag. Press any key to "
    s$ = s$ + "continue."
    CALL printbottomtext(s$)
    runround% = 0
END IF

DO: LOOP UNTIL INKEY$ = ""
k$ = INPUT$(1)

END FUNCTION

SUB titlescreen
' print title screen
DEFINT A-Z

CALL printgradtext("EGA Pride", 3)
CALL printcentered("by qalle (aka 0x10f)", 5)
CALL printcentered("version: Jul 2024", 7)
s$ = "Try to guess " + LTRIM$(STR$(ROUNDCNT)) + " pride flags out of "
s$ = s$ + LTRIM$(STR$(flagcount)) + "."
CALL printcentered(s$, 9)
s$ = "You have " + LTRIM$(STR$(CHOICECNT)) + " choices for each."
CALL printcentered(s$, 10)
CALL printcentered("Space = new game", 12)
CALL printcentered("    Q = quit    ", 13)

END SUB

