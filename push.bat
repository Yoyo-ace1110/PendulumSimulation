@echo off
chcp 65001 > nul

echo Copyright Notice
echo © 2025 Yoyo-ace1110. All Rights Reserved.

:: Get user input
set /p commit_msg="Enter commit message: "

echo.
echo ===================================================
echo Preparing Git operations...
echo Message: "%commit_msg%"
echo ===================================================
echo.

:: Step 1: Git Add
echo [1/3] Adding changes...
git add .
if errorlevel 1 (
    echo.
    echo ❌ Error: git add failed.
    goto :end
)

:: Step 2: Git Commit
echo [2/3] Committing changes...
if "%commit_msg%"=="" (
    echo.
    echo ⚠️ Warning: Message is empty. Using "Auto commit".
    set commit_msg=Auto commit
)

git commit -m "%commit_msg%"

:: Handle "nothing to commit" case
if errorlevel 1 (
    git status | findstr /i "nothing to commit"
    if not errorlevel 1 (
        echo.
        echo ✅ Info: Nothing new to commit. Skipping push.
        goto :end
    ) else (
        echo.
        echo ❌ Error: git commit failed.
        goto :end
    )
)

:: Step 3: Git Push
echo.
echo [3/3] Pushing to remote...
git push

if errorlevel 1 (
    echo.
    echo ❌ Error: Push failed.
    echo Tip: Try "git pull" first if there are remote changes.
) else (
    echo.
    echo ===================================================
    echo 🎉 Success! All changes pushed.
    echo ===================================================
)

:end
pause
