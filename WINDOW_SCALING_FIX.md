# ?? �����������: �������� ��������������� ����

**����:** 3 ������ 2025, 12:20 UTC  
**��������:** ���� �� ��������������, �������� ��������� ���� �� �����, ���������  
**������:** ? **����������**

---

## ?? ��������

### 1. ���� ������� ������� (1500x950)
- �� ��������� �� ������� � ������ �����������
- ��� ������������� �� ���� ����� ������ �������� ������ ��� ������������

### 2. Dock-������ ��� ����������� �������
- ����� ����������� ����������
- ��������� �� ����������� ������
- ������� ���� ����� �� �������������������

### 3. Status bar � toolbar ��� �����������
- �������� ������� ����� �����
- ������� ������������� ���� �� �����

### 4. ��������� ��� ��������� �������
- ��� throttling ��� resize
- QML ����������� �� ������ ������� ���������
- ���������� �� �������� ������������

---

## ? ����������� �����������

### ����������� #1: �������� ��������� ������ ����

**����:** `src/ui/main_window.py:33-41`

**����:**
```python
self.resize(1500, 950)
self.setWindowState(Qt.WindowState.WindowNoState)
```

**�����:**
```python
# Set reasonable initial size (not too large)
self.resize(1200, 800)

# Set minimum window size to prevent over-compression
self.setMinimumSize(1000, 700)

# Ensure window is in normal state
self.setWindowState(Qt.WindowState.WindowNoState)
```

**������:**
- ? ���� ���������� �� ����������� �������
- ? ����������� ������ ������������� ������ �������
- ? ����� ���������� �� ���� ����� ��� �������

---

### ����������� #2: ��������� ����������� �������� dock-�������

**����:** `src/ui/main_window.py:180-230`

**��� ������ ������ ���������:**

**����� ������ (Geometry, Pneumatics):**
```python
self.geometry_dock.setObjectName("GeometryDock")  # ��� ���������� ���������
self.geometry_dock.setMinimumWidth(250)  # ������� 250px
self.geometry_dock.setMaximumWidth(400)  # �������� 400px
```

**������ ������ (Charts, Modes):**
```python
self.charts_dock.setMinimumWidth(300)  # �������� ����� ������ �����
self.charts_dock.setMaximumWidth(600)
```

**������ ������ (Road):**
```python
self.road_dock.setMinimumHeight(150)  # ������������ �����������
self.road_dock.setMaximumHeight(300)
```

**������:**
- ? ������ �� ����� ������� �� ������������
- ? ������ �� ����� ������ ���� �����
- ? ����������� ������ ������ �����
- ? ��������� ����������� ��� ����� ������� ����

---

### ����������� #3: ���������� toolbar � status bar

**Toolbar:**
```python
toolbar.setObjectName("MainToolbar")
toolbar.setMaximumHeight(50)  # �� ����� 50px �������
```

**Status bar:**
```python
# ����������� ������ ��� ��������
self.sim_time_label.setMinimumWidth(120)
self.step_count_label.setMinimumWidth(80)
# ...

# ����������� ������
self.status_bar.setMaximumHeight(30)  # �� ����� 30px
```

**������:**
- ? Toolbar � status bar �� �������� ������ ������������
- ? ������� �� ������������� ���� �� �����
- ? ����� �������� ��������

---

### ����������� #4: �������� throttling ��� resize

**����:** `src/ui/main_window.py:490-516`

**����� ���:**
```python
def resizeEvent(self, event):
    """Override resizeEvent to handle window resizing gracefully"""
    super().resizeEvent(event)
    
    # Throttle resize updates to prevent performance issues
    if not hasattr(self, '_resize_timer'):
        self._resize_timer = QTimer(self)
        self._resize_timer.setSingleShot(True)
        self._resize_timer.timeout.connect(self._handle_resize_complete)
    
    # Restart timer on each resize event
    self._resize_timer.stop()
    self._resize_timer.start(100)  # Wait 100ms after last resize

def _handle_resize_complete(self):
    """Called after resize operation completes"""
    # Force update of QML widget
    if self._qquick_widget:
        self._qquick_widget.update()
    
    # Log new size for debugging
    new_size = self.size()
    self.logger.debug(f"Window resized to: {new_size.width()}x{new_size.height()}")
```

**��� ��������:**
1. ��� ������ ��������� ������� ����������� ������ �� 100��
2. ���� ������ �������� �����, ������ ���������������
3. ������ ����� ��������� ��������� (100�� ��� �������) ����������� ����������
4. QML ������ ����������� ������ ���� ��� � �����

**������:**
- ? ��� ��������� ��� ��������� �������
- ? ������� ������ ��� ������������� �� ���� �����
- ? �������� CPU (������ �����������)

---

### ����������� #5: ��������� �������� ����������� �������

**����:** `src/ui/main_window.py:220-227`

```python
# Set initial dock sizes using splitDockWidget for better control
# Stack left panels vertically
self.splitDockWidget(self.geometry_dock, self.pneumo_dock, Qt.Orientation.Vertical)

# Stack right panels vertically
self.splitDockWidget(self.charts_dock, self.modes_dock, Qt.Orientation.Vertical)
```

