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
    context=$1
    
    if [ -z $context ]; then
        echo "Please provide the context name: e.g., 'kc mycontext'"
        return 1
    fi
    
    kubectl config use-context $context
}
