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

# Teste de Carga

Para avaliar a escalabilidade do cluster, foi utilizado o container [`williamyeh/hey`](https://hub.docker.com/r/williamyeh/hey) para simular requisições concorrentes.

## Comando Utilizado

```bash
docker run --rm -it williamyeh/hey -z 2m -c 50 http://host.docker.internal:8080/
```
O teste simulou 50 requisições concorrentes por 2 minutos.

## Resultados Gerais

| Métrica                 | Valor           |
|--------------------------|----------------|
| Total de requisições     | 616.057        |
| Requests por segundo      | 5.133          |
| Latência média           | 0.0097 s       |
| Latência 50% (mediana)   | 0.0088 s       |
| Latência 90%             | 0.0152 s       |

---

## Distribuição de Latência

| Percentil | Latência |
|------------|----------|
| 10%        | 0.0054 s |
| 25%        | 0.0068 s |
| 50%        | 0.0088 s |
| 75%        | 0.0115 s |
| 90%        | 0.0152 s |
| 95%        | 0.0181 s |
| 99%        | 0.0255 s |

---

## Detalhes do Teste (HPA)

| Métrica                | Valor médio | Mais rápido | Mais lento |
|------------------------|------------|------------|------------|
| Total                   | 120.0284 s | 0.0015 s   | 0.2266 s   |
| Requests/sec            | 3383.97    | -          | -          |
| Total de dados          | 7.717.268 bytes | - | - |
| Tamanho por requisição   | 19 bytes   | -          | -          |
| DNS + Dialup             | 0.0000 s   | 0.0015 s   | 0.2266 s   |
| DNS Lookup               | 0.0000 s   | 0.0000 s   | 0.0152 s   |
| Request Write            | 0.0000 s   | 0.0000 s   | 0.0445 s   |
| Response Wait            | 0.0144 s   | 0.0014 s   | 0.2265 s   |
| Response Read            | 0.0002 s   | 0.0000 s   | 0.0445 s   |

---

## Observações

- O cluster demonstrou alto desempenho, conseguindo lidar com milhares de requisições simultâneas.
- A latência permanece baixa e consistente, indicando boa escalabilidade do sistema.


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
