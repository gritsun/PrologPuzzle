/*
There are 2 ways to execute program:
 1. run function tSolve and pass matrix as input parameter

 example : tSolve([[5,2,5],[3,0,1],[4,3,4]]).

 2. run function do with free variable X.

 example : do(X).

 output of the program : list of arrows in following sequence top ->
 right -> bottom -> left, every arrow is encoded with letters (D -
 down, DL - down left, UR - up right, etc).

*/

tGet(TABLE,I,J,RES) :- tGetRow(TABLE,I,ROW), lGet(ROW,J,RES).

tGetRow([H|_],I,H) :- I == 0, !.
tGetRow([_|T],I,RES) :- I1 is I-1, tGetRow(T,I1,RES).

lGet([H|_],I,H) :- I == 0, !.
lGet([_|T],I,RES) :- I1 is I-1, lGet(T,I1,RES).

tSet(TABLE,I,J,VAL,RES) :- tGetRow(TABLE,I,ROW), lSet(ROW,J,VAL,ROW_MOD) , tSetRow(TABLE,I,ROW_MOD,RES).

lSet([_|T],J,VAL,[VAL|T]) :- J == 0, !.
lSet([H|T],J,VAL,[H|RES]) :- J1 is J-1, lSet(T,J1,VAL,RES).

tSetRow([_|T],I,ROW,[ROW|T]) :- I == 0, !.
tSetRow([H|T],I,ROW,[H|RES]) :- I1 is I-1, tSetRow(T,I1,ROW,RES).

lSize([],0) :- !.
lSize([_|T],R) :- lSize(T,R1), R is R1+1.

tSize([H|T],N,M) :- lSize(H,M), lSize([H|T],N).

tSetArrow(TABLE,_,_, I, J, 0, TABLE) :- tGet(TABLE,I,J,VAL), VAL =< 0, !.
tSetArrow(TABLE,_,_, I,_, 1, TABLE) :- I < 0, !.
tSetArrow(TABLE,_,_, _,J, 1, TABLE) :- J < 0, !.
tSetArrow(TABLE,_,_, I,_, 1, TABLE) :- tSize(TABLE,N,_), I >= N, !.
tSetArrow(TABLE,_,_, _,J, 1, TABLE) :- tSize(TABLE,_,M), J >= M, !.
tSetArrow(TABLE,DIR_I, DIR_J, I, J, ISVALID_MOD, TABLE_MOD) :- tGet(TABLE,I,J,VAL), VAL > 0, VAL1 is VAL-1, tSet(TABLE,I,J,VAL1,NEW_TABLE), I1 is I+DIR_I, J1 is J + DIR_J, tSetArrow(NEW_TABLE,DIR_I,DIR_J,I1,J1,ISVALID_MOD, TABLE_MOD), ISVALID_MOD == 1, !.
tSetArrow(TABLE,DIR_I, DIR_J, I, J, ISVALID_MOD, TABLE) :- tGet(TABLE,I,J,VAL), VAL > 0, VAL1 is VAL-1,tSet(TABLE,I,J,VAL1,NEW_TABLE), I1 is I+DIR_I, J1 is J+DIR_J, tSetArrow(NEW_TABLE,DIR_I,DIR_J,I1,J1,ISVALID_MOD,_), ISVALID_MOD == 0, !.


tSolveTop(TABLE,I,VALID,RES) :- tSize(TABLE,_,M), I>=M , tSolveRight(TABLE,0,VALID,RES), !.
tSolveTop(TABLE,I,0,["Null "]) :- tSize(TABLE,_,M), I>=M , !.
tSolveTop(TABLE,I,VALID1,["D "|RES]) :-  tSetArrow(TABLE, 1, 0, 0, I, VALID,TABLE_NEW), VALID == 1, I1 is I+1,tSolveTop(TABLE_NEW,I1,VALID1,RES), VALID1 == 1,!.
tSolveTop(TABLE,I,VALID1,["DL "|RES]) :- P_J is I-1, P_J >= 0, tSetArrow(TABLE, 1, -1, 0, P_J, VALID,TABLE_NEW), VALID == 1, I1 is I+1,tSolveTop(TABLE_NEW,I1,VALID1,RES), VALID1 == 1, !.
tSolveTop(TABLE,I,VALID1,["DR "|RES]) :- P_J is I+1, tSize(TABLE,_,M), P_J < M, tSetArrow(TABLE, 1, 1, 0, P_J, VALID,TABLE_NEW), VALID == 1, I1 is I+1,tSolveTop(TABLE_NEW,I1,VALID1,RES), VALID1 == 1,!.


