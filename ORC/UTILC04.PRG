
* TITULO     :  MFB Materiais de Construcao Ltda ( MMStec - Orcamento )
* DATA       : 06/03/97
* PROGRAMA   : UTILC04.PRG
* COMENTARIO : CONSULTA (4 - Aniversariantes)
 
PARA R_CA
IF M->R_CA="E"
   SET DELETED OFF
   OK_PACK=.T.
ENDIF
**
** Bloco de inser��o C04.B01
**
MENSAGEM("Aguarde abertura de arquivos")
SELE 4
IF .NOT. USEREDE("HEPPYDAY",.F.,10)
   BEEP()
   MENSAGEM("O arquivo HEPPYDAY n�o est� dispon�vel",3)
   RETURN
ELSE
   SET INDEX TO HEPPY004,HEPPY005
ENDIF
SELE 4
**
** Bloco de inser��o C04.B02
**
SET ORDER TO 1
M->X_VERI = .T.
COR("MENU")
@ LIN_MENU,00
@ LIN_MENU,01 SAY IIF(R_CA="C","Consulta",IIF(R_CA="A","Altera��o","Exclus�o"))+" � 4 - Aniversariantes"
JANELA(03,02,21,77,"4 - Aniversariantes")
L_CON=L_SOM
C_CON=C_SOM
COR("MENU")
@ 05,04 CLEAR TO 17,75
@ 05,04 TO 07,75
@ 07,04 TO 17,75
@ 07,04 SAY "�"
@ 07,75 SAY "�"
DECLARE DB_CONTE[10],DB_CAB[10]
DB_CAB[1]="ANIVERSARIO"
DB_CAB[2]="ANIVERSARIANTE"
DB_CAB[3]="ENDERECO"
DB_CAB[4]="BAIRRO"
DB_CAB[5]="CIDADE"
DB_CAB[6]="ESTADO"
DB_CAB[7]="FONE ( 1 )"
DB_CAB[8]="FONE ( 2 )"
DB_CAB[9]="FONE ( 3 )"
DB_CAB[10]="INCLUSAO"
DB_CONTE[1]='DTOC(DATA_ANI)'
DB_CONTE[2]='ANIVER'
DB_CONTE[3]='ENDERECO'
DB_CONTE[4]='BAIRRO'
DB_CONTE[5]='CIDADE'
DB_CONTE[6]='ESTADO'
DB_CONTE[7]='FONE_1'
DB_CONTE[8]='FONE_2'
DB_CONTE[9]='FONE_3'
DB_CONTE[10]='DTOC(DATA_INC)'
IF M->R_CA="E"
   DB_CAB[1]="  "+DB_CAB[1]
   DB_CONTE[1]='DELE_TAR()+" "+'+DB_CONTE[1]
   DB_CAB[10]=DB_CAB[10]+"  "
   DB_CONTE[10]=DB_CONTE[10]+'+" "+DELE_TAR()'
ENDIF
SAI_DB=.T.
**
** Bloco de inser��o C04.B03
**
DO WHILE .T.
   **
   ** Bloco de inser��o C04.B04
   **
   MENSAGEM("Posicione sobre o registro desejado e tecle <ENTER>")
   COR("MENU")
   KEYBOARD CHR(65) 
   ***
   *** Inicio do bloco de substitui��o DB04.B
   DBEDIT(06,05,17,74,DB_CONTE,"EDITAR04",.T.,DB_CAB,"���"," � ","���")
   *** Final do bloco de substitui��o DB04.B
   ***
   ***
   *** Inicio do bloco de substitui��o C04.B
   SAI_DB=.F.
   MENSAGEM("Tecle <ESC> para sair")
   DO WHILE .T.
      M->ANIVER=SPACE(30)
      COR("GETS")
      @ 19,04 SAY "ANIVERSARIANTE" GET M->ANIVER PICTURE "@!"
      SET CURSOR ON
      READ
      SET CURSOR OFF
      IF LASTKEY()=27
         EXIT
      ENDIF
      SEEK TRIM(M->ANIVER)
      IF EOF()
         BEEP()
         MENSAGEM("Dados n�o encontrados",3)
         MENSAGEM("Tecle <ESC> para sair")
         LOOP
      ENDIF
      EXIT
   ENDDO
   SOMBRA(L_CON,C_CON)
   IF LASTKEY()=27
      EXIT
   ENDIF
ENDDO
SET DELETED ON
RESTSCREEN(LIN_MENU+1,00,23,79,TELA_PRI)
**
** Bloco de inser��o C04.B05
**
*** Final do bloco de substitui��o C04.B
***
 
FUNCTION EDITAR04
**
** Bloco de inser��o C04.B06
**
IF SAI_DB .OR. LASTKEY()=27
   RETURN 0
ELSEIF LASTKEY()=13
   SAVE SCREEN TO TE_LA
   FUNDO()
   DO WHILE .T.
      MENSAGEM("Tecle <ESC> para sair")
      CARREG04(2)
      IF M->R_CA="A"
         IF .NOT. REGLOCK(5)
            BEEP()
            MENSAGEM("Registro bloqueado, tente novamente",3)
            MENSAGEM("Tecle <ESC> para sair")
            RESTORE SCREEN FROM TE_LA
            RETURN 1
         ENDIF
         OK_GETS=CARGET04(2)
         IF OK_GETS
            IF PERG("Confirma altera��es ?")="S"
               SALVAR04()
               COMMIT
               UNLOCK
               COR("MENU")
               RESTORE SCREEN FROM TE_LA
               KEYBOARD CHR(0)
               L_SOM=L_CON
               C_SOM=C_CON
               RETURN 2
            ELSE
               UNLOCK
               LOOP
            ENDIF
         ELSE
            UNLOCK
            COR("MENU")
            RESTORE SCREEN FROM TE_LA
            KEYBOARD CHR(0)
            L_SOM=L_CON
            C_SOM=C_CON
            RETURN 1
         ENDIF
      ELSEIF M->R_CA="E"
         CARGET04(0)
         L_SOM=L_CON
         C_SOM=C_CON
         CLEAR GETS
         IF PERG("Deseja marcar este registro para EXCLUSAO ?")="S"
            IF .NOT. REGLOCK(5)
               BEEP()
               MENSAGEM("Dele��o mal sucedida",3)
               MENSAGEM("Tecle <ESC> para sair")
               RESTORE SCREEN FROM TE_LA
               RETURN 1
            ENDIF
            DELE
         ELSE
            IF .NOT. REGLOCK(5)
               BEEP()
               MENSAGEM("Dele��o mal sucedida",3)
               MENSAGEM("Tecle <ESC> para sair")
               RESTORE SCREEN FROM TE_LA
               RETURN 1
            ENDIF
            RECALL
         ENDIF
         UNLOCK
         COR("MENU")
         RESTORE SCREEN FROM TE_LA
         KEYBOARD CHR(0)
         RETURN 2
      ELSE
         CARGET04(3)
         L_SOM=L_CON
         C_SOM=C_CON
         COR("MENU")
         RESTORE SCREEN FROM TE_LA
         KEYBOARD CHR(0)
         RETURN 1
      ENDIF
   ENDDO
ELSEIF LASTKEY()=1
   GOTO TOP
ELSEIF LASTKEY()=6
   GOTO BOTT
ENDIF
RETURN 1
 
* Final do programa UTILC04.PRG