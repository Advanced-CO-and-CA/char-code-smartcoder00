/*************************************************************************************************
* file: char_code.s (Lab Assingment-4)                                                           *
* Author: Jethin Sekhar R (CS18M523)                                                             *
* Assembly code for Character-Coded Data                                                         *
*    Part 1: Compare two strings of ASCII characters to see which is larger                      *
*    Part 2: Given two strings, check whether the second string is a substring of the First one  *
*************************************************************************************************/
@ bss section
    .bss

@ data section
    .data
    result_start:         .word 0                   @ Part1 Test A Result
                          .word 0                   @ Part1 Test B Result
                          .word 0                   @ Part1 Test C Result
                          .word 0                   @ Part2 Test A Result
                          .word 0                   @ Part2 Test B Result
                          .word 0                   @ Part2 Test C Result

    part1_str_len:        .word     3
    part1_str1:           .ascii    "CAT"
    part1_str2:           .ascii    "BAT"
    part1_str3:           .ascii    "CUT"

    part2_str1:           .asciz    "CS6620"
    part2_str2:           .asciz    "SS"
    part2_str3:           .asciz    "620"
    part2_str4:           .asciz    "6U"

@ text section
      .text

@Function : CompareString                           @ Accepts 3 params and compares for fixed length
.global _fnCompareString                            @ Param1 : String1
                                                    @ Param2 : String2
                                                    @ Param3 : Length
                                                    @ Return : Greater(0xFFFFFFFF) or Not(0x00000000)

@Function : FindSubString                           @ Accepts 2 params and finds substring
.global _fnFindSubString                            @ Param1 : String1
                                                    @ Param2 : String2
                                                    @ Return : Sub String Index, 0 if not found

@ Globals Defines for Functions
retVal               .req r0                        @ Return Value
param1               .req r1                        @ Function Param1
param2               .req r2                        @ Function Param2
param3               .req r3                        @ Function Param3
param4               .req r4                        @ Function Param4
temp                 .req r8                        @ Temporary Variable
temp1                .req r8                        @ Temporary Variable
temp2                .req r9                        @ Temporary Variable

.global _main
    bl _main

.global _fnstrlen

/*** main Function ******************************************************************************/
_main:
    mov  temp, #0
    ldr  param1, =part1_str1                        @ Part 1 TestA "CAT" & "BAT"
    ldr  param2, =part1_str2                        @   Params String1, String2, Length
    ldr  param3, =part1_str_len                     @
    ldr  param3, [param3]                           @
    bl   _fnCompareString                           @ Function Call to Compare String
    mov   param1, temp                              @ Store the Result and increment
    bl   _fnStoreResult                             @    Result Store Index
    add  temp, #4                                   @

    ldr  param1, =part1_str1                        @ Part 1 TestB "CAT" & "CAT"
    ldr  param2, =part1_str1                        @   Params String1, String2, Length
    ldr  param3, =part1_str_len                     @
    ldr  param3, [param3]                           @
    bl   _fnCompareString                           @ Function Call to Compare String
    mov   param1, temp                              @ Store the Result and increment
    bl   _fnStoreResult                             @    Result Store Index
    add  temp, #4                                   @

    ldr  param1, =part1_str1                        @ Part 1 TestB "CAT" & "CUT"
    ldr  param2, =part1_str3                        @   Params String1, String2, Length
    ldr  param3, =part1_str_len                     @
    ldr  param3, [param3]                           @
    bl   _fnCompareString                           @ Function Call to Compare String
    mov   param1, temp                              @ Store the Result and increment
    bl   _fnStoreResult                             @    Result Store Index
    add  temp, #4                                   @

    ldr  param1, =part2_str1                        @ Part 2 TestA "CS6620" & "SS"
    ldr  param2, =part2_str2                        @   Params String1, String2
    bl   _fnFindSubString                           @
    mov   param1, temp                              @ Store the Result and increment
    bl   _fnStoreResult                             @    Result Store Index
    add  temp, #4                                   @

    ldr  param1, =part2_str1                        @ Part 2 TestB "CS6620" & "620"
    ldr  param2, =part2_str3                        @   Params String1, String2
    bl   _fnFindSubString                           @
    mov   param1, temp                              @ Store the Result and increment
    bl   _fnStoreResult                             @    Result Store Index
    add  temp, #4                                   @

    ldr  param1, =part2_str1                        @ Part 2 TestB "CS6620" & "6U"
    ldr  param2, =part2_str4                        @   Params String1, String2
    bl   _fnFindSubString                           @
    mov   param1, temp                              @ Store the Result and increment
    bl   _fnStoreResult                             @    Result Store Index

    bl   _end_of_program                            @ End of the program is here

