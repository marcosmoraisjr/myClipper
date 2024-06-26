
* TITULO     : MFB - LIVRO DE PRECOS
* DATA       : 26/06/97
* PROGRAMA   : LIVROI03.PRG
* COMENTARIO : INCLUSAO ( Grupos)
 
**
** Bloco de inser��o I03.B01
**
MENSAGEM("Aguarde abertura de arquivos")
SELE 2
USE GRUPOSSS INDEX GRUPO004,GRUPO005
SELE 2
**
** Bloco de inser��o I03.B02
**
***
*** Inicio do bloco de substitui��o I03.B
COR("MENU")
@ LIN_MENU,00
@ LIN_MENU,01 SAY "Inclus�o �  Grupos"
M->P_VERI = .T.
M->X_VERI = .F.
M->IN_CLUI=.T.
DO WHILE .T.
   **
   ** Bloco de inser��o I03.B03
   **
   MENSAGEM("Tecle <ESC> para retornar")
   IF M->P_VERI
      **
      ** Bloco de inser��o I03.B04
      **
      CARREG03(1)
   ELSE
      M->X_VERI = .T.
      **
      ** Bloco de inser��o I03.B05
      **
   ENDIF
   IF CARGET03(IIF(M->AL_TERA,2,1))=.F.
      IF M->AL_TERA
         **
         ** Bloco de inser��o I03.B06
         **
         CARREG03(2)
         M->X_VERI = .T.
         CARGET03(5)
         BEEP()
         IF PERG("Registro j� cadastrado. Deseja alterar ?")="S"
            **
            ** Bloco de inser��o I03.B07
            **
            M->IN_CLUI=.F.
            M->P_VERI=.F.
         ELSE
            **
            ** Bloco de inser��o I03.B08
            **
            M->AL_TERA=.F.
         ENDIF
         LOOP
      ENDIF
      **
      ** Bloco de inser��o I03.B09
      **
      EXIT
   ENDIF
   **
   ** Bloco de inser��o I03.B10
   **
   IF PERG("Confirma as informa��es ?")="N"
      M->P_VERI = .F.
      **
      ** Bloco de inser��o I03.B11
      **
      LOOP
   ENDIF
   M->P_VERI = .T.
   M->X_VERI = .F.
   **
   ** Bloco de inser��o I03.B12
   **
   IF M->IN_CLUI
      APPEND BLANK
   ELSE
      M->IN_CLUI=.T.
   ENDIF
   SALVAR03()
   COMMIT
ENDDO
RESTSCREEN(LIN_MENU+1,00,23,79,TELA_PRI)
**
** Bloco de inser��o I03.B13
**
*** Final do bloco de substitui��o I03.B
***
 
FUNCTION VERI003
PARA R_PARA
M->I_REG=RECN()
M->ORDEM = INDEXORD()
SET ORDER TO 1
SEEK M->CODIGOOOOO
IF M->I_REG=RECN() .AND. R_PARA=2
   SET ORDER TO M->ORDEM
   RETURN .T.
ENDIF
IF .NOT. EOF()
   IF R_PARA=2
      @ 00,00 SAY ""
      BEEP()
      MENSAGEM("Registro j� cadastrado",3)
      MENSAGEM("Tecle <ESC> para retornar")
      GOTO M->I_REG
      RETURN .F.
   ELSE
      M->AL_TERA=.T.
      CLEAR GETS
      SET ORDER TO M->ORDEM
      RETURN .T.
   ENDIF
ENDIF
SET ORDER TO M->ORDEM
GOTO M->I_REG
RETURN .T.
 
FUNCTION IFU03001
IF .NOT.(.NOT.EMPTY(M->CODIGOOOOO)) .AND. LASTKEY()<>5
   BEEP()
   MENSAGEM("Informe um numero para a descricao do grupo",3)
   MENSAGEM("Tecle <ESC> para retornar")
   RETURN .F.
ENDIF
RETURN .T.
 
FUNCTION IFU03002
IF .NOT.(.NOT.EMPTY(M->DESCRICAOO)) .AND. LASTKEY()<>5
   BEEP()
   MENSAGEM("Informe o grupo corretamente",3)
   MENSAGEM("Tecle <ESC> para retornar")
   RETURN .F.
ENDIF
RETURN .T.
 
FUNCTION CARREG03
PARA R_CAR
**
** Bloco de inser��o I03.B14
**
PUBLIC ME_MO,CODIGOOOOO,DESCRICAOO,OBSERVACAO,DIGITADOR
M->ME_MO = "[memo]"
IF M->R_CAR=1
   M->CODIGOOOOO=SPACE(  1)
   M->DESCRICAOO=SPACE( 20)
   M->OBSERVACAO=SPACE( 10)
   M->DIGITADOR=SPACE( 20)
**
** Bloco de inser��o I03.B15
**
M->DIGITADOR=M->OPERADOR
ELSE
   M->CODIGOOOOO=CODIGOOOOO
   M->DESCRICAOO=DESCRICAOO
   M->OBSERVACAO=OBSERVACAO
   M->DIGITADOR=DIGITADOR
   **
   ** Bloco de inser��o I03.B16
   **
ENDIF
 
FUNCTION CARGET03
PARA R_CAR
IF R_CAR<>5
   M->AL_TERA=.F.
ENDIF
**
** Bloco de inser��o I03.B17
**
JANELA( 8,20,16,60," Grupos")
COR("CERCADURAS")
@  9,21 TO 15,59
**
** Bloco de inser��o I03.B18
**
COR("GETS")
@ 10,26 SAY "N"
@ 10,28 SAY "DESCRICAO  DO  GRUPO"
@ 13,26 SAY "OBS"
@ 13,34 SAY "RESPONSAVEL INCLUSAO"
**
** Bloco de inser��o I03.B21
**
@ 11,26 GET M->CODIGOOOOO PICTURE "@!" VALID IFU03001() .AND.  VERI003(M->R_CAR)
@ 11,28 GET M->DESCRICAOO PICTURE "@!" VALID IFU03002()
@ 14,26 GET ME_MO PICT "9memo]" VALID EDITOR(@OBSERVACAO,"")
@ 14,34 GET M->DIGITADOR PICTURE "@!"
**
** Bloco de inser��o I03.B24
**
IF M->R_CAR=5
   CLEAR GETS
   RETURN .F.
ENDIF
IF M->R_CAR=3 .OR. M->R_CAR=0
   CLEAR GETS
   IF M->R_CAR=0
      RETURN .T.
   ENDIF
   MENSAGEM("Tecle algo para continuar")
   M->R_X=INKEY(0)
   IF M->R_X=27
      RETURN .F.
   ENDIF
   EDITOR(OBSERVACAO,"",.F.)
ELSE
   SET CURSOR ON
   READ
   SET CURSOR OFF
   IF M->AL_TERA
      RETURN .F.
   ENDIF
   IF LASTKEY()=27
      RETURN .F.
   ENDIF
ENDIF
RETURN .T.
 
FUNCTION SALVAR03
**
** Bloco de inser��o I03.B27
**
REPLACE CODIGOOOOO WITH M->CODIGOOOOO
REPLACE DESCRICAOO WITH M->DESCRICAOO
REPLACE OBSERVACAO WITH M->OBSERVACAO
REPLACE DIGITADOR WITH M->DIGITADOR
**
** Bloco de inser��o I03.B28
**
 
* Final do programa LIVROI03.PRG