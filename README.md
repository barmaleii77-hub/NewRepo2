# PneumoStabSim - Pneumatic Stabilizer Simulator

��������� �������������� ������� ������������.

## ����������

- Python 3.13+
- Visual Studio 2022+ � Python workload

## ���������

1. ���������� �����������
2. �������� ����������� �����:
   ```
   py -3.13 -m venv .venv
   . .\.venv\Scripts\Activate.ps1
   ```
3. ���������� �����������:
   ```
   pip install -r requirements.txt
   ```

## ������

```
python app/app.py
```

## ��������� �������

- `src/common/` - ����� ������� � ���������
- `src/core/` - ������� ���������, ���������
- `src/pneumo/` - ���������� �������������� �������
- `src/mechanics/` - ������������ ����������
- `src/physics/` - ���������� ���������
- `src/ui/` - ���������������� ��������� (PySide6)