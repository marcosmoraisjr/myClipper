
* TITULO     :  MFB - Vendas Comissisionadas e Gerais
* DATA       : 03/06/97
* PROGRAMA   : VENDAC02.PRG
* COMENTARIO : CONSULTA ( * Grupo A < 01,02,03,04 >-)
 
*
* -> Define o nivel de acesso
IF M->NIVEL<"3"
   BEEP()
   MENSAGEM("Acesso n�o permitido para este n�vel de senha",3)
   RETURN
ENDIF
PARA R_CA
IF M->R_CA="E"
   SET DELETED OFF
   OK_PACK=.T.
ENDIF
**
** Bloco de inser��o C02.B01
**
MENSAGEM("Aguarde abertura de arquivos")
SELE 1
IF .NOT. USEREDE("GRUP1234",.F.,10)
   BEEP()
   MENSAGEM("O arquivo GRUP1234 n�o est� dispon�vel",3)
   RETURN
ELSE
   SET INDEX TO GRUP1001
ENDIF
SELE 1
**
** Bloco de inser��o C02.B02
**
SET ORDER TO 1
M->X_VERI = .T.
COR("MENU")
@ LIN_MENU,00
@ LIN_MENU,01 SAY IIF(R_CA="C","Consulta",IIF(R_CA="A","Altera��o","Exclus�o"))+" �  * Grupo A < 01,02,03,04 >"
JANELA(03,02,21,77," * Grupo A < 01,02,03,04 >")
L_CON=L_SOM
C_CON=C_SOM
COR("MENU")
@ 05,04 CLEAR TO 17,75
@ 05,04 TO 07,75
@ 07,04 TO 17,75
@ 07,04 SAY "�"
@ 07,75 SAY "�"
DECLARE DB_CONTE[5],DB_CAB[5]
*
* -> Titulos das colunas
DB_CAB[1]="INCLUSAO"
DB_CAB[2]="VENDEDOR 1"
DB_CAB[3]="VENDEDOR 2"
DB_CAB[4]="VENDEDOR 3"
DB_CAB[5]="VENDEDOR 4"
*
* -> Conteudo das colunas
DB_CONTE[1]='DTOC(DATA)'
DB_CONTE[2]='STR(VENDAS01,10,2)'
DB_CONTE[3]='STR(VENDAS02,10,2)'
DB_CONTE[4]='STR(VENDAS03,10,2)'
DB_CONTE[5]='STR(VENDAS04,10,2)'
IF M->R_CA="E"
   DB_CAB[1]="  "+DB_CAB[1]
   DB_CONTE[1]='DELE_TAR()+" "+'+DB_CONTE[1]
   DB_CAB[5]=DB_CAB[5]+"  "
   DB_CONTE[5]=DB_CONTE[5]+'+" "+DELE_TAR()'
ENDIF
SAI_DB=.T.
**
** Bloco de inser��o C02.B03
**
DO WHILE .T.
   **
   ** Bloco de inser��o C02.B04
   **
   MENSAGEM("Posicione sobre o registro desejado e tecle <ENTER>")
   COR("MENU")
   KEYBOARD CHR(65) 
   ***
   *** Inicio do bloco de substitui��o DB02.B
   DBEDIT(06,05,17,74,DB_CONTE,"EDITAR02",.T.,DB_CAB,"���"," � ","���")
   *** Final do bloco de substitui��o DB02.B
   ***
   ***
   *** Inicio do bloco de substitui��o C02.B
   SAI_DB=.F.
   MENSAGEM("Tecle <ESC> para sair")
   DO WHILE .T.
      M->DATA=CTOD("  /  /  ")
      COR("GETS")
      @ 19,04 SAY "DATA     :" GET M->DATA
      SET CURSOR ON
      READ
      SET CURSOR OFF
      IF LASTKEY()=27
         EXIT
      ENDIF
      SEEK TRIM(DTOS(M->DATA))
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
** Bloco de inser��o C02.B05
**
*** Final do bloco de substitui��o C02.B
***
 
FUNCTION EDITAR02
**
** Bloco de inser��o C02.B06
**
IF SAI_DB .OR. LASTKEY()=27
   *
   * -> Finaliza edi��o
   RETURN 0
ELSEIF LASTKEY()=13
   *
   * -> Mostra o registro detalhadamente
   SAVE SCREEN TO TE_LA
   FUNDO()
   DO WHILE .T.
      MENSAGEM("Tecle <ESC> para sair")
      *
      * -> Carrega o conteudo do registro em variaveis
      CARREG02(2)
      IF M->R_CA="A"
         *
         * -> Monta tela de edicao
         IF .NOT. REGLOCK(5)
            BEEP()
            MENSAGEM("Registro bloqueado, tente novamente",3)
            MENSAGEM("Tecle <ESC> para sair")
            RESTORE SCREEN FROM TE_LA
            RETURN 1
         ENDIF
         OK_GETS=CARGET02(2)
         IF OK_GETS
            IF PERG("Confirma altera��es ?")="S"
               *
               * -> Atualiza o banco de dados
               SALVAR02()
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
         *
         * -> Mostra registro detalhadamente
         CARGET02(0)
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
         CARGET02(3)
         L_SOM=L_CON
         C_SOM=C_CON
         COR("MENU")
         RESTORE SCREEN FROM TE_LA
         KEYBOARD CHR(0)
         RETURN 1
      ENDIF
   ENDDO
ELSEIF LASTKEY()=1
   *
   * Vai para o comeco do arquivo
   GOTO TOP
ELSEIF LASTKEY()=6
   *
   * -> Vai para o final do arquivo
   GOTO BOTT
ENDIF
RETURN 1
 
* Final do programa VENDAC02.PRG