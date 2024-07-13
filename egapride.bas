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
CONST ROUNDCNT = 3   ' how many rounds

DIM SHARED names$(MAXFLAGS - 1)         ' names of flags
DIM SHARED drawcommands$(MAXFLAGS - 1)  ' commands for drawing flags
DIM SHARED flagcount                    ' how many flags

DIM corranswers(ROUNDCNT - 1)  ' correct answers

' Flag data (name followed by draw commands).
' Commands and arguments (see drawflag sub for details):
'   FH h         = set Flag Height
'   HR y h c     = Horizontal Rectangle
'   DH y h c     = Dithered Horizontal rectangle
'   VR x w c     = Vertical Rectangle
'   RE x w y h c = REctangle
'   CC r c       = Centered Circle
' Terminators:
'   "-" as command = end this flag's data
'   "-" as name    = end all flag data
' Note: preprocessing removes spaces from commands.
DATA aromantic, FH 160
DATA HR 000 032 002
DATA HR 032 032 010
DATA HR 064 032 015
DATA HR 096 032 007
DATA HR 128 032 000
DATA -
DATA asexual, FH 160
DATA HR 000 040 000
DATA HR 040 040 008
DATA HR 080 040 015
DATA HR 120 040 005
DATA -
DATA bisexual, FH 160
DATA HR 000 064 004
DATA DH 000 064 005
DATA HR 064 032 008
DATA DH 064 032 013
DATA HR 096 064 009
DATA -
DATA intersex, FH 178
DATA HR 000 177 014
DATA CC 061 005
DATA CC 044 014
DATA -
DATA lesbian, FH 150
DATA HR 000 030 004
DATA HR 030 030 012
DATA DH 030 030 014
DATA HR 060 030 015
DATA HR 090 030 008
DATA DH 090 030 013
DATA HR 120 030 005
DATA -
DATA nonbinary, FH 180
DATA HR 000 045 014
DATA HR 045 045 015
DATA HR 090 045 009
DATA DH 090 045 013
DATA HR 135 045 000
DATA DH 135 045 008
DATA -
DATA pansexual, FH 159
DATA HR 000 053 012
DATA HR 053 053 014
DATA HR 106 053 011
DATA -
DATA rainbow, FH 162
DATA HR 000 027 012
DATA HR 027 027 012
DATA DH 027 027 014
DATA HR 054 027 014
DATA HR 081 027 002
DATA HR 108 027 009
DATA HR 135 027 005
DATA -
DATA transgender, FH 160
DATA HR 000 032 011
DATA HR 032 032 013
DATA HR 064 032 015
DATA HR 096 032 013
DATA HR 128 032 011
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

DO
    ' main loop

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
    DO: k$ = UCASE$(INPUT$(1)): LOOP UNTIL k$ = " " OR k$ = "Q"
    IF k$ = "Q" THEN EXIT DO
LOOP

SCREEN 0

DEFSNG A-Z
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

DEFSNG A-Z
SUB drawflag (drawcommands$)
' Draw a flag by Draw Commands.
'   Draw Commands = a string with zero or more Blocks
'     Block       = a Command followed by zero or more Arguments
'       Command   = "AA"-"ZZ", in UPPER CASE
'       Argument  = "000"-"999"; count depends on Command
' Commands and their Arguments:
'   FHh     = set Flag Height
'   HRyhc   = Horizontal Rectangle (full width)
'   DHyhc   = Dithered Horizontal rectangle (full width)
'   VRxwc   = Vertical Rectangle (full height)
'   RExwyhc = REctangle
'   CCrc    = Centered Circle
' Arguments:
'   x, y = X position, Y position
'   w, h = Width, Height
'   r    = Radius
'   c    = Color
' Notes:
'   - flag width is always 320
'   - all shapes are filled (may not work if background isn't one-color)

DEFINT A-Z
DIM args(4)  ' Arguments

fw = 320: fh = 200  ' default flag size

i = 1
WHILE i < LEN(drawcommands$)
    ' Command
    c$ = MID$(drawcommands$, i, 2)
    i = i + 2

    ' number of Arguments
    SELECT CASE c$
        CASE "FH": argc = 1
        CASE "CC": argc = 2
        CASE "HR", "DH", "VR": argc = 3
        CASE "RE": argc = 5
        CASE ELSE: PRINT "Unknown draw command: "; c$: END
    END SELECT

    ' Arguments
    FOR j = 0 TO argc - 1
        args(j) = VAL(MID$(drawcommands$, i, 3))
        i = i + 3
    NEXT

    ' execute Command
    IF c$ = "FH" THEN
        fh = args(0)
    ELSEIF c$ = "HR" THEN
        LINE (0, args(0))-(fw - 1, args(0) + args(1) - 1), args(2), BF
    ELSEIF c$ = "DH" THEN
        FOR y = args(0) TO args(0) + args(1) - 1 STEP 2
            LINE (0, y)-(fw, y), args(2), , &H5555
            LINE (0, y + 1)-(fw, y + 1), args(2), , &HAAAA
        NEXT
    ELSEIF c$ = "VR" THEN
        LINE (args(0), 0)-(args(0) + args(1) - 1, fh - 1), args(2), BF
    ELSEIF c$ = "RE" THEN
        x2 = args(0) + args(1) - 1
        y2 = args(2) + args(3) - 1
        LINE (args(0), x2)-(args(2), y2), args(4), BF
    ELSEIF c$ = "CC" THEN
        CIRCLE (fw \ 2, fh \ 2), args(0), args(1)
        PAINT (fw \ 2, fh \ 2), args(1)
    ELSE
        PRINT "Unknown draw command: "; c$
        END
    END IF
WEND

END SUB

DEFSNG A-Z
FUNCTION formatratio$ (a%, b%)
' e.g. formatratio$(2, 5) = "2/5"
DEFINT A-Z

formatratio$ = LTRIM$(STR$(a%)) + "/" + LTRIM$(STR$(b%))

END FUNCTION

DEFSNG A-Z
FUNCTION getchoice$ (choices$)
' wait until user presses one of the specified keys (must be in UPPER CASE)
DEFINT A-Z

DO
    k$ = UCASE$(INPUT$(1))
LOOP UNTIL INSTR(choices$, k$)
getchoice$ = k$

END FUNCTION

DEFSNG A-Z
SUB printbottomtext (text$)
' print a string on lines 24-25
DEFINT A-Z

FOR i = 0 TO 1
    LOCATE 24 + i, 1: PRINT SPACE$(40);
    LOCATE 24 + i, 1: PRINT MID$(text$, i * 40 + 1, 40);
NEXT

END SUB

DEFSNG A-Z
SUB printcentered (text$, y%)
' print centered text
DEFINT A-Z

LOCATE y%, (40 - LEN(text$)) \ 2 + 1
PRINT text$

END SUB

DEFSNG A-Z
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

DEFSNG A-Z
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

DEFSNG A-Z
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

' ask for choice
validchoices$ = LEFT$("123456789", CHOICECNT) + "Q"
DO
    choice$ = UCASE$(INPUT$(1))
LOOP UNTIL INSTR(validchoices$, choice$)

' react to choice
IF choice$ = "Q" THEN
    SCREEN 0: END
ELSEIF choices(VAL(choice$) - 1) = correct THEN
    CALL printbottomtext("Correct. Press any key for the next flag.")
    runround% = 1
ELSE
    s$ = "No, that was the " + names$(correct) + " flag. Press any key for "
    s$ = s$ + "the next flag."
    CALL printbottomtext(s$)
    runround% = 0
END IF

k$ = INPUT$(1)

END FUNCTION

DEFSNG A-Z
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

