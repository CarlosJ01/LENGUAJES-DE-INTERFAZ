name "Calculadora ICM Macros"

;Imprimir una variable
imprimirVariable macro variable
  LEA DX, variable
  MOV AH, 9
  INT 21h
endm

; Leer 3 digitos y guardarlos
leerNumero3 macro numero leerNumeroCiclo salirLeerNumero3  comparacion  centenasNumero  decenasNumero unidadesNumero cicloNumero comparacion  centenas decenas
  MOV SI, 0
  
  leerNumeroCiclo:
    ;Solo 3 digitos
    CMP SI, 3
    JE salirLeerNumero3
    
    ;Pedir dato
    MOV AH, 1
    INT 21h
    
    CMP AL, 0Dh
    JE comparacion 
    
    ;Quitamos 30h al numero capturado
    MOV aux, AL
    SUB aux, 30h
    
    ;Unidades, Decenas o Centenas depende del indice
    CMP SI, 0
    JE centenasNumero
    CMP SI, 1
    JE decenasNumero
    CMP SI, 2
    JE unidadesNumero
    unidadesNumero:
        MOV AL, 1
        MUL aux
        ADD numero, AX
        JMP cicloNumero
    decenasNumero:
        MOV AL, 10
        MUL aux
        ADD numero, AX
        JMP cicloNumero
    centenasNumero:
        MOV AL, 100
        MUL aux 
        ADD numero, AX
        JMP cicloNumero                         
    ;Ciclo para segir leyendo
    cicloNumero:
        INC SI
        JMP leerNumeroCiclo
    ;Comparaciones para cuando se preciona un enter
    comparacion:
        CMP SI, 0
        JE leerNumeroCiclo
        CMP SI, 1
        JE  centenas
        CMP SI, 2
        JE  decenas
    centenas:
        MOV AX, numero
        MOV DX, 0
        MOV BX, 100
        div BX
        MOV numero, AX
        JMP salirLeerNumero3
    decenas:
        MOV AX, numero
        MOV DX, 0
        MOV BX, 10
        div BX
        MOV numero, AX
        JMP salirLeerNumero3
    
    salirLeerNumero3:
endm

;Imprimir un numero de 2 digitos
imprimirNumero2 macro numero
    ;Dividir para optener 2 numeros
    MOV AX, numero
    MOV DX, 0
    MOV BL, 10
    DIV BL
    ;Mostrar los digitos 
    MOV dig1, AL
    MOV dig2, AH
    ADD dig1, 30h
    ADD dig2, 30h
    
    imprimirCaracter dig1
    imprimirCaracter dig2
endm

;Imprimir un caracter
imprimirCaracter macro caracter
    MOV AH, 2
    MOV DL, caracter
    INT 21h
endm

.MODEL SMALL
.STACK 999h

.DATA
    ;Mensajes
    msg1 db "Calculadora de IMC $"
    msg2 db 0Dh, 0Ah,0Dh,0Ah, "Peso (000 kg) : ",0Dh,0Ah,"$"
    msg3 db 0Dh, 0Ah,0Dh,0Ah, "Altura (000 cm) : ",0Dh,0Ah, "$"
    linea db 0Dh, 0Ah,0Ah, "-----------------------------------------------------------$"
    msg4 db 0Dh, 0Ah,0Ah, "IMC : $"
    msg5 db 0Dh, 0Ah,0Ah, "Estado : $"
    obecidad db "Obesidad$"
    sobrepeso db "Sobrepeso$"
    normal db "Normal$"
    bajo db "Bajo de Peso$"
    
    ;Variables
    peso dw 0
    altura dw 0
    aux db 0
    resultado dw 0
    modulo dw 0
    decimal dw 0
    dig1 db 0
    dig2 db 0

.CODE
    MOV AX, @DATA
    MOV DS, AX
    
    ;Imprimir mensaje de bienvenida
    imprimirVariable msg1
    
    ;Leer peso
    imprimirVariable msg2
    leerNumero3 peso e11 e12  e13 e14 e15 e16 e17 e18 e19 e120
    
    ;Leer altura
    imprimirVariable msg3
    leerNumero3 altura e21 e22  e23 e24 e25 e26 e27 e28 e29 e220
    
    ;Calcular ICM
    ;Cuadrado de la estatura
    MOV AX, altura
    MUL altura
    MOV altura, AX
    ;Multiplicar el peso por 10000 para igualar los centimetros
    MOV AX, 10000
    MUL peso
    ;Dividir Peso / estatura^2
    DIV altura
    MOV resultado, AX
    MOV modulo, DX
    ;Optener decimal a 2 digitos
    MOV AX, 100
    MUL modulo
    DIV altura
    MOV decimal, AX
    
    ;Mostrar ICM
    imprimirVariable msg4
    imprimirNumero2 resultado
    imprimirCaracter "."
    imprimirNumero2 decimal
    
    ;Mostrar mensaje dependiendo del ICM
    imprimirVariable msg5
    
    CMP resultado, 18
    JNG pesoBajo
    CMP resultado, 25
    JNG pesoNormal
    CMP resultado, 30
    JNG pesoSobre
    JNLE pesoObesidad
    
    pesoBajo:
        imprimirVariable bajo
        JMP salir
    pesoNormal:
        imprimirVariable normal
        JMP salir
    pesoSobre:
        imprimirVariable sobrepeso
        JMP salir
    pesoObesidad:
        imprimirVariable obecidad
        JMP salir
    
    salir:
        .exit