#!/usr/bin/env bash
set -e

echo "============================================================================"
echo "  METU IEEE Computer Society - Python 101 Mini-Project Setup"
echo "  Mode: GLOBAL PC (Installs Python 3 & Libraries System-Wide)"
echo "============================================================================"
echo ""

# Step 1: Category Selection (Native macOS GUI / Linux Zenity GUI / Terminal Menu Fallback)
CHOICE=""
OS_TYPE="$(uname -s)"

if [ "$OS_TYPE" = "Darwin" ] && command -v osascript >/dev/null 2>&1; then
    CHOICE=$(osascript -e '
        set catList to {¬
            "1. Computer Vision & Real-Time Camera Systems", ¬
            "2. Data Visualization & Exploratory Analytics", ¬
            "3. Web Scraping & Automated Data Pipelines", ¬
            "4. Applied Machine Learning & Predictive Modeling", ¬
            "5. Desktop GUI Applications & Engineering Utilities", ¬
            "6. 2D Arcade Games & Physics Simulations", ¬
            "7. Lightweight Web Applications & Interactive Portals", ¬
            "8. Network Programming, Sockets & Client-Server Systems", ¬
            "9. Algorithm & Data Structure Visualizers", ¬
            "10. Document, Spreadsheet & PDF Workflow Automation", ¬
            "11. INSTALL ALL CATEGORIES (Complete Bundle)"}
        set selectedItem to choose from list catList with title "METU IEEE CS - Global PC Setup" with prompt "Select your Mini-Project Category to install globally:" default items {"1. Computer Vision & Real-Time Camera Systems"}
        if selectedItem is false then
            return "CANCEL"
        else
            set itemText to item 1 of selectedItem
            return word 1 of itemText
        end if
    ' 2>/dev/null || echo "")
elif command -v zenity >/dev/null 2>&1 && [ -n "${DISPLAY:-}${WAYLAND_DISPLAY:-}" ]; then
    CHOICE=$(zenity --list --title="METU IEEE CS - Global PC Setup" \
        --text="Select your Mini-Project Category to install globally on this computer:" \
        --width=680 --height=440 \
        --column="ID" --column="Category" \
        "1" "Computer Vision & Real-Time Camera Systems (opencv, mediapipe, ultralytics, numpy)" \
        "2" "Data Visualization & Exploratory Analytics (pandas, matplotlib, seaborn, plotly, requests)" \
        "3" "Web Scraping & Automated Data Pipelines (requests, bs4, httpx, schedule)" \
        "4" "Applied Machine Learning & Predictive Modeling (scikit-learn, pandas, numpy, matplotlib, joblib)" \
        "5" "Desktop GUI Applications & Engineering Utilities (customtkinter, PyQt6, pillow, matplotlib)" \
        "6" "2D Arcade Games & Physics Simulations (pygame-ce, pymunk, numpy)" \
        "7" "Lightweight Web Applications & Interactive Portals (streamlit, gradio, flask, fastapi, uvicorn)" \
        "8" "Network Programming, Sockets & Client-Server Systems (websockets)" \
        "9" "Algorithm & Data Structure Visualizers (pygame-ce, networkx, matplotlib)" \
        "10" "Document, Spreadsheet & PDF Workflow Automation (pypdf, reportlab, fpdf2, openpyxl, python-docx, qrcode)" \
        "11" "INSTALL ALL CATEGORIES (Complete Library Bundle)" 2>/dev/null || echo "CANCEL")
fi

if [ "$CHOICE" = "CANCEL" ]; then
    echo "[WARN] Setup cancelled by user."
    exit 0
fi

if [ -z "$CHOICE" ]; then
    echo "Select your Mini-Project Category:"
    echo "  [1] Computer Vision & Real-Time Camera Systems"
    echo "  [2] Data Visualization & Exploratory Analytics"
    echo "  [3] Web Scraping & Automated Data Pipelines"
    echo "  [4] Applied Machine Learning & Predictive Modeling"
    echo "  [5] Desktop GUI Applications & Engineering Utilities"
    echo "  [6] 2D Arcade Games & Physics Simulations"
    echo "  [7] Lightweight Web Applications & Interactive Portals"
    echo "  [8] Network Programming, Sockets & Client-Server Systems"
    echo "  [9] Algorithm & Data Structure Visualizers"
    echo " [10] Document, Spreadsheet & PDF Workflow Automation"
    echo " [11] Install ALL Categories"
    echo ""
    read -r -p "Enter category number (1-11): " CHOICE
fi

BASE_PKGS="ipykernel black flake8"
CAT_NAME=""
CAT_PKGS=""

case "$CHOICE" in
    1)
        CAT_NAME="1. Computer Vision & Real-Time Camera Systems"
        CAT_PKGS="opencv-python mediapipe ultralytics numpy"
        ;;
    2)
        CAT_NAME="2. Data Visualization & Exploratory Analytics"
        CAT_PKGS="pandas matplotlib seaborn plotly requests"
        ;;
    3)
        CAT_NAME="3. Web Scraping & Automated Data Pipelines"
        CAT_PKGS="requests beautifulsoup4 httpx schedule"
        ;;
    4)
        CAT_NAME="4. Applied Machine Learning & Predictive Modeling"
        CAT_PKGS="scikit-learn pandas numpy matplotlib joblib"
        ;;
    5)
        CAT_NAME="5. Desktop GUI Applications & Engineering Utilities"
        CAT_PKGS="customtkinter PyQt6 pillow matplotlib"
        ;;
    6)
        CAT_NAME="6. 2D Arcade Games & Physics Simulations"
        CAT_PKGS="pygame-ce pymunk numpy"
        ;;
    7)
        CAT_NAME="7. Lightweight Web Applications & Interactive Portals"
        CAT_PKGS="streamlit gradio flask fastapi uvicorn"
        ;;
    8)
        CAT_NAME="8. Network Programming, Sockets & Client-Server Systems"
        CAT_PKGS="websockets"
        ;;
    9)
        CAT_NAME="9. Algorithm & Data Structure Visualizers"
        CAT_PKGS="pygame-ce networkx matplotlib"
        ;;
    10)
        CAT_NAME="10. Document, Spreadsheet & PDF Workflow Automation"
        CAT_PKGS="pypdf reportlab fpdf2 openpyxl python-docx qrcode pillow"
        ;;
    11)
        CAT_NAME="11. ALL Mini-Project Categories"
        CAT_PKGS="opencv-python mediapipe ultralytics numpy pandas matplotlib seaborn plotly requests beautifulsoup4 httpx schedule scikit-learn joblib customtkinter PyQt6 pillow pygame-ce pymunk streamlit gradio flask fastapi uvicorn websockets networkx pypdf reportlab fpdf2 openpyxl python-docx qrcode"
        ;;
    *)
        echo "[ERROR] Invalid selection '$CHOICE'. Please run again and choose 1-11."
        exit 1
        ;;
