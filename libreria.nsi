!include x64.nsh
;
; Chequea que exista la entrada ODBC
;
;  Input: Nombre de la entrada ODBC
;  Output: TRUE, FALSE
;
; Usa
;
;    Push "laquesea"
;    Call ODBCEntryExists
;    Pop "$1"
;    MessageBox MB_OK|MB_ICONINFORMATION "La entrada de ODBC 'laquesea' existe: $1"
;
Var Ruta_registro 
!macro ODBCEntryExistsMacro

  ClearErrors
  ; Pop the name of the ODBC entry from the stack
  Exch $R0
 
  IfErrors InvalidParameter CheckODBCEntry
  InvalidParameter:
    MessageBox MB_OK|MB_ICONEXCLAMATION "Por favor introduzca un nombre de ODBC para buscar."
    StrCpy $R0 "FALSE"
    Goto Done
  CheckODBCEntry:
    ClearErrors
    ReadRegStr $R0 HKEY_LOCAL_MACHINE "$Ruta_registro\ODBC\ODBC.INI\ODBC Data Sources" "$R0"
    IfErrors NotFound Found
    NotFound:
      StrCpy $R0 "FALSE"
      Goto Done
    Found:
      StrCpy $R0 "TRUE"
      Goto Done
  Done:
 
  Exch $R0
 
!macroend
 
Function ODBCEntryExists
  !insertmacro ODBCEntryExistsMacro
FunctionEnd
 
Function un.ODBCEntryExists
  !insertmacro ODBCEntryExistsMacro
FunctionEnd



;-----------------------------------------------
;
; Muestra la lista de ODBC's del sistema separados por "|"
;
; Usamos asi:
;    Call Get_ODBC_Entries
;    Pop "$1"
;    MessageBox MB_OK|MB_ICONINFORMATION "Entradas ODBC: $1"
;
!ifndef Get_ODBC_Entries.Included
!define Get_ODBC_Entries.Included
 
!macro Get_ODBC_EntriesMacro
 

  ; Clear all errors at the beginning
  ClearErrors
  ; Pop the name of the ODBC entry from the stack
  Push $R0
  Push $R1
  Push $0
 
  StrCpy $0 0
  StrCpy $R0 ""
 
  loop:
    EnumRegValue $R1 HKEY_LOCAL_MACHINE "$Ruta_registro\ODBC\ODBC.INI\ODBC Data Sources" $0
    StrCmp $R1 "" Done
    StrCpy $R0 "$R0|$R1"
    IntOp $0 $0 + 1
    Goto loop
  Done:
 
  Pop $0
  Pop $R1
  Exch $R0
!macroend
 
Function Get_ODBC_Entries
  !insertmacro Get_ODBC_EntriesMacro
FunctionEnd
 
Function un.Get_ODBC_Entries
  !insertmacro Get_ODBC_EntriesMacro
FunctionEnd
 
!endif



;-----------------------------------------------
;
; Crea una entrada ODBC para MS Access database
;
; Requires: ODBCEntryExists
;    Input: Name of the ODBC entry
;           Path to the MS Access database
;   Output: FALSE,TRUE
;
; Usage:
;
;    Push "ODBCTEST"
;    Push "c:\program files\mdb\test.mdb"
;    Call CreateAccessODBCEntry
;    Pop $1
;    MessageBox MB_OK|MB_ICONINFORMATION "Entrada de Access ODBC creada: $1"
;
 
