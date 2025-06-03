@echo off
setlocal

set MAIN_BRANCH=main
set DEPLOY_BRANCH=gh-pages
set BUILD_DIR=_site

echo === Step 1: Ensure you’re on the main branch ===
git checkout %MAIN_BRANCH%

echo === Step 2: Build the Jekyll site ===
bundle exec jekyll build
if errorlevel 1 (
    echo ❌ Jekyll build failed. Exiting.
    exit /b 1
)

echo === Step 3: Check if gh-pages branch exists ===
git show-ref --quiet refs/heads/%DEPLOY_BRANCH%
if errorlevel 1 (
    echo 🔧 gh-pages branch not found. Creating it...
    git checkout --orphan %DEPLOY_BRANCH%
    git rm -rf . >nul 2>&1
    echo "Initializing gh-pages" > index.html
    git add index.html
    git commit -m "Initialize gh-pages branch"
    git push origin %DEPLOY_BRANCH%
) else (
    git checkout %DEPLOY_BRANCH%
)

echo === Step 4: Clear old files in gh-pages ===
git rm -rf . >nul 2>&1
del /q *.* >nul 2>&1
for /d %%i in (*) do rmdir /s /q "%%i"

echo === Step 5: Copy _site conten_
