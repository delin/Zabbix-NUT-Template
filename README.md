Zabbix-NUT-Template
===================

Zabbix Template for NUT(Network UPS Tools)

Supported UPS: http://www.networkupstools.org/stable-hcl.html


# Value mapping

Value mapping must be done before importing template. It can done in **Administration** / **General** / **Value mapping** (combobox on right side)

Then **Create value map**

	0  - unknown state
	1  - On line (mains is present)
	2  - On battery (mains is not present)
	3  - Low battery
	4  - The battery needs to be replaced
	5  - The battery is charging
	6  - The battery is discharging (inverter is providing load power)
	7  - UPS bypass circuit is active echo no battery protection is available
	8  - UPS is currently performing runtime calibration (on battery)
	9  - UPS is offline and is not supplying power to the load
	10 - UPS is overloaded
	11 - UPS is trimming incoming voltage (called "buck" in some hardware)
	12 - UPS is boosting incoming voltage

![Value mapping](https://raw.githubusercontent.com/blondak/Zabbix-NUT-Template/master/Configuration%20of%20value%20mapping.png)