Function CreateAccessODBCEntry


  StrCpy $Ruta_registro "SOFTWARE\"

  Exch $R1            ; Path to the MS Access database
  Exch
  Exch $R2            ; Name of the ODBC entry
 
  ; Save R0 on the stack
  Push $R0
 
  ; Check whether the ODBC entry already exists
  Push $R2
  Call ODBCEntryExists
  Pop $R0
  #MessageBox MB_OK $R0
  StrCmp $R0 "TRUE" AlreadyExists
 
  ; Create the necessary registry keys
  WriteRegStr HKEY_LOCAL_MACHINE "$Ruta_registro\ODBC\ODBC.INI\$R2" "DBQ" "$R1"
  WriteRegStr HKEY_LOCAL_MACHINE "$Ruta_registro\ODBC\ODBC.INI\$R2" "Driver" "$SYSDIR\odbcjt32.dll"
  WriteRegDWORD HKEY_LOCAL_MACHINE "$Ruta_registro\ODBC\ODBC.INI\$R2" "DriverId" 25
  WriteRegStr HKEY_LOCAL_MACHINE "$Ruta_registro\ODBC\ODBC.INI\$R2" "FIL" "MS Access;"
  WriteRegDWORD HKEY_LOCAL_MACHINE "$Ruta_registro\ODBC\ODBC.INI\$R2" "SafeTransactions" 0
  WriteRegStr HKEY_LOCAL_MACHINE "$Ruta_registro\ODBC\ODBC.INI\$R2" "UID" ""
  WriteRegStr HKEY_LOCAL_MACHINE "$Ruta_registro\ODBC\ODBC.INI\$R2\Engines\Jet" "ImplicitCommitSync" ""
  WriteRegDWORD HKEY_LOCAL_MACHINE "$Ruta_registro\ODBC\ODBC.INI\$R2\Engines\Jet" "MaxBufferSize" 2048
  WriteRegDWORD HKEY_LOCAL_MACHINE "$Ruta_registro\ODBC\ODBC.INI\$R2\Engines\Jet" "PageTimeout" 5
  WriteRegDWORD HKEY_LOCAL_MACHINE "$Ruta_registro\ODBC\ODBC.INI\$R2\Engines\Jet" "Threads" 3
  WriteRegStr HKEY_LOCAL_MACHINE "$Ruta_registro\ODBC\ODBC.INI\$R2\Engines\Jet" "UserCommitSync" "Yes"
  WriteRegStr HKEY_LOCAL_MACHINE "$Ruta_registro\ODBC\ODBC.INI\ODBC Data Sources" "$R2" "Microsoft Access Driver (*.mdb)"
 
  StrCpy $R1 "TRUE"
  Goto Done
 
  AlreadyExists:
    StrCpy $R1 "FALSE"
    Goto Done
 
  Done:
 
  ; Restore R0-R2
  Pop $R0
  Pop $R2
  Exch $R1
 
FunctionEnd

;-------------------------------------------------------------
; Graba en un fichero los archivos que encuentra en un directorio
; Se pueden poner filtros
;Push "$INSTDIR\output.txt" # output file
;Push "*.ext" # filter
;Push "C:\A-Folder" # folder to search in
;Call MakeFileList

Function MakeFileList
Exch $R0 #path
Exch
Exch $R1 #filter
Exch
Exch 2
Exch $R2 #output file
Exch 2
Push $R3
Push $R4
Push $R5
 ClearErrors
 FindFirst $R3 $R4 "$R0\$R1"
  FileOpen $R5 $R2 w
 
 Loop:
 IfErrors Done
  FileWrite $R5 "$R0\$R4$\r$\n"
  FindNext $R3 $R4
  Goto Loop
 
 Done:
  FileClose $R5
 FindClose $R3
Pop $R5
Pop $R4
Pop $R3
Pop $R2
Pop $R1
Pop $R0
FunctionEnd

;----------------------------------------------------------------
;Busca un fichero en un directorio y subdirectorios
;


Function FindFiles
  Exch $R5 # callback function
  Exch 
  Exch $R4 # file name
  Exch 2
  Exch $R0 # directory
  Push $R1
  Push $R2
  Push $R3
  Push $R6
 
  Push $R0 # first dir to search
 
  StrCpy $R3 1
 
  nextDir:
    Pop $R0
    IntOp $R3 $R3 - 1
    ClearErrors
    FindFirst $R1 $R2 "$R0\*.*"
    nextFile:
      StrCmp $R2 "." gotoNextFile
      StrCmp $R2 ".." gotoNextFile
 
      StrCmp $R2 $R4 0 isDir
        Push "$R0\$R2"
        Call $R5
        Pop $R6
        StrCmp $R6 "stop" 0 isDir
          loop:
            StrCmp $R3 0 done
            Pop $R0
            IntOp $R3 $R3 - 1
            Goto loop
 
      isDir:
        IfFileExists "$R0\$R2\*.*" 0 gotoNextFile
          IntOp $R3 $R3 + 1
          Push "$R0\$R2"
 
  gotoNextFile:
    FindNext $R1 $R2
    IfErrors 0 nextFile
 
  done:
    FindClose $R1
    StrCmp $R3 0 0 nextDir
 
  Pop $R6
  Pop $R3
  Pop $R2
  Pop $R1
  Pop $R0
  Pop $R5
  Pop $R4
FunctionEnd


