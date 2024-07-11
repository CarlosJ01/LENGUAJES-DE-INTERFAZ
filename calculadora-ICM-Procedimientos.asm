name "Calculadora ICM Procedimientos"
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
    ;Inicio
    MOV AX, @DATA
    MOV DS, AX
    
    LEA DX, msg1
    MOV AH, 9
    INT 21h
    
    ;Pedir el peso y altura
    CALL pLeerPeso
    CALL pLeerAltura
    
    ;Imprimir separador
    LEA DX, linea
    MOV AH, 9
    INT 21h
    
    ;Calculrar la ICM y mostrar los digitos de los numeros
    CALL pCalcularICM
    CALL pMostrarDigitos
    MOV DL, "."
    INT 21h
    MOV AX, decimal
    MOV DX, 0
    MOV BL, 10
    DIV BL
    CALL pMostrarDigitos
    
    ;Decicion depende del IMC
    LEA DX, msg5
    MOV AH, 9
    INT 21h
    CALL pDecicion
    
    ;Salir
    .exit
    
pLeerPeso PROC
    LEA DX, msg2
    INT 21h 
    MOV SI, 0
    
    leerPeso:
        ;Solo 3 digitos
        CMP SI, 3
        JE salirPLeerPeso
        
        ;Pedir dato
        MOV AH, 1
        INT 21h
        
        CMP AL, 0Dh
        JE comparacionPeso 
        
        ;Quitamos 30h al numero capturado
        MOV aux, AL
        SUB aux, 30h 
         
        
        ;Unidades, Decenas o Centenas depende del indice
        CMP SI, 0
        JE centenasPeso
        CMP SI, 1
        JE decenasPeso
        CMP SI, 2
        JE unidadesPeso
        
        ;Unidades, Decenas o Centenas se multiplican por 100 o 10 o 1 dependiendo y se suman al numero
        unidadesPeso:
            MOV AL, 1
            MUL aux
            ADD peso, AX
            JMP cicloPeso
        decenasPeso:
            MOV AL, 10
            MUL aux
            ADD peso, AX
            JMP cicloPeso
        centenasPeso:
            MOV AL, 100
            MUL aux 
            ADD peso, AX
            JMP cicloPeso
        
        ;Incrementa el indice y regresa al ciclo
        cicloPeso:
            INC SI
            JMP leerPeso
        
  
    
    ;Casos de ENTER para el peso
    comparacionPeso:
        CMP SI, 0
        JE leerPeso
        CMP SI, 1
        JE  centenasP
        CMP SI, 2
        JE  decenasP
    
    decenasP:
        MOV AX, peso
        MOV DX, 0
        MOV BX, 10
        div BX
        MOV peso, AX
        JMP salirPLeerPeso
    
    centenasP:
        MOV AX, peso
        MOV DX, 0
        MOV BX, 100
        div BX
        MOV peso, AX
        JMP salirPLeerPeso
    
    salirPLeerPeso:
        RET
pLeerPeso ENDP

pLeerAltura PROC
    LEA DX, msg3
    MOV AH, 9
    INT 21h 
    MOV SI, 0
    
    leerAltura:
        ;Solo 3 digitos
        CMP SI, 3
        JE salirPLeerAltura
               
        ;Pedir dato
        MOV AH, 1
        INT 21h
               
        
        ;Quitamos 30h al numero capturado
        MOV aux, AL
        SUB aux, 30h
        
        ;Unidades, Decenas o Centenas depende del indice
        CMP SI, 0
        JE centenasAltura
        CMP SI, 1
        JE decenasAltura
        CMP SI, 2
        JE unidadesAltura
        
        ;Unidades, Decenas o Centenas se multiplican por 100 o 10 o 1 dependiendo y se suman al numero 
        unidadesAltura:
            MOV AL, 1
            MUL aux
            ADD altura, AX
            JMP cicloAltura
        
        decenasAltura:
            MOV AL, 10
            MUL aux
            ADD altura, AX
            JMP cicloAltura
            
        centenasAltura:
            MOV AL, 100
            MUL aux 
            ADD altura, AX
            JMP cicloAltura
        
        ;Incrementa el indice y regresa al ciclo
        cicloAltura:
            INC SI
            JMP leerAltura
        
        salirPLeerAltura:
            RET 
pLeerAltura ENDP

pCalcularICM PROC
    ;Cuadrado de la estatura
    MOV AX, altura
    MUL altura
    MOV altura, AX
        
    ;Dividir Peso / estatura^2
    ;Multiplicar el peso por 10000 para igualar los centimetros
    MOV AX, 10000
    MUL peso
    
    ;Divicion
    DIV altura
    MOV resultado, AX
    MOV modulo, DX
    
    ;Optener decimal a 2 digitos
    MOV AX, 100
    MUL modulo
    DIV altura
    
    MOV decimal, AX
    
    ;Mostrar el IMC
    LEA DX, msg4
    MOV AH, 9
    INT 21h
    
    ;Divicion para mostrar los digitos de la parte entera
    MOV AX, resultado
    MOV DX, 0
    MOV BL, 10
    DIV BL
    RET
pCalcularICM ENDP

pMostrarDigitos PROC
    MOV dig1, AL
    MOV dig2, AH
    ADD dig1, 30h
    ADD dig2, 30h    
    MOV AH, 2
    MOV DL, dig1
    INT 21h
    MOV DL, dig2
    INT 21h
    RET
pMostrarDigitos ENDP

pDecicion PROC
    ;Decidir el estado
    CMP resultado, 18
    JNG pesoBajo
    
    CMP resultado, 25
    JNG pesoNormal
    
    CMP resultado, 30
    JNG pesoSobre
    JNLE pesoObesidad
    
    pesoBajo:
        LEA DX, bajo
        INT 21h
        RET
        
    pesoNormal:
        LEA DX, normal
        INT 21h
        RET
    
    pesoSobre:
        LEA DX, sobrepeso
        INT 21h
        RET
    
    pesoObesidad:
        LEA DX, obecidad
        INT 21h
        RET
pDecicion ENDP 