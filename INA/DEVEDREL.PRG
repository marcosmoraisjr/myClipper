
* TITULO     : Controle de Inadiplencia
* DATA       : 15/04/97
* PROGRAMA   : DEVEDREL.PRG
* COMENTARIO : MENU DE RELATORIOS
 
IF FILE ("REL.TXT")
     SETCOLOR("G/N")
     TEXTO=MEMOREAD("REL.TXT")
     @ 06,10 CLEAR TO 20,70
     @ 06,10       TO 20,70
     SOMBRA(06,10,20,70)
     @ 07,11 SAY PADC("ATENCAO OPERADOR...",58) COLOR ("RG+/N")
     MEMOEDIT(TEXTO,08,11,19,69,.F.)
ENDIF
**
** Bloco de inser��o REL.B01
**
MENSAGEM("Tecle <ESC> para sair")
DECLARE ME_NU[1]
ME_NU[1]="Inadiplentes"
M->MENU_S=MENU()
IF M->MENU_S=0
   RETURN
ENDIF
IF M->MENU_S=1
   DO DEVEDR01.PRG
ENDIF
CLOSE DATABASES
**
** Bloco de inser��o REL.B02
**
 
* Final do programa DEVEDREL.PRG