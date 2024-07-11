
name "Conversiones Macros"

;---------------------------------------------MACROS-----------------------------------------
             
;Imprimir una variable
imprimirVariable macro variable
    LEA DX, variable
    MOV AH, 9
    INT 21h
endm

;Imprimir caracter
imprimirCaracter macro
    MOV DX, BX
    MOV AH, 2
    INT 21h
endm

;Imprimir 6 variables
imprimir6 macro var1, var2, var3, var4, var5, var6
       
    MOV AH, 9
    LEA DX, var1 ;opcion1
    INT 21h
    LEA DX, var2 ;opcion2
    INT 21h
    LEA DX, var3 ;opcion3
    INT 21h
    LEA DX, var4 ;opcion4
    INT 21h 
    LEA DX, var5 ;opcion5
    INT 21h 
        
    LEA DX, var6 ;select
    INT 21h
endm 

;Imprime un salto de Linea      
imprimirEnter macro
    MOV DX, 20h
    MOV AH, 9
    INT 21h  
endm

;Ingresar valor
ingresar macro
    MOV DX, 0
    MOV AH, 1
    INT 21h  
endm

;Interrupcion entrada de teclado
interrupcion macro
    MOV DX, 0
    MOV AH, 1
    INT 21h  
endm

;Cambia la letra por mayuscula
letraMinuscula macro cadena 
    minusculas:
        MOV BL, cadena[SI]
        OR BL, 00100000b    
        
        imprimirCaracter
            
        INC SI
            
        CMP SI, CX
        JB minusculas
            
        MOV SI, 0h
            
        interrupcion ;macro interrupcion        
endm

;Cambia la letra por mayuscula
letraMayuscula macro cadena
    mayusculas:
        MOV BL, cadena[SI]
        AND BL, 11011111b
           
        imprimirCaracter
            
        INC SI
            
        CMP SI, CX
        JB mayusculas
            
        MOV SI, 0h
            
        interrupcion ;macro interrupcion
endm   

;Invierte la letra
letraInvertir macro cadena
    invertir:
        MOV BL, cadena[SI]
            
        CMP BL, 41h
        JAE letra
            
        JMP caracter            
                
        MOV SI, 0h
                
        interrupcion
                
        JMP menu
        
            
        letra:
            CMP BL, 5Ah
            JBE changeMinuscula;Menor o igual
            
            CMP BL, 60h            
            JBE caracter
                
            CMP BL, 7Ah
            JBE changeMayuscula
                
            JMP caracter
            
            changeMinuscula:
            ADD BL, 20h
                
            JMP caracter                 
                            
            changeMayuscula:
            SUB BL, 20h
                
            JMP caracter
            
            caracter:
                imprimirCaracter
                
                INC SI
                    
                CMP SI, CX
                JB invertir
                
                MOV SI, 0h
                
                interrupcion
endm

guardarIndice macro
    MOV CX, SI ;Guardar el mayor indice
    MOV SI, 0h  
endm

popear macro
    popeo:  
        POP AX
            
        LEA DX, AX
        MOV AH, 2
        INT 21h
                  
        INC SI
            
        CMP SI, CX
        JB popeo ;Menor               
            
        MOV SI, 0h
            
        interrupcion
            
endm

;------------------------------------------FIN MACROS--------------------------------------

.MODEL SMALL
.STACK 999h

.DATA
    ;Mensajes
    msg1 db "Bienvenido $"
    msg2 db 0Dh, 0Ah,0Dh,0Ah, "Ingresa cadena :",0Dh,0Ah,"$"

    opc1 db 0Dh, 0Ah, 0Dh, 0Ah, "[1] - Espejo$"
    opc2 db 0Dh, 0Ah, "[2] - Invertir cadena$"
    opc3 db 0Dh, 0Ah, "[3] - Convertir a mayusculas$"
    opc4 db 0Dh, 0Ah, "[4] - Convertir a minusculas$"
    opc5 db 0Dh, 0Ah, "[5] - Salir$"
    select db 0Dh, 0Ah,0Ah, "Ingrese la opcion :$"

    linea db 0Dh, 0Ah,0Ah, "-----------------------------------------------------------$"

    result db 0Dh, 0Ah,0Ah, "Resultados : $"       
            
    ;Variables
    cadena db 0

.CODE
    
    MOV AX, @DATA
    MOV DS, AX
    
    imprimirVariable msg1 ;Mensaje de bienvenida
    
    imprimirVariable msg2 ;Mensaje de cadena
    
    ingresarValor:
       ingresar 
        
       CMP AL, 0Dh
       JE enter       
       
       MOV cadena[si], al
       INC SI

       JMP ingresarValor

    enter:
       CMP SI, 10 ;Tenga minimo 10
       JAE menu1 ;Mayor o igual
       
       imprimirEnter

       JMP ingresarValor
    
    menu1:
        guardarIndice

    menu:
        imprimirVariable linea
        
        imprimir6 opc1, opc2, opc3, opc4, opc5, select
             
        ;Leer opcion
        ingresar 
        
        CMP AL, 31h ;opcion 1
        JE opcion1
        
        CMP AL, 32h ;opcion 2
        JE opcion2
        
        CMP AL, 33h ;opcion 3
        JE opcion3
        
        CMP AL, 34h ;opcion 4
        JE opcion4
        
        CMP AL, 35h ;opcion 5
        JE salir
                   
        JMP menu           
    
    opcion1: ;ESPEJO
        MOV AX, 0h
        
        MOV AL, cadena[SI]
        PUSH AX   
            
        INC SI
        
        CMP SI, CX
        JB opcion1  ;Menor
        
        MOV SI, 0h
        
        imprimirVariable result ;Mensaje de resultado           
        
        popear; Macro de popear 
            
        JMP menu
            
    opcion2:    
    
        imprimirVariable result ;Mensaje de resultado
        
        letraInvertir cadena ;Macro inversion cadena
                
        JMP menu                       
            
    
    ;Mayusculas
    opcion3:
        imprimirVariable result ;Mensaje de resultado
        
        letraMayuscula cadena ;Macro conversion a mayuscula
            
        JMP menu
            
    ;Minusculas
    opcion4:
        imprimirVariable result ;Mensaje de resultado
        
        letraMinuscula cadena ;Macro conversion a minuscula
            
        JMP menu
    
    salir:
        .exit         