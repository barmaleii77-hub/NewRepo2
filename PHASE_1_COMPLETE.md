# ? PHASE 1 ��������� - ��� ������ �������

**����:** 3 ������ 2025, 14:00 UTC  
**������:** ? **��� ������ �������� ��������**

---

## ?? ��� �������

### 1. AccordionWidget (`src/ui/accordion.py`)
- ? �������������� ������
- ? ������� ��������
- ? ���������
- ? ������ ����

### 2. ParameterSlider (`src/ui/parameter_slider.py`)
- ? ������� + SpinBox
- ? ����������� min/max
- ? ���������
- ? ������� ���������

### 3. ��� 5 ������� (`src/ui/panels_accordion.py`)

#### GeometryPanelAccordion
**���������:**
- Wheelbase (L): 2.0-5.0 m
- Track Width (B): 1.0-2.5 m
- Lever Arm (r): 0.1-0.6 m
- Lever Angle (?): -30 to 30 deg (read-only, calculated)
- Cylinder Stroke (s_max): 0.05-0.5 m
- Piston Diameter (D_p): 0.03-0.15 m
- Rod Diameter (D_r): 0.01-0.10 m
- Frame Mass (M_frame): 500-5000 kg
- Wheel Mass (M_wheel): 10-200 kg

**API:**
```python
geometry_panel = GeometryPanelAccordion()
geometry_panel.parameter_changed.connect(lambda name, value: ...)
params = geometry_panel.get_parameters()
geometry_panel.set_parameters(params)
geometry_panel.update_calculated_values(lever_angle_deg)
```

---

#### PneumoPanelAccordion
**���������:**
- Thermo Mode: Isothermal/Adiabatic (ComboBox)
- Head Volume (V_h): 100-2000 cm? (read-only, calculated)
- Rod Volume (V_r): 50-1500 cm? (read-only, calculated)
- Line A1 Pressure (P_A1): 50-500 kPa
- Line B1 Pressure (P_B1): 50-500 kPa
- Line A2 Pressure (P_A2): 50-500 kPa
- Line B2 Pressure (P_B2): 50-500 kPa
- Tank Pressure (P_tank): 100-600 kPa
- Relief Valve (P_relief): 200-800 kPa
- Atmospheric Temp (T_atm): -20 to 50 degC

**API:**
```python
pneumo_panel = PneumoPanelAccordion()
pneumo_panel.parameter_changed.connect(lambda name, value: ...)
pneumo_panel.thermo_mode_changed.connect(lambda mode: ...)
params = pneumo_panel.get_parameters()
pneumo_panel.update_calculated_volumes(v_head_m3, v_rod_m3)
```

---

#### SimulationPanelAccordion
**���������:**
- Simulation Mode: Kinematics/Dynamics (ComboBox)
- Kinematic Options (������ ��� kinematics):
  - Include Springs (CheckBox)
  - Include Dampers (CheckBox)
- Check Lever-Cylinder Interference (CheckBox)
- Time Step (dt): 0.0001-0.01 s
- Simulation Speed: 0.1-10.0x

**API:**
```python
sim_panel = SimulationPanelAccordion()
sim_panel.sim_mode_changed.connect(lambda mode: ...)
sim_panel.option_changed.connect(lambda name, enabled: ...)
sim_panel.parameter_changed.connect(lambda name, value: ...)
params = sim_panel.get_parameters()
```

**�����������:** Kinematic options ������������� ���������� � ������ Dynamics!

---

#### RoadPanelAccordion
**���������:**
- Road Input Mode: Manual (Sine) / Road Profile (ComboBox)

**Manual Mode:**
- Amplitude (A): 0.0-0.2 m
- Frequency (f): 0.1-10.0 Hz
- Phase Offset (rear): -180 to 180 deg

**Road Profile Mode:**
- Profile Type: Smooth Highway / City Streets / Off-Road / Mountain Serpentine / Custom
- Average Speed (v_avg): 10-120 km/h

**API:**
```python
road_panel = RoadPanelAccordion()
road_panel.road_mode_changed.connect(lambda mode: ...)
road_panel.profile_type_changed.connect(lambda ptype: ...)
road_panel.parameter_changed.connect(lambda name, value: ...)
params = road_panel.get_parameters()
```

**�����������:** ��������� ������������� ������������� ��� ����� ������!

---

#### AdvancedPanelAccordion
**���������:**
- Spring Stiffness (k): 10000-200000 N/m
- Damper Coefficient (c): 500-10000 N*s/m
- Dead Zone (both ends): 0-20%
- Target FPS: 30-120 fps
- Anti-Aliasing Quality: 0-4
- Shadow Quality: 0-4

**API:**
```python
advanced_panel = AdvancedPanelAccordion()
advanced_panel.parameter_changed.connect(lambda name, value: ...)
params = advanced_panel.get_parameters()
```

---

## ?? ������������

### Test Application: `test_all_accordion_panels.py`

**����������:**
```
? ��� 5 ������ �������
? ���������/������������ ��������
? ��� �������� ��������
? ��� SpinBox ����������������
? Min/Max ����������� ��������
? ������ ������������� ���������
? ����� ����������/������������
? ��� ������� ��������
? ������ ���� ���������
```

