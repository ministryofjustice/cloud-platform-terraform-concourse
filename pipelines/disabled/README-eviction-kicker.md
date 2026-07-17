# Stuck Eviction Kicker pipeline

With bootstrap pipeline in paused state, when you're ready to execute a node group upgrade (for example via the AWS console using "Rolling" strategy), set the stuck-eviction-kicker-no-force.yaml pipeline in Concourse for your target cluster and log group:

ie:

```
fly -t manager set-pipeline \
  -p stuck-eviction-monitor-no-force \
  -c stuck-eviction-kicker-no-force.yaml \
  -v cluster_name=cp-1607-0849 \
  -v cluster_log_group=/aws/eks/cp-1607-0849/cluster
  ```

  Then unpause the pipeline, kick off a build with the + button in Concourse. Once the script is running, kick off the node group upgrade.

  ## Mass deploy test script 
  
  including 10% bad pdb configs we've been using to test this process out with great results:

`mass-deploy.sh`:

```
  for i in {1..100}; do
cat <<EOF >> mass-deploy-test.yaml
---
apiVersion: v1
kind: Namespace
metadata:
  name: mass-deploy-$i
  labels:
    pod-security.kubernetes.io/enforce: restricted
    pod-security.kubernetes.io/enforce-version: latest
---
apiVersion: apps/v1
kind: Deployment
metadata:
  name: secure-nginx-$i
  namespace: mass-deploy-$i
spec:
  replicas: 2
  selector:
    matchLabels:
      app: nginx
  template:
    metadata:
      labels:
        app: nginx
    spec:
      securityContext:
        runAsNonRoot: true
        runAsUser: 10001
        runAsGroup: 10001
        fsGroup: 10001
        seccompProfile:
          type: RuntimeDefault
      containers:
      - name: nginx
        image: nginxinc/nginx-unprivileged:alpine
        imagePullPolicy: IfNotPresent
        securityContext:
          allowPrivilegeEscalation: false
          readOnlyRootFilesystem: true
          runAsNonRoot: true
          runAsUser: 10001
          capabilities:
            drop:
            - ALL
        ports:
        - containerPort: 8080
          name: http
        resources:
          limits:
            cpu: 500m
            memory: 500Mi
          requests:
            cpu: 200m
            memory: 200Mi
        volumeMounts:
        - mountPath: /tmp
          name: tmp-volume
      volumes:
      - name: tmp-volume
        emptyDir: {}
EOF

# Modulo 10 injects the strict PDB into exactly 10% of these new namespaces
if [ $((i % 10)) -eq 0 ]; then
cat <<EOF >> mass-deploy-test.yaml
---
apiVersion: policy/v1
kind: PodDisruptionBudget
metadata:
  name: un-evictable-pdb
  namespace: mass-deploy-$i
spec:
  maxUnavailable: 0
  selector:
    matchLabels:
      app: nginx
EOF
fi

done

# Apply the renamed configuration
kubectl apply -f mass-deploy-test.yaml
```