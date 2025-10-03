# ?? �������� ���� �� ������������ ����������� �������� P1-P13

**����:** 3 ������ 2025  
**����:** `src/mechanics/kinematics.py`  
**������:** ? **��������� �������������**

---

## ? ������������ ����������� P13

### 1. **������ ���������� �������** ?

**����������:** ����������� ���������� ������� � ������� ��������������� ���������

**����������:**
```python
class LeverKinematics:
    def solve_from_free_end_y(self, free_end_y, free_end_y_dot=0.0):
        # ������� �������� ����������: ? = arcsin(y/L)
        sin_theta = free_end_y / self.L
        theta = np.arcsin(sin_theta)
        
        # ���������� �������
        cos_theta = np.sqrt(1.0 - sin_theta**2)
        free_end = Point2(x=self.pivot.x + self.L * cos_theta, ...)
        attach = Point2(x=self.pivot.x + (self.rho * self.L) * cos_theta, ...)
        
        # ������� ��������: d?/dt = (dy/dt) / (L * cos(?))
        theta_dot = free_end_y_dot / (self.L * cos_theta)
```

**��������:**
- ? ���������� ������� �������� ����������
- ? ���� ��������� (X > 0, cos(?) > 0)
- ? ���������� ������� ��������
- ? ��������� ��������� �������

---

### 2. **���������� ���������** ?

**����������:** ������������ ��� ������ � ������ �����

**����������:**
```python
class CylinderKinematics:
    def solve_from_lever_state(self, lever_state, ...):
        # ���������� ����� ���������
        D = self.frame_hinge.distance_to(rod_hinge)
        
        # ��� ������: s = D - D0
        s = D - D0
        s = np.clip(s, -self.S_max / 2.0, self.S_max / 2.0)
        
        # ������ ����� (� �������� ������)
        V_head = self.delta_head + self.A_head * (self.S_max / 2.0 + s)
        V_rod = self.delta_rod + self.A_rod * (self.S_max / 2.0 - s)
        
        # �������
        self.A_head = ? * (D_in / 2)?
        self.A_rod = A_head - ? * (D_rod / 2)?
```

**��������:**
- ? ������ ������ ���� ������
- ? ���� ������� ��� (?_head, ?_rod)
- ? ���������� ������� ������
- ? ����������� ���� (clipping)

---

### 3. **��������� track = 2*(L+b)** ?

**����������:** ���������� ������������ �����

**���������� � `constraints.py`:**
```python
def enforce_track_invariant(
    track: float,
    arm_length: Optional[float],
    pivot_offset: Optional[float],
    mode: ConstraintMode
) -> tuple[float, float]:
    # track = 2 * (L + b)
    if mode == ConstraintMode.FIX_ARM:
        pivot_offset = (track / 2.0) - arm_length
    elif mode == ConstraintMode.FIX_PIVOT:
        arm_length = (track / 2.0) - pivot_offset
```

**��������:**
- ? ������������� ���������� �������
- ? ��� ������ ��������
- ? ����� ������������ ��������� (4/4 passed)

---

### 4. **�������� ������������� (�������)** ?

**����������:** ����������� ������������ ����� ������� � ���������

**����������:**
```python
class InterferenceChecker:
    def check_lever_cylinder_interference(
        self, lever_state, cylinder_state
    ) -> Tuple[bool, float]:
        # ����� ��� ������� (������ ��������� �����)
        lever_seg = Segment2(lever_state.attach, lever_state.free_end)
        lever_capsule = Capsule2(lever_seg, self.R_arm)
        
        # ������� ��� �������
        cyl_seg = Segment2(cylinder_state.frame_hinge, cylinder_state.rod_hinge)
        cyl_capsule = Capsule2(cyl_seg, self.R_cyl)
        
        # �������� ������
        clearance = capsule_capsule_clearance(lever_capsule, cyl_capsule)
        is_interfering = clearance < 0.0
```

**��������:**
- ? ������������� ������ (segment + radius)
- ? ����������: �������� ������ ��������� ����� ������
- ? ������ ������ (clearance)
- ? ����� �������� (3/3 passed)

---

### 5. **2D ��������� (geometry.py)** ?

**����������:** ������� �������������� ��������� � ��������

