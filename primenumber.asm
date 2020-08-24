.686
.model flat, stdcall
option casemap :none

include \masm32\include\windows.inc
include \masm32\include\kernel32.inc
include \masm32\include\masm32.inc
include \masm32\include\msvcrt.inc
includelib \masm32\lib\kernel32.lib
includelib \masm32\lib\masm32.lib
includelib \masm32\lib\msvcrt.lib
include \masm32\macros\macros.asm


.data
;----- VARIAVEIS UTILIZADAS NO SISTEMA -----
integer1 dword ? ; VARIAVEL 
defined_eax dword ? ; EAX DEFINED

;-------------------------------------------

;----- MENSAGENS DO SISTEMA -----
is_prime_message db "O numero eh primo", 0h; MENSAGEM DE QUE O NUMERO EH PRIMO
is_not_prime_message db " O numero nao eh primo", 0h ; MENSAGEM DE QUE O NUMERO NAO EH PRIMO
;--------------------------------

;----- RECEBE INPUT ( "SCANF" ) -----
request db "Digite um numero: ", 0h; REQUISICAO DE NUMERO VIA CONSOLE
newLine db 0AH; pula linha
inputString db 10 dup(0)
outputString db 10 dup(0)
;------------------------------------

;----------STARTA A ESTRUTURA DOS HANDLES----------
inputHandle dd 0
outputHandle dd 0
console_count dd 0
tam_outputString dd 0
;--------------------------------------------------


.code
start:
    
    invoke GetStdHandle, STD_INPUT_HANDLE
    mov inputHandle, eax
    invoke GetStdHandle, STD_OUTPUT_HANDLE
    mov outputHandle,eax

    invoke WriteConsole, outputHandle, addr request, sizeof request, addr console_count, NULL ; pega o input do numero
    invoke ReadConsole, inputHandle, addr inputString, sizeof inputString, addr console_count, NULL ; le se o numero

    mov esi, offset inputString

;----- VERIFICACAO DOS DIGITOS E SUA CONVERSAO BIT A BIT-----
proximo:
    mov al, [esi] ; codigo de verifaçao dos digitos e sua conversao apos
    inc esi
    cmp al, 48
    jl terminar
    cmp al, 58
    jl proximo

terminar:
    dec esi
    xor al, al
    mov [esi], al

invoke atodw, addr inputString ; conversao ascII para binaria
mov integer1, eax
;------------------------------------------------------------


;----- ALGORITIMO -----
mov ecx,2 ; CONTADOR

mov defined_eax, eax; EAX DEFINED
print str$(defined_eax),13,10 ; NAO TIRA


cmp eax, 2 ; INICIA VERIFICANDO O 2 COMO PRIMEIRO NUMERO PRIMO
jl isNotPrime
je isPrime

cmp eax, 3
je isPrime


primeLoop:
    ;LOGICA, COMPARAR EAX(input) com ECX(contador) E CASO IGUAIS
    ;OS MESMOS SAO PRIMOS POR SEREM SEUS DIVISORES
            
    cmp eax, ecx ; SE IGUAL, EH PRIMO
    je isPrime
    
    mov ebx, ecx ; MOVA PARA EBX, O ECX(2)
          
    div ebx; EAX/ECX
    mov eax, defined_eax

    cmp edx, 0; EDX resto
    je isNotPrime
    inc ecx
    jmp primeLoop


isPrime:
    invoke dwtoa, eax, addr outputString; converte de volta para String
    invoke StrLen, addr outputString ; determinando tamnho da String resultante
    mov tam_outputString, eax

    invoke WriteConsole, outputHandle, addr is_prime_message, sizeof is_prime_message, addr console_count, NULL ; imprime o numero eh primo
    invoke WriteConsole, outputHandle, addr outputString, tam_outputString, addr console_count, NULL ; o numero 
    invoke WriteConsole, outputHandle, addr newLine, sizeof newLine, addr console_count, NULL ; pula linha
    
    
    invoke ExitProcess, 0  
        
isNotPrime:
    invoke dwtoa, eax, addr outputString; converte de volta para String
    invoke StrLen, addr outputString ; determinando tamnho da String resultante
    mov tam_outputString, eax

    invoke WriteConsole, outputHandle, addr is_not_prime_message, sizeof is_not_prime_message, addr console_count, NULL ; IMPRIME O NUMERO NAO EH PRIMO
    invoke WriteConsole, outputHandle, addr outputString, tam_outputString, addr console_count, NULL ; o numero 
    invoke WriteConsole, outputHandle, addr newLine, sizeof newLine, addr console_count, NULL ; pula linha
       
    invoke ExitProcess, 0  
end start