Name "SicalWin"
OutFile "instalador_sical.exe"

!include MUI.nsh
!include MUI2.nsh
!include Sections.nsh
!include LogicLib.nsh
!include x64.nsh
!include libreria.nsi
!include Library.nsh
!include nsDialogs.nsh
SetDateSave on
SetDatablockOptimize on
CRCCheck on
SilentInstall normal
BGGradient 000000 300000 FFFFFF
InstallColors FF8080 000030
XPStyle on
LicenseText "Acuerdo de licencia"
LicenseData "licencia.txt"
RequestExecutionLevel admin
ManifestSupportedOS all

;--------------------------------

Var /global SOURCE
Var /global BROWSESOURCE
Var /global SOURCETEXT
Var Dialog
Var Text

;--------------------------------
Function nsDialogsPage
    !insertmacro MUI_HEADER_TEXT "Instalador SicalWin" "Seleccione la URL del servidor de SicalWin."

    nsDialogs::Create 1018
    Pop $Dialog

    ${If} $Dialog == error
        Abort
    ${EndIf}
    StrCpy $SOURCE "C:\"
    ${NSD_CreateGroupBox} 10% 10u 80% 62u "Indicaciones"
    Pop $0

        ${NSD_CreateLabel} 12% 30u 75% 10u "Introduzca la URL del servidor de Sicalwin"
        Pop $0

        ${NSD_CreateLabel} 12% 50u 75% 10u "En el formato \\servidor\carpetaRaizdeSical\"
        Pop $0

        
    ${NSD_CreateGroupBox} 5% 86u 90% 34u "Servidor SicalWin URL"
    Pop $0

       	#${NSD_CreateDirRequest} 15% 100u 49% 12u "C:\"
        ${NSD_CreateText} 15% 100u 49% 12u "C:\"
       	Pop $Text
        ${NSD_OnChange} $Text Cambia_URL
         
        
        ${NSD_CreateBrowseButton} 65% 100u 20% 12u "Buscar..."
        pop $BROWSESOURCE
        ${NSD_OnClick} $BROWSESOURCE Browsesource
        
    nsDialogs::Show
FunctionEnd

Function Browsesource
    nsDialogs::SelectFolderDialog "Seleccione el directorio padre donde esta SicalWin" "C:\"
    pop $SOURCE
    ${NSD_SetText} $Text $SOURCE
FunctionEnd

Function Cambia_URL
	Pop $1
	${NSD_GetText} $Text $0
    StrCpy $SOURCE $0
FunctionEnd



;--------------------------------
Page license
UninstPage uninstConfirm
UninstPage instfiles
;--------------------------------

;--------------------------------
;Var Ruta_registro
Var Traza
Var Administrador_Cliente
Var Administrador_Servidor
Var Administrador_Ultimo_idioma
Var Administrador_Version
Var Administrador_Ultimo_usuario
Var Inicio_Configuracion
Var Inicio_Puesto
Var Sicalwin_Cliente
Var Sicalwin_Aviso_Access
Var Sicalwin_Numero_de_Copias
Var Sicalwin_Destino_Impresion
Var Sicalwin_Documentos_en_cache
Var Sicalwin_Impresora_Servidor
Var Sicalwin_Servidor
Var Sicalwin_Ultimo_idioma
Var Sicalwin_Ultimo_usuario
Var Sicalwin_2006_Aviso_Access
Var Sicalwin_2006_Aumentar_Escala
Var Sicalwin_2006_Aumentar_Letras
Var Sicalwin_2006_Tipo_Letra
Var Sicalwin_2006_Firma_Electronica
Var Sicalwin_2006_Fecha_Ultima_Actualizacion
Var Sicalwin_2006_Numero_de_Copias
Var Sicalwin_2006_Destino_Impresion
Var Sicalwin_2006_Documentos_en_cache
Var Sicalwin_2006_Impresora_Servidor
Var Sicalwin_2006_Version
Var Sicalwin_2006_Ultimo_usuario
Var Sicalwin_2006_Servidor
Var Sicalwin_2006_Ultimo_idioma