tSolveRight(TABLE,I,VALID,RES) :- tSize(TABLE,N,_), I>=N, tSolveBottom(TABLE,0,VALID,RES), !.
tSolveRight(TABLE,I,0,["NULL"]) :- tSize(TABLE,N,_), I>=N, !.
tSolveRight(TABLE,I,VALID1,["L "|RES]) :- tSize(TABLE,_,M), M1 is M-1,tSetArrow(TABLE, 0, -1, I, M1, VALID,TABLE_NEW), VALID == 1, I1 is I+1,tSolveRight(TABLE_NEW,I1,VALID1,RES), VALID1 == 1, !.
tSolveRight(TABLE,I,VALID1,["LD "|RES]) :- tSize(TABLE,N,M), P_I is I+1, P_I < N, tSetArrow(TABLE, 1, -1, P_I, M-1, VALID,TABLE_NEW), VALID == 1, I1 is I+1,tSolveRight(TABLE_NEW,I1,VALID1,RES), VALID1 == 1, !.
tSolveRight(TABLE,I,VALID1,["LU "|RES]) :- P_I is I-1, tSize(TABLE,_,M), P_I >= 0, M1 is M-1,tSetArrow(TABLE, -1, -1, P_I, M1, VALID,TABLE_NEW), VALID == 1, I1 is I+1,tSolveRight(TABLE_NEW,I1,VALID1,RES), VALID1 == 1, !.

tSolveBottom(TABLE,I,VALID,RES) :- tSize(TABLE,_,M), I>=M, tSolveLeft(TABLE,0,VALID,RES),!.
tSolveBottom(TABLE,I,0,["Null"]) :- tSize(TABLE,_,M), I>=M, !.
tSolveBottom(TABLE,I,VALID1,["U "|RES]) :- tSize(TABLE,N,_), N1 is N-1,tSetArrow(TABLE, -1, 0, N1, I, VALID,TABLE_NEW), VALID is 1, I1 is I+1,tSolveBottom(TABLE_NEW,I1,VALID1,RES), VALID1 == 1, !.
tSolveBottom(TABLE,I,VALID1,["UL "|RES]) :-  tSize(TABLE,N,_), N1 is N-1,P_J is I-1, P_J >= 0, tSetArrow(TABLE, -1, -1, N1, P_J, VALID,TABLE_NEW), VALID == 1, I1 is I+1,tSolveBottom(TABLE_NEW,I1,VALID1,RES), VALID1 == 1, !.
tSolveBottom(TABLE,I,VALID1,["UR "|RES]) :- P_J is I+1, tSize(TABLE,N,M), P_J < M, N1 is N-1,tSetArrow(TABLE, -1, 1, N1, P_J, VALID,TABLE_NEW), VALID == 1, I1 is I+1,tSolveBottom(TABLE_NEW,I1,VALID1,RES), VALID1 == 1, !.


tSolveLeft(TABLE,I,1,[]) :- tSize(TABLE,N,_), I>=N, !.
tSolveLeft(TABLE,I,VALID1,["R "|RES]) :- tSetArrow(TABLE, 0, 1, I, 0, VALID,TABLE_NEW), VALID == 1, I1 is I+1,tSolveLeft(TABLE_NEW,I1,VALID1,RES), VALID1 == 1, !.
tSolveLeft(TABLE,I,VALID1,["RD "|RES]) :-  tSize(TABLE,N,_), P_I is I+1, P_I < N, tSetArrow(TABLE, 1, 1, P_I, 0, VALID,TABLE_NEW), VALID == 1, I1 is I+1,tSolveLeft(TABLE_NEW,I1,VALID1,RES), VALID1 == 1, !.
tSolveLeft(TABLE,I,VALID1,["RU "|RES]) :- P_I is I-1, P_I >= 0, tSetArrow(TABLE, -1, 1, P_I, 0, VALID,TABLE_NEW), VALID == 1, I1 is I+1,tSolveLeft(TABLE_NEW,I1,VALID1,RES), VALID1 == 1, !.

tPrintList([]) :- !.
tPrintList([H|T]) :- format("~s",[H]),  tPrintList(T), !.

tSolve(TABLE) :- tSolveTop(TABLE,0,_,RES), tPrintList(RES), !.

do(_) :- tSolve([[5,2,5],[3,0,1],[4,3,4]]),!.






















