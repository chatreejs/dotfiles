#!/bin/bash

function k() {
    # kubectl wrapper: when the output is YAML/JSON, pipe through yq/jq for
    # syntax highlighting. Falls back to plain kubectl if the tool is missing.
    local arg prev
    local fmt=""
    for arg in "$@"; do
        case "$arg" in
            -oyaml | -o=yaml | --output=yaml)
                fmt="yaml"
                ;;
            -ojson | -o=json | --output=json)
                fmt="json"
                ;;
            yaml | json)
                [ "$prev" = "-o" ] || [ "$prev" = "--output" ] && fmt="$arg"
                ;;
        esac
        prev="$arg"
    done

    if [ "$fmt" = "yaml" ] && command -v yq >/dev/null 2>&1; then
        kubectl "$@" | yq
    elif [ "$fmt" = "json" ] && command -v jq >/dev/null 2>&1; then
        kubectl "$@" | jq
    else
        kubectl "$@"
    fi
}

function kn() {
    local namespace=$1
    if [ -z "$namespace" ]; then
        echo "Please provide the namespace name: e.g., 'kn mywebapp'"
        echo "Usage: kn [--list | namespace_name]"
        return 1
    fi

    case "$namespace" in
        --list | -l | ls)
            kubectl get namespaces
            ;;
        *)
            kubectl config set-context $(kubectl config current-context) --namespace "$namespace"
            ;;
    esac
}

function kc() {
    local input=$1

    if [ -z "$input" ]; then
        echo "Please provide a command or context name."
        echo "Usage: kc [ls | context_name]"
        return 1
    fi

    case "$input" in
        --list | -l | ls)
            kubectl config get-contexts
            ;;
        *)
            kubectl config use-context "$input"
            ;;
    esac
}
