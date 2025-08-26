# Atividade Ponderada: Cluster Kubernetes

## Objetivo

O objetivo deste projeto é desenvolver um **cluster Kubernetes** com escalabilidade, utilizando o **Horizontal Pod Autoscaler (HPA)** para ajustar automaticamente o número de réplicas de uma aplicação baseada em **PHP e Apache**.  

O projeto demonstra a aplicação de conceitos de **orquestração, escalabilidade e monitoramento de métricas de pods** em Kubernetes.

---

## Estrutura do Repositório

```powershell
├── k8s/
│ ├── 01-deployment.yaml # Deployment da aplicação PHP-Apache
│ ├── 02-service.yaml # Serviço LoadBalancer para expor a aplicação
│ └── 03-hpa.yaml # Configuração do Horizontal Pod Autoscaler
├── README.md # Documentação do projeto
└── scripts/
└── load-test.js # Script de teste de carga (k6)
```

## Pré-requisitos

- [Docker Desktop](https://www.docker.com/products/docker-desktop) ativo
- [k3d](https://k3d.io/) para criar o cluster Kubernetes
- [kubectl](https://kubernetes.io/docs/tasks/tools/) configurado
- [k6](https://k6.io/) para testes de carga (opcional, para validação do HPA)

## Passo a passo: Configuração do Cluster

### 1. Criar o cluster Kubernetes com k3d

```powershell
k3d cluster create ponderada --agents 2
```

Verifique se o cluster está ativo:

```powershell
k3d cluster list
```

### 2. Configurar o contexto do kubectl

```powershell
$env:KUBECONFIG="C:\Users\Inteli\cluster\kubeconfig.yaml"
kubectl config current-context
```

### 3. Aplicar Deployment e Service

```powershell
kubectl apply -f k8s/01-deployment.yaml
kubectl apply -f k8s/02-service.yaml
```

Verifique se os pods estão sendo criados:

```powershell
kubectl get pods -o wide
kubectl get svc -o wide
```

## Resultados do Cluster Kubernetes

### Status dos Nodes

| Node                    | CPU (cores) | CPU % | Memory (bytes) | Memory % |
|-------------------------|-------------|-------|----------------|----------|
| k3d-ponderada-agent-0   | 168m        | 2%    | 181Mi          | 2%       |
| k3d-ponderada-agent-1   | 100m        | 1%    | 157Mi          | 2%       |
| k3d-ponderada-server-0  | 140m        | 1%    | 549Mi          | 7%       |

---

### Status dos Pods (Default Namespace)

| Pod Name                  | Ready | Status              | Restarts | Node                     | Age |
|----------------------------|-------|-------------------|----------|-------------------------|-----|
| php-apache-667467f4d-27tz9| 0/1   | ContainerCreating  | 0        | k3d-ponderada-agent-0   | 15s |

---

### Services

| Service Name        | Type         | Cluster-IP    | External-IP | Ports        | Selector       |
|--------------------|--------------|--------------|------------|-------------|----------------|
| php-apache-svc      | LoadBalancer | 10.43.66.166 | <pending>  | 80:30582/TCP| app=php-apache |

---

### Teste de Carga (k6)

Durante o teste de carga com 50 VUs por 1 minuto, o HPA deve escalar automaticamente o deployment `php-apache` até o máximo de 10 pods, dependendo da CPU utilizada.

---