##===========================================================================
## Modern UI Pages
##===========================================================================

!insertmacro MUI_PAGE_WELCOME
Page custom nsDialogsPage
!define MUI_PAGE_CUSTOMFUNCTION_PRE SelectFilesCheck
!define MUI_PAGE_CUSTOMFUNCTION_LEAVE ComponentsLeave
!insertmacro MUI_PAGE_COMPONENTS

## This is the title on the first Directory page
!define MUI_DIRECTORYPAGE_TEXT_TOP "$(MUI_DIRECTORYPAGE_TEXT_TOP_A)"

!define MUI_PAGE_CUSTOMFUNCTION_PRE SelectFilesA
!insertmacro MUI_PAGE_DIRECTORY
!insertmacro MUI_PAGE_INSTFILES

## This is the title on the second Directory page
!define MUI_DIRECTORYPAGE_TEXT_TOP "$(MUI_DIRECTORYPAGE_TEXT_TOP_B)"

!define MUI_PAGE_CUSTOMFUNCTION_PRE SelectFilesB
!insertmacro MUI_PAGE_DIRECTORY
!insertmacro MUI_PAGE_INSTFILES

!define MUI_PAGE_CUSTOMFUNCTION_LEAVE DeleteSectionsINI
!insertmacro MUI_PAGE_FINISH
!insertmacro MUI_LANGUAGE "Spanish"

##===========================================================================
## Language strings
##===========================================================================

LangString NoSectionsSelected ${LANG_SPANISH} "¡No has seleccionado nada!"
LangString MUI_DIRECTORYPAGE_TEXT_TOP_A ${LANG_SPANISH} "Se descomprimirán las aplicaciones en el siguiente directorio temporal. En caso de querer guardarlas, selecciones otro directorio"

##==========================================================================
## Start sections
##===========================================================================

## Sections Group 1

SectionGroup /e "Aplicaciones" PROG1


Section "mdac28sdk" SEC1
 	 SetOutPath "$INSTDIR"
	 File "mdac28sdk.msi"
	 ExecWait '"msiexec" /i  "$INSTDIR\mdac28sdk.msi" /passive'
SectionEnd

Section "Microsoft WSE 2.0 SP3" SEC2

	 SetOutPath "$INSTDIR"
	 File "Microsoft WSE 2.0 SP3.msi"
	 ExecWait '"msiexec" /i  "$INSTDIR\Microsoft WSE 2.0 SP3.msi" /passive'
	 ${If} ${Errors}
	    MessageBox mb_iconstop "Parece que no puede descargar .NET 3.5, compruebe internet o el proxy.$/nDebe volver a instalar Microsoft WSE 2.0 SP3.msi una vez descargado .NET 3.5"
         ${else}
	    MessageBox mb_iconstop "Pulse aceptar cuando se haya instalado .NET 3.5 para continuar con la instalación"
	 ${EndIf}
Continuar:

SectionEnd

Section "msxmlspa" SEC3
	 SetOutPath "$INSTDIR"
	 File "msxmlspa.msi"
	 ExecWait '"msiexec" /i  "$INSTDIR\msxmlspa.msi" /passive'
	 ${If} ${Errors}
	    MessageBox mb_iconstop "No se ha podido ejecutar msxmlspa.msi $0"
          ${EndIf}

SectionEnd

#Section /o "msvbvm50" SEC5 con la opcion /o desactivamos la opción

Section "msvbvm50" SEC4
	 SetOutPath "$INSTDIR"
	 File "msvbvm50.exe"
	 ExecWait '"$INSTDIR\msvbvm50.exe"'
	 ${If} ${Errors}
	    MessageBox mb_iconstop "No se ha podido ejecutar msvbvm50.exe $0"
          ${EndIf}


SectionEnd

