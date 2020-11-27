@echo on
C:
cd \Program Files (x86)\Persyst\Insight

SETLOCAL ENABLEDELAYEDEXPANSION 
for /f "delims=" %%F in (D:\batch_test\edftest.csv) do (
mkdir D:\Persyst\batch2\"%%F"
InsightII /T=PersystLayout /Tool=ClipExport /Filename=!des! "%%F"
) 
pause

:: Read extensions ( option: /T) 
::DAT  Grass: Twin
::pnt  NK: NihonKohden
::sig  Stellate: Harmonie

:: for 'set' in loop, SETLOCAL ENABLEDELAYEDEXPANSION and !  !   are required!



::::::::::: apply all extenstions :::::::::::::::
@echo on
c:
cd "C:\Program Files (x86)\Persyst\Insight"

for /R "D:\EEGtest\NK" %%F in (*.pnt) do (
	InsightII /T=NihonKohden /Tool=ClipExport /Filename="D:\EEGstore2\%%~nF_export.edf" "%%F"
	)

for /R "D:\EEGtest\" %%F in (*.sig) do (
	InsightII /T=Harmonie /Tool=ClipExport /Filename="D:\EEGstore2\%%~nF_export.edf" "%%F"
	)

for /R "D:\EEGtest\" %%F in (*.qqq) do (
	InsightII /T=Twin /Tool=ClipExport /Filename="D:\EEGstore2\%%~nF_export.edf" "%%F"
	)

for /R "D:\EEGtest\" %%F in (*.sdy) do (
	InsightII /T=Compumedics /Tool=ClipExport /Filename="D:\EEGstore2\%%~nF_export.edf" "%%F"
	)

pause


:: 파일 확장자와 filetype에 대한 정보
:: *pnt: 니혼고덴(NihonKohden), 수동-NihonKohden 2100(*.pnt), 암호화(+)
:: *.sig: 스텔레이트(Stellate), 수동 -Harmonie (*.sig), 암호화(-)
:: *.qqq: 그라스(Grass telefactor), 수동- Twin (Logfile.qqq) (Logfile.qqq) , 암호화(-)
:: *.sdy: 컴퓨메딕스(Compumedics), 수동-Compumedics_(Pro_4) , 암호화(+)
