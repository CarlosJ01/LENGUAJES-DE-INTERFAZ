name "Conversiones"
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
    CALL pInicio

    ;Mensaje de bienvenida 
    LEA DX, msg1
    MOV AH, 9
    INT 21h
    
    ;Mensaje cadena
    LEA DX, msg2
    INT 21h
    MOV SI, 0
    
    call pIngresaCadena 
    
    JMP menu

    menu:
        CALL pMenu ; mensajes de opciones
        
        ;Leer opcion
        CALL pIngresar 
        
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
        
        CALL pResult
            
        
            popeo:
                POP AX
                
                CALL pPopear
                          
                INC SI
                    
                CMP SI, CX
                JB popeo ;Menor               
                    
                MOV SI, 0h
                    
                CALL pIngresar
            
            JMP menu
            
    opcion2:    
    
        CALL pResult
        
        CALL pInvertir
                
        JMP menu
                        
            
    
    ;Mayusculas
    opcion3:
        CALL pResult
        
        CALL pMayusculas
            
        JMP menu
            
    ;Minusculas
    opcion4:
        CALL pResult
        
        CALL pMinusculas
            
        JMP menu
    
    salir:
        .exit

;---------------------------------------PROCEDIMIENTOS----------------------------------- 

;Inicio del programa
pInicio PROC
    ;Cargar Data
    MOV AX, @data
    MOV DS, ax
RET
pInicio ENDP
                       
                       
;Introduccion de cadena
pIngresaCadena PROC
    ingresar:
       CALL pIngresar

       CMP AL, 0Dh
       JE enter       
       
       MOV cadena[si], al
       INC SI

       JMP ingresar

    enter:
       CMP SI, 10 ;Tenga minimo 10
       JAE guardarMayor ;Mayor o igual
       
       MOV DX, 20h
       MOV AH, 9
       INT 21h

       JMP ingresar
    
    guardarMayor:
        MOV CX, SI ;Guardar el mayor indice
        MOV SI, 0h
        
RET
pIngresaCadena ENDP
  

;Imprime menu de opciones
pMenu PROC
    LEA DX, linea
    MOV AH, 9
    INT 21h

    ;Opciones
    LEA DX, opc1
    MOV AH, 9
    INT 21h
    LEA DX, opc2
    INT 21h
    LEA DX, opc3
    INT 21h
    LEA DX, opc4
    INT 21h 
    LEA DX, opc5
    INT 21h 
        
    LEA DX, select
    INT 21h  
RET
pMenu ENDP  
      
;Pop      
pPopear PROC                    
    LEA DX, AX
    MOV AH, 2
    INT 21h
RET
pPopear ENDP

;Invertir la cadena
pInvertir PROC
    invertir:
            MOV BL, cadena[SI]
            
            CMP BL, 41h
            JAE letra
            
            JMP caracter            
                
            MOV SI, 0h
                
            CALL pIngresar
                
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
                CALL pImprimir
                
                INC SI
                    
                CMP SI, CX
                JB invertir
                
                MOV SI, 0h
                
                CALL pIngresar
RET
pInvertir ENDP


;Convertir a mayuscula
pMayusculas PROC
    mayusculas:
        MOV BL, cadena[SI]
        AND BL, 11011111b
            
        CALL pImprimir
            
        INC SI
            
        CMP SI, CX
        JB mayusculas
            
        MOV SI, 0h
            
        CALL pIngresar
RET
pMayusculas ENDP
      
;Convertir a minusculas      
pMinusculas PROC
    minusculas:
        MOV BL, cadena[SI]
        OR BL, 00100000b
            
        CALL pImprimir
            
        INC SI
           
        CMP SI, CX
        JB minusculas
            
        MOV SI, 0h
            
        CALL pIngresar
RET
pMinusculas ENDP

;Imprime un caracter
pImprimir PROC
    MOV DX, BX
    MOV AH, 2
    INT 21h  
RET
pImprimir ENDP

;Interrupcion de entrada        
pIngresar PROC  
    MOV DX, 0
    MOV AH, 1
    INT 21h
RET
pIngresar ENDP

;Imprime resultado
pResult PROC  
    LEA DX, result ;Mensaje de resultado
    MOV AH, 9
    INT 21h   
RET
pResult ENDP