;-----------------------------------------------------
Function GetTime
	!define GetTime `!insertmacro GetTimeCall`
 
	!macro GetTimeCall _FILE _OPTION _R1 _R2 _R3 _R4 _R5 _R6 _R7
		Push `${_FILE}`
		Push `${_OPTION}`
		Call GetTime
		Pop ${_R1}
		Pop ${_R2}
		Pop ${_R3}
		Pop ${_R4}
		Pop ${_R5}
		Pop ${_R6}
		Pop ${_R7}
	!macroend
 
	Exch $1
	Exch
	Exch $0
	Exch
	Push $2
	Push $3
	Push $4
	Push $5
	Push $6
	Push $7
	ClearErrors
 
	StrCmp $1 'L' gettime
	StrCmp $1 'A' getfile
	StrCmp $1 'C' getfile
	StrCmp $1 'M' getfile
	StrCmp $1 'LS' gettime
	StrCmp $1 'AS' getfile
	StrCmp $1 'CS' getfile
	StrCmp $1 'MS' getfile
	goto error
 
	getfile:
	IfFileExists $0 0 error
	System::Call /NOUNLOAD '*(i,l,l,l,i,i,i,i,&t260,&t14) i .r6'
	System::Call /NOUNLOAD 'kernel32::FindFirstFileA(t,i)i(r0,r6) .r2'
	System::Call /NOUNLOAD 'kernel32::FindClose(i)i(r2)'
 
	gettime:
	System::Call /NOUNLOAD '*(&i2,&i2,&i2,&i2,&i2,&i2,&i2,&i2) i .r7'
	StrCmp $1 'L' 0 systemtime
	System::Call /NOUNLOAD 'kernel32::GetLocalTime(i)i(r7)'
	goto convert
	systemtime:
	StrCmp $1 'LS' 0 filetime
	System::Call /NOUNLOAD 'kernel32::GetSystemTime(i)i(r7)'
	goto convert
 
	filetime:
	System::Call /NOUNLOAD '*$6(i,l,l,l,i,i,i,i,&t260,&t14)i(,.r4,.r3,.r2)'
	System::Free /NOUNLOAD $6
	StrCmp $1 'A' 0 +3
	StrCpy $2 $3
	goto tolocal
	StrCmp $1 'C' 0 +3
	StrCpy $2 $4
	goto tolocal
	StrCmp $1 'M' tolocal
 
	StrCmp $1 'AS' tosystem
	StrCmp $1 'CS' 0 +3
	StrCpy $3 $4
	goto tosystem
	StrCmp $1 'MS' 0 +3
	StrCpy $3 $2
	goto tosystem
 
	tolocal:
	System::Call /NOUNLOAD 'kernel32::FileTimeToLocalFileTime(*l,*l)i(r2,.r3)'
	tosystem:
	System::Call /NOUNLOAD 'kernel32::FileTimeToSystemTime(*l,i)i(r3,r7)'
 
	convert:
	System::Call /NOUNLOAD '*$7(&i2,&i2,&i2,&i2,&i2,&i2,&i2,&i2)i(.r5,.r6,.r4,.r0,.r3,.r2,.r1,)'
	System::Free $7
 
	IntCmp $0 9 0 0 +2
	StrCpy $0 '0$0'
	IntCmp $1 9 0 0 +2
	StrCpy $1 '0$1'
	IntCmp $2 9 0 0 +2
	StrCpy $2 '0$2'
	IntCmp $6 9 0 0 +2
	StrCpy $6 '0$6'
 
	StrCmp $4 0 0 +3
	StrCpy $4 Sunday
	goto end
	StrCmp $4 1 0 +3
	StrCpy $4 Monday
	goto end
	StrCmp $4 2 0 +3
	StrCpy $4 Tuesday
	goto end
	StrCmp $4 3 0 +3
	StrCpy $4 Wednesday
	goto end
	StrCmp $4 4 0 +3
	StrCpy $4 Thursday
	goto end
	StrCmp $4 5 0 +3
	StrCpy $4 Friday
	goto end
	StrCmp $4 6 0 error
	StrCpy $4 Saturday
	goto end
 
	error:
	SetErrors
	StrCpy $0 ''
	StrCpy $1 ''
	StrCpy $2 ''
	StrCpy $3 ''
	StrCpy $4 ''
	StrCpy $5 ''
	StrCpy $6 ''
 
	end:
	Pop $7
	Exch $6
	Exch
	Exch $5
	Exch 2
	Exch $4
	Exch 3
	Exch $3
	Exch 4
	Exch $2
	Exch 5
	Exch $1
	Exch 6
	Exch $0
FunctionEnd
;---------------------------------------



