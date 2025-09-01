# Cluster Kubernetes com HPA

## Introdução
Nesta atividade, o objetivo foi desenvolver um **cluster Kubernetes** com escalabilidade, utilizando o **Horizontal Pod Autoscaler (HPA)** para ajustar automaticamente o número de réplicas de uma aplicação PHP com Apache. 
O projeto foi implementado utilizando o **k3d**, mas poderia ser feito com outras ferramentas como **minikube** ou **k3s**. Além da construção do cluster, foram realizados testes de carga para analisar o comportamento do HPA.

---

## Estrutura do Cluster

### Deployments
```bash
NAME                         READY   UP-TO-DATE   AVAILABLE   AGE
deployment.apps/php-apache   1/1     1            1           16m
```

### ReplicaSets
```bash
NAME                                    DESIRED   CURRENT   READY   AGE
replicaset.apps/php-apache-54b7ff8977   1         1         1       16m
```

### Pods
```bash
NAME                              READY   STATUS    RESTARTS   AGE
pod/php-apache-54b7ff8977-l2xwj   1/1     Running   0          16m
```

### Services
```bash
NAME                     TYPE           CLUSTER-IP      EXTERNAL-IP   PORT(S)        AGE
service/php-apache-svc   LoadBalancer   10.43.105.231   <pending>     80:31633/TCP   16m
```

### HPA
```bash
NAME                                                 REFERENCE               TARGETS       MINPODS   MAXPODS   REPLICAS   AGE
horizontalpodautoscaler.autoscaling/php-apache-hpa   Deployment/php-apache   cpu: 0%/50%   1         10        1          15m
```
- Mínimo de réplicas: 1
- Máximo de réplicas: 10
- Métrica monitorada: CPU
- Status: AbleToScale, ScalingActive, ScalingLImited
- Obs: Houve warnings sobre métricas de CPU não retornadas, o que é comum em clusters locais sem métricas externas configuradas.

## Métricas de Recurso do Cluster

### Nodes
```bash
NAME                       CPU(cores)   CPU%   MEMORY(bytes)   MEMORY%
k3d-hpa-cluster-agent-0    118m         1%     210Mi           2%
k3d-hpa-cluster-agent-1    124m         1%     319Mi           4%
k3d-hpa-cluster-server-0   131m         1%     523Mi           6%
```

### Pods
```bash
NAME                              CPU(cores)   MEMORY(bytes)
php-apache-54b7ff8977-l2xwj      1m           9Mi
```

## Teste de carga

Para avaliar a escalabilidade, foi utilizado o container [williamyeh/hey](https://hub.docker.com/r/williamyeh/hey?utm_source=chatgpt.com) para simular 50 requisições concorrentes por 2 minutos.

O teste de carga mostrou que o cluster é capaz de lidar com um grande número de requisições simultâneas, demonstrando desempenho consistente.

```bash
docker run --rm -it williamyeh/hey -z 2m -c 50 http://host.docker.internal:8080/
```

### Resultados

- Total de requisições: 616.057
- Requests/sec: 5.133
- Latência média: 0.0097s
- Latência 50%: 0.0088s
- Latência 90%: 0.0152s

### Distribuição de latência

```bash
10% em 0.0054s
25% em 0.0068s
50% em 0.0088s
75% em 0.0115s
90% em 0.0152s
95% em 0.0181s
99% em 0.0255s
```

---

## Como executar

1) Clone o repositório:
```bash
git clone https://github.com/rafaelarojas/cluster
cd https://github.com/rafaelarojas/cluster
```

2) Suba o cluster:
```bash
k3d cluster create hpa-cluster -f k3d-config.yaml
```

3) Aplique os manifests do Kubernetes:
```bash
kubectl apply -f deployment.yaml
kubectl apply -f service.yaml
kubectl apply -f hpa.yaml
```

4) Verifique o status:
```bash
kubectl get all
kubectl get hpa
```

5) Execute testes de carga:
```bash
docker run --rm -it williamyeh/hey -z 2m -c 50 http://host.docker.internal:8080/
```
