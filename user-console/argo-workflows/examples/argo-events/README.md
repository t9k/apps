Following https://argoproj.github.io/argo-events/quick_start/, create argo-events examples:

```bash
# 1. create eventbus
kubectl create -n demo -f eventbus.yaml

# 2. create eventsource
kubectl create -n demo -f eventsource.yaml

# 3. create rbac
kubectl create -n demo -f sensor-rbac.yaml
kubectl create -n demo -f workflow-rbac.yaml

# 4. create sensor
kubectl create -n demo -f sensor.yaml

# 5. port forward event source
kubectl port-forward -n demo webhook-eventsource-svc 12000:12000

# 6. send event
curl -d '{"message":"this is my first webhook"}' -H "Content-Type: application/json" -X POST http://localhost:12000/example

# 7. check result
kubectl -n demo get workflows | grep "webhook"
```
