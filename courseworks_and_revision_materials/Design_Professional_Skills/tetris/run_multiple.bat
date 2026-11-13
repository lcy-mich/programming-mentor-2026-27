@echo off
setlocal enabledelayedexpansion

set TOTAL=10
set RESULT_DIR=results

echo Creating output directory: %RESULT_DIR%
if not exist %RESULT_DIR% mkdir %RESULT_DIR%

echo Starting %TOTAL% parallel runs...

REM -----------------------------------------
REM  Launch parallel tasks
REM -----------------------------------------
for /L %%i in (0,1,%TOTAL%-1) do (
    REM Generate strong random seed via PowerShell
    for /f %%s in ('powershell -NoProfile -Command "(Get-Random -Minimum 1 -Maximum 2147483647)"') do set SEED=%%s

    @REM echo Run %%i seed=!SEED!

    REM Run each job in its own background cmd window
    start "" cmd /c ^
        "set ADV_SEED=!SEED! && python headless.py > %RESULT_DIR%\run_%%i.txt 2>&1"
)

echo Waiting for all runs to complete...

REM -----------------------------------------
REM  Wait until all python processes exit
REM -----------------------------------------
:waitloop
tasklist /FI "IMAGENAME eq python.exe" | find /I "python.exe" >nul
if not errorlevel 1 (
    timeout /t 1 >nul
    goto waitloop
)

echo All runs finished. Logs in results\*.txt
echo.
echo ==========================================
echo ALL RUNS COMPLETED - SUMMARY
echo ==========================================
echo.

REM -----------------------------------------
REM  Collect scores
REM -----------------------------------------
set count=0
set scores=

for /L %%i in (0,1,%TOTAL%-1) do (
    if exist %RESULT_DIR%\run_%%i.txt (
        for /f "tokens=2 delims== " %%s in ('findstr /C:"Score=" %RESULT_DIR%\run_%%i.txt') do (
            @REM echo Run %%i: %%s
            set scores=!scores! %%s
            set /a count+=1
        )
    )
)

echo.

REM -----------------------------------------
REM  Compute statistics in PowerShell
REM -----------------------------------------
if %count% GTR 0 (
    echo Statistics:
    powershell -NoProfile -Command ^
        "$scores = '%scores%'.Split(' ',[System.StringSplitOptions]::RemoveEmptyEntries) | ForEach-Object {[int]$_};" ^
        "$scores = $scores | Sort-Object;" ^
        "$min=$scores[0]; $max=$scores[-1]; $mean=($scores | Measure-Object -Average).Average;" ^
        "if($scores.Count %% 2){ $median=$scores[[int]($scores.Count/2)] } else { $median=($scores[$scores.Count/2-1]+$scores[$scores.Count/2])/2 }" ^
        "Write-Host 'Total runs: ' $scores.Count;" ^
        "Write-Host 'Min: ' $min;" ^
        "Write-Host 'Max: ' $max;" ^
        "Write-Host 'Mean: ' ([math]::Round($mean,4));" ^
        "Write-Host 'Median: ' $median;"
)

endlocal
