
* TITULO     : *** Barreto Constru��o ***
* DATA       : 17/04/97
* PROGRAMA   : MFBC11.PRG
* COMENTARIO : CONSULTA ( Venda/vista Cimento)
 
PARA R_CA
IF M->R_CA="E"
     SET DELETED OFF
     OK_PACK=.T.
ENDIF
**
** Bloco de inser��o C11.B01
**
MENSAGEM("Aguarde abertura de arquivos")
SELE 1
IF .NOT. USEREDE("AVISTACM",.F.,10)
     BEEP()
     MENSAGEM("O arquivo AVISTACM n�o est� dispon�vel",3)
     RETURN
ELSE
     SET INDEX TO AVIST001
ENDIF
SELE 1
**
** Bloco de inser��o C11.B02
**
SET ORDER TO 1
M->X_VERI = .T.
COR("MENU")
@ LIN_MENU,00
@ LIN_MENU,01 SAY IIF(R_CA="C","Consulta",IIF(R_CA="A","Altera��o","Exclus�o"))+" �  Venda/vista Cimento"
JANELA(03,02,21,77," Venda/vista Cimento")
L_CON=L_SOM
C_CON=C_SOM
COR("MENU")
@ 05,04 CLEAR TO 17,75
@ 05,04 TO 07,75
@ 07,04 TO 17,75
@ 07,04 SAY "�"
@ 07,75 SAY "�"
DECLARE DB_CONTE[8],DB_CAB[8]
*
* -> Titulos das colunas
DB_CAB[1]="V"
DB_CAB[2]="Data"
DB_CAB[3]="Documento"
DB_CAB[4]="Cliente"
DB_CAB[5]="Qde sacos"
DB_CAB[6]="R$ Unitario"
DB_CAB[7]="R$ valor"
DB_CAB[8]="Observacao"
*
* -> Conteudo das colunas
DB_CONTE[1]='VENDEDOR'
DB_CONTE[2]='DTOC(DATA)'
DB_CONTE[3]='NATADUPLIC'
DB_CONTE[4]='NOMECLIENT'
DB_CONTE[5]='STR(QUANTSACOS,10,2)'
DB_CONTE[6]='STR(VALORUNITA,10,2)'
DB_CONTE[7]='STR(VALORVENDA,10,2)'
DB_CONTE[8]='OBSERVACAO'
IF M->R_CA="E"
     DB_CAB[1]="  "+DB_CAB[1]
     DB_CONTE[1]='DELE_TAR()+" "+'+DB_CONTE[1]
     DB_CAB[8]=DB_CAB[8]+"  "
     DB_CONTE[8]=DB_CONTE[8]+'+" "+DELE_TAR()'
ENDIF
SAI_DB=.T.
**
** Bloco de inser��o C11.B03
**
DO WHILE .T.
     **
     ** Bloco de inser��o C11.B04
     **
     MENSAGEM("Posicione sobre o registro desejado e tecle <ENTER>")
     COR("MENU")
     KEYBOARD CHR(65) 
     ***
     *** Inicio do bloco de substitui��o DB11.B
     DBEDIT(06,05,17,74,DB_CONTE,"EDITAR11",.T.,DB_CAB,"���"," � ","���")
     *** Final do bloco de substitui��o DB11.B
     ***
     ***
     *** Inicio do bloco de substitui��o C11.B
     SAI_DB=.F.
     MENSAGEM("Tecle <ESC> para sair")
     DO WHILE .T.
          M->NATADUPLIC=SPACE(13)
          COR("GETS")
          @ 19,04 SAY "Documento :" GET M->NATADUPLIC PICTURE "@!"
          SET CURSOR ON
          READ
          SET CURSOR OFF
          IF LASTKEY()=27
               EXIT
          ENDIF
          SEEK TRIM(M->NATADUPLIC)
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
** Bloco de inser��o C11.B05
**
*** Final do bloco de substitui��o C11.B
***
 
FUNCTION EDITAR11
**
** Bloco de inser��o C11.B06
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
          CARREG06(2)
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
               OK_GETS=CARGET06(2)
               IF OK_GETS
                    IF PERG("Confirma altera��es ?")="S"
                         *
                         * -> Atualiza o banco de dados
                         SALVAR06()
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
               CARGET06(0)
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
               CARGET06(3)
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
 
* Final do programa MFBC11.PRG