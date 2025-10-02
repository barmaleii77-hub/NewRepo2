# ? ����������: ��� ������� ���� ����������

**��������:** ���� ���������, �� �� ����� �� ������  
**�������:** ? ���� ��������! ����� ����� ���

---

## ?? ��� ������ ����

### 1. ? ������ ����� Windows
- ������� ������ **Python** ��� **PneumoStabSim** �� ������ �����
- �������� �� ����

### 2. ? Alt+Tab
- ������� **Alt+Tab** ��� ������������ ����� ������
- ������� ���� "PneumoStabSim - Pneumatic Stabilizer Simulator"

### 3. ? ������ �������
- ���� � ��� ��������� ���������, ��������� ��� ������
- ���� ����� ��������� �� ������ ��������

### 4. ? ��������� �����
```powershell
# ���������, ������� �� �������
Get-Process python | Where-Object {$_.MainWindowTitle -like "*Pneumo*"}
```

---

## ?? ������ ����������

### ������ 1: �� Visual Studio
```powershell
# 1. �������� �������� PowerShell
# 2. ����������� ����������� �����
.\.venv\Scripts\Activate.ps1

# 3. ��������� ����������
python app.py
```

### ������ 2: ������� ����
```powershell
# �������� ����� (������ ����)
# ����� ������� ���� �� run_app.bat
```

---

## ?? �������� ������

**����� ������� �� ������ �������:**
```
=== PNEUMOSTABSIM STARTING ===
Step 1: Setting High DPI policy...
Step 2: Creating QApplication...
Step 3: Installing Qt message handler...
Step 4: Setting application properties...
Step 5: Creating MainWindow...
Step 6: MainWindow created - Size: 1500x950
         Window title: PneumoStabSim - Pneumatic Stabilizer Simulator
Step 7: Window shown - Visible: True

============================================================
APPLICATION READY - Close window to exit
Check taskbar or press Alt+Tab if window is not visible
============================================================
```

? **���� ������ ��� - ���� ������� � ��������!**

---

## ?? ��� ������ ���� � ����

������� ���� **PneumoStabSim** ��������:

### �����
- **OpenGL 3D Viewport** (����-����� ���)

### ������
- **Geometry** (�����) - �������������� ���������
- **Pneumatics** (������ ������) - ����������
- **Charts** (������ �����, �������) - �������
- **Modes** (���������) - ������ ���������
- **Road Profiles** (���������) - ������� ������

### ����
- File ? Save/Load Preset, Export
- Road ? Load CSV, Clear Profiles
- Parameters ? Reset UI Layout
- View ? Show/Hide panels

### Toolbar
- Start, Stop, Pause, Reset

### Statusbar
- Sim Time, Steps, FPS, Queue stats

---

## ?? ���� ���� �Ѩ �٨ �� �����

### ��������: ���� �� ��������� ������

**�������:**
1. ������� **Alt+Space** ����� ���� � ������
2. �������� **Move** (M)
3. ����������� ������� ���������� ��� �����������
4. ������� **Enter**

### ��������: ���� ��������������

**�������:**
- ������� �� ������ �����
- �������� ������ ������� ? **Maximize** ��� **Restore**

### ��������: ���� ����������/���������

**�������:**
- ��� ������ �������� ����������
- �������� �������� OpenGL
- ��� �������� ��������� � Windows Settings ? Display ? Graphics

---

## ? ������������� ������

**���������� ��������, ����:**
- ? � ������� �������� "Step 7: Window shown"
- ? ������� python.exe �������
- ? ���� ���� � Alt+Tab
- ? ���� ������� � `logs/run.log`

**��� ��������:**
- �������� ���� ���������� (�������)
- ��� ������� **Ctrl+C** � �������

---

## ?? ���������� ������ � ������!

���� �� ������ ���� - �� �������� ���������!