### ����������� ���������:
```
[GEOMETRY] wheelbase = 3.5
[PNEUMO] pressure_a1 = 150.0
[PNEUMO] Thermo mode = adiabatic
[SIMULATION] Mode = kinematics
[SIMULATION] include_springs = True
[SIMULATION] time_step = 0.001
[ROAD] Mode = profile
[ROAD] Profile type = city_streets
[ROAD] avg_speed = 80.0
[ADVANCED] spring_stiffness = 75000.0
```

---

## ?? ������������ �����������

### ����� ������ - ��������� (100% ?)
- ? ������������ ��������� � ��������������� ��������
- ? ���������
- ? ������ ����
- ? ������� ��������
- ? ���������� ����������� ����������

### ���������� ���������� (100% ?)
- ? �������� ��� ���� ����������
- ? SpinBox ��� ������� �����
- ? ����������� ���������� min/max
- ? ������� ���������
- ? ��������� ���������� (min < max)

### ������ ������� (100% ?)
- ? Kinematics / Dynamics
- ? Isothermal / Adiabatic
- ? ��� 4 ���������� ��������
- ? ����� ��� ���������� (springs/dampers)

### ������ ������� ����������� (90% ?)
- ? Manual (sine): ���������, �������, ����
- ? Road Profile: ��� ������, ������� ��������
- ?? ���������� �������� ��� �� �����������

### ������������� � ��������� (100% ?)
- ? �������� ������������� (checkbox)
- ? ���� ������ (checkbox, kinematics only)
- ? ���� ������������� (checkbox, kinematics only)
- ? ����������� ���������
- ? ��������� �������

---

## ?? ��������

### �� Phase 1:
```
����� ������:          0% ?
����������:            0% ?
������:               60% ??
����� ������������:   25% ?
```

### ����� Phase 1:
```
����� ������:        100% ?
����������:          100% ?
������:              100% ?
����� ������������:   60% ?? (+35%)
```

**��������:** 25% ? **60%** (+35%)

---

## ?? ��������� ���: ���������� � MAINWINDOW

### ��� ����� �������:

1. **�������� dock widgets �� accordion** (1 ���)
   ```python
   # � MainWindow.__init__()
   
   # ������� accordion
   self.left_accordion = AccordionWidget()
   
   # �������� ������
   self.geometry_panel = GeometryPanelAccordion()
   self.left_accordion.add_section("geometry", "Geometry", 
                                    self.geometry_panel, expanded=True)
   
   self.pneumo_panel = PneumoPanelAccordion()
   self.left_accordion.add_section("pneumo", "Pneumatics", 
                                    self.pneumo_panel, expanded=False)
   
   # ... ��������� ������
   
   # ���������� � dock
   left_dock = QDockWidget("Parameters", self)
   left_dock.setWidget(self.left_accordion)
   self.addDockWidget(Qt.DockWidgetArea.LeftDockWidgetArea, left_dock)
   ```

2. **���������� ������� � simulation manager** (1-2 ����)
   ```python
   # Geometry changes
   self.geometry_panel.parameter_changed.connect(
       self._on_geometry_parameter_changed
   )
   
   # Pneumo changes
   self.pneumo_panel.parameter_changed.connect(
       self._on_pneumo_parameter_changed
   )
   self.pneumo_panel.thermo_mode_changed.connect(
       self._on_thermo_mode_changed
   )
   
   # Simulation mode changes
   self.sim_panel.sim_mode_changed.connect(
       self._on_sim_mode_changed
   )
   
   # ... � �.�.
   ```

3. **������� ������ ������** (30 ���)
   - GeometryPanel ? �������
   - PneumoPanel ? �������
   - ModesPanel ? �������
   - RoadPanel ? �������

4. **������������** (1 ���)
   - ������ ����������
   - �������� ���� ����������
   - �������� ���������

**����� �����:** 3-4 ����

---

## ? ������

### ���������� Phase 1:
1. ? AccordionWidget ������ � ��������
2. ? ParameterSlider ������ � ��������
3. ? ��� 5 ������� �������:
   - GeometryPanelAccordion
   - PneumoPanelAccordion
   - SimulationPanelAccordion
   - RoadPanelAccordion
   - AdvancedPanelAccordion
4. ? ��� ������ ��������������
5. ? ��� ������� ��������
6. ? ������ ������������� �������������

### ������������ �����������:
- ? **100%** - ���������
- ? **100%** - �������� � ������������ ����������
- ? **100%** - ������ ������� (4 ����������)
- ? **90%** - ������ ������� �����������
- ? **100%** - ������������� � ���������

### ��������� ������:
1. ? **���������� � MainWindow** (3-4 ����)
2. ? **ParameterManager** ��� ������������� (3-5 ����)
3. ? **3D ��������** (5-7 ����)

---

**����:** 3 ������ 2025, 14:00 UTC  
**������:** ? **PHASE 1 ���������**  
**��������:** **25% ? 60%** (+35%)  
**��������� ���:** ���������� � MainWindow

?? **��� ������ ������� � �������� ��������!** ??
