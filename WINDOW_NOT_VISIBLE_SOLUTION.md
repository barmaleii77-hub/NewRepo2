# ? �������: ���� ���������� �� �����

**��������:** ���������� �����������, �� ���� �� ������������  
**������:** ? **������**

---

## ?? �����������

### 1. �������� �������� ���� ?
```
Step 5: Creating MainWindow...
Step 6: MainWindow created - Size: 1500x950
         Window title: PneumoStabSim - Pneumatic Stabilizer Simulator
Step 7: Window shown - Visible: True
         Position: ...
```

? **���� ��������� � ���������� ��� "visible"**

### 2. �������� �������� ?
```powershell
Get-Process python
# ������� ������� � �������
```

---

## ?? ������� ��������

**���� ��������� � ������������, ��:**

1. **����� ���� �� ������� ������** - ���� �����������, �� �� � ������
2. **����� ���� �� ������ ��������** - ���� ��������� �������
3. **����� ���������������� �����** - ��-�� �������� Windows

---

## ? �������

### ������� 1: �������������� ��������� ����

�������� � `MainWindow.__init__()` ����� `self.resize()`:

```python
def __init__(self):
    super().__init__()
    self.setWindowTitle("PneumoStabSim - Pneumatic Stabilizer Simulator")
    self.resize(1500, 950)
    
    # ?? �������� ���:
    # ������� ���� ������ � ������������
    self.setWindowState(Qt.WindowState.WindowActive)
    self.raise_()
    self.activateWindow()
    
    # ... ��������� ��� ...
```

### ������� 2: �������� app.py

�������� ����� `window.show()`:

```python
# � app.py, ������:
window.show()

# �����������:
window.show()
window.raise_()
window.activateWindow()
```

### ������� 3: ������ �� ��������� ������

��������� ���������� ��������:

```powershell
# ����������� ����������� �����
.\.venv\Scripts\Activate.ps1

# ��������� ����������
python app.py
```

**����� �������:**
- ��������� ������ ����� Windows
- ������� Alt+Tab ��� ������������ ����
- ��������� ������ ������� (���� ����)

---

## ?? ������� �����������

������� ����������� ����� ������:
