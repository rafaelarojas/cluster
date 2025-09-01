# Remover recursos e cluster
kubectl delete -f ..\k8s\30-hpa.yaml --ignore-not-found
kubectl delete -f ..\k8s\20-service.yaml --ignore-not-found
kubectl delete -f ..\k8s\10-deployment.yaml --ignore-not-found
kubectl delete -f ..\k8s\00-namespace.yaml --ignore-not-found
k3d cluster delete hpa-lab