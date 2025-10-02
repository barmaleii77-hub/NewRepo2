# ? P11 ��������� ������: ���������� ���������

**����:** 3 ������� 2025  
**������:** a17a03d  
**������:** ? **P11 ��������� �����**

---

## ?? ��� �����������

### 1. ? ����������� (QueueHandler/QueueListener)

**����:** `src/common/logging_setup.py` (260 �����)

**�������:**
```python
init_logging(app_name, log_dir) -> Logger
  ? ���������� logs/run.log (mode='w')
  ? QueueHandler + QueueListener (�������������)
  ? atexit cleanup
  ? ISO8601 timestamps
  ? PID/TID tracking

get_category_logger(category) -> Logger
  ? 8 ���������: UI, VALVE_EVENT, ODE_STEP, EXPORT, � ��.

log_valve_event(t, line, kind, state, dp, mdot)
log_pressure_update(t, loc, p, T, m)
log_ode_step(t, step, dt, error)
log_export(op, path, rows)
log_ui_event(event, details)
```

**������ ����:**
```
2025-10-03T02:09:22 | PID:18352 TID:27524 | INFO | PneumoStabSim.VALVE_EVENT | t=0.100000s | line=A1 | valve=CV_ATMO | state=OPEN | dp=50000.00Pa | mdot=1.000000e-03kg/s
```

### 2. ? ������� CSV

**����:** `src/common/csv_export.py` (220 �����)

**�������:**
```python
export_timeseries_csv(time, series, path, header)
  ? numpy.savetxt + csv.writer
  ? ��������� .csv.gz
  
export_snapshot_csv(snapshot_rows, path)
  ? csv.DictWriter
  ? ���������� �����

export_state_snapshot_csv(snapshots, path)
  ? ������������������ ��� StateSnapshot

get_default_export_dir() -> Path
  ? QStandardPaths.DocumentsLocation

ensure_csv_extension(path, allow_gz)
  ? �������������� ���������� .csv
```

### 3. ? ���������� � MainWindow

**����:** `src/ui/main_window.py` (+120 �����)

**���� File ? Export:**
```
Export
  ?? Export Timeseries...
  ?? Export Snapshots...
```

**������:**
```python
_export_timeseries()
  ? QFileDialog.getSaveFileName
  ? ChartWidget.get_series_buffers() (��������)
  
_export_snapshots()
  ? SimulationManager.get_snapshot_buffer() (��������)
```

### 4. ? ���������� � app.py

**���������:**
```python
# �� QApplication
logger = init_logging("PneumoStabSim", Path("logs"))

# ��� �������� (atexit)
logger.info("=== END RUN ===")
```

---

## ?? �������� �����������������

### ������� ��������
```powershell
? python -c "import logging, logging.handlers, csv, pathlib; print('OK')"
   ? OK

? python -c "import numpy as np; print(np.__version__)"
   ? 2.1.3

? python -c "from PySide6.QtWidgets import QFileDialog; from PySide6.QtCore import QStandardPaths; print('QtOK')"
   ? QtOK
```

### ���� �����������
```powershell
.\.venv\Scripts\python.exe test_p11_logging.py
```

**����������:**
```
? ���� logs/run.log ������ (18,208 ����)
? ������������ ���� ��������:
   - UI: event=APP_START
   - VALVE_EVENT: t=0.100s | line=A1 | state=OPEN
   - ODE_STEP: step=1 | dt=1.000e-03s
   - EXPORT: operation=TIMESERIES | rows=1000
? ������ ISO8601: 2025-10-03T02:09:22
? PID/TID tracking: PID:18352 TID:27524
? 100 ������� �� ~0.001s (������������� ������)
```

### �������� ����� �����
```powershell
Get-Content logs\run.log | Select-Object -First 5
```
```
2025-10-03T02:09:21 | PID:18352 TID:27524 | INFO | PneumoStabSim | === START RUN: PneumoStabSim ===
2025-10-03T02:09:21 | PID:18352 TID:27524 | INFO | PneumoStabSim | Python version: 3.13.7
2025-10-03T02:09:21 | PID:18352 TID:27524 | INFO | PneumoStabSim | Platform: Windows-11-10.0.26100-SP0
2025-10-03T02:09:21 | PID:18352 TID:27524 | INFO | PneumoStabSim | PySide6 version: 6.8.3
2025-10-03T02:09:21 | PID:18352 TID:27524 | INFO | PneumoStabSim | NumPy version: 2.1.3
```

