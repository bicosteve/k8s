#! /bin/bash 
# building docker image for client
docker build -t bixoloo/multi-client:latest -t bixoloo/multi-client:$GIT_SHA -f ./client/Dockerfile ./client 
# building docker image for server 
docker build -t bixoloo/multi-server:latest -t bixoloo/multi-server:$GIT_SHA -f ./server/Dockerfile ./server 
# building docker image for woker
docker build -t bixoloo/multi-worker:latest -t bixoloo/multi-worker:$GIT_SHA -f ./worker/Dockerfile ./worker 
# building docker image for client

#Pushing images to docker hub 
docker push bixoloo/multi-client:latest
docker push bixoloo/multi-server:latest
docker push bixoloo/multi-worker:latest

docker push bixoloo/multi-client:$GIT_SHA 
docker push bixoloo/multi-server:$GIT_SHA 
docker push bixoloo/multi-worker:$GIT_SHA  


# Apply K8S files 
kubectl apply -f client 
kubectl apply -f db-volumes
kubectl apply -f ingress
kubectl apply -f redis 
kubectl apply -f worker 

# this will be added on gcp console
kubectl apply -f postgres 
kubectl apply -f server 

#Setting up image versions on deployments
kubectl set image server/deployments/deployment.yml server=bixoloo/multi-server:$GIT_SHA
kubectl set image client/deployments/deployment.yml client=bixoloo/multi-client:$GIT_SHA
kubectl set image worker/deployments/deployment.yml workerr=bixoloo/multi-worker:$GIT_SHA


# Before applying the manifests, 
# 1. set gcloud project with gcloud config set project <project_id>
# gcloud config set project multi-k8s-396215
# 2. set compute zone
# gcloud config set compute/zone me-central1-a
# 3. Get credentials: gcloud container clusters get-credentials <cluster_name> 
# gcloud container clusters get-credentials k8scluster
#NB: these commands are only run once in one project
# after this, kubectl can be run safely in the console
# kubectl create secret generic pgpassword --from-literal PGPASSWORD=$PGPASSWORD

# HELM SET UP 
# you have to install ingress as service in your cloud cluster
# use this https://github.com/kubernetes/ingress-nginx 
# use github.com/helm/helm/ check on the guide to install helm
# use from script to install
# 1. curl -fsSL -o get_helm.sh https://raw.githubusercontent.com/helm/helm/main/scripts/get-helm-3
# 2. chmod 700 get_helm.sh
# 3. ./get_helm.sh 
# set up tiller correctly in the gke 
# RBAC - role based access control
# 

# Kubernetes Security with RBAC
# 1. User accounts - identifies a *person* administering our cluster
# 2. Service accounts - identifies a *pod* admnistering a cluster
# 3. ClusterRoleBinding - authorizes an account to do a certain set of actions across the *entire cluster*.
# 4. Role Binding - authorizes an account to do a certain set of actions in a *single namespace* 

# K8s Namespaces 
# kubectl get namespaces 
# 1. default - 
# 2. kube-public -> 
# 3. kube-system -> contains k8s objects that make k8s work. Administrative level

# 1. Creating Service Accounts for tiller 
# kubectl create serviceaccount --namespace kube-system tiller
# 2. Creating a clusterrolebinding for role 'cluster-admin'
# kubectl create clusterrolebinding tiller-cluster-rule --clusterrole=cluster-admin --serviceaccount=kube-system:tiller

#ingress set up for gke

# NB: Read more on ingress-nginx