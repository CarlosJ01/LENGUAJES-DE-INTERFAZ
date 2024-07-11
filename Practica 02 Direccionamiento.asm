.STACK 100  ;segmento de pila

.DATA   ;segmento de datos

B DB 'AZUL'
c db 'k$'
Tabla dw 999

.CODE   ;segmento de codigo
MOV AX, @DATA   ;@DATA la direccion de datos
mov ds, ax

;----------------------------------------------
;direccionamiento de registro

mov ax, 50
mov bx, ax

;----------------------------------------------
;direccionamiento inmediato

mov ax, 500

;----------------------------------------------
;direccionaliento directo

;almacena en BX el contenido de la direccion de memoria DS:1000.
MOV BX, [1000]

;almacena en AX el contenido de la direccion de memoria DS:TABLA
MOV AX, [TABLA]

;---------------------------------------------------------------
;direccionamiento indirecto mediante registro
;Cuando el operando esta en memoria en una posicion contenida en un registro (BX, BP, SI, DI)

MOV AX,[BX] ;almacena en AX el contenido de la direccion de memoria DS:[BX]
mov bp, 50h ;BP es la pila SS -> Desplazamiento BP
MOV [BP], CX ;almacena en la direccion apuntada por BP en la pila el contenido de CX

;---------------------------------------------------------------------------------------------
;Direccionamiento por registro base

;Cuando el operando esta en memoria en una posicion apuntada por el regitro BX o BP al
;que se le aniade un determinado desplazamiento

MOV AX, [BP] + 2    ;almacena en AX el contenido de la posicion de memoria que
                    ;resulte de sumara 2 al contenido de BP (dentro del segmento de pila)

;Equivalente a
MOV AX, [BP + 20h]

;---------------------------------------------------------------------------------------------
;Direccionamiento indexado

;cuando la direccion del operando es optenida como la suma de un desplazamiento
;mas de un indice (DI, SI)

mov di, 10
MOV AX, TABLA[DI]   ;almacena en  AX el contenido de la posicion de memoria apuntada
                    ;por el resultado de sumarle a TABLA el contenido de DI
 
;---------------------------------------------------------------------------------------------
;Direccionamiento indexado respecto a una base

;Cuando la direccion del operando se obtiene de la suma de un registro
;base (BP o BX), de un indice (DI, SI) y opcionalmente un desplazamiento

mov bx, 2
MOV AX, TABLA[BX][DI]   ;almacena en AX el contenido de la posicion de memoria apuntada por la
                        ;suma de TABLA, el contenido de BX y el contenido de DI
                        
;---------------------------------------------------------------------------------------------

.exit