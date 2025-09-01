# Criar cluster e aplicar manifests
k3d cluster create -c ..\k3d-cluster.yaml
kubectl apply -f ..\k8s\00-namespace.yaml
kubectl apply -f ..\k8s\10-deployment.yaml
kubectl apply -f ..\k8s\20-service.yaml
# Garantir metrics-server (idempotente)
kubectl apply -f https://github.com/kubernetes-sigs/metrics-server/releases/latest/download/components.yaml
kubectl apply -f ..\k8s\30-hpa.yaml
kubectl get all -n app
Write-Host "App em http://localhost:8080"