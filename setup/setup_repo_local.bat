@echo off
setlocal EnableDelayedExpansion
title METU IEEE CS - Python 101 Repo-Local Setup (.venv)

echo ============================================================================
echo   METU IEEE Computer Society - Python 101 Mini-Project Setup
echo   Mode: REPO-LOCAL (.venv inside this repository only)
echo ============================================================================
echo.

:: Determine Repository Root (if script is inside a setup/ subfolder, step up one level)
set "SCRIPT_DIR=%~dp0"
if "%SCRIPT_DIR:~-1%"=="\" set "SCRIPT_DIR=%SCRIPT_DIR:~0,-1%"
for %%I in ("%SCRIPT_DIR%") do set "FOLDER_NAME=%%~nxI"
if /I "%FOLDER_NAME%"=="setup" (
    for %%I in ("%SCRIPT_DIR%\..") do set "REPO_ROOT=%%~fI"
) else (
    set "REPO_ROOT=%SCRIPT_DIR%"
)

cd /d "%REPO_ROOT%"
echo [INFO] Target Repository Root: "%REPO_ROOT%"
echo.

:: Launch Native Windows GUI Category Picker (with console fallback)
echo [STEP 1/4] Opening Mini-Project Category Selector...
set "CHOICE="
for /f "usebackq tokens=*" %%A in (`powershell -NoProfile -ExecutionPolicy Bypass -Command ^
    "try { ^
        Add-Type -AssemblyName System.Windows.Forms; ^
        Add-Type -AssemblyName System.Drawing; ^
        $form = New-Object System.Windows.Forms.Form; ^
        $form.Text = 'METU IEEE CS - Mini-Project Category Selector (Repo-Local)'; ^
        $form.Size = New-Object System.Drawing.Size(560, 420); ^
        $form.StartPosition = 'CenterScreen'; ^
        $form.FormBorderStyle = 'FixedDialog'; ^
        $form.MaximizeBox = $false; ^
        $form.TopMost = $true; ^
        $lbl = New-Object System.Windows.Forms.Label; ^
        $lbl.Text = 'Select your Mini-Project Category to install its recommended libraries:'; ^
        $lbl.Location = New-Object System.Drawing.Point(20, 15); ^
        $lbl.Size = New-Object System.Drawing.Size(510, 25); ^
        $lbl.Font = New-Object System.Drawing.Font('Segoe UI', 10, [System.Drawing.FontStyle]::Bold); ^
        $form.Controls.Add($lbl); ^
        $list = New-Object System.Windows.Forms.ListBox; ^
        $list.Location = New-Object System.Drawing.Point(20, 45); ^
        $list.Size = New-Object System.Drawing.Size(505, 260); ^
        $list.Font = New-Object System.Drawing.Font('Segoe UI', 10); ^
        [void]$list.Items.Add('1. Computer Vision & Real-Time Camera Systems (opencv, mediapipe, ultralytics, numpy)'); ^
        [void]$list.Items.Add('2. Data Visualization & Exploratory Analytics (pandas, matplotlib, seaborn, plotly, requests)'); ^
        [void]$list.Items.Add('3. Web Scraping & Automated Data Pipelines (requests, bs4, httpx, schedule)'); ^
        [void]$list.Items.Add('4. Applied Machine Learning & Predictive Modeling (scikit-learn, pandas, numpy, matplotlib, joblib)'); ^
        [void]$list.Items.Add('5. Desktop GUI Applications & Engineering Utilities (customtkinter, PyQt6, pillow, matplotlib)'); ^
        [void]$list.Items.Add('6. 2D Arcade Games & Physics Simulations (pygame-ce, pymunk, numpy)'); ^
        [void]$list.Items.Add('7. Lightweight Web Applications & Interactive Portals (streamlit, gradio, flask, fastapi, uvicorn)'); ^
        [void]$list.Items.Add('8. Network Programming, Sockets & Client-Server Systems (websockets)'); ^
        [void]$list.Items.Add('9. Algorithm & Data Structure Visualizers (pygame-ce, networkx, matplotlib)'); ^
        [void]$list.Items.Add('10. Document, Spreadsheet & PDF Workflow Automation (pypdf, reportlab, fpdf2, openpyxl, python-docx, qrcode)'); ^
        [void]$list.Items.Add('11. INSTALL ALL CATEGORIES (Complete Library Bundle)'); ^
        $list.SelectedIndex = 0; ^
        $form.Controls.Add($list); ^
        $btn = New-Object System.Windows.Forms.Button; ^
        $btn.Text = 'Install Selected Category'; ^
        $btn.Location = New-Object System.Drawing.Point(180, 320); ^
        $btn.Size = New-Object System.Drawing.Size(200, 38); ^
        $btn.Font = New-Object System.Drawing.Font('Segoe UI', 10, [System.Drawing.FontStyle]::Bold); ^
        $btn.DialogResult = [System.Windows.Forms.DialogResult]::OK; ^
        $form.AcceptButton = $btn; ^
        $form.Controls.Add($btn); ^
        if ($form.ShowDialog() -eq [System.Windows.Forms.DialogResult]::OK) { ^
            Write-Output ($list.SelectedIndex + 1) ^
        } else { ^
            Write-Output 'CANCEL' ^
        } ^
    } catch { Write-Output 'FALLBACK' }"`) do set "CHOICE=%%A"

