# ? ГОТОВО - АНИМИРОВАННАЯ СХЕМА КИНЕМАТИКИ

## ?? ЗАПУСК

```bash
python run_diagram.py
```

---

## ?? ЧТО ВЫ УВИДИТЕ

### Схема подвески (P13):
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

### Анимация:
- ???? Free end движется вверх-вниз (±150mm)
- ?? Lever вращается вокруг pivot
- ?? Cylinder удлиняется/сжимается

### Панель параметров (левый верхний угол):
```
GEOMETRY:
  • Lever arm L = 400 mm
  • Rod attach ? = 0.70
  • Cylinder hinge X = -300 mm

KINEMATICS (real-time):
  • Free end Y = [animated] mm
  • Lever angle ? = [calculated]°
  • Attach X, Y = [calculated] mm
  • Cylinder length D = [calculated] mm
  • Cylinder angle = [calculated]°
```

---

## ??? УПРАВЛЕНИЕ

- **Drag мышью** ? Вращение камеры вокруг схемы
- **Mouse wheel** ? Приближение/отдаление
- **Кнопка RESET** ? Возврат к начальному виду

---

## ?? КОМПОНЕНТЫ

| Цвет | Элемент |
|------|---------|
| ?? Оранжевый | Pivot (шарнир) + Lever (рычаг) |
| ?? Синий | Rod attach (точка крепления) + Cylinder (цилиндр) |
| ?? Зелёный | Free end (свободный конец) |
| ? Чёрный | Wheel (колесо) |
| ?? Красный | X axis (горизонталь) |
| ?? Зелёный | Y axis (вертикаль) |

---

## ? СООТВЕТСТВИЕ P13

- ? Координатная система: X (наружу), Y (вверх)
- ? Lever angle ? от оси X (против часовой стрелки)
- ? Pivot в начале координат
- ? Rod attach на расстоянии ?*L
- ? Cylinder от frame hinge к rod attach
- ? Все расчёты в реальном времени

---

## ?? ОТЛИЧИЯ ОТ РЕАЛИСТИЧНОЙ ВЕРСИИ

### Убрано (для чистоты схемы):
- ? Резервуар воздуха
- ? Шланги
- ? Пружины
- ? Сложная рама
- ? Детальное колесо
- ? Сетка пола

### Оставлено (суть кинематики):
- ? Lever mechanism
- ? Pneumatic cylinder
- ? Coordinate axes
- ? Key points (pivot, attach, free end)
- ? Real-time calculations

**Результат:** ЧИСТАЯ ТЕХНИЧЕСКАЯ СХЕМА! ??

---

## ?? ОБРАЗОВАТЕЛЬНАЯ ЦЕННОСТЬ

**Идеально для:**
- Понимания кинематики подвески
- Проверки геометрических параметров
- Визуализации движения
- Отладки расчётов
- Презентаций и документации

---

## ?? ФАЙЛЫ

- `test_suspension_diagram.qml` - QML сцена (~450 строк)
- `run_diagram.py` - Python launcher
- `DIAGRAM_SUCCESS_REPORT.md` - Полный отчёт

---

**? ГОТОВО К ИСПОЛЬЗОВАНИЮ!**

Запустите: `python run_diagram.py` ??