**����������:**
```python
@dataclass
class Point2:
    x: float; y: float
    def distance_to(self, other) -> float
    def __sub__(self, other) -> 'Point2'
    def __add__(self, other) -> 'Point2'

@dataclass  
class Segment2:
    p1: Point2; p2: Point2
    def length(self) -> float
    def direction(self) -> Point2

@dataclass
class Capsule2:
    segment: Segment2
    radius: float

# �������
def dot(a, b) -> float
def norm(v) -> float
def normalize(v) -> Point2
def dist_point_segment(p, seg) -> float
def dist_segment_segment(seg1, seg2) -> float
def capsule_capsule_clearance(c1, c2) -> float
```

**��������:**
- ? ��� ����������� ���������
- ? ��������� ��������
- ? ������� ����������
- ? �������� ����������� ������

---

### 6. **��������� ���������� (constraints.py)** ?

**����������:** �������� ���������� �����������

**����������:**
```python
# ������������ ������������ �����������
def validate_max_vertical_travel(arm_length, max_vertical_travel):
    assert max_vertical_travel <= 2 * arm_length

# ���� ����� ��������� �����
def validate_rod_attach_fraction(rod_attach_fraction):
    assert 0.1 <= rod_attach_fraction <= 0.9

# ����������� ���������� �����
def validate_residual_volume(V_head, V_rod, A_head, A_rod):
    V_min = 0.005 * (V_head + V_rod)
    assert min(V_head, V_rod) >= V_min
```

**��������:**
- ? ��� ��������� �����������
- ? ����� ��������� ��������� ������ (3/3 passed)

---

### 7. **����������: solve_axle_plane()** ?

**����������:** ��������������� ������� ��� ������� ����� �������� ���������

**����������:**
```python
def solve_axle_plane(
    side: str,  # "left" or "right"
    position: str,  # "front" or "rear"
    arm_length: float,
    pivot_offset: float,
    rod_attach_fraction: float,
    free_end_y: float,
    cylinder_params: dict,
    check_interference: bool = False
) -> dict:
    # ������� ���������� ������
    lever_kin = LeverKinematics(...)
    lever_state = lever_kin.solve_from_free_end_y(free_end_y)
    
    # ������� ���������� ��������
    cyl_kin = CylinderKinematics(...)
    cylinder_state = cyl_kin.solve_from_lever_state(lever_state)
    
    # ��������� �������������
    interference_checker = InterferenceChecker(...)
    is_interfering, clearance = interference_checker.check_lever_cylinder_interference(...)
    
    return {
        'lever_state': lever_state,
        'cylinder_state': cylinder_state,
        'is_interfering': is_interfering,
        'clearance': clearance
    }
```

**��������:**
- ? ����������� �������
- ? ���������� ��� ���������
- ? ���� ���������� �������� (1/1 passed)

---

## ?? �������� �������

### ��� ����� PASSED (14/14) ?

**TestTrackInvariant (4/4):**
- ? `test_enforce_track_fix_arm` - �������� ������
- ? `test_invariant_holds` - ��������� �����������
- ? `test_invariant_violated` - ����������� ���������
- ? `test_mirrored_sides` - ���������� �������

**TestStrokeValidation (3/3):**
- ? `test_extreme_strokes_respect_dead_zones` - ������� ����
- ? `test_max_vertical_travel` - ����. ����������� ? 2*L
- ? `test_residual_volume_minimum` - ���������� ����� ? 0.5%

**TestAngleStrokeRelationship (3/3):**
- ? `test_angle_consistency` - ��������������� �����
- ? `test_symmetric_angles` - ��������� �����
- ? `test_zero_angle_zero_displacement` - ?=0 ? y=0

**TestInterferenceChecking (3/3):**
- ? `test_capsule_distance_calculation` - ���������� ������
- ? `test_capsule_intersection` - ����������� ������
- ? `test_no_interference_normal_config` - ��� ������������� ? **FIXED**

**TestKinematicsIntegration (1/1):**
- ? `test_solve_axle_plane` - ����������� �������

---

## ?? ��������� �������� ����

### ? Docstrings � �����������

**����������:** �������� ������������

**��������:**
```python
"""
Precise kinematics for P13 geometric engine

Implements:
- Lever kinematics (angle ? position)
- Cylinder kinematics (stroke ? volumes)
- Interference checking (capsule-capsule)

Coordinate system (per wheel plane):
- X: transverse from frame to wheel (+ outward)
- Y: vertical (+ up)
- ?: lever angle from X axis (CCW positive)

References:
- Inverse kinematics: https://www.cs.columbia.edu/~allen/F19/NOTES/stanfordinvkin.pdf
- numpy: https://numpy.org/doc/stable/
"""
```

