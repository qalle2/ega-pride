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

CONST MAXFLAGS = 20  ' maximum number of flags
CONST CHOICECNT = 3  ' number of choices
CONST ROUNDCNT = 10  ' how many rounds

DIM SHARED names$(MAXFLAGS - 1)         ' names of flags
DIM SHARED drawcommands$(MAXFLAGS - 1)  ' commands for drawing flags
DIM SHARED flagcount                    ' how many flags

DIM corranswers(ROUNDCNT - 1)  ' correct answers

' Flag data (name followed by draw commands).
' Commands and arguments (see drawflag sub for details):
'   HRyhc     = filled   Horizontal Rectangle (full width)
'   DHyhc     = Dithered Horizontal rectangle (full width, transparent)
'   RExwyhc   = filled   arbitrary  REctangle
'   DRxwyhc   = Dithered arbitrary  Rectangle (transparent)
'   TRxyxyxyc = TRiangle
'   CIxyrc    = CIrcle
'   FIxyc     = flood FIll, stop at fill color
'   DFxy      = Dithered light red/yellow flood Fill, stop at white
' Terminators:
'   "-" as command = end this flag's data
'   "-" as name    = end all flag data
' Note: preprocessing removes spaces from commands.
DATA aromantic
DATA HR 000 036 002
DATA HR 036 036 010
DATA HR 072 036 015
DATA HR 108 036 007
DATA HR 144 036 000
DATA -
DATA asexual
DATA HR 000 045 000
DATA HR 045 045 008
DATA HR 090 045 015
DATA HR 135 045 005
DATA -
DATA bisexual
DATA HR 000 072 004
DATA DH 000 072 005
DATA HR 072 036 008
DATA DH 072 036 013
DATA HR 108 072 009
DATA -
DATA demisexual
DATA HR 000 075 015
DATA HR 075 030 005
DATA HR 105 075 007
DATA TR 000 000 120 090 000 179 000
DATA FI 001 090 000
DATA -
DATA gay men
DATA HR 000 036 002
DATA HR 036 036 010
DATA HR 072 036 015
DATA HR 108 036 009
DATA DH 108 036 011
DATA HR 144 036 001
DATA DH 144 036 005
DATA -
DATA intersex
DATA HR 000 180 014
DATA CI 160 090 061 005
DATA CI 160 090 045 005
DATA FI 160 045 005
DATA -
DATA lesbian
DATA HR 000 036 004
DATA HR 036 036 012
DATA DH 036 036 014
DATA HR 072 036 015
DATA HR 108 036 008
DATA DH 108 036 013
DATA HR 144 036 005
DATA -
DATA nonbinary
DATA HR 000 045 014
DATA HR 045 045 015
DATA HR 090 045 009
DATA DH 090 045 013
DATA HR 135 045 000
DATA DH 135 045 008
DATA -
DATA omnisexual
DATA HR 000 036 012
DATA DH 000 036 015
DATA HR 036 036 012
DATA HR 072 036 000
DATA DH 072 036 005
DATA HR 108 036 009
DATA HR 144 036 009
DATA DH 144 036 015
DATA -
DATA pansexual
DATA HR 000 060 012
DATA HR 060 060 014
DATA HR 120 060 011
DATA -
DATA polyamory
' horizontal stripes (3 rectangles)
DATA RE 072 248 000 060 009
DATA DR 072 248 000 060 011
DATA RE 072 248 060 060 012
DATA HR 120 060 000
DATA DH 120 060 005
' white (1 rectangle, 2 triangles)
DATA RE 000 072 000 120 015
DATA TR 072 000 144 060 072 119 015
DATA FI 073 060 015
DATA TR 000 120 072 120 000 179 015
DATA FI 001 121 015
' heart (2 circles, 1 triangle)
DATA CI 050 045 023 012
DATA FI 050 045 012
DATA CI 050 075 023 012
DATA FI 050 075 012
DATA TR 062 028 103 060 062 092 012
DATA FI 100 060 012
DATA DF 100 060
DATA -
DATA polysexual
DATA HR 000 060 013
DATA HR 060 060 010
DATA HR 120 060 009
DATA DH 120 060 011
DATA -
DATA rainbow
DATA HR 000 030 012
DATA HR 030 030 012
DATA DH 030 030 014
DATA HR 060 030 014
DATA HR 090 030 002
DATA HR 120 030 009
DATA HR 150 030 005
DATA -
DATA transgender
DATA HR 000 036 011
DATA HR 036 036 013
DATA HR 072 036 015
DATA HR 108 036 013
DATA HR 144 036 011
DATA -
DATA -