Section "Runtime Visual" SEC5
  	 SetOutPath "$INSTDIR\Runtime_Visual"
	 File "Runtime_Visual\Substitucion_Componentes.exe"
	 File "Runtime_Visual\Substitucion_Componentes.W02"
	 File "Runtime_Visual\Substitucion_Componentes.W03"
	 File "Runtime_Visual\Substitucion_Componentes.W04"
	 File "Runtime_Visual\Substitucion_Componentes.W05"
	 File "Runtime_Visual\Substitucion_Componentes.W06"
	 ExecWait '"$INSTDIR\Runtime_Visual\Substitucion_Componentes.exe"' $0
	 ${If} ${Errors}
	    MessageBox mb_iconstop "No se ha podido ejecutar Substitucion_Componentes.exe $0"
	 ${EndIf}

SectionEnd

Section /o "Crystal Report" SEC6
	 SetOutPath "$INSTDIR\CrystalReports\CrystalReports"
	 File "CrystalReports\CrystalReports\Substitucion_dlla_crystal.exe"
	 File "CrystalReports\CrystalReports\Substitucion_dlla_crystal.W02"
	 File "CrystalReports\CrystalReports\Substitucion_dlla_crystal.W03"
	 File "CrystalReports\CrystalReports\Substitucion_dlla_crystal.W04"
	 File "CrystalReports\CrystalReports\Substitucion_dlla_crystal.W05"
	 ExecWait '"$INSTDIR\CrystalReports\CrystalReports\Substitucion_dlla_crystal.exe"' $0
	 ${If} ${Errors}
	    MessageBox mb_iconstop "No se ha podido ejecutar Substitucion_dlla_crystal.exe $0"
	 ${EndIf}

  	 SetOutPath $SYSDIR
	 ClearErrors
	 File "CrystalReports\Exportacion_PDF\craxdrt.dll" 
	 File "CrystalReports\Exportacion_PDF\crtslv.dll" 
	 File "CrystalReports\Exportacion_PDF\crviewer.dll" 
	 File "CrystalReports\Exportacion_PDF\crxf_pdf.dll" 
	 File "CrystalReports\Exportacion_PDF\exportmodeller.dll"
	 File "CrystalReports\Exportacion_PDF\P2SODBC.dll"
        # execwait "regsvr32 -s $SYSDIR\craxdrt.dll"
        # execwait "regsvr32 -s $SYSDIR\crtslv.dll"
        # execwait "regsvr32 -s $SYSDIR\crviewer.dll"
         execwait "regsvr32 -s $SYSDIR\crxf_pdf.dll"
         execwait "regsvr32 -s $SYSDIR\P2SODBC.dll"
         execwait "regsvr32 -s $SYSDIR\exportmodeller.dll"
	 !insertmacro InstallLib REGDLLTLB NOTSHARED REBOOT_NOTPROTECTED CrystalReports\Exportacion_PDF\craxdrt.dll $SYSDIR\craxdrt.dll $SYSDIR
	 !insertmacro InstallLib REGDLLTLB NOTSHARED REBOOT_NOTPROTECTED CrystalReports\Exportacion_PDF\crtslv.dll $SYSDIR\crtslv.dll $SYSDIR
	 !insertmacro InstallLib REGDLLTLB NOTSHARED REBOOT_NOTPROTECTED CrystalReports\Exportacion_PDF\crviewer.dll $SYSDIR\crviewer.dll $SYSDIR
	# !insertmacro InstallLib REGDLLTLB NOTSHARED REBOOT_NOTPROTECTED CrystalReports\Exportacion_PDF\crxf_pdf.dll $SYSDIR\crxf_pdf.dll $SYSDIR
	# !insertmacro InstallLib REGDLLTLB NOTSHARED REBOOT_NOTPROTECTED CrystalReports\Exportacion_PDF\P2SODBC.dll $SYSDIR\P2SODBC.dll $SYSDIR
	# !insertmacro InstallLib REGDLLTLB NOTSHARED REBOOT_NOTPROTECTED CrystalReports\Exportacion_PDF\exportmodeller.dll $SYSDIR\exportmodeller.dll $SYSDIR
SectionEnd



