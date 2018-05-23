# 4e4th eZ430 project for IAR Kickstarter - snapshot

4e4th and application will run ON this chip.

Based on 4e4th Release 0.34 for the TI MSP430G2553 Value Line LaunchPad Develpoment Tool (MSP-EXP430G2), Rev. 1.5 chip.  
Based on CamelForth MSP430 V0.3 that Bard Rodriguez has created for the MSP430F1611. 

## Assembling 4e4th
The project has been created using IAR Kickstart. Add it to IAR Kickstart as exsiting project. 

The free version of IAR can only program projects up to 4K. If the file is larger, you can use a BSL scripter tool like the FET-Pro430 Flash Programmer by Elprotronic. To be able to use an external scripter tool, **IAR must be configured** to output the file in Intel Hex Format. Select project options, Linker output, check "Override default" an enter 4e4th-eZ430.hex as output filename. And select "other output format = intel extended". This will create an image file using Intel Hex format in the folder Debug/Exe, which can be programmed into the MCU using the FET-Pro430 tool. 

## Try it out directly
It is easy to program 4e4th into the board.  
Download and install the free 430 version of the elprotronic programmer at  
 https://www.elprotronic.com/productdata;jsessionid=8FA5E1E626677AABC3683EC0D712B01F  
Select the correct processor 430G2553, point to the hex file you find here and follow the steps.  
Do not forget RESET after programming.

Then start your favourite Terminal program and start writing short examples, like in:  
https://wiki.forth-ev.de/doku.php/en:projects:a-start-with-forth:start0  
and there probably chapter 11c as a good starting point.

- New to 4e4th?  
Go through the documentation at https://wiki.forth-ev.de/doku.php/en:projects:4e4th:start  
Read readme.430, releasenotes.txt, msp430development.pdf and CFvs4e4th05a.pdf to learn more.  
Check out other 4e4th projects on github. 

- Need the Programmer?  
https://www.elprotronic.com/  
"Lite FET-Pro430 Elprotronic Programmer" burns image into MCU.

- More books  
https://wiki.forth-ev.de/doku.php/en:projects:litlist  
and  
https://wiki.forth-ev.de/doku.php/en:projects:pintaske_s_electronic_forth_bookshelf

## Verification


23 May 2018  
---
## Annotation
The reset procedure executes BOOT. If there is a valid application it will start. Else WIPE is executed. 

After executing SAVE the Forth state will survive a reset. Connecting P1.3 to GND during reset will force a WIPE. This way 4e4th can be resurrected from the dead(lock).

Have fun.