RANDOMIZE TIMER

CALL readflagdata

IF CHOICECNT > flagcount THEN PRINT "Too many choices.": END
IF ROUNDCNT > flagcount THEN PRINT "Too many rounds.": END

highscore = 0

SCREEN 7

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
'       Command   = "AA"-"ZZ", in UPPER CASE
'       Argument  = "000"-"999"; count depends on Command
' Commands and their Arguments:
'   HRyhc     = filled   Horizontal Rectangle (full width)
'   DHyhc     = Dithered Horizontal rectangle (full width, transparent)
'   RExwyhc   = filled   arbitrary  REctangle
'   DRxwyhc   = Dithered arbitrary  Rectangle (transparent)
'   TRxyxyxyc = TRiangle
'   CIxyrc    = CIrcle
'   FIxyc     = flood FIll, stop at fill color
'   DFxy      = Dithered light red/yellow flood Fill, stop at white
' Arguments:
'   x, y = X position, Y position
'   w, h = Width, Height
'   r    = Radius
'   c    = Color
' Note: flag width is always 320.

DEFINT A-Z
DIM args(6)  ' Arguments

dci = 1
WHILE dci < LEN(drawcommands$)
    ' Command
    c$ = MID$(drawcommands$, dci, 2)
    dci = dci + 2

    ' number of Arguments
    SELECT CASE c$
        CASE "DF": argc = 2
        CASE "HR", "DH", "FI": argc = 3
        CASE "CI": argc = 4
        CASE "RE", "DR": argc = 5
        CASE "TR": argc = 7
        CASE ELSE: PRINT "Unknown draw command: "; c$: END
    END SELECT

    ' Arguments
    FOR j = 0 TO argc - 1
        args(j) = VAL(MID$(drawcommands$, dci, 3))
        dci = dci + 3
    NEXT

    ' execute Command
    IF c$ = "HR" THEN
        LINE (0, args(0))-(319, args(0) + args(1) - 1), args(2), BF
    ELSEIF c$ = "DH" THEN
        FOR y = args(0) TO args(0) + args(1) - 1
            IF (y AND 1) THEN pattern = &H5555 ELSE pattern = &HAAAA
            LINE (0, y)-(319, y), args(2), , pattern
        NEXT
    ELSEIF c$ = "RE" THEN
        x2 = args(0) + args(1) - 1
        y2 = args(2) + args(3) - 1
        LINE (args(0), args(2))-(x2, y2), args(4), BF
    ELSEIF c$ = "DR" THEN
        x2 = args(0) + args(1) - 1
        FOR y = args(2) TO args(2) + args(3) - 1
            IF (y AND 1) THEN pattern = &H5555 ELSE pattern = &HAAAA
            LINE (args(0), y)-(x2, y), args(4), , pattern
        NEXT
    ELSEIF c$ = "TR" THEN
        LINE (args(0), args(1))-(args(2), args(3)), args(6)
        LINE -(args(4), args(5)), args(6)
        LINE -(args(0), args(1)), args(6)
    ELSEIF c$ = "CI" THEN
        CIRCLE (args(0), args(1)), args(2), args(3)
    ELSEIF c$ = "FI" THEN
        PAINT (args(0), args(1)), args(2)
    ELSEIF c$ = "DF" THEN
        ' pattern (r = light red = &HC, y = yellow = &HE)
        '   ryryryry
        '   yryryryr
        ' byte = 8*1 px of one bitplane
        pattern$ = CHR$(0) + CHR$(&H55) + CHR$(255) + CHR$(255)
        pattern$ = pattern$ + CHR$(0) + CHR$(&HAA) + CHR$(255) + CHR$(255)
        PAINT (args(0), args(1)), pattern$, 15
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
' wait until user presses one of the specified keys (must be in UPPER CASE)
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

flagcount = 0
DO
    READ item$  ' name or final terminator
    IF item$ = "-" THEN EXIT DO
    names$(flagcount) = item$
    drawcom$ = ""
    DO
        READ item$  ' command or flag terminator
        IF item$ = "-" THEN EXIT DO
        drawcom$ = drawcom$ + item$
    LOOP
    drawcommands$(flagcount) = UCASE$(deletespaces$(drawcom$))
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