if "%CHOICE%"=="CANCEL" (
    echo [WARN] Setup cancelled by user.
    pause
    exit /b 0
)

if "%CHOICE%"=="FALLBACK" goto :CONSOLE_MENU
if "%CHOICE%"=="" goto :CONSOLE_MENU
goto :MAP_PACKAGES

:CONSOLE_MENU
echo.
echo Select your Mini-Project Category:
echo   [1] Computer Vision ^& Real-Time Camera Systems
echo   [2] Data Visualization ^& Exploratory Analytics
echo   [3] Web Scraping ^& Automated Data Pipelines
echo   [4] Applied Machine Learning ^& Predictive Modeling
echo   [5] Desktop GUI Applications ^& Engineering Utilities
echo   [6] 2D Arcade Games ^& Physics Simulations
echo   [7] Lightweight Web Applications ^& Interactive Portals
echo   [8] Network Programming, Sockets ^& Client-Server Systems
echo   [9] Algorithm ^& Data Structure Visualizers
echo  [10] Document, Spreadsheet ^& PDF Workflow Automation
echo  [11] Install ALL Categories
echo.
set /p "CHOICE=Enter category number (1-11): "

:MAP_PACKAGES
set "BASE_PKGS=ipykernel black flake8"
set "CAT_NAME="
set "CAT_PKGS="

if "%CHOICE%"=="1" (
    set "CAT_NAME=1. Computer Vision & Real-Time Camera Systems"
    set "CAT_PKGS=opencv-python mediapipe ultralytics numpy"
)
if "%CHOICE%"=="2" (
    set "CAT_NAME=2. Data Visualization & Exploratory Analytics"
    set "CAT_PKGS=pandas matplotlib seaborn plotly requests"
)
if "%CHOICE%"=="3" (
    set "CAT_NAME=3. Web Scraping & Automated Data Pipelines"
    set "CAT_PKGS=requests beautifulsoup4 httpx schedule"
)
if "%CHOICE%"=="4" (
    set "CAT_NAME=4. Applied Machine Learning & Predictive Modeling"
    set "CAT_PKGS=scikit-learn pandas numpy matplotlib joblib"
)
if "%CHOICE%"=="5" (
    set "CAT_NAME=5. Desktop GUI Applications & Engineering Utilities"
    set "CAT_PKGS=customtkinter PyQt6 pillow matplotlib"
)
if "%CHOICE%"=="6" (
    set "CAT_NAME=6. 2D Arcade Games & Physics Simulations"
    set "CAT_PKGS=pygame-ce pymunk numpy"
)
if "%CHOICE%"=="7" (
    set "CAT_NAME=7. Lightweight Web Applications & Interactive Portals"
    set "CAT_PKGS=streamlit gradio flask fastapi uvicorn"
)
if "%CHOICE%"=="8" (
    set "CAT_NAME=8. Network Programming, Sockets & Client-Server Systems"
    set "CAT_PKGS=websockets"
)
if "%CHOICE%"=="9" (
    set "CAT_NAME=9. Algorithm & Data Structure Visualizers"
    set "CAT_PKGS=pygame-ce networkx matplotlib"
)
if "%CHOICE%"=="10" (
    set "CAT_NAME=10. Document, Spreadsheet & PDF Workflow Automation"
    set "CAT_PKGS=pypdf reportlab fpdf2 openpyxl python-docx qrcode pillow"
)
if "%CHOICE%"=="11" (
    set "CAT_NAME=11. ALL Mini-Project Categories"
    set "CAT_PKGS=opencv-python mediapipe ultralytics numpy pandas matplotlib seaborn plotly requests beautifulsoup4 httpx schedule scikit-learn joblib customtkinter PyQt6 pillow pygame-ce pymunk streamlit gradio flask fastapi uvicorn websockets networkx pypdf reportlab fpdf2 openpyxl python-docx qrcode"
)