- ? ��������� �������� ������
- ? ������� ��������� �����������������
- ? ������ �� ���������
- ? Docstrings ��� ���� ������� � �������

---

### ? ��������� (Type Hints)

**����������:** ������������ ��������� �����

**��������:**
```python
from typing import Optional, Tuple

def solve_from_free_end_y(
    self, 
    free_end_y: float,
    free_end_y_dot: float = 0.0
) -> LeverState:
    ...

def check_lever_cylinder_interference(
    self,
    lever_state: LeverState,
    cylinder_state: CylinderState
) -> Tuple[bool, float]:
    ...
```

- ? ��� ��������� ������������
- ? ������������ ���� �������
- ? ������������� `Optional`, `Tuple`

---

### ? ��������� ������

**����������:** ��������� ������� ������

**��������:**
```python
# �������� ������
if abs(free_end_y) > self.L:
    raise ValueError(
        f"Free end Y={free_end_y:.3f}m exceeds arm length {self.L:.3f}m"
    )

# ��������� ������������
sin_theta = np.clip(sin_theta, -1.0, 1.0)

# ������ �� ������� �� ����
if abs(cos_theta) > 1e-6:
    theta_dot = free_end_y_dot / (self.L * cos_theta)
else:
    theta_dot = 0.0
```

- ? �������� ���������� ������
- ? `np.clip` ��� ��������� ������������
- ? ������ �� ������� �� ����

---

### ? ������������� NumPy

**����������:** ����������� ����������

**��������:**
```python
import numpy as np

# �������������
theta = np.arcsin(sin_theta)
cos_theta = np.sqrt(1.0 - sin_theta**2)

# �������
self.A_head = np.pi * (self.D_in / 2.0) ** 2
self.A_rod = self.A_head - np.pi * (self.D_rod / 2.0) ** 2

# �����������
s = np.clip(s, -self.S_max / 2.0, self.S_max / 2.0)
```

- ? NumPy ��� ����������
- ? ��������� �������� (����� Point2)

---

### ? Dataclasses

**����������:** ������������ @dataclass ��� �������� ������

**��������:**
```python
from dataclasses import dataclass

@dataclass
class LeverState:
    pivot: Point2
    attach: Point2
    free_end: Point2
    angle: float
    angular_velocity: float = 0.0
    arm_length: float = 0.0
    rod_attach_fraction: float = 0.0

@dataclass
class CylinderState:
    frame_hinge: Point2
    rod_hinge: Point2
    stroke: float
    stroke_velocity: float = 0.0
    volume_head: float = 0.0
    volume_rod: float = 0.0
    distance: float = 0.0
    cylinder_axis_angle: float = 0.0
    area_head: float = 0.0
    area_rod: float = 0.0
```

- ? ��� ��������� ��� dataclass
- ? �������� �� ���������
- ? �������������� ����

---

## ?? �������� ������

| �������� | ������ | ����������� |
|----------|--------|-------------|
| **�������������� ������������** | ? 5/5 | ��� ������� ����� |
| **�������� �������** | ? 5/5 | 14/14 ������ passed |
| **������������** | ? 5/5 | �������� docstrings |
| **���������** | ? 5/5 | ������ ��������� |
| **��������� ������** | ? 5/5 | ��������� + ������ |
| **�����������** | ? 5/5 | ������ ���������� |
| **������������ P13** | ? 5/5 | 100% ������������ |

---

## ? ������

### ��� ��������� ������������� �����������:

1. ? **P13 - ������ ����������** - �����������
2. ? **��������� track = 2*(L+b)** - �����������
3. ? **�������� �������������** - ����������� � ����������
4. ? **2D ���������** - ������ ����� ����������
5. ? **���������** - ��� ����������� �����������
6. ? **�����** - 14/14 �������� (100%)
7. ? **������������** - ��������
8. ? **���������** - ������

### ����������� ����������� �������:

- ? ���������� �������� ������������� (����������� ������ ��������� ����� ������)
- ? ��� ����� ������ ��������
- ? ��� ����� � production

---

## ?? ���������� � ��������� ������

��� ����� ���:
1. ? ���������� � UI (����������� ?, s, V_head, V_rod)
2. ? ������������ ��������� � ��������� �����
3. ? ���������� ������� ������
4. ? ������������ ������������� � �������� �������

---

**������:** ? **������ ������������ ����������� P1-P13**

**������������:** ����� ���������� � ���������� ����� (P14 ��� ���������� � UI)
