' Copyleft (C) 2015 ZeroEightOne, some rights reserved
' Lottery simulator program
' Version 1.0 | Aug 14, 2015

_TITLE "ZEO's Lottery Simulator Version 1.3"

SCREEN _NEWIMAGE(800, 600, 256)

rootpath$ = ENVIRON$("SYSTEMROOT") 'C:\Windows
fontfile$ = rootpath$ + "\Fonts\UbuntuMono-R.ttf"
style$ = "monospace"
fsmall& = _LOADFONT(fontfile$, 44, style$)
ftiny& = _LOADFONT(fontfile$, 22, style$)

_FONT ftiny&

DIM a(50)
DIM b(20)
DIM nres AS DOUBLE
DIM kres AS DOUBLE
DIM res AS LONG

1 INPUT "How many main balls to be drawn? (>1) :"; mnball
2 INPUT "How many main balls in a pool? (>above) :"; mnall

IF mnall <= mnball THEN GOTO 1

3 INPUT "How many bonus balls to be drawn? (Input 0 for no bonus ball) :"; bnball

IF bnball = 0 THEN
    bnall = 0
    GOTO drawstart
END IF

4 INPUT "How many bonus balls in a pool? (>above) :"; bnall
IF bnall <= bnball THEN GOTO 3

drawstart:
CLS
PRINT "Summary :"
PRINT "Main Pool  : Pool/Draw :"; mnall; "/"; mnball
PRINT "Bonus Pool : Pool/Draw :"; bnall; "/"; bnball

IF bnall = 0 THEN
    PRINT "Chance to win : 1 in "; USING "##########"; perm(mnall, mnball) - 1
END IF

IF bnall <> 0 THEN
    PRINT "Chance to win : 1 in "; USING "##########"; (perm(mnall, mnball) - 1) * (perm(bnall, bnball) - 1)
END IF
PRINT "Press A to continue..."

_FONT fsmall&

DO
LOOP UNTIL INKEY$ = "a"

start: CLS
PRINT "Drawing main numbers..."

_FONT ftiny&
LOCATE 6, 43: PRINT "BONUS BALL(S)"
LOCATE 6, 5: PRINT "MAIN BALL(S)"

_FONT fsmall&

I = 0
pst = 4
pss = 0
FOR x = 1 TO mnball

    pss = pss + 1
    IF x = 7 THEN
        pst = pst + 1
        pss = pss - 6
    END IF

    IF x = 13 THEN
        pst = pst + 1
        pss = pss - 6
    END IF

    LOCATE 1, 24: PRINT "("; x; "/ mnball )"

    100 DO
        _LIMIT 10 + 10 * x
        I = I + 1

        pseed = TIMER
        seed = pseed ^ 3 - pseed ^ 2
        RANDOMIZE USING seed

        a(x) = INT(RND * mnall) + 1
        LOCATE 2, 1: PRINT a(x)
    LOOP UNTIL INKEY$ = "a"

    FOR p = 1 TO x - 1
        IF x = 1 THEN EXIT FOR

        IF a(x) = a(p) THEN GOTO 100

    NEXT p

    LOCATE pst, 3 * pss

    IF a(x) > 9 THEN PRINT USING "##"; a(x)
    IF a(x) < 10 THEN PRINT USING "0#"; a(x)

NEXT x

'-----------------------------
' BONUS, as same as main balls
'-----------------------------

IF bnball = 0 THEN GOTO sort

_FONT fsmall&
LOCATE 1, 1
PRINT "Drawing bonus numbers..."

I = 0
pst = 4
pss = 0
FOR x = 1 TO bnball

    pss = pss + 1
    IF x = 6 THEN
        pst = pst + 1
        pss = pss - 5
    END IF

    IF x = 11 THEN
        pst = pst + 1
        pss = pss - 5
    END IF

    200 DO
        I = I + 1

        RANDOMIZE TIMER
        b(x) = INT(RND * bnall) + 1
        LOCATE 2, 1: PRINT b(x)
    LOOP UNTIL INKEY$ = "a"

    FOR p = 1 TO x - 1
        IF x = 1 THEN EXIT FOR

        IF b(x) = b(p) THEN GOTO 200

    NEXT p

    LOCATE pst, 3 * pss + 19
    IF b(x) > 9 THEN PRINT USING "##"; b(x)
    IF b(x) < 10 THEN PRINT USING "0#"; b(x)

NEXT x

_DELAY 0.5
LOCATE 4, 3:

sort:

FOR bl = 1 TO 14
    _DELAY 0.04
    PRINT " ";
NEXT bl

LOCATE 4, 22
FOR bl = 1 TO 2
    _DELAY 0.04
    PRINT " ";
NEXT bl

LOCATE 4, 25
FOR bl = 1 TO 2
    _DELAY 0.04
    PRINT " ";
NEXT bl

_DELAY 0.5

FOR I = 2 TO mnball
    FOR j = 1 TO mnball
        IF a(I) < a(j) THEN SWAP a(I), a(j)
    NEXT j
NEXT I

IF bnball = 1 THEN GOTO SkipSortBonus

FOR I = 2 TO bnball
    FOR j = 1 TO bnball
        IF b(I) < b(j) THEN SWAP b(I), b(j)
    NEXT j
NEXT I

SkipSortBonus:
CLS

_FONT ftiny&
LOCATE 6, 43: PRINT "BONUS BALL(S)"
LOCATE 6, 5: PRINT "MAIN BALL(S)"

_FONT fsmall&

pst = 4
pss = 0

FOR x = 1 TO mnball
    pss = pss + 1
    IF x = 7 THEN
        pst = pst + 1
        pss = pss - 6
    END IF

    IF x = 13 THEN
        pst = pst + 1
        pss = pss - 6
    END IF

    LOCATE pst, 3 * pss

    IF a(x) > 9 THEN PRINT USING "##"; a(x)
    IF a(x) < 10 THEN PRINT USING "0#"; a(x)
NEXT x

pst = 4
pss = 0

FOR x = 1 TO bnball

    pss = pss + 1
    IF x = 6 THEN
        pst = pst + 1
        pss = pss - 5
    END IF

    IF x = 11 THEN
        pst = pst + 1
        pss = pss - 5
    END IF
    LOCATE pst, 3 * pss + 19

    IF b(x) > 9 THEN PRINT USING "##"; b(x)
    IF b(x) < 10 THEN PRINT USING "0#"; b(x)
NEXT x

LOCATE 1, 1: PRINT "                                            "
LOCATE 2, 1: PRINT "                "

LOCATE 12, 1
PRINT "Draw again? press A. Q to quit"

10 b$ = INKEY$
IF b$ = "" THEN GOTO 10
IF b$ = "a" THEN GOTO start
IF b$ = "q" THEN SYSTEM

' FUNCTION -----------------------------------

FUNCTION perm (n, k)

nres = 1
kres = 1

FOR i = n TO n - k + 1 STEP -1
    nres = nres * i
NEXT i

FOR i = 1 TO k
    kres = kres * i
NEXT i

res = nres / kres
perm = res

END FUNCTION
