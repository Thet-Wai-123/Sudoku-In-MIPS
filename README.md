# Sudoku-In-MIPS-Assembly

## Purpose

The purpose of this project is a simple Sudoku game, with an interactive ruleset that tells the user when the input violates on of the rule.

## Instruction

To run this, make sure to have the option to assemble all the files in the directory as the main file uses functions from another file. In MARS, it is in setting->checkbox for assemble all files in directory. The main code is in main.asm, which links the global functions and macros from other files.

When the game starts, a partially filled Sudoku board is displayed, and the user is prompted to enter a move. This MIPS Sudoku game is a 9×9 puzzle where players fill empty cells so that each number from 1 to 9 appears only once in every row and column. Players are prompted to input a row number (1–9), a column number (1–9), and a value (1–9) to insert into the selected cell. If the user enters 0 as the value, the selected cell will be cleared. The program checks the row and column for duplicate entries of the value, and if a conflict is found, an error message is displayed and the user is asked to try again. The board updates after each move and runs continuously until manually stopped. The program will end once all the cells are filled.

## Made by

Craig Chan, Nicholas Garcia, Theoden Melgar, Thet Wai  
CS 2640 Final Project  
May 11, 2025
