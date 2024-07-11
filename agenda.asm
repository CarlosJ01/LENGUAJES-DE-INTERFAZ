name "agenda"

.MODEL SMALL

.STACK 100h

.DATA

msg db "Bienvenido a su agenda$" 
adios db 0Dh, 0Ah, "ADIOS !!! $"                                                              
linea db 0Dh, 0Ah, "------------------------------------------------------------------------------", 0Dh, 0Ah, "$"

menu db 0Dh, 0Ah, 0Dh, 0Ah, "Ingrese el numero para seleccionar al contacto (1-5) o para ver todos (6). Para salir presione 0: $"

opc db 0Dh, 0Ah, 0Dh, 0Ah, "Presione (0) para salir o para continuar (9): $"

cont1 db 0Dh, 0Ah, 0Dh, 0Ah, "Nombre: Carlos Jahir Castro Cazares", 0Dh, 0Ah, "Edad: 22 anios", 0Dh, 0Ah, "Fecha Nac: 03/09/98", 0Dh, 0Ah, "No. Control: 17120151", 0Dh, 0Ah,"Telefono: 4431837007", 0Dh, 0Ah, "l17120151@tecnm.mx", 0Dh, 0Ah,"$"
cont2 db 0Dh, 0Ah, 0Dh, 0Ah, "Nombre: Giovanni Hasid Martinez Resendiz", 0Dh, 0Ah, "Edad: 21 anios", 0Dh, 0Ah, "Fecha Nac: 05/01/99", 0Dh, 0Ah, "No. Control: 17120182", 0Dh, 0Ah,"Telefono: 4433572706", 0Dh, 0Ah, "l17120182@tecnm.mx", 0Dh, 0Ah,"$"
cont3 db 0Dh, 0Ah, 0Dh, 0Ah, "Nombre: Jesus Ivan Lemus Cervantes", 0Dh, 0Ah, "Edad: 22 anios", 0Dh, 0Ah, "Fecha Nac: 24/12/98", 0Dh, 0Ah, "No. Control: 17120177", 0Dh, 0Ah,"Telefono: 4430000000", 0Dh, 0Ah, "l1710000@tecnm.mx", 0Dh, 0Ah,"$"
cont4 db 0Dh, 0Ah, 0Dh, 0Ah, "Nombre: Ernesto Vieyra", 0Dh, 0Ah, "Edad: 22 anios", 0Dh, 0Ah, "Fecha Nac: 14/03/98", 0Dh, 0Ah, "No.Control: 17120223", 0Dh, 0Ah,"Telefono: 4430000000", 0Dh, 0Ah, "l1710000@tecnm.mx", 0Dh, 0Ah,"$"
cont5 db 0Dh, 0Ah, 0Dh, 0Ah, "Nombre: Jaime Isai Velazquez Aguilar", 0Dh, 0Ah, "Edad: 22 anios", 0Dh, 0Ah, "Fecha Nac: 09/09/98 ", 0Dh, 0Ah,"No.Control:17120222", 0Dh, 0Ah,"Telefono: 4430000000", 0Dh, 0Ah, "l1710000@tecnm.mx", 0Dh, 0Ah,"$"

opc1 db 0Dh, 0Ah, 0Dh, 0Ah,"[1] => Carlos Jahir$"
opc2 db 0Dh, 0Ah, 0Dh, 0Ah,"[2] => Giovanni Hasid$"
opc3 db 0Dh, 0Ah, 0Dh, 0Ah,"[3] => Jesus$"
opc4 db 0Dh, 0Ah, 0Dh, 0Ah,"[4] => Ernesto$"
opc5 db 0Dh, 0Ah, 0Dh, 0Ah,"[5] => Jaime$"

num db 0 ; Guarda la opcion del numero de contacto

.code

;Cargamos data en ax
mov ax, @data
mov ds, ax

;Muestra mensaje de Bienvenida
mov dx, offset msg
mov ah, 9
int 21h

;Pregunta que contacto
opciones:        
    MOV AH, 9
    LEA DX, opc1
    INT 21h
    LEA DX, opc2
    INT 21h
    LEA DX, opc3
    INT 21h
    LEA DX, opc4
    INT 21h
    LEA DX, opc5
    INT 21h
    
    LEA DX, menu
    INT 21h
    
    ;Entrada de caracter con echo
    MOV AH, 1
    INT 21h
    MOV num, AL
    
    LEA DX, linea
    MOV AH, 9
    INT 21h
     
    JZ switchOpc              
   
agenda1: 
    lea dx, cont1
    mov ah, 9
    int 21h
    jmp mensaje

agenda2: 
    lea dx, cont2
    mov ah, 9
    int 21h
    jmp mensaje

agenda3: 
    lea dx, cont3
    mov ah, 9
    int 21h
    jmp mensaje

agenda4: 
    lea dx, cont4
    mov ah, 9
    int 21h
    jmp mensaje

agenda5: 
    lea dx, cont5
    mov ah, 9
    int 21h
    jmp mensaje

agenda6:        
    mov ah, 9
    lea dx,cont1
    int 21h
    lea dx, cont2
    int 21h
    lea dx, cont3
    int 21h
    lea dx, cont4
    int 21h
    lea dx, cont5
    int 21h
    jmp mensaje

;Offset busca mensaje de preguntar si continuar o salir
mensaje:
    mov ah, 9  
    lea dx, linea
    int 21h
    lea dx, opc
    int 21h

    ;Guarda el caracter
    mov ah, 01 
    int 21h
    mov num, al

    JE switchOpc 
    
switchOpc:
    CMP num, "0"
    JZ salir
    
    CMP num, "1"
    JZ agenda1
    
    CMP num, "2"
    JZ agenda2
    
    CMP num, "3"
    JZ agenda3
    
    CMP num, "4"
    JZ agenda4
    
    CMP num, "5"
    JZ agenda5
    
    CMP num, "6"
    JZ agenda6
    
    CMP num, "9"
    JZ opciones      
                                                                     
salir:
    mov ah,9
    LEA DX, adios
    INT 21h
.exit





