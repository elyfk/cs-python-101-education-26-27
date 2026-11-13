#!/usr/bin/env bash
set -e

echo "============================================================================"
echo "  METU IEEE Computer Society - Python 101 Mini-Project Setup"
echo "  Mode: REPO-LOCAL (.venv inside this repository only)"
echo "============================================================================"
echo ""

# Determine Repository Root (if script is inside a setup/ subfolder, step up one level)
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
if [ "$(basename "$SCRIPT_DIR")" = "setup" ]; then
    REPO_ROOT="$(cd "$SCRIPT_DIR/.." && pwd)"
else
    REPO_ROOT="$SCRIPT_DIR"
fi
cd "$REPO_ROOT"
echo "[INFO] Target Repository Root: $REPO_ROOT"
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
        set selectedItem to choose from list catList with title "METU IEEE CS - Repo-Local Setup" with prompt "Select your Mini-Project Category:" default items {"1. Computer Vision & Real-Time Camera Systems"}
        if selectedItem is false then
            return "CANCEL"
        else
            set itemText to item 1 of selectedItem
            return word 1 of itemText
        end if
    ' 2>/dev/null || echo "")
elif command -v zenity >/dev/null 2>&1 && [ -n "${DISPLAY:-}${WAYLAND_DISPLAY:-}" ]; then
    CHOICE=$(zenity --list --title="METU IEEE CS - Repo-Local Setup" \
        --text="Select your Mini-Project Category to install into .venv:" \
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

# Step 2: Ensure uv is available to manage isolated Python 3.12 without sudo
echo "[STEP 2/4] Preparing standalone Python manager (uv)..."
export PATH="$HOME/.local/bin:$HOME/.cargo/bin:$PATH"
if ! command -v uv >/dev/null 2>&1; then
    curl -LsSf https://astral.sh/uv/install.sh | sh
    export PATH="$HOME/.local/bin:$HOME/.cargo/bin:$PATH"
fi

# Step 3: Create isolated Python 3.12 virtual environment inside .venv
echo ""
echo "[STEP 3/4] Creating isolated Python 3.12 environment in $REPO_ROOT/.venv..."
uv venv "$REPO_ROOT/.venv" --python 3.12 --seed

# Step 4: Install packages and configure VS Code / Jupyter
echo ""
echo "[STEP 4/4] Installing libraries for $CAT_NAME..."
# shellcheck disable=SC2086
uv pip install --python "$REPO_ROOT/.venv/bin/python" $BASE_PKGS $CAT_PKGS

"$REPO_ROOT/.venv/bin/python" -m ipykernel install --user --name cs-python-101-venv --display-name "Python 3.12 (.venv)" >/dev/null 2>&1 || true

mkdir -p "$REPO_ROOT/.vscode"
if [ ! -f "$REPO_ROOT/.vscode/settings.json" ]; then
    cat << 'EOF' > "$REPO_ROOT/.vscode/settings.json"
{
  "python.defaultInterpreterPath": "${workspaceFolder}/.venv/bin/python",
  "jupyter.kernels.trusted": ["${workspaceFolder}/.venv/bin/python"],
  "notebook.lineNumbers": "on"
}
EOF
fi

echo ""
echo "============================================================================"
echo "  SUCCESS! Repo-Local Python 3.12 Environment (.venv) is Ready!"
echo "  Installed Category: $CAT_NAME"
echo "  Activate in terminal anytime with: source .venv/bin/activate"
echo "============================================================================"