if "%CAT_NAME%"=="" (
    echo [ERROR] Invalid selection "%CHOICE%". Please run the script again and choose 1-11.
    pause
    exit /b 1
)

echo [SELECTED] %CAT_NAME%
echo [PACKAGES] %BASE_PKGS% %CAT_PKGS%
echo.

:: Step 2: Bootstrap standalone uv inside .venv-tools (zero system pollution)
echo [STEP 2/4] Preparing standalone Python manager (uv)...
set "UV_EXE=%REPO_ROOT%\.venv\uv.exe"
where uv >nul 2>&1
if %ERRORLEVEL% EQU 0 (
    for /f "delims=" %%U in ('where uv') do set "UV_EXE=%%U"
) else (
    if not exist "%REPO_ROOT%\.venv" mkdir "%REPO_ROOT%\.venv"
    powershell -NoProfile -ExecutionPolicy Bypass -Command ^
        "$ env:UV_INSTALL_DIR = '%REPO_ROOT%\.venv'; irm https://astral.sh/uv/install.ps1 | iex"
)

if not exist "%UV_EXE%" (
    if exist "%USERPROFILE%\.local\bin\uv.exe" set "UV_EXE=%USERPROFILE%\.local\bin\uv.exe"
    if exist "%USERPROFILE%\.cargo\bin\uv.exe" set "UV_EXE=%USERPROFILE%\.cargo\bin\uv.exe"
)

:: Step 3: Create isolated Python 3.12 virtual environment in .venv
echo.
echo [STEP 3/4] Creating isolated Python 3.12 environment in "%REPO_ROOT%\.venv"...
"%UV_EXE%" venv "%REPO_ROOT%\.venv" --python 3.12 --seed
if %ERRORLEVEL% NEQ 0 (
    echo [ERROR] Failed to create .venv environment. Check your internet connection.
    pause
    exit /b 1
)

:: Step 4: Install selected packages & register VS Code / Jupyter settings
echo.
echo [STEP 4/4] Installing libraries for %CAT_NAME%...
"%UV_EXE%" pip install --python "%REPO_ROOT%\.venv\Scripts\python.exe" %BASE_PKGS% %CAT_PKGS%
if %ERRORLEVEL% NEQ 0 (
    echo [ERROR] Package installation encountered an error.
    pause
    exit /b 1
)

"%REPO_ROOT%\.venv\Scripts\python.exe" -m ipykernel install --user --name cs-python-101-venv --display-name "Python 3.12 (.venv)" >nul 2>&1

:: Configure VS Code to auto-select this repo's .venv interpreter
if not exist "%REPO_ROOT%\.vscode" mkdir "%REPO_ROOT%\.vscode"
if not exist "%REPO_ROOT%\.vscode\settings.json" (
    (
        echo {
        echo   "python.defaultInterpreterPath": "${workspaceFolder}/.venv/Scripts/python.exe",
        echo   "jupyter.kernels.trusted": ["${workspaceFolder}/.venv/Scripts/python.exe"],
        echo   "notebook.lineNumbers": "on"
        echo }
    ) > "%REPO_ROOT%\.vscode\settings.json"
)

echo.
echo ============================================================================
echo   SUCCESS! Repo-Local Python 3.12 Environment (.venv) is Ready!
echo   Installed Category: %CAT_NAME%
echo   Location: %REPO_ROOT%\.venv
echo ============================================================================
pause
