Zabbix-NUT-Template
===================

Zabbix Template for NUT(Network UPS Tools)

Supported UPS: http://www.networkupstools.org/stable-hcl.html


# Installation

Install the NUT client tools, then run from the repository directory:

```sh
sudo install -D -m 755 sh/ups_status.sh /etc/zabbix/sh/ups_status.sh
sudo install -D -m 644 zabbix_agentd.d/userparameter_nut.conf /etc/zabbix/zabbix_agentd.d/userparameter_nut.conf
```

Use your agent's included configuration directory (usually
`/etc/zabbix/zabbix_agent2.d` for Agent 2), then restart the agent.
For new installations on Zabbix 7.0 LTS or 7.4, import `nut_ups_template_zb-6.4_.xml`.
When updating, reimport the same template variant already in use.

# Value mapping

The 6.2 and 6.4 templates include value mapping. The following manual steps
apply only to the legacy `zbx_export_templates.xml` (Zabbix 2.0).

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
	13 - On line and the battery is charging
	14 - On battery and the battery is discharging

Combined statuses report one state. Fault priority is `OFF`, `LB`, `OVER`,
`BYPASS`, `RB`; unknown flags remain code 0 unless a known fault is present.
Failed `upsc` requests become unsupported items. The 6.2 and 6.4 templates
alert after 5 minutes without status data.

![Value mapping](https://raw.githubusercontent.com/blondak/Zabbix-NUT-Template/master/Configuration%20of%20value%20mapping.png)