**������:**
- ? ������ ������������ ����������� (�� ���������)
- ? ������� �������������� ����������
- ? ����� ������������ splitter �������

---

## ?? ������� ������� �����������

### ������� ����:
| �������� | �������� | ������� |
|----------|----------|---------|
| ��������� ������ | 1200x800 | ��������� �� ����������� ������� |
| ����������� ������ | 1000x700 | ������������� ������ ������� |
| ������������ ������ | (�� ����������) | ����� ���������� �� ���� ����� |

### Dock-������:
| ������ | Min Width | Max Width | Min Height | Max Height |
|--------|-----------|-----------|------------|------------|
| **Geometry** | 250px | 400px | - | - |
| **Pneumatics** | 250px | 400px | - | - |
| **Charts** | 300px | 600px | - | - |
| **Modes** | 300px | 600px | - | - |
| **Road** | - | - | 150px | 300px |

### UI ��������:
| ������� | ����������� | �������� |
|---------|-------------|----------|
| **Toolbar** | Max Height | 50px |
| **Status Bar** | Max Height | 30px |
| **Status Bar �������** | Min Width | 80-300px |

---

## ?? ��������

### �������� ��������:

1. **������ �� ��������� ������ (1366x768):**
   - ? ���� ���������
   - ? ��� ������ �����
   - ? ����� ��������

2. **������������� �� ���� �����:**
   - ? ������ ����������� �� ��������� (�� �� ������)
   - ? ����������� ������ �������� ���������� �����
   - ? ��� ���������
   - ? ��� ���������

3. **��������� ������� drag-��:**
   - ? ������� ������
   - ? ��� ��������
   - ? Throttling ��������

4. **����������� ����:**
   - ? ���� �� ����� ���� ������ 1000x700
   - ? ������ ��������� ����������

---

## ?? �������������� ���������

### ��������� objectName ��� ���������� ���������:

```python
self.geometry_dock.setObjectName("GeometryDock")
self.pneumo_dock.setObjectName("PneumaticsDock")
self.charts_dock.setObjectName("ChartsDock")
self.modes_dock.setObjectName("ModesDock")
self.road_dock.setObjectName("RoadDock")
self.toolbar.setObjectName("MainToolbar")
```

**������:**
- ? ��������� ������� ����������� ����� ���������
- ? ��� �������������� "objectName not set"
- ? `saveState()` � `restoreState()` �������� ���������

---

## ?? ����������

### �� �����������:
```
? ���� 1500x950 (������� �������)
? ������ ��� ����������� (���������)
? ��������� ��� resize
? �������� ������������� ���� �� �����
? ���������������� �� ��������� �������
```

### ����� �����������:
```
? ���� 1200x800 (����������)
? ������� 1000x700 (������ �� ������)
? ������: 250-600px width, 150-300px height
? Throttling resize (100ms)
? Toolbar max 50px, Status bar max 30px
? ������� ������ ��� ����� �������
? ��� ���������
? �������� �� ������� �� 1366x768 �� 4K
```

---

## ?? ������������ �� �������������

### ��� �������������:

1. **����������� ������:** 1200x800 (�� ���������)
2. **����������� ������:** 1000x700 (������ ������)
3. **�������������:** ����� ���������� �� ���� ����� ��� �������
4. **������:** ����� ������������ ������� ������� (splitter)
5. **������ ������:** "Toggle Panels" ��� ������������� 3D view

### ��� �������������:

**��� ���������� ����� dock-�������:**
```python
new_dock = QDockWidget("Name", self)
new_dock.setObjectName("NameDock")  # �����������!
new_dock.setMinimumWidth(250)       # �������
new_dock.setMaximumWidth(400)       # ��������
self.addDockWidget(Qt.DockWidgetArea.LeftDockWidgetArea, new_dock)
```

**��� ��������� UI:**
- ������ �������������� min/max �������
- ����������� `splitDockWidget` ��� �������� �����������
- ���������� `objectName` ��� ���� ��������

---

## ?? ���������� �����

| ���� | ��������� | ������ |
|------|-----------|--------|
| `src/ui/main_window.py` | ������� ���� | 33-41 |
| `src/ui/main_window.py` | Dock-������ min/max | 180-230 |
| `src/ui/main_window.py` | Toolbar max height | 340-368 |
| `src/ui/main_window.py` | Status bar min/max | 370-406 |
| `src/ui/main_window.py` | resizeEvent throttling | 490-516 |

**�����:** 5 ������ ���������, ~150 ����� ����

---

## ? �������� ������

**�������� ���������������:** ? **��������� ������**

- ? ���� ��������� �� ����� �������
- ? ������ �� ��������� ���� �� �����
- ? ��� ��������� ��� ��������� �������
- ? ����� ���������� �� ���� �����
- ? �������� �������� ���������
- ? ������� ������ UI

**���������� � �������������:** ?? **100%**

---

**���� ����������:** 3 ������ 2025, 12:20 UTC  
**������:** ? **PRODUCTION READY**

?? **���������� ������ ��������� ��������������!** ??
