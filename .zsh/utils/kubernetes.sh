#!/bin/bash

function kn() {
    namespace=$1
    if [ -z $namespace ]; then
        echo "Please provide the namespace name: e.g., 'kn mywebapp'"
        return 1
    fi

    kubectl config set-context $(kubectl config current-context) --namespace $namespace
}

function kc() {
	local input=$1

    if [ -z "$input" ]; then
        echo "Please provide a command or context name."
		echo "Usage: kc [ls | context_name]"
        return 1
    fi

	case "$input" in
		ls)
			kubectl config get-contexts
			;;
		*)
			kubectl config use-context "$input"
			;;
	esac
}
