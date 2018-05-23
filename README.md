# 4e4th - IAR Kickstarter snapshot

4e4th Release 0.34 for the TI MSP430G2553 Value Line LaunchPad Develpoment Tool (MSP-EXP430G2), Rev. 1.5 chip.  
One of the few processors still available in the breadboard friendy 20 Pin DIL Package.  
4e4th and application will run ON this chip.

It is based on CamelForth MSP430 V0.3 that Bard Rodriguez has created for the MSP430F1611. 

## Assembling 4e4th
The project has been created using IAR Kickstart. To build the project, proceed as documented in readme.430. Add 4e-aLP430.s43 to the project. Instead of init430f1611.s43 and vecs430f1611.s43 use 4e-init430G2553.s43, and 4e-vecs430G2553.s43. Add all 4e-info files too. 

The free version of IAR can only program projects up to 4K. If the file is larger, you can use a BSL scripter tool like the FET-Pro430 Flash Programmer by Elprotronic. To be able to use an external scripter tool, **IAR must be configured** to output the file in Intel Hex Format. Select the option "Output file override" under Project/Options/Linker/Output and "other output format = intel extended". This will create a file 4e4th.a43 using Intel Hex format in the folder Debug/Exe. This file can be programmed into the MCU using the FET-Pro430 tool. 

## Try it out directly
It is easy to program 4e4th into the TI MSP430 Launchpad.  
Download and install the free 430 version of the elprotronic programmer at  
 https://www.elprotronic.com/productdata;jsessionid=8FA5E1E626677AABC3683EC0D712B01F  
Select the correct processor 430G2553, point to the hex file you find here and follow the steps.  
Do not forget RESET after programming.

Then start your favourite Terminal program and start writing short examples, like in:  
https://wiki.forth-ev.de/doku.php/en:projects:a-start-with-forth:start0  
and there probably chapter 11c as a good starting point.

## Start with Forth  
- Quickstart  
Connect to 4e4th on your Launchpad using a terminal emulator.  
Compile and save demo forth application: blink.4th  
4e4th is case insensitive, you may type WORDS upper- or lower case.

- New to Forth?  
https://wiki.forth-ev.de/doku.php/en:projects:a-start-with-forth:start0  
There are various Forth systems mentioned, but the handling is the same.

- New to the TI LaunchPad?  
https://wiki.forth-ev.de/doku.php/projects:4e4th:start

- New to 4e4th?  
Go through the documentation at https://wiki.forth-ev.de/doku.php/en:projects:4e4th:start  
Read readme.430, releasenotes.txt, msp430development.pdf and CFvs4e4th05a.pdf to learn more.

- Need the Programmer?  
https://www.elprotronic.com/  
"Lite FET-Pro430 Elprotronic Programmer" burns image into MCU.

- More books  
https://wiki.forth-ev.de/doku.php/en:projects:litlist  
and  
https://wiki.forth-ev.de/doku.php/en:projects:pintaske_s_electronic_forth_bookshelf

## Verification


19 May 2018  
---
## Annotation
The reset procedure executes BOOT. If there is a valid application it will start. Else WIPE is executed. 

After executing SAVE the Forth state will survive a reset. Pressing and holding button S2 during reset will force a WIPE. This way 4e4th can be resurrected from the dead(lock).

Have fun.

