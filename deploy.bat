@echo off
REM === Set branch names ===
set MAIN_BRANCH=main
set DEPLOY_BRANCH=gh-pages
set BUILD_DIR=_site

echo === Step 1: Build the Jekyll site ===
bundle exec jekyll build
if errorlevel 1 (
    echo Jekyll build failed. Exiting.
    exit /b 1
)

echo === Step 2: Stash uncommitted changes in main ===
git add -A
git stash

echo === Step 3: Switch to gh-pages branch ===
git checkout %DEPLOY_BRANCH%
if errorlevel 1 (
    echo gh-pages branch does not exist. Creating...
    git checkout -b %DEPLOY_BRANCH%
)

echo === Step 4: Remove old files ===
git rm -rf . >nul 2>&1
del /q *.* >nul 2>&1
for /d %%i in (*) do rmdir /s /q "%%i"

echo === Step 5: Copy built site files (excluding _site folder) ===
xcopy "%BUILD_DIR%\*" . /E /I /Y >nul

echo === Step 6: Commit and push to gh-pages ===
git add .
git commit -m "Deploy site update"
git push origin %DEPLOY_BRANCH%

echo === Step 7: Return to main branch and restore changes ===
git checkout %MAIN_BRANCH%
git stash pop

echo === ✅ Deployment complete! ===
pause
