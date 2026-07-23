# Stuck Evictions Monitoring pipeline

## About

This pipeline supports our preferred method of carrying out node group upgrades during an EKS upgrade process. It allows us to handover the node group upgrade itself to AWS, using the "Rolling" strategy, while we monitor for stuck evictions and take action to resolve them if they occur.

## How to use

With bootstrap pipeline in paused state, when you're ready to execute a cluster node group upgrade, set the stuck-evictions-monitor.yaml pipeline in Concourse for your target cluster and log group:

ie:

```
fly -t manager set-pipeline \
  -p stuck-evictions-monitor \
  -c stuck-evictions-monitor.yaml \
  -v cluster_name=cp-1607-0849 \
  -v cluster_log_group=/aws/eks/cp-1607-0849/cluster
```

Then unpause the newly created `stuck-evictions-monitor` pipeline, and kick off a build with the + button in Concourse. Once the script is running, kick off the node group upgrade in the AWS console.

Once the node group upgrade is complete, cancel the `stuck-evictions-monitor` pipeline.

## Testing 

If you want to test this pipeline out on your own cluster, you can use the following script to mass deploy 100 namespaces with 2 nginx pods each. The script is setup to apply bad pdb configuration to 10% of the deployments, which will cause the stuck eviction monitor to detect and safely delete any resulting stuck pods.

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