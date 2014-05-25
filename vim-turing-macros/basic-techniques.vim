" ===================
" A very simple macro
" ===================

= reg s (for simple)
foa hi there

Breakdown:
fo            -> go forward to an 'o'
a hi there  -> append ' hi there' and escape

" =========================
" Wrapping macros in macros
" =========================

= reg r (for repeat)
0@sj

Breakdown:
0  -> go to the beginning of the line
@s -> execute macro s
j  -> then go to the next line

" ===========================
" Simple self modifying macro
" ===========================

= reg m (for modify)
ggdG1Ohello 1"mptOw"mdd

Breakdown:
ggdG          -> delete the entire file
1Ohello 1   -> one time, enter the line 'hello 1'
"mp           -> put this macro
tO          -> find and increment the first number
w           -> find and increment the second number
"mdd          -> put the newly modified macro back into reg m.

" NOTE:
" You might not get the results you expect if you run it multiple times.
" The macro runs however many times you called, but only with the version
" of the macro as it existed when you typed @m. Calling from another macro
" works fine, however.

= reg n (for wanting to make a Number of runs)
@m

" =========================
" A Macro with Conditionals
" =========================
" This command chooses the yanks the appropriate macro into reg a
" (for action), and then performs it

= reg p (for program)
0y$/^":f:w"ay$@a

" These lines contain the macros that will be the actions
hello:    A hi therej
goodbye:  dd

Breakdown:
starting in the left split
0y$    -> yank the line you're on and jump to the right split
/^": -> perform a search for the line just lanked followed by a colon
f:w"ay$  -> yank the text after the colon into reg a
@a     -> go to the left split and perform reg a


" ======================
" load all of the macros
" ======================
" You may have noticed that before each macro was a line with: = reg ?
" We can use those lines to automatically load all of the macros in this file
" into the appropriate registers.

= reg l (for load)
o:vsplit /tmp/run-file:let @a="":g/^= reg /y A"apdkG$s1 +GJA 0V:!bc"nye:let @a="":g/^= reg /.,+1y A"apggdjO0wwylj0:y D2"CRj"iddO@i0"nP"rdd@r

Breakdown:
  -> set up a working window
o:vsplit /tmp/run-file

  -> get count of number of macros
:let @a=""                -> Clear out reg a
:g/^= reg /y A          -> yank all the '= reg' lines (and the ones after them) into a.
"ap                       -> paste those reg lines into the working file
dk                          -> trim out empty line
G$s1 +                  -> replace all of the lines with '1 +'
GJA 0                   -> join all the lines together and tack a zero on the end
V:!bc"nye                 -> pipe the equation to bc and yank the result into reg n

  -> copy the macros to the working space
:let @a=""                -> Clear out reg a
:g/^= reg /.,+1y A      -> yank all the '= reg' lines (and the ones after them) into a.
"ap                       -> paste those reg lines into the working file
ggdj                        -> clear out two empty lines that were a side effect
  -> write out sub macro i
O                           -> start writing
0wwyl                       -> grap which reg to write to
j0:y D2"CRj             -> yank the macro into the above reg
                          -> stop writing
"idd                        -> copy it into i
  -> write out sub macro r, which will repeat i, n times
O@i0"nP"rdd
  -> call it
@r



" ===============
" compile a macro
" ===============
" Takes one of the breakdowns (selected in visual mode) and copy it
" to the default register.

= reg c (for compile)
omtyGpmwVG:s/\s\+->.*//'wVG:j!dd't

Breakdown:
omt               -> Mark the top of the visual selection
yGp               -> Yank the selected area and put it at the bottom of the file
mwVG              -> Mark where we are, select to the bottom of the file
:s/\s\+->.*//   -> remove non-comment parts of the macros
'wVG:j!         -> go back to the mark, join together the lines without spaces
dd't              -> dd the macro and go back the the beginning