esac

echo "[SELECTED] $CAT_NAME"
echo "[PACKAGES] $BASE_PKGS $CAT_PKGS"
echo ""

# Step 2: Check / Install System Python 3
echo "[STEP 2/3] Checking system-wide Python 3 installation..."
if ! command -v python3 >/dev/null 2>&1; then
    echo "[INFO] Python 3 not found. Installing Python 3..."
    if [ "$OS_TYPE" = "Darwin" ]; then
        if command -v brew >/dev/null 2>&1; then
            brew install python@3.12 python-tk@3.12
        else
            echo "[INFO] Downloading official macOS Python 3.12 Universal2 installer..."
            curl -Lo /tmp/python-macos.pkg "https://www.python.org/ftp/python/3.12.8/python-3.12.8-macos11.pkg"
            sudo installer -pkg /tmp/python-macos.pkg -target /
            rm -f /tmp/python-macos.pkg
        fi
    elif command -v apt-get >/dev/null 2>&1; then
        sudo apt-get update && sudo apt-get install -y python3 python3-pip python3-venv python3-tk
    elif command -v dnf >/dev/null 2>&1; then
        sudo dnf install -y python3 python3-pip python3-tkinter
    elif command -v pacman >/dev/null 2>&1; then
        sudo pacman -Sy --noconfirm python python-pip tk
    fi
fi

# Ensure pip is available
if ! python3 -m pip --version >/dev/null 2>&1; then
    python3 -m ensurepip --user >/dev/null 2>&1 || true
fi

# Step 3: Install selected packages into user's global environment (handling PEP 668 safely)
echo ""
echo "[STEP 3/3] Installing libraries globally for $CAT_NAME..."
PIP_FLAGS="--user"
if python3 -m pip install --help 2>&1 | grep -q "break-system-packages"; then
    PIP_FLAGS="--user --break-system-packages"
fi

# If running inside an active conda/virtualenv, omit --user
if [ -n "${VIRTUAL_ENV:-}${CONDA_PREFIX:-}" ]; then
    PIP_FLAGS=""
fi

# shellcheck disable=SC2086
python3 -m pip install --upgrade $PIP_FLAGS $BASE_PKGS $CAT_PKGS

python3 -m ipykernel install --user --name python3 --display-name "Python 3" >/dev/null 2>&1 || true

echo ""
echo "============================================================================"
echo "  SUCCESS! Global PC Python & Libraries are Ready!"
echo "  Installed Category: $CAT_NAME"
echo "============================================================================"