Section "Componentes y Librerías" SEC7
	 ${If} ${RunningX64}
		StrCpy $Ruta_registro "SOFTWARE\WOW6432Node"
		DetailPrint "Realizando instalación para Windows 64-bit"
	 ${Else}
		DetailPrint "Realizando instalación para Windows 32-bit"
		StrCpy $Ruta_registro "SOFTWARE\"
	 ${EndIF}
	 SetOutPath "$INSTDIR"
	 File "SWinR.bat"
	 
	 ExpandEnvStrings $0 %COMSPEC%
     ExecWait '"$0" /C "$INSTDIR\SWinR.bat $SOURCE"'
	 ${If} ${Errors}
	    MessageBox mb_iconstop "No se ha podido ejecutar SWinR.bat $0"
	 ${EndIf}



SectionEnd

Section "Claves de Registro" SEC8
	 ${If} ${RunningX64}
		StrCpy $Ruta_registro "SOFTWARE\WOW6432Node"
		DetailPrint "Realizando instalación para Windows 64-bit"
	 ${Else}
		DetailPrint "Realizando instalación para Windows 32-bit"
		StrCpy $Ruta_registro "SOFTWARE\"
	 ${EndIF}
	 SetOutPath "$INSTDIR"
	 ExpandEnvStrings $0 %COMSPEC%
	 ${GetTime} "" "L" $0 $1 $2 $3 $4 $5 $6
	 ClearErrors
     ReadRegStr $0 HKLM "$Ruta_registro\AYTOS\" "Traza"
     ${If} ${Errors}
        ;No se ha encontrado la clave creamos las claves
        WriteRegStr HKEY_LOCAL_MACHINE "$Ruta_registro\AYTOS\" "Traza" ""
        WriteRegStr HKEY_LOCAL_MACHINE "$Ruta_registro\AYTOS\Administrador" "Cliente" "$SOURCE\SicalWin"
        WriteRegStr HKEY_LOCAL_MACHINE "$Ruta_registro\AYTOS\Administrador" "Servidor" "$SOURCE\SicalWin2006"
        WriteRegStr HKEY_LOCAL_MACHINE "$Ruta_registro\AYTOS\Administrador" "Ultimo idioma" "1"
        WriteRegStr HKEY_LOCAL_MACHINE "$Ruta_registro\AYTOS\Administrador" "Version" "8.51.00"
        WriteRegStr HKEY_LOCAL_MACHINE "$Ruta_registro\AYTOS\Administrador" "Ultimo Usuario" "ADM"
	  
        WriteRegStr HKEY_LOCAL_MACHINE "$Ruta_registro\AYTOS\Inicio" "Puesto" "2"
        WriteRegStr HKEY_LOCAL_MACHINE "$Ruta_registro\AYTOS\Inicio" "Configuracion" "$SOURCE\Sicalwin\ADM.cfg"
	 
        WriteRegStr HKEY_LOCAL_MACHINE "$Ruta_registro\AYTOS\SicalWin" "Cliente" "$SOURCE"
        WriteRegStr HKEY_LOCAL_MACHINE "$Ruta_registro\AYTOS\SicalWin" "Aviso Access" "NO"
        WriteRegStr HKEY_LOCAL_MACHINE "$Ruta_registro\AYTOS\SicalWin" "Numero de Copias" "1"
        WriteRegStr HKEY_LOCAL_MACHINE "$Ruta_registro\AYTOS\SicalWin" "Destino Impresion" "1"
        WriteRegStr HKEY_LOCAL_MACHINE "$Ruta_registro\AYTOS\SicalWin" "Documentos en cache" "3"
        WriteRegStr HKEY_LOCAL_MACHINE "$Ruta_registro\AYTOS\SicalWin" "Impresora Servidor" ""
        WriteRegStr HKEY_LOCAL_MACHINE "$Ruta_registro\AYTOS\SicalWin" "Servidor" "$SOURCE"
        WriteRegStr HKEY_LOCAL_MACHINE "$Ruta_registro\AYTOS\SicalWin" "Ultimo idioma" "1"
        WriteRegStr HKEY_LOCAL_MACHINE "$Ruta_registro\AYTOS\SicalWin" "Ultimo usuario" "adm"
        WriteRegStr HKEY_LOCAL_MACHINE "$Ruta_registro\AYTOS\SicalWin" "Version" "3.08.0001"
	 
        WriteRegStr HKEY_LOCAL_MACHINE "$Ruta_registro\AYTOS\SicalWin 2006" "Aviso Access" "NO"
        WriteRegStr HKEY_LOCAL_MACHINE "$Ruta_registro\AYTOS\SicalWin 2006" "Fecha Ultima Actualizacion" "$0/$1/$2"
        WriteRegStr HKEY_LOCAL_MACHINE "$Ruta_registro\AYTOS\SicalWin 2006" "Servidor" "$SOURCE\SicalWin2006"
        WriteRegStr HKEY_LOCAL_MACHINE "$Ruta_registro\AYTOS\SicalWin 2006" "Ultimo idioma" "1"
        WriteRegStr HKEY_LOCAL_MACHINE "$Ruta_registro\AYTOS\SicalWin 2006" "Version" "8.54.0001"
        WriteRegStr HKEY_LOCAL_MACHINE "$Ruta_registro\AYTOS\SicalWin 2006" "Ultimo usuario" "adm"
	 
        ${If} ${Errors}
            MessageBox mb_iconstop "No se ha podido crear las entradas de registro"
        ${EndIf}
    
        
    ${Else}
        MessageBox mb_iconstop "Las claves de registro ya existen, no se sobreescriben"
    ${EndIf}
	
