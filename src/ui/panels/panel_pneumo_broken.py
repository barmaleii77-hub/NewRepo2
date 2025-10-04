# -*- coding: utf-8 -*-
"""
Pneumatic system configuration panel (Russian UI)
Controls for pneumatic parameters using knobs and radio buttons
"""

from PySide6.QtWidgets import (QWidget, QVBoxLayout, QHBoxLayout, QGroupBox, 
                              QRadioButton, QCheckBox, QPushButton, QLabel,
                              QButtonGroup, QSizePolicy)
from PySide6.QtCore import Signal, Slot, Qt
from PySide6.QtGui import QFont

from ..widgets import Knob


class PneumoPanel(QWidget):
    """Panel for pneumatic system configuration with Russian UI"""
    
    # Signals for parameter changes
    parameter_changed = Signal(str, float)
    mode_changed = Signal(str, str)
    pneumatic_updated = Signal(dict)
    
    def __init__(self, parent=None):
        super().__init__(parent)
        self.parameters = {}
        self._setup_ui()
        self._set_default_values()
        self._connect_signals()
        self.setSizePolicy(QSizePolicy.Policy.Preferred, QSizePolicy.Policy.Expanding)
    
    def _setup_ui(self):
        """Setup user interface with Russian labels"""
        layout = QVBoxLayout(self)
        layout.setSpacing(8)
        layout.setContentsMargins(8, 8, 8, 8)
        
        # Title
        title_label = QLabel("�������������� �������")
        title_font = QFont()
        title_font.setPointSize(12)
        title_font.setBold(True)
        title_label.setFont(title_font)
        title_label.setAlignment(Qt.AlignmentFlag.AlignCenter)
        layout.addWidget(title_label)
        
        # Groups
        layout.addWidget(self._create_check_valves_group())
        layout.addWidget(self._create_relief_valves_group())
        layout.addWidget(self._create_environment_group())
        layout.addWidget(self._create_options_group())
        layout.addLayout(self._create_buttons())
        layout.addStretch()
    
    def _create_check_valves_group(self) -> QGroupBox:
        """Create check valves group"""
        group = QGroupBox("�������� �������")
        layout = QVBoxLayout(group)
        
        # Pressure differences
        knobs_layout = QHBoxLayout()
        self.cv_atmo_dp_knob = Knob(0.001, 0.1, 0.01, 0.001, 3, "���", "������?����� ?P")
        self.cv_tank_dp_knob = Knob(0.001, 0.1, 0.01, 0.001, 3, "���", "�����?��� ?P")
        knobs_layout.addWidget(self.cv_atmo_dp_knob)
        knobs_layout.addWidget(self.cv_tank_dp_knob)
        layout.addLayout(knobs_layout)
        
        # Diameters
        diameters_layout = QHBoxLayout()
        self.cv_atmo_dia_knob = Knob(1.0, 10.0, 3.0, 0.1, 1, "��", "����. ���. ��")
        self.cv_tank_dia_knob = Knob(1.0, 10.0, 3.0, 0.1, 1, "��", "����. ���. ��")
        diameters_layout.addWidget(self.cv_atmo_dia_knob)
        diameters_layout.addWidget(self.cv_tank_dia_knob)
        layout.addLayout(diameters_layout)
        
        return group
    
    def _create_relief_valves_group(self) -> QGroupBox:
        """Create relief valves group"""
        group = QGroupBox("����������������� �������")
        layout = QVBoxLayout(group)
        
        # Pressures
        pressures_layout = QHBoxLayout()
        self.relief_min_pressure_knob = Knob(1.0, 10.0, 2.5, 0.1, 1, "���", "���. �����")
        self.relief_stiff_pressure_knob = Knob(5.0, 50.0, 15.0, 0.5, 1, "���", "����� Ƹ���.")
        self.relief_safety_pressure_knob = Knob(20.0, 100.0, 50.0, 1.0, 0, "���", "����. �����")
        pressures_layout.addWidget(self.relief_min_pressure_knob)
        pressures_layout.addWidget(self.relief_stiff_pressure_knob)
        pressures_layout.addWidget(self.relief_safety_pressure_knob)
        layout.addLayout(pressures_layout)
        
        # Throttles
        throttles_layout = QHBoxLayout()
        self.throttle_min_dia_knob = Knob(0.5, 3.0, 1.0, 0.1, 1, "��", "���. ��������")
        self.throttle_stiff_dia_knob = Knob(0.5, 3.0, 1.5, 0.1, 1, "��", "Ƹ���. ��������")
        throttles_layout.addWidget(self.throttle_min_dia_knob)
        throttles_layout.addWidget(self.throttle_stiff_dia_knob)
        throttles_layout.addStretch()
        layout.addLayout(throttles_layout)
        
        return group
    
    def _create_environment_group(self) -> QGroupBox:
        """Create environment group"""
        group = QGroupBox("���������� �����")
        layout = QVBoxLayout(group)
        
        env_layout = QHBoxLayout()
        
        # Temperature
        self.atmo_temp_knob = Knob(-20.0, 50.0, 20.0, 1.0, 0, "�C", "����. ������.")
        env_layout.addWidget(self.atmo_temp_knob)
        
        # Thermo mode
        thermo_widget = QWidget()
        thermo_layout = QVBoxLayout(thermo_widget)
        thermo_layout.setContentsMargins(4, 4, 4, 4)
        
        thermo_title = QLabel("����� �����")
        thermo_title.setAlignment(Qt.AlignmentFlag.AlignCenter)
        font = QFont()
        font.setPointSize(9)
        font.setBold(True)
        thermo_title.setFont(font)
        thermo_layout.addWidget(thermo_title)
        
        self.thermo_button_group = QButtonGroup()
        self.isothermal_radio = QRadioButton("��������������")
        self.adiabatic_radio = QRadioButton("��������������")
        self.isothermal_radio.setChecked(True)
        
        self.thermo_button_group.addButton(self.isothermal_radio, 0)
        self.thermo_button_group.addButton(self.adiabatic_radio, 1)
        
        thermo_layout.addWidget(self.isothermal_radio)
        thermo_layout.addWidget(self.adiabatic_radio)
        
        env_layout.addWidget(thermo_widget)
        env_layout.addStretch()
        layout.addLayout(env_layout)
        
        return group
    
    def _create_options_group(self) -> QGroupBox:
        """Create system options group"""
        group = QGroupBox("��������� �����")
        layout = QVBoxLayout(group)
        
        self.master_isolation_check = QCheckBox("������� ����. ������ ������")
        self.master_isolation_check.setChecked(False)
        layout.addWidget(self.master_isolation_check)
        
        self.link_rod_dia_check = QCheckBox("������� ����. ������ �����/���")
        self.link_rod_dia_check.setChecked(False)
        layout.addWidget(self.link_rod_dia_check)
        
        return group
    
    def _create_buttons(self) -> QHBoxLayout:
        """Create control buttons"""
        layout = QHBoxLayout()
        
        self.reset_button = QPushButton("����� � ����������")
        self.reset_button.clicked.connect(self._reset_to_defaults)
        layout.addWidget(self.reset_button)
        
        self.validate_button = QPushButton("��������� �������")
        self.validate_button.clicked.connect(self._validate_system)
        layout.addWidget(self.validate_button)
        
        layout.addStretch()
        return layout
    
    def _set_default_values(self):
        """Set default parameter values"""
        defaults = {
            'cv_atmo_dp': 0.01, 'cv_tank_dp': 0.01,
            'cv_atmo_dia': 3.0, 'cv_tank_dia': 3.0,
            'relief_min_pressure': 2.5, 'relief_stiff_pressure': 15.0,
            'relief_safety_pressure': 50.0, 'throttle_min_dia': 1.0,
            'throttle_stiff_dia': 1.5, 'atmo_temp': 20.0,
            'thermo_mode': 'ISOTHERMAL', 'master_isolation_open': False,
            'link_rod_dia': False
        }
        self.parameters.update(defaults)
    
    def _connect_signals(self):
        """Connect widget signals"""
        # Connect all knobs
        self.cv_atmo_dp_knob.valueChanged.connect(lambda v: self._on_parameter_changed('cv_atmo_dp', v))
        self.cv_tank_dp_knob.valueChanged.connect(lambda v: self._on_parameter_changed('cv_tank_dp', v))
        self.cv_atmo_dia_knob.valueChanged.connect(lambda v: self._on_parameter_changed('cv_atmo_dia', v))
        self.cv_tank_dia_knob.valueChanged.connect(lambda v: self._on_parameter_changed('cv_tank_dia', v))
        
        self.relief_min_pressure_knob.valueChanged.connect(lambda v: self._on_parameter_changed('relief_min_pressure', v))
        self.relief_stiff_pressure_knob.valueChanged.connect(lambda v: self._on_parameter_changed('relief_stiff_pressure', v))
        self.relief_safety_pressure_knob.valueChanged.connect(lambda v: self._on_parameter_changed('relief_safety_pressure', v))
        self.throttle_min_dia_knob.valueChanged.connect(lambda v: self._on_parameter_changed('throttle_min_dia', v))
        self.throttle_stiff_dia_knob.valueChanged.connect(lambda v: self._on_parameter_changed('throttle_stiff_dia', v))
        
        self.atmo_temp_knob.valueChanged.connect(lambda v: self._on_parameter_changed('atmo_temp', v))
        
        # Radio buttons and checkboxes
        self.thermo_button_group.buttonToggled.connect(self._on_thermo_mode_changed)
        self.master_isolation_check.toggled.connect(lambda checked: self._on_parameter_changed('master_isolation_open', checked))
        self.link_rod_dia_check.toggled.connect(lambda checked: self._on_parameter_changed('link_rod_dia', checked))
    
    @Slot(str, float)
    def _on_parameter_changed(self, param_name: str, value):
        """Handle parameter change"""
        self.parameters[param_name] = value
        
        # Validate relief pressures
        if param_name in ['relief_min_pressure', 'relief_stiff_pressure', 'relief_safety_pressure']:
            self._validate_relief_pressures()
        
        # Emit signals
        if isinstance(value, bool):
            self.mode_changed.emit(param_name, str(value))
        else:
            self.parameter_changed.emit(param_name, float(value))
        
        self.pneumatic_updated.emit(self.parameters.copy())
    
    @Slot()
    def _on_thermo_mode_changed(self):
        """Handle thermo mode change"""
        mode = 'ISOTHERMAL' if self.isothermal_radio.isChecked() else 'ADIABATIC'
        self.parameters['thermo_mode'] = mode
        self.mode_changed.emit('thermo_mode', mode)
        self.pneumatic_updated.emit(self.parameters.copy())
    
    def _validate_relief_pressures(self):
        """Validate relief pressure ordering"""
        min_p = self.parameters['relief_min_pressure']
        stiff_p = self.parameters['relief_stiff_pressure']
        safety_p = self.parameters['relief_safety_pressure']
        
        if stiff_p <= min_p:
            new_stiff = min_p + 1.0
            self.relief_stiff_pressure_knob.setValue(new_stiff)
            self.parameters['relief_stiff_pressure'] = new_stiff
        
        if safety_p <= stiff_p:
            new_safety = self.parameters['relief_stiff_pressure'] + 5.0
            self.relief_safety_pressure_knob.setValue(new_safety)
            self.parameters['relief_safety_pressure'] = new_safety
    
    @Slot()
    def _reset_to_defaults(self):
        """Reset to defaults"""
        self._set_default_values()
        
        # Update all controls
        self.cv_atmo_dp_knob.setValue(0.01)
        self.cv_tank_dp_knob.setValue(0.01)
        self.cv_atmo_dia_knob.setValue(3.0)
        self.cv_tank_dia_knob.setValue(3.0)
        
        self.relief_min_pressure_knob.setValue(2.5)
        self.relief_stiff_pressure_knob.setValue(15.0)
        self.relief_safety_pressure_knob.setValue(50.0)
        self.throttle_min_dia_knob.setValue(1.0)
        self.throttle_stiff_dia_knob.setValue(1.5)
        
        self.atmo_temp_knob.setValue(20.0)
        
        self.isothermal_radio.setChecked(True)
        self.master_isolation_check.setChecked(False)
        self.link_rod_dia_check.setChecked(False)
        
        self.pneumatic_updated.emit(self.parameters.copy())
    
    @Slot()
    def _validate_system(self):
        """Validate system configuration"""
        from PySide6.QtWidgets import QMessageBox
        
        warnings = []
        errors = []
        
        # Check pressure ordering
        min_p = self.parameters['relief_min_pressure']
        stiff_p = self.parameters['relief_stiff_pressure']
        safety_p = self.parameters['relief_safety_pressure']
        
        if not (min_p < stiff_p < safety_p):
            errors.append("�������� ������ ������ ���� �����������: ��� < Ƹ������� < ������������")
        
        # Check temperature
        temp = self.parameters['atmo_temp']
        if temp < -10.0:
            warnings.append(f"������ ����������� ({temp} �C) ����� �������� �� �������� ����")
        elif temp > 40.0:
            warnings.append(f"������� ����������� ({temp} �C) ����� �������� �� ������ �������")
        
        # Show results
        if errors:
            QMessageBox.critical(self, '�������� �������', '������:\n' + '\n'.join(errors))
        elif warnings:
            QMessageBox.warning(self, '�������� �������', '��������������:\n' + '\n'.join(warnings))
        else:
            QMessageBox.information(self, '�������� �������', '��� ��������� ���������.')
    
    def get_parameters(self) -> dict:
        """Get current parameters"""
        return self.parameters.copy()
    
    def set_parameters(self, params: dict):
        """Set parameters from dictionary"""
        self.parameters.update(params)
        # Update UI controls as needed