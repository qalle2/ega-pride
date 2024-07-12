DECLARE SUB drawflag (drawcommands$)
DECLARE SUB printstring (stri$)
DECLARE FUNCTION deletespaces$ (old$)
DEFINT A-Z

CONST MAXFLAGS = 20  ' maximum number of flags
CONST CHOICECNT = 3  ' number of choices

DIM names$(MAXFLAGS - 1)         ' names of flags
DIM drawcommands$(MAXFLAGS - 1)  ' commands for drawing flags
DIM choices(CHOICECNT - 1)       ' indexes to names$ and drawcommands$

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
DATA intersex, FH 178
DATA HR 000 177 014
DATA CC 061 005
DATA CC 044 014
DATA -
DATA transgender, FH 160
DATA HR 000 160 011
DATA HR 032 096 013
DATA HR 064 032 015
DATA -
DATA pansexual, FH 160
DATA HR 000 053 012
DATA HR 053 054 014
DATA HR 107 053 011
DATA -
DATA asexual, FH 160
DATA HR 000 040 000
DATA HR 040 040 008
DATA HR 080 040 015
DATA HR 120 040 005
DATA -
DATA rainbow, FH 164
DATA HR 000 027 012
DATA HR 027 027 012
DATA DH 027 027 014
DATA HR 054 028 014
DATA HR 082 028 002
DATA HR 110 027 009
DATA HR 137 027 005
DATA -
DATA -

RANDOMIZE TIMER

' read flag data
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

IF flagcount < CHOICECNT THEN PRINT "Too few flags.": END

SCREEN 7

correct = INT(RND * flagcount)  ' index to names$, drawcommands$
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
CALL printstring(quest$)

' ask for choice
validchoices$ = LEFT$("123456789", CHOICECNT) + "Q"
DO
    choice$ = UCASE$(INPUT$(1))
LOOP UNTIL INSTR(validchoices$, choice$)

' react to choice
IF choice$ = "Q" THEN
    SCREEN 0: END
ELSEIF choices(VAL(choice$) - 1) = correct THEN
    CALL printstring("Correct. Press any key.")
ELSE
    CALL printstring("Incorrect. Press any key.")
END IF

k$ = INPUT$(1)
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
        FOR Y = args(0) TO args(0) + args(1) - 1 STEP 2
            LINE (0, Y)-(fw, Y), args(2), , &H5555
            LINE (0, Y + 1)-(fw, Y + 1), args(2), , &HAAAA
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
SUB printstring (stri$)
' print a string on lines 24-25
DEFINT A-Z

FOR i = 0 TO 1
    LOCATE 24 + i, 1: PRINT SPACE$(40);
    LOCATE 24 + i, 1: PRINT MID$(stri$, i * 40 + 1, 40);
NEXT

END SUB

