#!/bin/sh
 
ups=$1
key=$2
 
if [ $key = ups.status ]; then
	state=`/bin/upsc $ups $key`
	case $state in
		OL)		echo 1 ;; #'On line (mains is present)' ;;
		OB)		echo 2 ;; #'On battery (mains is not present)' ;;
		LB)		echo 3 ;; #'Low battery' ;;
		RB)		echo 4 ;; #'The battery needs to be replaced' ;;
		CHRG)		echo 5 ;; #'The battery is charging' ;;
		DISCHRG)	echo 6 ;; #'The battery is discharging (inverter is providing load power)' ;;
		BYPASS)		echo 7 ;; #'UPS bypass circuit is active echo no battery protection is available' ;;
		CAL)		echo 8 ;; #'UPS is currently performing runtime calibration (on battery)' ;;
		OFF)		echo 9 ;; #'UPS is offline and is not supplying power to the load' ;;
		OVER)		echo 10 ;; #'UPS is overloaded' ;;
		TRIM)		echo 11 ;; #'UPS is trimming incoming voltage (called "buck" in some hardware)' ;;
		BOOST)		echo 12 ;; #'UPS is boosting incoming voltage' ;;
		* )		echo 0 ;; #'unknown state' ;;
	esac
else
	/bin/upsc $ups $key
fi
