# ? ������ - ������������� ����� ����������

## ?? ������

```bash
python run_diagram.py
```

---

## ?? ��� �� �������

### ����� �������� (P13):
```
        Y ?
          ?    ? Green (free end + wheel)
          ?   /
          ?  / Orange lever (L=400mm)
          ? /
    ?????????????????? X
       Orange       Blue cylinder
       (pivot)      
          ?\
          ? ? Gray (frame hinge)
```

### ��������:
- ???? Free end �������� �����-���� (�150mm)
- ?? Lever ��������� ������ pivot
- ?? Cylinder ����������/���������

### ������ ���������� (����� ������� ����):
```
GEOMETRY:
  � Lever arm L = 400 mm
  � Rod attach ? = 0.70
  � Cylinder hinge X = -300 mm

KINEMATICS (real-time):
  � Free end Y = [animated] mm
  � Lever angle ? = [calculated]�
  � Attach X, Y = [calculated] mm
  � Cylinder length D = [calculated] mm
  � Cylinder angle = [calculated]�
```

---

## ??? ����������

- **Drag �����** ? �������� ������ ������ �����
- **Mouse wheel** ? �����������/���������
- **������ RESET** ? ������� � ���������� ����

---

## ?? ����������

| ���� | ������� |
|------|---------|
| ?? ��������� | Pivot (������) + Lever (�����) |
| ?? ����� | Rod attach (����� ���������) + Cylinder (�������) |
| ?? ������ | Free end (��������� �����) |
| ? ׸���� | Wheel (������) |
| ?? ������� | X axis (�����������) |
| ?? ������ | Y axis (���������) |

---

## ? ������������ P13

- ? ������������ �������: X (������), Y (�����)
- ? Lever angle ? �� ��� X (������ ������� �������)
- ? Pivot � ������ ���������
- ? Rod attach �� ���������� ?*L
- ? Cylinder �� frame hinge � rod attach
- ? ��� ������� � �������� �������

---

## ?? ������� �� ������������ ������

### ������ (��� ������� �����):
- ? ��������� �������
- ? ������
- ? �������
- ? ������� ����
- ? ��������� ������
- ? ����� ����

### ��������� (���� ����������):
- ? Lever mechanism
- ? Pneumatic cylinder
- ? Coordinate axes
- ? Key points (pivot, attach, free end)
- ? Real-time calculations

**���������:** ������ ����������� �����! ??

---

## ?? ��������������� ��������

**�������� ���:**
- ��������� ���������� ��������
- �������� �������������� ����������
- ������������ ��������
- ������� ��������
- ����������� � ������������

---

## ?? �����

- `test_suspension_diagram.qml` - QML ����� (~450 �����)
- `run_diagram.py` - Python launcher
- `DIAGRAM_SUCCESS_REPORT.md` - ������ �����

---

**? ������ � �������������!**

���������: `python run_diagram.py` ??
