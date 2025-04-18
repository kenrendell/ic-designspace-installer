#!/bin/sh

# Function to modify paths
prepend_envv () {
	{ [ -n "$2" ] && [ "$2" = "${2#*:}" ]; } || { printf "No ':' character is allowed!\n"; return 1; }

	# Extract the value from the variable
	envv="$(eval printf "'%s'" '"${'"${1}"'}"')" || return 1

	# Remove redundant colons ':'
	while [ "${envv#*::}" != "${envv}" ]; do
		envv="$(printf '%s' "${envv}" | sed -E -n 's/(:{2,})/:/p')"
	done; envv="${envv#:}"; envv="${envv%:}"

	# Prepend the entry
	case ":${envv}:" in
		(*":${2}:"*) # delete entry if exists
			lpath="${envv%:"${2}"*}"; [ "${lpath}" = "${envv}" ] && lpath=
			rpath="${envv#*"${2}":}"; [ "${rpath}" = "${envv}" ] && rpath=

			{ [ -n "${rpath}" ] && envv=":${rpath}"; } || envv=
			[ -n "${lpath}" ] && envv=":${lpath}${envv}"

			envv="${2}${envv}" ;;
		(*) envv="${2}$(test -n "${envv}" && printf ':')${envv}" ;;
	esac;

	# Assign the resulting value
	eval "${1}='${envv}'"
}
