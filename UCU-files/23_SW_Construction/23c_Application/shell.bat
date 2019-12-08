@echo off
set PATH=%CD%\BSW\util\gnu;%PATH%
SET ROOT_DIR=%CD%
rem mst: Substitute "\" by "/". Does not work inside "if" clause!
set "ROOT_DIR=%ROOT_DIR:\=/%"

set        	MATLAB_BUILD=%1
set              COMMAND=%2
set      BSW_LIB_VERSION=%3
set ENABLE_MULTI_PROCESS=%4

set MAKEFILE=%ROOT_DIR%/Bsw/make/Makefile_Bsw_Lib.mak
set SHELL=cmd.exe

cls
if %COMMAND%==lib_rebuild (goto LIB_REBUILD)
if %COMMAND%==lib_build   (goto LIB_BUILD)
if %COMMAND%==dist 			  (goto DIST)
if %COMMAND%==shell			  (goto SHELL)
if %COMMAND%==build_all	  (goto BUILD_ALL)
if %COMMAND%==build_AMOS_APP4UCU	  (goto BUILD_AMOS_APP4UCU)
if %COMMAND%==build_WLOAD	  (goto BUILD_WLOAD)
if %COMMAND%==build_RTE	  (goto BUILD_RTE)
if %COMMAND%==build_IOHWAB  (goto BUILD_IOHWAB)
if %COMMAND%==build_all_libs  (goto BUILD_ALL_LIBS)
if %COMMAND%==build_DELIVERABLE  (goto BUILD_DELIVERABLE)

:SHELL
cls
@echo ***
@echo *** Use "make -f .\BSW\make\Makefile_Bsw_Lib clean all ..." to build targets
@echo ***
cmd.exe
goto EXIT

:LIB_REBUILD
make --no-builtin-rules --no-print-directory -j1 -f %MAKEFILE% clean  
make --no-builtin-rules --no-print-directory -j1 -f %MAKEFILE% build_info  
make --no-builtin-rules --no-print-directory %ENABLE_MULTI_PROCESS% -f %MAKEFILE% all  
make --no-builtin-rules --no-print-directory -j1 -f %MAKEFILE% mem_usage
goto EXIT

:LIB_BUILD
make --no-builtin-rules --no-print-directory -j1 -f %MAKEFILE% clean_lib 
make --no-builtin-rules --no-print-directory -j1 -f %MAKEFILE% build_info  
make --no-builtin-rules --no-print-directory %ENABLE_MULTI_PROCESS% -f %MAKEFILE% all 
make --no-builtin-rules --no-print-directory -j1 -f %MAKEFILE% mem_usage
goto EXIT


:BUILD_AMOS_APP4UCU
CD %ROOT_DIR%\Appl
call SWC.bat "AMOS_APP4UCU" "AMOS_APP4UCU_autosar_rtw"
goto EXIT
:BUILD_WLOAD
CD %ROOT_DIR%\Appl
call SWC.bat "wLoad" 
goto EXIT
:BUILD_RTE
CD %ROOT_DIR%\Appl
call SWC.bat "Rte" "rte"
goto EXIT
:BUILD_IOHWAB
CD %ROOT_DIR%\Appl
call SWC.bat "IOHwAb_C0" "IOHwAb_C0_autosar_rtw"
goto EXIT
:BUILD_ALL_LIBS
call Libs.bat all
goto EXIT
:BUILD_DELIVERABLE
call Libs.bat deliverable
goto EXIT
:DIST
make --no-builtin-rules --no-print-directory %ENABLE_MULTI_PROCESS% -f %MAKEFILE% clean all
make --no-builtin-rules --no-print-directory -j1 -f %MAKEFILE% dist
goto EXIT

:EXIT
pause
