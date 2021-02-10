#!/bin/bash

kubectl -n kong delete configmap kong-plugin-custom-auth2
kubectl -n kong create configmap kong-plugin-custom-auth2 --from-file=kong/plugins/custom-auth


