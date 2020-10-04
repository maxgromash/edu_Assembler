format PE console

entry start

include 'win32a.inc'

section '.data' data readable writable

;-------Вариант 8 Гребенщиков Максим Михайлович БПИ194---------------------------------------------------------------------------------------------------------------------------------------

        enterLength db 'Enter length of array: ', 0
        formatNum db '%d', 0
        formatNumOutput db '%d ', 0
        itemNumber db 'Number %d: ', 0
        wrong db 'Wrong input!',0

        size dd ?
        X dd ?

        array rd 100
        sortedArray rd 100

        NULL = 0

section '.code' code readable executable
;------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
        start:

               call inputArray
               call sortArray
               call outputArray

         finish:
               call [getch]
               push NULL
               call [ExitProcess]

;---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
        sortArray:

               mov ebx, 0
               lp3:
                        mov ecx, [array+ebx*4]
                        add ecx, 5
                        mov edx, [array+ebx*4]
                        sub edx, 5

                        cmp [array+ebx*4], -5
                        jl  lessThanMinusFive

                        cmp [array+ebx*4], 5
                        jg moreThanFive

                        mov [sortedArray+ebx*4], 0

                        endlp3:
                        add ebx, 1
                        cmp ebx, [size]
               jne lp3
               ret

               lessThanMinusFive:
               mov [sortedArray+ebx*4], edx
               jmp endlp3

               moreThanFive:
               mov [sortedArray+ebx*4], ecx
               jmp endlp3
;------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

        inputArray:
               push enterLength
               call [printf]
               add esp, 4

               push size
               push formatNum
               call[scanf]
               add esp, 8

               cmp [size], 1
               jl wrongInput

               cmp [size], 100
               jg wrongInput


               mov ebx, 0
               lp:

                        mov eax, ebx
                        add eax, 1

                        push eax
                        push itemNumber
                        call[printf]
                        add esp, 8

                        push X
                        push formatNum
                        call[scanf]
                        add esp, 8

                        mov eax, [X]
                        mov [array+ebx*4], eax

                        add ebx, 1
                        cmp ebx, [size]
               jne lp
               ret

        wrongInput:
                push wrong
                call [printf]
                jmp finish



;--------------------------------------------------------------------------------------------------------------------------------------------------------------------------
        outputArray:
               mov ebx, 0
               lp2:
                        push [sortedArray+ebx*4]
                        push formatNumOutput
                        call[printf]
                        add esp, 8

                        add ebx, 1
                        cmp ebx, [size]
               jne lp2
               ret

;--------------------------------------------------------------------------------------------------------------------------------------------------------------------------

section '.idata' import data readable

        library kernel, 'kernel32.dll',\
                msvcrt, 'msvcrt.dll'

        import kernel,\
               ExitProcess, 'ExitProcess'

        import msvcrt,\
               printf, 'printf',\
               getch, '_getch',\
               scanf, 'scanf'
;------------------------------------------------------------------------------------------------------------------------------------------------------------------------