/*** Function: FindSubString *******************************************************************/
str1_Idx             .req r4                        @ Index String1
str2_Idx             .req r5                        @ Index String2
sub_str_idx          .req r6                        @

_fnFindSubString:                                   @ Find SubString Index
    push  {str1_Idx, str2_Idx, sub_str_idx, lr}     @ Store local variables & return address to stack
    push  {temp1, temp2}                            @ Store temp variables in stack
    mov   sub_str_idx, #0                           @ Initialize Sub String Index
  _fnFindSubString_find:                            @ Loop to Begin Searching
    mov   str1_Idx, sub_str_idx                     @ Initialize String1 Index
    mov   str2_Idx, #0                              @ Initialize String2 Index
    ldrb  temp2, [param2, str2_Idx]                 @ Read String2 Start Character
  _fnFindSubString_loop:                            @ Loop to look for first character
    ldrb  temp1, [param1, str1_Idx]                 @ Read String1 Characters
    add   str1_Idx,  #1                             @ Increment String1 Index
    movs  temp1, temp1                              @ Check for null character
    beq   _fnFindSubString_mot_found                @ Sub string not found
    cmp   temp1, temp2                              @ Compare Characters and continue searching
    bne   _fnFindSubString_loop                     @   if characters are not matching otherwise -
    mov   sub_str_idx, str1_Idx                     @   continue with substring matching
    sub   str1_Idx, #1                              @
  _fnFindSubString_loop2:                           @ Substring Matching loop
    add   str1_Idx,  #1                             @ Increment String1 Index
    add   str2_Idx,  #1                             @ Increment String1 Index
    ldrb  temp1, [param1, str1_Idx]                 @ Read String1 characters
    ldrb  temp2, [param2, str2_Idx]                 @ Read String2 characters
    movs  temp2, temp2                              @ Check for String2 null char
    beq   _fnFindSubString_found                    @ If null char found, finish search
    cmp   temp1, temp2                              @ Compare Characters and continue matching -
    beq   _fnFindSubString_loop2                    @    if values are matching otherwise -
    movs  temp1, temp1                              @    check of end string1 and restart searching -
    bne   _fnFindSubString_find                     @    Stop if null char found.
  _fnFindSubString_mot_found:                       @
    movs  sub_str_idx, #0                           @ Reset Result
  _fnFindSubString_found:                           @
    movs  retVal, sub_str_idx                       @ Update Result, This contain substring index
  _fnFindSubString_end:                             @
    pop   {temp1, temp2}                            @ Restore temp variables from stack
    pop   {str1_Idx, str2_Idx, sub_str_idx, pc}     @ Restore all values and return

/*** Function: CompareString *******************************************************************/
_fnCompareString:                                   @ Compare two strings
    push  {temp1, temp2, lr}                        @ Store local variables & return address to stack
    mov   retVal, #0                                @ Initialize Result
  _fnCompareString_loop:                            @ Loop for comparison
    ldrb  temp1, [param1], #1                       @ Read String Characters
    ldrb  temp2, [param2], #1                       @ Read String Characters
    cmp   temp1, temp2                              @ Compare characters and stop itterations if -
    bne   _fnCompareString_ne                       @    not equal
    subs  param3, #1                                @ Decrement Length of string and stop if -
    bne   _fnCompareString_loop                     @    reached end of string otherwise -
    b     _fnCompareString_end                      @    continue comparison
  _fnCompareString_ne:
    bgt   _fnCompareString_end                      @ Dont update retVal if string is less or equal
    sub   retVal, #1                                @ Set 0xFFFFFFFF if String2 is greater
  _fnCompareString_end:
    pop   {temp1, temp2, pc}                        @ Restore all values and return

/*** Function: storeResult **********************************************************************/
_fnStoreResult:                                     @ Store Result, Recevies Index and retVal
    push  {temp, lr}
    ldr   temp, =result_start
    str   retVal, [temp1, param1]
    pop   {temp, pc}

/*** Function: strlen ***************************************************************************/
_fnstrlen:                                          @ Calculate Length of a String
    push  {temp, lr}
    mov   retVal, #0
  _fnstrlen_loop:
    ldrb  temp, [param1], #1
    movs  temp, temp
    addne retVal, #1
    bne   _fnstrlen_loop
    pop  {temp, pc}

/*** End ****************************************************************************************/
_end_of_program:
    .end