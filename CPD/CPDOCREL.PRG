
* TITULO     :  Sistema de Contas a Pagar
* DATA       : 25/04/97
* PROGRAMA   : CPDOCREL.PRG
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
DECLARE ME_NU[2]
ME_NU[1]=">A.Contas a pagar"
ME_NU[2]=">B.Contas pagas"
M->MENU_S=MENU()
IF M->MENU_S=0
   RETURN
ENDIF
IF M->MENU_S=1
   DECLARE ME_NU[2]
   ME_NU[1]="1.Duplicatas a pagar"
   ME_NU[2]="2.Cheques a Pagar"
   S_MENU=MENU(1)
   IF M->S_MENU=1
      DO CPDOCR02.PRG
   ELSEIF M->S_MENU=2
      DO CPDOCR03.PRG
   ENDIF
ELSEIF M->MENU_S=2
   DECLARE ME_NU[2]
   ME_NU[1]="1.Duplicatas pagas"
   ME_NU[2]="2.Cheques pagos"
   S_MENU=MENU(1)
   IF M->S_MENU=1
      DO CPDOCR05.PRG
   ELSEIF M->S_MENU=2
      DO CPDOCR06.PRG
   ENDIF
ENDIF
CLOSE DATABASES
**
** Bloco de inser��o REL.B02
**
 
* Final do programa CPDOCREL.PRG