SectionEnd




Section /o "ODBC's" SEC9

    Call Get_ODBC_Entries
    Pop "$1"
    #MessageBox MB_OK|MB_ICONINFORMATION "Entradas ODBC: $1"
	MessageBox MB_OK|MB_ICONINFORMATION "Servidor $SOURCE"
	${Locate} "$SOURCE" "/L=F /M=*.mdb /S= /G=1" "Encontrado"
	IfErrors 0 +2
	MessageBox MB_OK "Se ha producido un error"
	
SectionEnd
 
Function Encontrado
    Var /global nombre_fichero
	MessageBox MB_YESNO "Se ha encontrado la base de datos access $\n$R9 $\n¿Desea crear los ODBC?" IDYES true IDNO false
	
    true: 
      
        push "$R7"
        call GetBaseName
        pop "$nombre_fichero"
        DetailPrint "El nombre del ODBC es $nombre_fichero"
        Push "$nombre_fichero"
        Push "$R9"
        Call CreateAccessODBCEntry
        Pop "$1"
        DetailPrint "Entrada de Access ODBC creada: $1"
        #MessageBox MB_OK|MB_ICONINFORMATION "Entrada de Access ODBC creada: $1"
  
    false:
    Push $0
FunctionEnd




SectionGroupEnd


## Sections Group 2

SectionGroup /e  "Servidor SicalWin" PROG2
 
Section /o "Aytofacturas" SEC10
 SetOutPath "$INSTDIR"
 ClearErrors
 File "aytosFacturas.sfx.exe"
 ExecWait '"$INSTDIR\aytosFacturas.sfx.exe"'
 ${If} ${Errors}
    MessageBox mb_iconstop "No se ha podido ejecutar aytosFacturas.sfx.exe!"
 ${Else}
    MessageBox mb_iconstop "Si ha terminado la instalación de AytoFacturas en la otra ventana pulse aceptar."
 ${EndIf}
SectionEnd
 
