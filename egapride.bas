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
'   HREyhc    = Horizontal REctangle (filled, full width)
'   DHRyhc    = Dithered Horizontal Rectangle (full width, transparent)
'   RECxwyhc  = RECtangle (filled)
'   DRExwyhc  = Dithered REctangle (transparent)
'   LINxyxyc  = LINe
'   CLIxyc    = Continue LIne
'   CIRxyrc   = CIRcle
'   ARCxyrcaa = ARC (aa: start angle, end angle)
'   FILxycc   = FILl (cc: fill color, color to stop at)
'   DFIxyccc  = Dithered FIll (ccc: fill color 1/2, color to stop at)
' Terminators:
'   "-" as command = end this flag's data
'   "-" as name    = end all flag data
' Note: preprocessing removes spaces from commands.
DATA abrosexual
DATA HRE 000 036 002
DATA HRE 036 036 010
DATA HRE 072 036 015
DATA HRE 108 036 012
DATA HRE 144 036 004
DATA -
DATA agender
DATA HRE 000 026 000
DATA HRE 026 026 007
DATA HRE 052 026 015
DATA HRE 078 026 010
DATA HRE 104 026 015
DATA HRE 130 026 007
DATA HRE 156 026 000
DATA -
DATA aromantic
DATA HRE 000 036 002
DATA HRE 036 036 010
DATA HRE 072 036 015
DATA HRE 108 036 007
DATA HRE 144 036 000
DATA -
DATA aromantic asexual
DATA HRE 000 072 014
DATA DHR 000 036 012
DATA HRE 072 036 015
DATA HRE 108 036 009
DATA DHR 108 036 011
DATA HRE 144 036 001
DATA DHR 144 036 003
DATA -
DATA asexual
DATA HRE 000 045 000
DATA HRE 045 045 007
DATA HRE 090 045 015
DATA HRE 135 045 005
DATA -
DATA autism
DATA HRE 000 179 012
DATA DHR 000 179 014
' arcs and lines between them
DATA ARC 106 090 020 015 045 315
DATA ARC 106 090 040 015 045 315
DATA ARC 213 090 020 015 225 135
DATA ARC 213 090 040 015 225 135
DATA LIN 116 105 195 061 015
DATA LIN 126 119 205 075 015
DATA LIN 116 075 195 119 015
DATA LIN 126 061 205 105 015
' split circles with vertical lines
DATA LIN 106 058 106 072 015
DATA LIN 106 108 106 122 015
DATA LIN 213 058 213 072 015
DATA LIN 213 108 213 122 015
' fill band from left to right
DATA FIL 085 090 013 015
DATA FIL 107 070 012 015
DATA FIL 107 110 009 015
DATA FIL 159 090 011 015
DATA FIL 212 070 011 015
DATA FIL 212 110 014 015
DATA FIL 234 090 010 015
' undo vertical lines
DATA LIN 106 058 106 072 013
DATA LIN 106 108 106 122 013
DATA LIN 213 058 213 072 011
DATA LIN 213 108 213 122 014
' undo diagonal lines on blue part of band
DATA LIN 143 090 159 099 011
DATA LIN 160 080 178 090 011
DATA -
DATA bear
' stripes
DATA HRE 000 026 006
DATA HRE 026 078 014
DATA DHR 026 026 012
DATA DHR 078 026 015
DATA HRE 104 026 015
DATA HRE 130 026 008
DATA HRE 156 026 000
' pawprint - largest part
DATA LIN 059 033 076 033 000
DATA CLI 096 043 000
DATA CLI 106 043 000
DATA CLI 118 037 000
DATA CLI 125 037 000
DATA CLI 131 043 000
DATA CLI 131 046 000
DATA CLI 121 056 000
DATA CLI 091 071 000
DATA CLI 071 091 000
DATA CLI 063 091 000
DATA CLI 060 088 000
DATA CLI 060 060 000
DATA CLI 048 048 000
DATA CLI 048 044 000
DATA CLI 059 033 000
DATA FIL 060 034 000 000
' pawprint - 1st small part from left
DATA LIN 031 073 042 073 000
DATA CLI 052 078 000
DATA CLI 052 087 000
DATA CLI 050 089 000
DATA CLI 046 089 000
DATA CLI 038 085 000
DATA CLI 031 078 000
DATA CLI 031 073 000
DATA FIL 032 074 000 000
' pawprint - 2nd small part from left
DATA LIN 027 049 034 049 000
DATA CLI 050 057 000
DATA CLI 050 064 000
DATA CLI 047 067 000
DATA CLI 037 067 000
DATA CLI 027 057 000
DATA CLI 027 049 000
DATA FIL 028 050 000 000
' pawprint - 3rd small part from left
DATA LIN 026 023 037 023 000
DATA CLI 051 030 000
DATA CLI 051 036 000
DATA CLI 045 042 000
DATA CLI 042 042 000
DATA CLI 034 038 000
DATA CLI 026 030 000
DATA CLI 026 023 000
DATA FIL 027 024 000 000
' pawprint - 4th small part from left
DATA LIN 048 013 068 013 000
DATA CLI 076 017 000
DATA CLI 076 025 000
DATA CLI 072 029 000
DATA CLI 065 029 000
DATA CLI 043 018 000
DATA CLI 048 013 000
DATA FIL 049 014 000 000
' pawprint - 5th small part from left
DATA LIN 085 019 095 019 000
DATA CLI 111 027 000
DATA CLI 111 035 000
DATA CLI 107 039 000
DATA CLI 101 039 000
DATA CLI 085 031 000
DATA CLI 085 019 000
DATA FIL 086 020 000 000
DATA -
DATA bigender
DATA HRE 000 052 013
DATA HRE 052 026 009
DATA DHR 000 026 007
DATA DHR 026 052 015
DATA HRE 078 026 015
DATA HRE 104 052 015
DATA HRE 156 026 009
DATA DHR 104 026 009
DATA DHR 130 052 011
DATA -
DATA bisexual
DATA HRE 000 072 004
DATA DHR 000 072 005
DATA HRE 072 036 008
DATA DHR 072 036 013
DATA HRE 108 072 009
DATA -
DATA demiboy
DATA HRE 000 026 008
DATA HRE 026 026 007
DATA HRE 052 078 015
DATA DHR 052 026 011
DATA DHR 104 026 011
DATA HRE 130 026 007
DATA HRE 156 026 008
DATA -
DATA demigirl
DATA HRE 000 026 008
DATA HRE 026 026 007
DATA HRE 052 078 015
DATA DHR 052 026 012
DATA DHR 104 026 012
DATA HRE 130 026 007
DATA HRE 156 026 008
DATA -
DATA demiromantic
DATA HRE 000 075 015
DATA HRE 075 030 002
DATA HRE 105 075 007
DATA LIN 000 000 137 090 000
DATA CLI 000 179 000
DATA FIL 000 090 000 000
DATA -
DATA demisexual
DATA HRE 000 075 015
DATA HRE 075 030 005
DATA HRE 105 075 007
DATA LIN 000 000 137 090 000
DATA CLI 000 179 000
DATA FIL 000 090 000 000
DATA -
DATA gay men
DATA HRE 000 036 002
DATA HRE 036 036 010
DATA HRE 072 036 015
DATA HRE 108 036 009
DATA DHR 108 036 011
DATA HRE 144 036 001
DATA DHR 144 036 005
DATA -
DATA genderfluid
DATA HRE 000 036 012
DATA HRE 036 036 015
DATA HRE 072 036 013
DATA HRE 108 036 000
DATA DHR 108 036 008
DATA HRE 144 036 009
DATA -
DATA genderqueer
DATA HRE 000 060 013
DATA DHR 000 060 009
DATA HRE 060 060 015
DATA HRE 120 060 002
DATA -
DATA intersex
DATA HRE 000 180 014
DATA CIR 160 090 061 005
DATA CIR 160 090 045 005
DATA FIL 160 045 005 005
DATA -
DATA leather
' stripes
DATA HRE 020 020 009
DATA HRE 060 020 009
DATA HRE 080 020 015
DATA HRE 100 020 009
DATA HRE 140 020 009
' heart
DATA ARC 086 024 024 004 330 200
DATA ARC 050 046 024 004 045 290
DATA LIN 110 024 106 075 004
DATA CLI 050 066 004
DATA FIL 105 074 004 004
DATA -
DATA lesbian
DATA HRE 000 036 004
DATA HRE 036 036 012
DATA DHR 036 036 014
DATA HRE 072 036 015
DATA HRE 108 036 007
DATA DHR 108 036 013
DATA HRE 144 036 005
DATA -
DATA non-binary
DATA HRE 000 045 014
DATA HRE 045 045 015
DATA HRE 090 045 009
DATA DHR 090 045 013
DATA HRE 135 045 000
DATA DHR 135 045 008
DATA -
DATA non-human unity
' stripes
DATA HRE 000 060 002
DATA HRE 060 060 015
DATA HRE 120 060 001
DATA DHR 120 060 005
' white circle
DATA CIR 160 095 073 015
DATA FIL 160 050 015 015
DATA FIL 160 125 015 015
' black circle
DATA CIR 160 095 043 000
DATA CIR 160 095 050 000
DATA FIL 204 095 000 000
' outer edges of heptagram, clockwise from top
DATA LIN 163 059 169 078 000
DATA CLI 191 069 000
DATA LIN 195 074 180 090 000
DATA CLI 203 100 000
DATA LIN 202 105 176 105 000
DATA CLI 183 126 000
DATA LIN 176 129 159 112 000
DATA CLI 143 129 000
DATA LIN 136 126 143 105 000
DATA CLI 117 105 000
DATA LIN 116 099 139 090 000
DATA CLI 123 074 000
DATA LIN 128 069 150 079 000
DATA CLI 156 058 000
' quadrilaterals around central heptagon, clockwise from top
DATA LIN 160 069 163 082 000
DATA CLI 160 084 000
DATA CLI 156 082 000
DATA CLI 159 069 000
DATA LIN 182 079 175 088 000
DATA CLI 171 087 000
DATA CLI 170 084 000
DATA CLI 182 079 000
DATA LIN 190 101 175 101 000
DATA CLI 174 098 000
DATA CLI 176 094 000
DATA CLI 190 101 000
DATA LIN 173 118 163 108 000
DATA CLI 165 105 000
DATA CLI 170 105 000
DATA CLI 173 118 000
DATA LIN 145 118 148 105 000
DATA CLI 153 105 000
DATA CLI 155 108 000
DATA CLI 145 118 000
DATA LIN 129 100 142 094 000
DATA CLI 145 097 000
DATA CLI 143 101 000
DATA CLI 129 100 000
DATA LIN 137 079 149 084 000
DATA CLI 147 087 000
DATA CLI 144 088 000
DATA CLI 137 080 000
' inner edges of heptagram (central heptagon)
DATA LIN 160 088 166 090 000
DATA CLI 167 096 000
DATA CLI 162 101 000
DATA CLI 156 101 000
DATA CLI 151 096 000
DATA CLI 153 090 000
DATA CLI 159 088 000
' fill heptagram
DATA FIL 160 060 000 000
' edges of triangle
DATA LIN 160 037 218 125 000
DATA CLI 101 125 000
DATA CLI 159 037 000
DATA LIN 160 046 208 121 000
DATA CLI 111 121 000
DATA CLI 159 046 000
' fill triangle, clockwise from top
DATA FIL 160 038 000 000
DATA FIL 175 065 000 000
DATA FIL 190 090 000 000
DATA FIL 217 124 000 000
DATA FIL 185 122 000 000
DATA FIL 160 124 000 000
DATA FIL 135 122 000 000
DATA FIL 103 124 000 000
DATA FIL 130 090 000 000
DATA FIL 145 065 000 000
DATA -
DATA omnisexual
DATA HRE 000 036 012
DATA DHR 000 036 015
DATA HRE 036 036 012
DATA HRE 072 036 000
DATA DHR 072 036 005
DATA HRE 108 036 009
DATA HRE 144 036 009
DATA DHR 144 036 015
DATA -
DATA pansexual
DATA HRE 000 060 012
DATA HRE 060 060 014
DATA HRE 120 060 011
DATA -
DATA polyamory
' horizontal stripes (3 rectangles)
DATA REC 072 248 000 060 009
DATA DRE 072 248 000 060 011
DATA REC 072 248 060 060 012
DATA HRE 120 060 000
DATA DHR 120 060 005
' white (2 lines)
DATA LIN 072 000 144 060 015
DATA CLI 000 179 015
DATA FIL 000 000 015 015
' heart (2 arcs, 2 lines)
DATA ARC 050 045 023 012 000 270
DATA ARC 050 075 023 012 090 359
DATA LIN 062 028 103 060 012
DATA CLI 062 092 012
DATA FIL 100 060 012 012
DATA DFI 100 060 012 014 015
DATA -
DATA polysexual
DATA HRE 000 060 013
DATA HRE 060 060 010
DATA HRE 120 060 009
DATA DHR 120 060 011
DATA -
DATA queer
DATA HRE 000 020 000
DATA HRE 020 040 011
DATA DHR 020 020 015
DATA DHR 040 020 009
DATA HRE 060 020 010
DATA DHR 060 020 014
DATA HRE 080 020 015
DATA HRE 100 020 012
DATA DHR 100 020 014
DATA HRE 120 020 012
DATA HRE 140 020 012
DATA DHR 140 020 015
DATA HRE 160 020 000
DATA -
DATA rainbow
DATA HRE 000 030 012
DATA HRE 030 030 012
DATA DHR 030 030 014
DATA HRE 060 030 014
DATA HRE 090 030 002
DATA HRE 120 030 009
DATA HRE 150 030 005
DATA -
DATA rainbow-progress
' horizontal stripes
DATA REC 054 266 000 030 012
DATA REC 081 239 030 030 012
DATA DRE 081 239 030 030 014
DATA REC 108 212 060 030 014
DATA REC 108 212 090 030 010
DATA REC 081 239 120 030 009
DATA REC 054 266 150 030 013
' chevrons are 27 px wide and 23 px tall
' white triangle
DATA LIN 000 045 054 090 015
DATA CLI 000 135 015
DATA FIL 053 090 015 015
' pink chevron
DATA LIN 000 022 081 090 015
DATA CLI 000 158 015
DATA DFI 080 090 012 015 015
' blue chevron
DATA LIN 000 022 081 090 011
DATA CLI 000 158 011
DATA LIN 000 000 108 090 011
DATA CLI 000 179 011
DATA FIL 107 090 011 011
' brown chevron
DATA LIN 000 000 108 090 006
DATA CLI 000 179 006
DATA LIN 027 000 135 090 006
DATA CLI 027 179 006
DATA CLI 000 179 006
DATA FIL 134 090 006 006
' black chevron
DATA LIN 027 000 135 090 000
DATA CLI 027 179 000
DATA LIN 054 000 162 090 000
DATA CLI 054 179 000
DATA FIL 161 090 000 000
DATA -
DATA rainbow-progress-intersex
' horizontal stripes
DATA REC 054 266 000 030 012
DATA REC 081 239 030 030 012
DATA DRE 081 239 030 030 014
DATA REC 108 212 060 030 014
DATA REC 108 212 090 030 010
DATA REC 081 239 120 030 009
DATA REC 054 266 150 030 013
' chevrons are 22 px wide and 18 px tall
' yellow triangle
DATA LIN 000 018 080 090 014
DATA CLI 000 162 014
DATA FIL 079 090 014 014
' white chevron
DATA LIN 000 018 080 090 015
DATA CLI 000 162 015
DATA LIN 000 000 102 090 015
DATA CLI 000 179 015
DATA FIL 101 090 015 015
' pink chevron
DATA LIN 022 000 124 090 015
DATA CLI 022 179 015
DATA LIN 000 180 022 180 015
DATA DFI 123 090 012 015 015
DATA LIN 000 180 022 180 000
' cyan chevron
DATA LIN 022 000 124 090 011
DATA CLI 022 179 011
DATA LIN 044 000 146 090 011
DATA CLI 044 179 011
DATA CLI 022 179 011
DATA FIL 145 090 011 011
' brown chevron
DATA LIN 044 000 146 090 006
DATA CLI 044 179 006
DATA LIN 066 000 168 090 006
DATA CLI 066 179 006
DATA CLI 044 179 006
DATA FIL 167 090 006 006
' black chevron
DATA LIN 066 000 168 090 000
DATA CLI 066 179 000
DATA LIN 088 000 190 090 000
DATA CLI 088 179 000
DATA FIL 169 090 000 000
' circle
DATA CIR 030 090 019 005
DATA CIR 030 090 024 005
DATA FIL 050 090 005 005
DATA -
DATA transgender
DATA HRE 000 036 011
DATA HRE 036 108 015
DATA DHR 036 036 012
DATA DHR 108 036 012
DATA HRE 144 036 011
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
'       Command   = "AAA"-"ZZZ", in UPPER CASE
'       Argument  = "000"-"999"; count depends on Command
' Commands and their Arguments:
'   HREyhc    = Horizontal REctangle (filled, full width)
'   DHRyhc    = Dithered Horizontal Rectangle (full width, transparent)
'   RECxwyhc  = RECtangle (filled)
'   DRExwyhc  = Dithered REctangle (transparent)
'   LINxyxyc  = LINe
'   CLIxyc    = Continue LIne
'   CIRxyrc   = CIRcle
'   ARCxyrcaa = ARC (aa: start angle, end angle)
'   FILxycc   = FILl (cc: fill color, color to stop at)
'   DFIxyccc  = Dithered FIll (ccc: fill color 1/2, color to stop at)
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
        CASE "HRE", "DHR", "CLI": argc = 3
        CASE "CIR", "FIL": argc = 4
        CASE "REC", "DRE", "LIN", "DFI": argc = 5
        CASE "ARC": argc = 6
        CASE ELSE: PRINT "Unknown draw command: "; c$: END
    END SELECT

    ' Arguments
    FOR j = 0 TO argc - 1
        args(j) = VAL(MID$(drawcommands$, dci, 3))
        dci = dci + 3
    NEXT

    ' execute Command
    IF c$ = "HRE" THEN
        LINE (0, args(0))-(319, args(0) + args(1) - 1), args(2), BF
    ELSEIF c$ = "DHR" THEN
        FOR y = args(0) TO args(0) + args(1) - 1
            IF (y AND 1) THEN pattern = &H5555 ELSE pattern = &HAAAA
            LINE (0, y)-(319, y), args(2), , pattern
        NEXT
    ELSEIF c$ = "REC" THEN
        x2 = args(0) + args(1) - 1
        y2 = args(2) + args(3) - 1
        LINE (args(0), args(2))-(x2, y2), args(4), BF
    ELSEIF c$ = "DRE" THEN
        x2 = args(0) + args(1) - 1
        FOR y = args(2) TO args(2) + args(3) - 1
            IF (y AND 1) THEN pattern = &H5555 ELSE pattern = &HAAAA
            LINE (args(0), y)-(x2, y), args(4), , pattern
        NEXT
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
        ' pattern = 8*2 pixels = 8 bytes;
        ' byte = 8*1 px of one bitplane; 4 bytes = B/G/R/intensity
        pattern$ = STRING$(8, &H0)
        FOR i = 0 TO 3
            pow = 2 ^ i
            b1set = (args(2) AND pow) > 0
            b2set = (args(3) AND pow) > 0
            IF b1set AND b2set THEN
                MID$(pattern$, i + 1, 1) = CHR$(&HFF)
                MID$(pattern$, i + 5, 1) = CHR$(&HFF)
            ELSEIF b1set OR b2set THEN
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

DEFSNG A-Z
FUNCTION formatratio$ (a%, b%)
' e.g. formatratio$(2, 5) = "2/5"
DEFINT A-Z

formatratio$ = LTRIM$(STR$(a%)) + "/" + LTRIM$(STR$(b%))

END FUNCTION

DEFSNG A-Z
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

PRINT "Reading flag data..."

flagcount = 0
DO
    READ item$  ' name or final terminator
    IF item$ = "-" THEN EXIT DO
    IF flagcount = MAXFLAGS THEN PRINT "Please increase MAXFLAGS.": END
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

