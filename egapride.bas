DECLARE SUB drawflag (commands$)
DECLARE SUB printstring (stri$)

' commands: FH,FS,RE,HR,VR,CC,--
DATA intersex,fh178--fs014--cc061005--cc044014
DATA transgender,fh160--fs011--hr032127013--hr064096015
DATA pansexual,fh160--hr000053012--hr054106014--hr107159011
DATA asexual,fh160--hr000039000--hr040079008--hr080119015--hr120159005
DATA rainbow,fh164--hr000026012--hr027054012--dh027054014--hr055081014--hr082108002--hr109136009--hr137163005
DATA -,-

DIM names$(19), drawstrings$(19)
DIM choices(2)  ' indexes to names$ and drawstrings$
RANDOMIZE TIMER

flagcount = 0
DO
    READ n$, ds$
    IF n$ = "-" THEN EXIT DO
    names$(flagcount) = n$
    drawstrings$(flagcount) = ds$
    flagcount = flagcount + 1
LOOP

SCREEN 7

correct = INT(RND * flagcount)  ' index to names$, drawstrings$
CALL drawflag(drawstrings$(correct))

' randomise choices (all different, must contain correct answer)
DO
    hascorrect = 0
    FOR i = 0 TO 2
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

' format question
question$ = ""
FOR i = 0 TO 2
    question$ = question$ + LTRIM$(STR$(i + 1)) + "=" + names$(choices(i))
    question$ = question$ + ", "
NEXT
question$ = question$ + "Q=quit?"

' ask for choice
CALL printstring(question$)
DO
    choice$ = UCASE$(INPUT$(1))
LOOP UNTIL INSTR("123Q", choice$)

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

SUB drawflag (commands$)
' Draw flag by commands. The command string consists of blocks.
' Each block starts with a command ("AA"-"ZZ", case insensitive) and is
' followed by any number of arguments depending on the command.
' Each argument is "000"-"999".

fw = 320: fh = 200  ' default flag size

DIM args(10)

i = 1
WHILE i < LEN(commands$)
    ' read command
    c$ = UCASE$(MID$(commands$, i, 2))
    i = i + 2

    ' get argument count
    SELECT CASE c$
        CASE "FH": argc = 1  ' Flag Height
        CASE "FS": argc = 1  ' Fill Screen
        CASE "RE": argc = 5  ' filled REctangle
        CASE "HR": argc = 3  ' Horizontal filled Rectangle
        CASE "VR": argc = 3  ' Vertical filled Rectangle
        CASE "CC": argc = 2  ' Centered filled Circle
        CASE "DH": argc = 3  ' Dithered Horizontal rectangle
        CASE "--": argc = 0  ' nothing
        CASE ELSE
            PRINT "Unknown draw command: "; c$: END
    END SELECT

    ' read arguments
    FOR j = 0 TO argc - 1
        args(j) = VAL(MID$(commands$, i, 3))
        i = i + 3
    NEXT

    ' execute command
    IF c$ = "FH" THEN  ' Flag Height
        fh = args(0)
    ELSEIF c$ = "FS" THEN  ' Fill Screen
        LINE (0, 0)-(fw - 1, fh - 1), args(0), BF
    ELSEIF c$ = "HR" THEN  ' Horizontal Rectangle (full width)
        LINE (0, args(0))-(fw - 1, args(1)), args(2), BF
    ELSEIF c$ = "VR" THEN  ' Vertical Rectangle (full height)
        LINE (args(0), 0)-(args(1), fh - 1), args(2), BF
    ELSEIF c$ = "RE" THEN  ' REctangle
        LINE (args(0), args(1))-(args(2), args(3)), args(4), BF
    ELSEIF c$ = "CC" THEN  ' Centered filled CIrcle
        CIRCLE (fw \ 2, fh \ 2), args(0), args(1)
        PAINT (fw \ 2, fh \ 2), args(1)
    ELSEIF c$ = "DH" THEN  ' Dithered Horizontal rectangle (fullwidth)
        FOR y = args(0) TO args(1) STEP 2
            LINE (0, y)-(fw, y), args(2), , &H5555
            LINE (0, y + 1)-(fw, y + 1), args(2), , &HAAAA
        NEXT
    ELSEIF c$ = "--" THEN
        ' nothing (for readability)
    ELSE
        PRINT "Unknown draw command: "; c$
        END
    END IF
WEND

END SUB

SUB printstring (stri$)

LOCATE 24, 1: PRINT SPACE$(40);
LOCATE 25, 1: PRINT SPACE$(40);
LOCATE 24, 1: PRINT LEFT$(stri$, 40);
LOCATE 25, 1: PRINT MID$(stri$, 40);

END SUB

