@echo off
setlocal EnableDelayedExpansion
title METU IEEE CS - Python 101 Global PC Setup

echo ============================================================================
echo   METU IEEE Computer Society - Python 101 Mini-Project Setup
echo   Mode: GLOBAL PC (Installs Python 3.12 ^& Libraries System-Wide)
echo ============================================================================
echo.

:: Step 1: Launch Native Windows GUI Category Picker (with console fallback)
echo [STEP 1/3] Opening Mini-Project Category Selector...
set "CHOICE="
for /f "usebackq tokens=*" %%A in (`powershell -NoProfile -ExecutionPolicy Bypass -Command ^
    "try { ^
        Add-Type -AssemblyName System.Windows.Forms; ^
        Add-Type -AssemblyName System.Drawing; ^
        $form = New-Object System.Windows.Forms.Form; ^
        $form.Text = 'METU IEEE CS - Mini-Project Category Selector (Global PC)'; ^
        $form.Size = New-Object System.Drawing.Size(560, 420); ^
        $form.StartPosition = 'CenterScreen'; ^
        $form.FormBorderStyle = 'FixedDialog'; ^
        $form.MaximizeBox = $false; ^
        $form.TopMost = $true; ^
        $lbl = New-Object System.Windows.Forms.Label; ^
        $lbl.Text = 'Select your Mini-Project Category to install globally on this PC:'; ^
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
        $btn.Text = 'Install Globally on PC'; ^
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

:: Step 2: Check for real system Python (avoiding the Windows Store stub)
echo [STEP 2/3] Checking system-wide Python installation...
set "PY_CMD="
python -c "import sys; assert sys.version_info >= (3, 10)" >nul 2>&1
if %ERRORLEVEL% EQU 0 (
    set "PY_CMD=python"
) else (
    py -3 -c "import sys; assert sys.version_info >= (3, 10)" >nul 2>&1
    if !ERRORLEVEL! EQU 0 set "PY_CMD=py -3"
)

if "%PY_CMD%"=="" (
    echo [INFO] Python 3.10+ not detected. Installing Python 3.12 globally...
    where winget >nul 2>&1
    if !ERRORLEVEL! EQU 0 (
        winget install -e --id Python.Python.3.12 --scope user --accept-package-agreements --accept-source-agreements
    ) else (
        echo [INFO] Downloading official Python 3.12 installer from python.org...
        powershell -NoProfile -ExecutionPolicy Bypass -Command ^
            "Invoke-WebRequest -Uri 'https://www.python.org/ftp/python/3.12.8/python-3.12.8-amd64.exe' -OutFile '$env:TEMP\python-installer.exe'"
        "%TEMP%\python-installer.exe" /passive InstallAllUsers=0 PrependPath=1 Include_test=0
        del "%TEMP%\python-installer.exe" >nul 2>&1
    )
    if exist "%LocalAppData%\Programs\Python\Python312\python.exe" (
        set "PY_CMD=%LocalAppData%\Programs\Python\Python312\python.exe"
    ) else (
        set "PY_CMD=python"
    )
)

echo [INFO] Using Python command: %PY_CMD%
echo.

:: Step 3: Install libraries globally and register Jupyter kernel
echo [STEP 3/3] Installing libraries globally for %CAT_NAME%...
%PY_CMD% -m pip install --upgrade pip
%PY_CMD% -m pip install --upgrade %BASE_PKGS% %CAT_PKGS%
if %ERRORLEVEL% NEQ 0 (
    echo [ERROR] Package installation encountered an error.
    pause
    exit /b 1
)

%PY_CMD% -m ipykernel install --user --name python3 --display-name "Python 3" >nul 2>&1

echo.
echo ============================================================================
echo   SUCCESS! Global PC Python & Libraries are Ready!
echo   Installed Category: %CAT_NAME%
echo   Note: Restart VS Code or your terminal if Python was newly installed.
echo ============================================================================
pause