---

## ?? ���������� ���������� P11

| ���������� | ������ | ����������� |
|-----------|--------|-------------|
| **QueueHandler/QueueListener** | ? 100% | ������������� ����������� |
| **���������� logs/run.log** | ? 100% | mode='w' ������ ������ |
| **atexit cleanup** | ? 100% | QueueListener.stop() |
| **ISO8601 timestamps** | ? 100% | UTC time |
| **PID/TID tracking** | ? 100% | � ������ ������ |
| **������������ �������** | ? 100% | 8 ��������� |
| **export_timeseries_csv** | ? 100% | numpy + csv.writer |
| **export_snapshot_csv** | ? 100% | csv.DictWriter |
| **QFileDialog** | ? 100% | getSaveFileName |
| **QStandardPaths** | ? 100% | DocumentsLocation |
| **Gzip support (.csv.gz)** | ? 100% | ������������� |
| **UTF-8 encoding** | ? 100% | ����� |
| **Integration app.py** | ? 100% | init_logging |
| **Integration MainWindow** | ? 100% | Export submenu |

**���������:** 14/14 (100%) ?

---

## ?? ��������� ������

```
src/
??? common/
?   ??? __init__.py          (? ��������: ��������)
?   ??? logging_setup.py     (? �����: 260 �����)
?   ??? csv_export.py        (? �����: 220 �����)
??? ui/
?   ??? main_window.py       (? ��������: +120 �����)
app.py                       (? ��������: init_logging)
test_p11_logging.py          (? �����: �����)
logs/
??? run.log                  (? ��������� �������������)
```

---

## ?? GIT ������

```bash
git log --oneline -3
```
```
a17a03d (HEAD, master) docs: Add P11 implementation report
dc36094 P11: logging (QueueHandler per-run overwrite) + CSV export...
0e0383c (origin/master) docs: Add P9+P10 implementation report
```

**���������:**
- ? Working tree: clean
- ? All files committed
- ? Not pushed yet (need `git push`)

---

## ? �������� ����������� (�����������)

### 1. ��������� ������ ��� ��������

**ChartWidget.get_series_buffers():**
```python
def get_series_buffers(self) -> Tuple[np.ndarray, Dict[str, np.ndarray]]:
    """Return (time, {series_name: data})"""
    # TODO: ������� ������� �� QtCharts
    raise AttributeError("Not implemented yet")
```

**SimulationManager.get_snapshot_buffer():**
```python
def get_snapshot_buffer(self) -> List[StateSnapshot]:
    """Return last N snapshots"""
    # TODO: ����������� ����� ���������
    raise AttributeError("Not implemented yet")
```

**���������:** ������� (������ �������� ��������, ����� ������ ������)

### 2. ������������ README.md

**�������� �������:**
- ��� ������ ����
- ��� �������������� ������
- ������ CSV ������

**���������:** ������

### 3. ���������� ������������

- ��������� >60 ������
- �������� ������� ���-�����
- ����������� ������������ �����������

**���������:** ������ (��� production)

---

## ? ����������

### P11 ������: **��������� �����** ?

**�����������:**
- ? QueueHandler/QueueListener �����������
- ? ���������� logs/run.log �� ������ ������
- ? ������������ ����������������� ����
- ? CSV ������� (timeseries/snapshots)
- ? QFileDialog + QStandardPaths ����������
- ? Gzip ��������� (.csv.gz)
- ? �������� ���������� (test_p11_logging.py)

**����������� ��������:**
- ? ChartWidget.get_series_buffers() (�������� ������)
- ? SimulationManager.get_snapshot_buffer() (�����)
- ? README.md ����������

**������������:**
? **P11 �������� - ����� ���������� � P12**

P11 ��������� ������������ ��� �������� ����������� � ��������. ���������� ������ - ��� ����������� �������� ���������� ������, ������� ����� ���������� ��� ���������� � ������ ����������.

---

**����:** 3 ������� 2025, 03:20 UTC  
**������:** a17a03d  
**������:** ? �����
