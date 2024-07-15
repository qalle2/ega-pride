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

CONST MAXFLAGS = 30  ' maximum number of flags
CONST CHOICECNT = 3  ' number of choices
CONST ROUNDCNT = 10  ' how many rounds
CONST DEBUGMODE = 0  ' just show the first flag and quit
CONST PI = 3.141593

DIM SHARED names$(MAXFLAGS - 1)         ' names of flags
DIM SHARED drawcommands$(MAXFLAGS - 1)  ' commands for drawing flags
DIM SHARED flagcount                    ' how many flags

DIM corranswers(ROUNDCNT - 1)  ' correct answers

' Flag data (name followed by draw commands).
' Try to minimise overdraw.
' Commands and arguments (see drawflag sub for details):
'   HRyhc    = filled   Horizontal Rectangle (full width)
'   DHyhc    = Dithered Horizontal rectangle (full width, transparent)
'   RExwyhc  = filled   arbitrary  REctangle
'   DRxwyhc  = Dithered arbitrary  Rectangle (transparent)
'   LIxyxyc  = LIne
'   CLxyc    = Continue Line
'   CIxyrc   = CIrcle
'   ARxyrcaa = ARc (aa: start angle, end angle)
'   FIxycc   = flood FIll (cc: fill color, color to stop at)
'   DFxy     = Dithered light red/yellow flood Fill, stop at white
' Terminators:
'   "-" as command = end this flag's data
'   "-" as name    = end all flag data
' Note: preprocessing removes spaces from commands.
DATA abrosexual
DATA HR 000 036 002
DATA HR 036 036 010
DATA HR 072 036 015
DATA HR 108 036 012
DATA HR 144 036 004
DATA -
DATA agender
DATA HR 000 026 000
DATA HR 026 026 007
DATA HR 052 026 015
DATA HR 078 026 010
DATA HR 104 026 015
DATA HR 130 026 007
DATA HR 156 026 000
DATA -
DATA aromantic
DATA HR 000 036 002
DATA HR 036 036 010
DATA HR 072 036 015
DATA HR 108 036 007
DATA HR 144 036 000
DATA -
DATA aromanticasexual
DATA HR 000 072 014
DATA DH 000 036 012
DATA HR 072 036 015
DATA HR 108 036 009
DATA DH 108 036 011
DATA HR 144 036 001
DATA DH 144 036 003
DATA -
DATA asexual
DATA HR 000 045 000
DATA HR 045 045 007
DATA HR 090 045 015
DATA HR 135 045 005
DATA -
DATA autism
DATA HR 000 179 012
DATA DH 000 179 014
' arcs and lines between them
DATA AR 106 090 020 015 045 315
DATA AR 106 090 040 015 045 315
DATA AR 213 090 020 015 225 135
DATA AR 213 090 040 015 225 135
DATA LI 116 105 195 061 015
DATA LI 126 119 205 075 015
DATA LI 116 075 195 119 015
DATA LI 126 061 205 105 015
' split circles with vertical lines
DATA LI 106 058 106 072 015
DATA LI 106 108 106 122 015
DATA LI 213 058 213 072 015
DATA LI 213 108 213 122 015
' fill band from left to right
DATA FI 085 090 013 015
DATA FI 107 070 012 015
DATA FI 107 110 009 015
DATA FI 159 090 011 015
DATA FI 212 070 011 015
DATA FI 212 110 014 015
DATA FI 234 090 010 015
' undo vertical lines
DATA LI 106 058 106 072 013
DATA LI 106 108 106 122 013
DATA LI 213 058 213 072 011
DATA LI 213 108 213 122 014
' undo diagonal lines on blue part of band
DATA LI 143 090 159 099 011
DATA LI 160 080 178 090 011
DATA -
DATA bigender
DATA HR 000 052 013
DATA HR 052 026 009
DATA DH 000 026 007
DATA DH 026 052 015
DATA HR 078 026 015
DATA HR 104 052 015
DATA HR 156 026 009
DATA DH 104 026 009
DATA DH 130 052 011
DATA -
DATA bisexual
DATA HR 000 072 004
DATA DH 000 072 005
DATA HR 072 036 008
DATA DH 072 036 013
DATA HR 108 072 009
DATA -
DATA demiboy
DATA HR 000 026 008
DATA HR 026 026 007
DATA HR 052 078 015
DATA DH 052 026 011
DATA DH 104 026 011
DATA HR 130 026 007
DATA HR 156 026 008
DATA -
DATA demigirl
DATA HR 000 026 008
DATA HR 026 026 007
DATA HR 052 078 015
DATA DH 052 026 012
DATA DH 104 026 012
DATA HR 130 026 007
DATA HR 156 026 008
DATA -
DATA demiromantic
DATA HR 000 075 015
DATA HR 075 030 002
DATA HR 105 075 007
DATA LI 000 000 137 090 000
DATA CL 000 179 000
DATA FI 000 090 000 000
DATA -
DATA demisexual
DATA HR 000 075 015
DATA HR 075 030 005
DATA HR 105 075 007
DATA LI 000 000 137 090 000
DATA CL 000 179 000
DATA FI 000 090 000 000
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
DATA genderfluid
DATA HR 000 036 012
DATA HR 036 036 015
DATA HR 072 036 013
DATA HR 108 036 000
DATA DH 108 036 008
DATA HR 144 036 009
DATA -
DATA genderqueer
DATA HR 000 060 013
DATA DH 000 060 009
DATA HR 060 060 015
DATA HR 120 060 002
DATA -
DATA intersex
DATA HR 000 180 014
DATA CI 160 090 061 005
DATA CI 160 090 045 005
DATA FI 160 045 005 005
DATA -
DATA lesbian
DATA HR 000 036 004
DATA HR 036 036 012
DATA DH 036 036 014
DATA HR 072 036 015
DATA HR 108 036 007
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
' white (2 lines)
DATA LI 072 000 144 060 015
DATA CL 000 179 015
DATA FI 000 000 015 015
' heart (2 arcs, 2 lines)
DATA AR 050 045 023 012 000 270
DATA AR 050 075 023 012 090 359
DATA LI 062 028 103 060 012
DATA CL 062 092 012
DATA FI 100 060 012 012
DATA DF 100 060
DATA -
DATA polysexual
DATA HR 000 060 013
DATA HR 060 060 010
DATA HR 120 060 009
DATA DH 120 060 011
DATA -
DATA queer
DATA HR 000 020 000
DATA HR 020 040 011
DATA DH 020 020 015
DATA DH 040 020 009
DATA HR 060 020 010
DATA DH 060 020 014
DATA HR 080 020 015
DATA HR 100 020 012
DATA DH 100 020 014
DATA HR 120 020 012
DATA HR 140 020 012
DATA DH 140 020 015
DATA HR 160 020 000
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
DATA rainbowprogress
' horizontal stripes
DATA RE 054 266 000 030 012
DATA RE 081 239 030 030 012
DATA DR 081 239 030 030 014
DATA RE 108 212 060 030 014
DATA RE 108 212 090 030 010
DATA RE 081 239 120 030 009
DATA RE 054 266 150 030 013
' chevrons are 27 px wide and 23 px tall
' white triangle
DATA LI 000 045 054 090 015
DATA CL 000 135 015
DATA FI 053 090 015 015
' pink chevron
DATA LI 000 045 054 090 013
DATA CL 000 135 013
DATA LI 000 022 081 090 013
DATA CL 000 158 013
DATA FI 080 090 013 013
' blue chevron
DATA LI 000 022 081 090 011
DATA CL 000 158 011
DATA LI 000 000 108 090 011
DATA CL 000 179 011
DATA FI 107 090 011 011
' brown chevron
DATA LI 000 000 108 090 006
DATA CL 000 179 006
DATA LI 027 000 135 090 006
DATA CL 027 179 006
DATA CL 000 179 006
DATA FI 134 090 006 006
' black chevron
DATA LI 027 000 135 090 000
DATA CL 027 179 000
DATA LI 054 000 162 090 000
DATA CL 054 179 000
DATA FI 161 090 000 000
DATA -
DATA rainbowprogressintersex
' horizontal stripes
DATA RE 054 266 000 030 012
DATA RE 081 239 030 030 012
DATA DR 081 239 030 030 014
DATA RE 108 212 060 030 014
DATA RE 108 212 090 030 010
DATA RE 081 239 120 030 009
DATA RE 054 266 150 030 013
' chevrons are 22 px wide and 18 px tall
' yellow triangle
DATA LI 000 018 080 090 014
DATA CL 000 162 014
DATA FI 079 090 014 014
' white chevron
DATA LI 000 018 080 090 015
DATA CL 000 162 015
DATA LI 000 000 102 090 015
DATA CL 000 179 015
DATA FI 101 090 015 015
' pink chevron
DATA LI 000 000 102 090 013
DATA CL 000 179 013
DATA LI 022 000 124 090 013
DATA CL 022 179 013
DATA CL 000 179 013
DATA FI 123 090 013 013
' cyan chevron
DATA LI 022 000 124 090 011
DATA CL 022 179 011
DATA LI 044 000 146 090 011
DATA CL 044 179 011
DATA CL 022 179 011
DATA FI 145 090 011 011
' brown chevron
DATA LI 044 000 146 090 006
DATA CL 044 179 006
DATA LI 066 000 168 090 006
DATA CL 066 179 006
DATA CL 044 179 006
DATA FI 167 090 006 006
' black chevron
DATA LI 066 000 168 090 000
DATA CL 066 179 000
DATA LI 088 000 190 090 000
DATA CL 088 179 000
DATA FI 169 090 000 000
' circle
DATA CI 030 090 019 005
DATA CI 030 090 024 005
DATA FI 050 090 005 005
DATA -
DATA transgender
DATA HR 000 036 011
DATA HR 036 108 015
DATA DH 036 036 012
DATA DH 108 036 012
DATA HR 144 036 011
DATA -
DATA -