Section /o "Servidor Sicalwin" SEC11
  	 SetOutPath "$INSTDIR\SICALWIN_6"
	 File "SICALWIN_6\sicalwin_6000100.exe"
	 File "SICALWIN_6\sicalwin_6000100.W02"
	 File "SICALWIN_6\sicalwin_6000100.W03"
	 File "SICALWIN_6\sicalwin_6000100.W04"
	 File "SICALWIN_6\sicalwin_6000100.W05"
	 File "SICALWIN_6\sicalwin_6000100.W06"
	 File "SICALWIN_6\sicalwin_6000100.W07"
	 File "SICALWIN_6\sicalwin_6000100.W08"
	 File "SICALWIN_6\sicalwin_6000100.W09"
	 File "SICALWIN_6\sicalwin_6000100.W10"
	 File "SICALWIN_6\sicalwin_6000100.W11"
	 File "SICALWIN_6\sicalwin_6000100.W12"
	 File "SICALWIN_6\sicalwin_6000100.W13"
	 File "SICALWIN_6\sicalwin_6000100.W14"
	 File "SICALWIN_6\sicalwin_6000100.W15"
	 File "SICALWIN_6\sicalwin_6000100.W16"
	 File "SICALWIN_6\sicalwin_6000100.W17"
	 File "SICALWIN_6\sicalwin_6000100.W18"
	 File "SICALWIN_6\sicalwin_6000100.W19"
	 ClearErrors
	 ExecWait '"$INSTDIR\SICALWIN_6\sicalwin_6000100.exe"'
	 ${If} ${Errors}
	    MessageBox mb_iconstop "No se ha podido ejecutar sicalwin_6000100.exe!"
	 ${EndIf}

SectionEnd
SectionGroupEnd


   !insertmacro MUI_FUNCTION_DESCRIPTION_BEGIN
   !insertmacro MUI_DESCRIPTION_TEXT ${PROG1} "Todas las aplicaciones necesarias para correr SicalWin"
   !insertmacro MUI_DESCRIPTION_TEXT ${SEC1} "Instala Microsoft Data Access Component (MDAC) 2.8"
   !insertmacro MUI_DESCRIPTION_TEXT ${SEC2} "Instala Web Service Enhancements (WSE) para .NET"
   !insertmacro MUI_DESCRIPTION_TEXT ${SEC3} "Microsoft XML"
   !insertmacro MUI_DESCRIPTION_TEXT ${SEC4} "Microsoft VisualBasic 5 DLL"
   !insertmacro MUI_DESCRIPTION_TEXT ${SEC5} "Instala el Runtime de Visual"
   !insertmacro MUI_DESCRIPTION_TEXT ${SEC6} "Instala CrystalReports"
   !insertmacro MUI_DESCRIPTION_TEXT ${SEC7} "Registra las librerias y OCX necesarios para Sicalwin" 
   !insertmacro MUI_DESCRIPTION_TEXT ${SEC8} "Instala en el registro del sistema las claves de SicalWin"
   !insertmacro MUI_DESCRIPTION_TEXT ${SEC9} "Crea los ODBC de las DB" 
   !insertmacro MUI_DESCRIPTION_TEXT ${PROG2} "Instala las aplicaciones necesarias para instalar un servidor de SicalWin"
   !insertmacro MUI_DESCRIPTION_TEXT ${SEC10} "Instala AytoFacturas para Sicalwin" 
   !insertmacro MUI_DESCRIPTION_TEXT ${SEC11} "Instala el servidor de SicalWin" 

!insertmacro MUI_FUNCTION_DESCRIPTION_END



##===========================================================================
## Settings
##===========================================================================

!define PROG1_InstDir    "$TEMP\SICAL_TMP\"
!define PROG1_StartIndex ${PROG1}
!define PROG1_EndIndex   ${SEC9}

!define PROG2_InstDir "$TEMP\SICAL_TMP\"
!define PROG2_StartIndex ${PROG2}
!define PROG2_EndIndex   ${SEC11}

##===========================================================================
## Please don't modify below here unless you're a NSIS 'wiz-kid'
##===========================================================================

## Create $PLUGINSDIR
Function .onInit
 InitPluginsDir
FunctionEnd

## If user goes back to this page from 1st Directory page
## we need to put the sections back to how they were before
Var IfBack
Function SelectFilesCheck
 StrCmp $IfBack 1 0 NoCheck
  Call ResetFiles
 NoCheck:
FunctionEnd

## Also if no sections are selected, warn the user!
Function ComponentsLeave
Push $R0
Push $R1

 Call IsPROG1Selected
  Pop $R0
 Call IsPROG2Selected
  Pop $R1
 StrCmp $R0 1 End
 StrCmp $R1 1 End
  Pop $R1
  Pop $R0
 MessageBox MB_OK|MB_ICONEXCLAMATION "$(NoSectionsSelected)"
 Abort

End:
Pop $R1
Pop $R0
FunctionEnd

