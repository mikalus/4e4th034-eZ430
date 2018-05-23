; ----------------------------------------------------------------------
; 4e4th is a Forth based on CamelForth 
; for the Texas Instruments MSP430 
; 
; This program is free software; you can redistribute it and/or modify
; it under the terms of the GNU General Public License as published by
; the Free Software Foundation; either version 3 of the License, or
; (at your option) any later version.
; 
; This program is distributed in the hope that it will be useful,
; but WITHOUT ANY WARRANTY; without even the implied warranty of
; MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
; GNU General Public License for more details.
;
; You should have received a copy of the GNU General Public License
; along with this program.  If not, see <http://www.gnu.org/licenses/>.
; 
; See LICENSE TERMS in Brads file readme.txt as well.

; ----------------------------------------------------------------------
; 4e-CF430F2274forth.h: - Register, Model, Macro declarations - MSP430F2274
; ----------------------------------------------------------------------

// ; FORTH MEMORY USAGE
// ; for Flash memory operations - this includes information and main
// ; ROM, but not the main ROM used by the kernel. 
#define INFOSTART   (0x1000) // ok mk
#define INFOEND     (0x10FF) // ok mk
#define RAMSTART    (0x0200) // ok mk
#define RAMEND      (0x05FF) // ok mk
#define USERFLASHSTART  (0x8000) // ok mk  
#define USERFLASHEND    (0xD7FF) // muss übereinstimmen mit -P CODE linker 
#define ISRSTART    (0xFE00) 
#define ISREND      (0xFFDF)
#define MAINSEG     (512) // wozu ?? mk
#define INFOSEG     (128) // ?? mk

// ; FORTH REGISTER USAGE

// ; Forth virtual machine
// PC = R00 
#define RSP SP // R01
// R02 = SR statusregister
// R03 = CG constantgenerator
#define PSP R4
#define IP  R5
#define W   R6
#define TOS R7

// ; Loop parameters in registers
#define INDEX R8
#define LIMIT R9

// ; Scratch registers
#define X  R10
#define Y  R11
#define Q  R12
#define T  R13
// nc  R14
// nc  R15


// ; T.I. Integer Subroutines Definitions
#define IROP1   TOS
#define IROP2L  R10
#define IROP2M  R11
#define IRACL   R12
#define IRACM   R13
#define IRBT    W  

// ; INDIRECT-THREADED NEXT

NEXT    MACRO
        MOV @IP+,W     // ; fetch word address into W
        MOV @W+,PC     // ; fetch code address into PC, W=PFA
        ENDM

// ; BRANCH DESTINATION (RELATIVE BRANCH)
// ; For relative branch addresses, i.e., a branch is ADD @IP,IP

DEST    MACRO   label
        DW      label-$
        ENDM

// ; HEADER CONSTRUCTION MACROS

HEADER  MACRO   asmname,length,litname,action
        PUBLIC  asmname
        DW      link
        DB      0FFh       ; not immediate
link    SET     $
        DB      length
        DB      litname
        EVEN
        IF      'action'='DOCODE'
asmname: DW     $+2
        ELSE
asmname: DW      action
        ENDIF
        ENDM

HEADLESS  MACRO   asmname,action
        PUBLIC  asmname
        IF      'action'='DOCODE'
asmname: DW     $+2
        ELSE
asmname: DW      action
        ENDIF
        ENDM

IMMED   MACRO   asmname,length,litname,action
        PUBLIC  asmname
        DW      link
        DB      0FEh      // ; immediate (LSB=0)
link    SET     $
        DB      length
        DB      litname
        EVEN
        IF      'action'='DOCODE'
asmname: DW     $+2
        ELSE
asmname: DW      action
        ENDIF
        ENDM

HEADERLESS  MACRO   asmname,length,litname,action
        PUBLIC  asmname
        IF      'action'='DOCODE'
asmname: DW     $+2
        ELSE
asmname: DW      action
        ENDIF
        ENDM