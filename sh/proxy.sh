#!/bin/bash

HOST=192.168.1.1
PORT=10808

proxy() {
	help() {
		echo "usage $0 [-h] [--help] [-s] [--set] [-u] [--unset]"
		echo
		echo "options:"
		echo "  -h, --help        print this message"
		echo "  -s, --set         setup proxy"
		echo "  -u, --unset       unset proxy"
	}


	if [[ "$1" == "-h" || "$1" == "--help" ]]; then
		help
	elif [[ "$1" == "-s" || "$1" == "--set" ]]; then
		export http_proxy=http://${HOST}:${PORT}
		export https_proxy=https://${HOST}:${PORT}
		echo "set proxy: ${HOST}:${PORT}"
	elif [[ "$1" == "-u" || "$1" == "--unset" ]]; then
		unset http_proxy
		unset https_proxy
		echo "unset proxy"
	else
		help
	fi


	unset -f help
}
