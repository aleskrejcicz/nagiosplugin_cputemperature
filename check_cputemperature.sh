#!/usr/bin/env bash


# ./check_cputemperature.sh  <warn> <crit>
# ./check_cputemperature.sh  $1 $2
#
# Version 0.1



function is_int() {
    if [[ $1 =~ ^-?[0-9]+$ ]]; then
        return 0
    else
        return 1
    fi
}

function check_arg() {
	if [[ $# = 2 ]]
	then
		for var in $@; do
			if ! is_int $var
			then
				echo "UNKNOWN: [Bad syntax]: Argumets \"$var\" must be integer! Example: /check_cputemperature.sh 39 55"
				exit 3
			fi
		done
		if [[ $1 -gt $2 ]] || [[ $1 == $2 ]]; then
			echo "UNKNOWN: [Bad syntax]: The WARNING threshold must be greater than the CRITICAL threshold!"
			exit 3
		fi
	else
		echo "UNKNOWN: [Bad syntax]: ./check_cputemperature.sh <warn> <crit>"
		exit 3
	fi
}

check_arg $*


# =============================================================================

cpu_temp=`sensors | grep 'CPU Temperature' | cut -d + -f 2 | cut -d . -f1`

if ! is_int $cpu_temp; then
	echo "UNKNOWN: [Parse error]: CPU Temperature is not int \"$cpu_temp\""
	exit 3
elif [[ $2 -lt $cpu_temp ]] || [[ $2 == $cpu_temp ]]; then
    echo "CRITICAL: CPU Temperature $cpu_temp (Opt: W: $1, C: $2)"
    exit 2
elif [[ $1 -lt $cpu_temp ]] || [[ $1 == $cpu_temp ]]; then
    echo "WARNING: CPU Temperature $cpu_temp (Opt: W: $1, C: $2)"
    exit 1
else
    echo "OK : CPU Temperature $cpu_temp (Opt: W: $1, C: $2)"
    exit 0
fi