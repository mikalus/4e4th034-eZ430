\ This small (1524 bytes) MSP430 assembler produces code at IHERE
\ WAS means Willems ASsembler for MSP430 and 4E4th

\ Complete security by checking for valid registers
\ and extended checking on addressing errors
\ 4 nibbles form dual opcode | instr. | S-reg. | modes | D-reg.  |
\ Single opcode              | 9-bit instruc.   | mode | D/S-reg |
\ Conditionals               | 6-bit instr | 10-bit rel. branch |
\ Only basic opcodes: 0402 bytes ( ~1 kByte)
\ With corrected and shrinked an control structs: 05F4 bytes
\ Together with DAS6.F about 0A40 bytes
\ When used together with DAS, first compile DAS !!!!
\ Added ) to destination addressing modes, it assembles 0 <reg> x)

HEX   \ until the end

\ x1 = Extra dataword 1, x2 = Extra dataword 2,
\ opc = opcode being build, ext = Nr. of extra datawords
  VARIABLE x1      VARIABLE x2
  VARIABLE opc     VARIABLE ext

: xtra   1 ext +! ;

\ Needs to be executed one time before you start assemble code
: Sas    0 opc !  0 ext ! ;

\ ----- addressing
  00 CONSTANT pc   01 CONSTANT rp    02 CONSTANT sr    03 CONSTANT cg
  04 CONSTANT sp   05 CONSTANT ip    06 CONSTANT w     07 CONSTANT tos
  08 CONSTANT r8   09 CONSTANT r9    0A CONSTANT r10   0B CONSTANT r11
( 0C CONSTANT r12  0D CONSTANT r13   0E CONSTANT r14 ) 0F CONSTANT r15
( 10 constant x} ) 20 constant )     30 constant )+  ( 40 constant # )

\ Immediate mode: Save extra data to help variable x1
: #     ( x -- m )    x1 !  xtra  40 ;

\ Indexed mode: Save extra data to help variables x1 or x2
: x)    ( x R -- R m )
   >r  ext @ 0= if    x1 !  r@ cg <> if xtra then
                else  x2 !  xtra  then  r>  10 ;

: ?addr  over u< abort" Addr err" ;    ( m m# -- m )
: ?reg   r15 u> abort" Reg err" ;      ( R -- )

: #4  sr ) ;   : #8  sr )+ ;        : &   sr x) ;
: #0  cg ;     : #1  0 cg x) ;      : #2  cg ) ;
: #-1 cg )+ ;  : .b  40 opc ! ;

\ Flag must be true when Sdata is used for 2 operand opcodes
: Sdata  ( ms flag -- )
   >r  dup r15 u> if            \ Mode data?
      3 depth ?addr drop        \ Not enough data?
      dup 40 = if  drop  pc )+  then \ Handle #
      )+ ?addr  ( R m )         \ Check valid addr mode
   else
      0      ( R 0 )            \ Add fake address mode
   then
   over ?reg  r> if  swap ><  then  or opc +! ;

: SDdata    ( ms md -- )
   dup r15 u> if                \ Address mode on top?
     over ?reg                  \ Yes, valid register
     dup ) = if  drop 0 swap x)  then  \ Add ) to destination modes
     10 ?addr  8 * or           \ Check addr. mode and add to dest. field
   else
     dup ?reg                   \ No, Check Register
   then
   opc +!  -1 Sdata ;           \ Build opc and add source mode

: opc,      ( -- )
   opc @ i,  ext @ if  x1 @ i,  then
   ext @ 2 and if  x2 @ i,  then
\   opc @ u.  ext @ if  x1 @ u.  then \ For debugging only
\   ext @ 2 and if  x2 @ u.  then
   Sas ;

: 1op    <builds i, does> @ opc +! 0 Sdata opc, ;
: 2op    <builds i, does> @ opc +! SDdata opc, ;

: reti  1300 i, ;

\ Note that SWPB SXT and CALL may not be used with .B argument
\ Also # is only valid on the CALL opcode and the source of 2op(codes)
\ The use of & with CALL needs the address stored on that address
\ it may be ROM but that is of no use # CALL is the choice there. 
   1000 1op rrc    1080 1op swpb   1100 1op rra
   1180 1op sxt    1200 1op push   1280 1op call

   4000 2op mov    5000 2op add    6000 2op addc   7000 2op subc
   8000 2op sub    9000 2op cmp    A000 2op dadd   B000 2op bit
   C000 2op bic    D000 2op bis    E000 2op xor>   F000 2op and>

cr ihere c000 - dup . decimal . hex

\ Macros
: next  ip )+ w mov   w )+ pc mov ;
: clrc  #1 sr bic ;
: -)  >r  #2 r@ sub  r> ) ;

\ Conditions, these version are likely to stay 
   2000 CONSTANT =?       2400 CONSTANT <>?     2800 CONSTANT cs?
   2C00 CONSTANT cc?      3000 CONSTANT pos?    3400 CONSTANT >?
   3800 CONSTANT <eq?     3C00 CONSTANT never
   2800 CONSTANT u<eq?    2C00 CONSTANT u>?

\ <offset>     = masker for offset -> then and until
\ never        = cond for always.jump -> ahead, again
\              = masker for condition -> see ?cond

: calc  ( a1 a2 -- opc )  cell+  - 2/ 3ff and or ; \ *** CELL+
: ?pair ( x y -- )  - abort" No pair" ;
: ?cond ( cond -- cond ) dup c3ff and  abort" Need cond" ;

: if, ( cond -- ifcond ifloc )   ?cond  66 or  ihere  cell iallot ;
: begin, ( -- beginloc begin# )  ihere  77 ;

: then, ( ifcond ifloc -- )
   >r  dup 00ff and  66 ?pair
   never and  ?cond  ihere r@ calc  r> i! ;

: until, ( beginloc begin# cond -- )
   swap 77 ?pair  ?cond  swap ihere calc  i, ;

: again,    never until, ;
: else,     never if,  2swap then, ;
: while,    if, 2swap ;
: repeat,   again, then, ;
: jmp       77 again, ;  \ jump, relative addr in opcode

: code      header  Sas  ihere cell+ i,  55 ;
: end-code  55 ?pair ;

Sas  cr ihere c000 - dup . decimal . hex