Function IsPROG1Selected
Push $R0
Push $R1

 StrCpy $R0 ${PROG1_StartIndex} # Group 1 start

  Loop:
   IntOp $R0 $R0 + 1
   SectionGetFlags $R0 $R1			# Get section flags
    IntOp $R1 $R1 & ${SF_SELECTED}
    StrCmp $R1 ${SF_SELECTED} 0 +3		# If section is selected, done
     StrCpy $R0 1
     Goto Done
    StrCmp $R0 ${PROG1_EndIndex} 0 Loop

 Done:
Pop $R1
Exch $R0
FunctionEnd

Function IsPROG2Selected
Push $R0
Push $R1
 
 StrCpy $R0 ${PROG2_StartIndex}    # Group 2 start
 
  Loop:
   IntOp $R0 $R0 + 1
   SectionGetFlags $R0 $R1                      # Get section flags
    IntOp $R1 $R1 & ${SF_SELECTED}
    StrCmp $R1 ${SF_SELECTED} 0 +3              # If section is selected, done
     StrCpy $R0 1
     Goto Done
    StrCmp $R0 ${PROG2_EndIndex} 0 Loop
 
 Done:
Pop $R1
Exch $R0
FunctionEnd

## Here we are selecting first sections to install
## by unselecting all the others!
Function SelectFilesA

 # If user clicks Back now, we will know to reselect Group 2's sections for
 # Components page
 StrCpy $IfBack 1

 # We need to save the state of the Group 2 Sections
 # for the next InstFiles page
Push $R0
Push $R1

 
 StrCpy $R0 ${PROG2_StartIndex} # Group 2 start
 
  Loop:
   IntOp $R0 $R0 + 1
   SectionGetFlags $R0 $R1                                  # Get section flags
    WriteINIStr "$PLUGINSDIR\sections.ini" Sections $R0 $R1 # Save state
    !insertmacro UnselectSection $R0                        # Then unselect it
    StrCmp $R0 ${PROG2_EndIndex} 0 Loop
 
 # Don't install prog 1?
 Call IsPROG1Selected
 Pop $R0
 StrCmp $R0 1 +4
  Pop $R1
  Pop $R0
  Abort
 
 # Set current $INSTDIR to PROG1_InstDir define
 StrCpy $INSTDIR "${PROG1_InstDir}"
 
Pop $R1
Pop $R0
FunctionEnd
 
## Here we need to unselect all Group 1 sections
## and then re-select those in Group 2 (that the user had selected on
## Components page)
Function SelectFilesB
Push $R0
Push $R1
 
 StrCpy $R0 ${PROG1_StartIndex}    # Group 1 start
 
  Loop:
   IntOp $R0 $R0 + 1
    !insertmacro UnselectSection $R0            # Unselect it
    StrCmp $R0 ${PROG1_EndIndex} 0 Loop
 
 Call ResetFiles
 
 # Don't install prog 2?
 Call IsPROG2Selected
 Pop $R0
 StrCmp $R0 1 +4
  Pop $R1
  Pop $R0
  Abort
 
 # Set current $INSTDIR to PROG2_InstDir define
 StrCpy $INSTDIR "${PROG2_InstDir}"
 
Pop $R1
Pop $R0
FunctionEnd
 
## This will set all sections to how they were on the components page
## originally
Function ResetFiles
Push $R0
Push $R1
 
 StrCpy $R0 ${PROG2_StartIndex}    # Group 2 start
 
  Loop:
   IntOp $R0 $R0 + 1
   ReadINIStr "$R1" "$PLUGINSDIR\sections.ini" Sections $R0 # Get sec flags
    SectionSetFlags $R0 $R1                               # Re-set flags for this sec
    StrCmp $R0 ${PROG2_EndIndex} 0 Loop
 
Pop $R1
Pop $R0
FunctionEnd
 
## Here we are deleting the temp INI file at the end of installation
Function DeleteSectionsINI
 Delete "$PLUGINSDIR\Sections.ini"
 FlushINI "$PLUGINSDIR\Sections.ini"
FunctionEnd