RANDOMIZE TIMER

CALL readflagdata

IF CHOICECNT > flagcount THEN PRINT "Too many choices.": END
IF ROUNDCNT > flagcount THEN PRINT "Too many rounds.": END

highscore = 0

SCREEN 7

IF DEBUGMODE THEN CALL drawflag(drawcommands$(0)): END

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
'   HRyhc    = filled   Horizontal Rectangle (full width)
'   DHyhc    = Dithered Horizontal rectangle (full width, transparent)
'   RExwyhc  = filled   arbitrary  REctangle
'   DRxwyhc  = Dithered arbitrary  Rectangle (transparent)
'   LIxyxyc  = LIne
'   CLxyc    = Continue Line
'   CIxyrc   = CIrcle
'   ARxyrcaa = ARc (aa: start angle, end angle)
'   FIxycc   = flood FIll (cc: fill color, color to stop at)
'   DFxy     = Dithered light red/yellow flood Fill, stop at white
' Arguments:
'   x, y = X position, Y position
'   w, h = Width, Height
'   r    = Radius
'   c    = Color
'   a    = angle (degrees CCW from right)
' Note: flag width is always 320.

DEFINT A-Z
DIM args(5)  ' Arguments

dci = 1
WHILE dci < LEN(drawcommands$)
    ' Command
    c$ = MID$(drawcommands$, dci, 2)
    dci = dci + 2

    ' number of Arguments
    SELECT CASE c$
        CASE "DF": argc = 2
        CASE "HR", "DH", "CL": argc = 3
        CASE "CI", "FI": argc = 4
        CASE "RE", "DR", "LI": argc = 5
        CASE "AR": argc = 6
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
    ELSEIF c$ = "LI" THEN
        LINE (args(0), args(1))-(args(2), args(3)), args(4)
    ELSEIF c$ = "CL" THEN
        LINE -(args(0), args(1)), args(2)
    ELSEIF c$ = "CI" THEN
        CIRCLE (args(0), args(1)), args(2), args(3)
    ELSEIF c$ = "AR" THEN
        a1! = args(4) * PI / 180
        a2! = args(5) * PI / 180
        CIRCLE (args(0), args(1)), args(2), args(3), a1!, a2!
    ELSEIF c$ = "FI" THEN
        PAINT (args(0), args(1)), args(2), args(3)
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

