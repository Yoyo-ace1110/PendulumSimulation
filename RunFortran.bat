@echo off
setlocal enabledelayedexpansion

:: 提示用戶輸入資料夾名稱
set /p TargetDir="Please enter the project folder name: "
if "%TargetDir%"=="" (
    echo.
    echo Error: No folder name entered. Please try again.
    goto :eof
)
if not exist "%TargetDir%" (
    echo.
    echo Error: Folder [%TargetDir%] not found. Please check if the name is correct.
    goto :eof
)
:: 檢查該資料夾內是否存在 main.cfg
if not exist "%TargetDir%\main.cfg" (
    echo.
    echo Error: The main.cfg configuration file could not be found in [%TargetDir%].
    goto :eof
)

:: 切換至目標資料夾並建立 build
pushd "%TargetDir%"
if not exist "build" mkdir "build"
echo.
echo Reading [main.cfg] and parsing the project architecture...

:: --------------------------------
:: 讀取設定檔機制
set "MainFile="
set "MainName="
set "ModuleFiles="
set /a LineCount=0

:: 逐行讀取該資料夾下的 main.cfg
for /f "usebackq tokens=*" %%i in ("main.cfg") do (
    set /a LineCount+=1
    if !LineCount!==1 (
        set "MainFile=%%i"
        set "MainName=%%~ni"
    ) else (
        set "ModuleFiles=!ModuleFiles! %%i"
    )
)

echo Main program file name: %MainFile%
echo Executable   file name: %MainName%.exe
if not "%ModuleFiles%"=="" (
    echo Related modules:%ModuleFiles%
) else (
    echo This project has no external modules.
)

echo.
echo Compiling...
:: 呼叫 gfortran 進行編譯
call gfortran %ModuleFiles% %MainFile% -o "build\%MainName%.exe" -O3 -Wall -g -fcheck=all -std=f2008
:: 檢查編譯結果
if errorlevel 1 (
    echo.
    echo Compilation failed! Please check the error message above.
    popd
    goto :eof
)
echo.

echo Compilation successful! Executing program...
echo ----------------------------------------------------------------
echo.
:: 執行程式
"build\%MainName%.exe"
echo ----------------------------------------------------------------
echo The program has finished executing!

:: 回到原本的目錄
popd
endlocal
:eof
