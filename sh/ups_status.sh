#!/bin/bash

ups=${1:-}

fail() {
    printf 'Error: %s\n' "$1"
    exit 1
}

if [[ $ups = ups.discovery ]]; then
    [[ $# -le 2 && -z ${2:-} ]] || fail 'usage: ups_status.sh ups.discovery'
    names=$(/bin/upsc -l 2>/dev/null) || fail 'upsc failed during discovery'

    echo -e "{\n\t\"data\":["
    first=1
    while IFS= read -r discovered ; do
        [[ -n $discovered ]] || continue
        if [ $first -eq 0 ]; then
            echo -e ","
        fi
        discovered=${discovered//\\/\\\\}
        discovered=${discovered//\"/\\\"}
        printf '\t\t{ "{#UPSNAME}":\t"%s" }' "$discovered"
        first=0
    done <<< "$names"
    echo -e "\n\t]\n}"

else
key=${2:-}
[[ $# -eq 2 && -n $ups && -n $key ]] || fail 'usage: ups_status.sh UPSNAME KEY'

if [[ $key = ups.status ]]; then
	state=$(/bin/upsc "$ups" "$key" 2>/dev/null) || fail "upsc failed for $ups ($key)"
	read -r -a flags <<< "$state"
	state=" ${flags[*]} "
	for flag in "${flags[@]}"; do
	    case "$flag" in
	        OL|OB|LB|RB|CHRG|DISCHRG|BYPASS|CAL|OFF|OVER|TRIM|BOOST) ;;
	        *) state+=" UNKNOWN " ;;
	    esac
	done

	# Unknown flags rank below faults, but above normal states.
	for flag in OFF LB OVER BYPASS RB UNKNOWN OB CAL TRIM BOOST DISCHRG CHRG OL; do
	    [[ $state == *" $flag "* ]] || continue
	    case "$flag" in
	        OB) [[ $state == *" DISCHRG "* ]] && flag="OB DISCHRG" ;;
	        CHRG) [[ $state == *" OL "* ]] && flag="OL CHRG" ;;
	    esac
	    state=$flag
	    break
	done
	case "$state" in
		"OL")		echo 1 ;; #'On line (mains is present)' ;;
		"OB")		echo 2 ;; #'On battery' ;;
		"LB")		echo 3 ;; #'Low battery' ;;
		"RB")		echo 4 ;; #'The battery needs to be replaced' ;;
		"CHRG")		echo 5 ;; #'The battery is charging' ;;
		"DISCHRG")	echo 6 ;; #'The battery is discharging (inverter is providing load power)' ;;
		"BYPASS")	echo 7 ;; #'UPS bypass circuit is active echo no battery protection is available' ;;
		"CAL")		echo 8 ;; #'UPS is currently performing runtime calibration (on battery)' ;;
		"OFF")		echo 9 ;; #'UPS is offline and is not supplying power to the load' ;;
		"OVER")		echo 10 ;; #'UPS is overloaded' ;;
		"TRIM")		echo 11 ;; #'UPS is trimming incoming voltage (called "buck" in some hardware)' ;;
		"BOOST")	echo 12 ;; #'UPS is boosting incoming voltage' ;;
		"OL CHRG")	echo 13 ;; #'On line (mains present) and the battery is charging' ;;
  		"OB DISCHRG")   echo 14 ;; #'On battery discharging (mains absent)
		* )		echo 0 ;; #'unknown state' ;;
	esac
else
	value=$(/bin/upsc "$ups" "$key" 2>/dev/null) || fail "upsc failed for $ups ($key)"
	printf '%s\n' "$value"
fi

fi
