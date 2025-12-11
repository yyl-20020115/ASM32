; Seattle Computer Products 8086 Assembler  version 2.44
;   by Tim Paterson
; Runs on the 8086 under MS-DOS

;* * * * * * REVISION HISTORY * * * * * *
;
; 12/29/80  2.01  General release with 86-DOS version 0.34
; 02/22/81  2.10  Increased buffer size from 128 bytes to 1024 bytes
; 03/18/81  2.11  General cleanup and more documentation
; 03/24/81  2.20  Modify ESC handling for full 8087 operation
; 04/01/81  2.21  Fix date in HEX and PRN files; modify buffer handling
; 04/03/81  2.22  Fix 2.21 buffer handling
; 04/13/81  2.23  Re-open source file for listing to allow assembling CON:
; 04/28/81  2.24  Allow nested IFs
; 07/30/81  2.25  Add Intel string mnemonics; clean up a little
; 08/02/81  2.30  Re-write pass 2:
;			Always report errors to console
;			Exact byte lengths for HEX and PRN files
; 11/08/81  2.40  Add 8087 mnemonics; print full error messages;
;		  allow expressions with *, /, and ()
; 07/04/82  2.41  Fix Intel's 8087 "reverse-bit" bug; don't copy date
; 08/18/82  2.42  Increase stack from 80 to 256 (Damn! Overflowed again!)
; 01/05/83  2.43  Correct over-zealous optimization in 2.42
; 05/09/83  2.44  Add memory usage report
;
;* * * * * * * * * * * * * * * * * * * * *

SYMWID:	EQU	5	;5 symbols per line in dump
FCB:	EQU	5CH
BUFSIZ:	EQU	1024	;Source code buffer
LSTBUFSIZ:EQU	BUFSIZ	;List file buffer
HEXBUFSIZ:EQU	70	;Hex file buffer (26*2 + 5*2 + 3 + EXTRA)
EOL:	EQU	13	;ASCII carriage return
OBJECT:	EQU	100H	;DEFAULT "PUT" ADDRESS

;System call function codes
PRINTMES: EQU	9
OPEN:	EQU	15
CLOSE:	EQU	16
READ:	EQU	20
SETDMA:	EQU	26
MAKE:	EQU	22
BLKWRT:	EQU	40

;The following equates define some token values returned by GETSYM
UNDEFID:EQU	0	;Undefined identifier (including no nearby RET)
CONST:	EQU	1	;Constant (including $)
REG:	EQU	2	;8-bit register
XREG:	EQU	3	;16-bit register (except segment registers)
SREG:	EQU	4	;Segment register
FREG:	EQU	6	;8087 floating point register

;Bits to build 8087 opcode table entries
ONEREG:	EQU	40H	;Single ST register OK as operand
NEEDOP:	EQU	80H	;Must have an operand
INTEGER:EQU	20H	;For integer operations
REAL:	EQU	28H	;For real operations
EXTENDED EQU	10H	;For Long integers or Temporary real
MEMORY:	EQU	18H	;For general memory operations
STACKOP:EQU	10H	;Two register arithmetic with pop
ARITH:	EQU	8	;Non-pop arithmetic operations