;---------------------------------------------------------------------
;------Locate-----------------

Function Locate
	!define Locate `!insertmacro LocateCall`
 
	!macro LocateCall _PATH _OPTIONS _FUNC
		Push $0
		Push `${_PATH}`
		Push `${_OPTIONS}`
		GetFunctionAddress $0 `${_FUNC}`
		Push `$0`
		Call Locate
		Pop $0
	!macroend
 
	Exch $2
	Exch
	Exch $1
	Exch
	Exch 2
	Exch $0
	Exch 2
	Push $3
	Push $4
	Push $5
	Push $6
	Push $7
	Push $8
	Push $9
	Push $R6
	Push $R7
	Push $R8
	Push $R9
	ClearErrors
 
	StrCpy $3 ''
	StrCpy $4 ''
	StrCpy $5 ''
	StrCpy $6 ''
	StrCpy $7 ''
	StrCpy $8 0
	StrCpy $R7 ''
 
	StrCpy $R9 $0 1 -1
	StrCmp $R9 '\' 0 +3
	StrCpy $0 $0 -1
	goto -3
	IfFileExists '$0\*.*' 0 error
 
	option:
	StrCpy $R9 $1 1
	StrCpy $1 $1 '' 1
	StrCmp $R9 ' ' -2
	StrCmp $R9 '' sizeset
	StrCmp $R9 '/' 0 -4
	StrCpy $9 -1
	IntOp $9 $9 + 1
	StrCpy $R9 $1 1 $9
	StrCmp $R9 '' +2
	StrCmp $R9 '/' 0 -3
	StrCpy $R8 $1 $9
	StrCpy $R8 $R8 '' 2
	StrCpy $R9 $R8 '' -1
	StrCmp $R9 ' ' 0 +3
	StrCpy $R8 $R8 -1
	goto -3
	StrCpy $R9 $1 2
	StrCpy $1 $1 '' $9
 
	StrCmp $R9 'L=' 0 mask
	StrCpy $3 $R8
	StrCmp $3 '' +6
	StrCmp $3 'FD' +5
	StrCmp $3 'F' +4
	StrCmp $3 'D' +3
	StrCmp $3 'DE' +2
	StrCmp $3 'FDE' 0 error
	goto option
 
	mask:
	StrCmp $R9 'M=' 0 size
	StrCpy $4 $R8
	goto option
 
	size:
	StrCmp $R9 'S=' 0 gotosubdir
	StrCpy $6 $R8
	goto option
 
 
	gotosubdir:
	StrCmp $R9 'G=' 0 banner
	StrCpy $7 $R8
	StrCmp $7 '' +3
	StrCmp $7 '1' +2
	StrCmp $7 '0' 0 error
	goto option
 
	banner:
	StrCmp $R9 'B=' 0 error
	StrCpy $R7 $R8
	StrCmp $R7 '' +3
	StrCmp $R7 '1' +2
	StrCmp $R7 '0' 0 error
	goto option
 
	sizeset:
	StrCmp $6 '' default
	StrCpy $9 0
	StrCpy $R9 $6 1 $9
	StrCmp $R9 '' +4
	StrCmp $R9 ':' +3
	IntOp $9 $9 + 1
	goto -4
	StrCpy $5 $6 $9
	IntOp $9 $9 + 1
	StrCpy $1 $6 1 -1
	StrCpy $6 $6 -1 $9
	StrCmp $5 '' +2
	IntOp $5 $5 + 0
	StrCmp $6 '' +2
	IntOp $6 $6 + 0
 
	StrCmp $1 'B' 0 +3
	StrCpy $1 1
	goto default
	StrCmp $1 'K' 0 +3
	StrCpy $1 1024
	goto default
	StrCmp $1 'M' 0 +3
	StrCpy $1 1048576
	goto default
	StrCmp $1 'G' 0 error
	StrCpy $1 1073741824
 
	default:
	StrCmp $3 '' 0 +2
	StrCpy $3 'FD'
	StrCmp $4 '' 0 +2
	StrCpy $4 '*.*'
	StrCmp $7 '' 0 +2
	StrCpy $7 '1'
	StrCmp $R7 '' 0 +2
	StrCpy $R7 '0'
	StrCpy $7 'G$7B$R7'
 
	StrCpy $8 1
	Push $0
	SetDetailsPrint textonly
 
	nextdir:
	IntOp $8 $8 - 1
	Pop $R8
 
	StrCpy $9 $7 2 2
	StrCmp $9 'B0' +3
	GetLabelAddress $9 findfirst
	goto call
	DetailPrint 'Search in: $R8'
 
	findfirst:
	FindFirst $0 $R7 '$R8\$4'
	IfErrors subdir
	StrCmp $R7 '.' 0 +5
	FindNext $0 $R7
	StrCmp $R7 '..' 0 +3
	FindNext $0 $R7
	IfErrors subdir
 
	dir:
	IfFileExists '$R8\$R7\*.*' 0 file
	StrCpy $R6 ''
	StrCmp $3 'DE' +4
	StrCmp $3 'FDE' +3
	StrCmp $3 'FD' precall
	StrCmp $3 'F' findnext precall
	FindFirst $9 $R9 '$R8\$R7\*.*'
	StrCmp $R9 '.' 0 +4
	FindNext $9 $R9
	StrCmp $R9 '..' 0 +2
	FindNext $9 $R9
	FindClose $9
	IfErrors precall findnext
 
	file:
	StrCmp $3 'FDE' +3
	StrCmp $3 'FD' +2
	StrCmp $3 'F' 0 findnext
	StrCpy $R6 0
	StrCmp $5$6 '' precall
	FileOpen $9 '$R8\$R7' r
	IfErrors +3
	FileSeek $9 0 END $R6
	FileClose $9
	System::Int64Op $R6 / $1
	Pop $R6
	StrCmp $5 '' +2
	IntCmp $R6 $5 0 findnext
	StrCmp $6 '' +2
	IntCmp $R6 $6 0 0 findnext
 
	precall:
	StrCpy $9 0
	StrCpy $R9 '$R8\$R7'
 
	call:
	Push $0
	Push $1
	Push $2
	Push $3
	Push $4
	Push $5
	Push $6
	Push $7
	Push $8
	Push $9
	Push $R7
	Push $R8
	StrCmp $9 0 +4
	StrCpy $R6 ''
	StrCpy $R7 ''
	StrCpy $R9 ''
	Call $2
	Pop $R9
	Pop $R8
	Pop $R7
	Pop $9
	Pop $8
	Pop $7
	Pop $6
	Pop $5
	Pop $4
	Pop $3
	Pop $2
	Pop $1
	Pop $0
	IfErrors error
 
	StrCmp $R9 'StopLocate' clearstack
	goto $9
 
	findnext:
	FindNext $0 $R7
	IfErrors 0 dir
	FindClose $0
 
	subdir:
	StrCpy $9 $7 2
	StrCmp $9 'G0' end
	FindFirst $0 $R7 '$R8\*.*'
	StrCmp $R7 '.' 0 +5
	FindNext $0 $R7
	StrCmp $R7 '..' 0 +3
	FindNext $0 $R7
	IfErrors +7
 
	IfFileExists '$R8\$R7\*.*' 0 +3
	Push '$R8\$R7'
	IntOp $8 $8 + 1
	FindNext $0 $R7
	IfErrors 0 -4
	FindClose $0
	StrCmp $8 0 end nextdir
 
	error:
	SetErrors
 
	clearstack:
	StrCmp $8 0 end
	IntOp $8 $8 - 1
	Pop $R8
	goto clearstack
 
	end:
	SetDetailsPrint both
	Pop $R9
	Pop $R8
	Pop $R7
	Pop $R6
	Pop $9
	Pop $8
	Pop $7
	Pop $6
	Pop $5
	Pop $4
	Pop $3
	Pop $2
	Pop $1
	Pop $0
FunctionEnd



Function GetBaseName
    ; This function takes a file name and returns the base name (no extension)
    ; Input is from the top of the stack
    ; Usage example:
    ; push (file name)
    ; call GetBaseName
    ; pop (file name)
 
 
    Exch $1  ; Initial value
    Push $2  ; Pointer variable
    Push $3  ; single character (temp)
    Push $4  ; New string
    strCpy $4 ""
    ; I add 'x' to the string to make it easier to 
    ;  use with my pointer variable
    StrCpy $1 "x$1"  
    strCpy $2 "0"
  StartBaseLoop:
    IntOp $2 $2 + 1
    StrCpy $3 $1 1 $2
    strCmp $3 "." ExitBaseLoop
    StrCmp $3 "" ExitBaseLoop
    StrCpy $4 "$4$3"
    Goto StartBaseLoop
  ExitBaseLoop:
    StrCpy $1 $4
    Pop $4
    Pop $3
    Pop $2
    Exch $1
FunctionEnd

