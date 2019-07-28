#!/usr/bin/env bash
ansible-playbook settingup_kubernetes_cluster.yml
ansible-playbook join_kubernetes_workers_nodes.yml

# List the kubernetes nodes
kubectl get nodes
curl -o get_helm.sh https://raw.githubusercontent.com/kubernetes/helm/master/scripts/get
chmod +x get_helm.sh
./get_helm.sh

# To check the helm installed properly
kubectl get deployments -n kube-system

#Deploy an application in Kubernetes Engine
kubectl run hello-app --image=gcr.io/google-samples/hello-app:1.0 --port=8080
kubectl expose deployment hello-app

#Deploy NGINX Ingress Controller with RBAC enabled
helm install --name nginx-ingress stable/nginx-ingress --set rbac.create=true --set controller.publishService.enabled=true

#kubectl get service nginx-ingress-controller

kubectl apply -f ingress-resource.yaml

#kubectl get ingress ingress-resource


if curl -s --head --request GET http://34.68.15.23/hello | grep "200 OK"
  then
    echo "The HTTP server is up!"
  else
    echo "The HTTP server is down!"
fi


#Create namespaces
kubectl create namespace staging
kubectl create namespace production

for i in staging production
do
   kubectl apply -f https://k8s.io/examples/application/guestbook/redis-master-deployment.yaml --namespace=$i
   kubectl apply -f https://k8s.io/examples/application/guestbook/redis-master-service.yaml --namespace=$i
   kubectl apply -f https://k8s.io/examples/application/guestbook/redis-slave-deployment.yaml
   kubectl apply -f https://k8s.io/examples/application/guestbook/redis-slave-service.yaml
   kubectl apply -f https://k8s.io/examples/application/guestbook/frontend-deployment.yaml

done

# Autoscale the frontend deployment for CPU % above 70 to maximum 5 pods
kubectl autoscale deployment frontend --cpu-percent=70 --min=1 --max=5

