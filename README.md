# 1. SIMPLE K8S

config file -> used to create 'objects'
objects serve different purposes like running a container, monitoring a container, setting up a network, etc
kubernetes cluster: set of nodes that run containerized applications, provide flexible and scalable infrastructure for building, deploying and
managing apps
types of objects:

1. statefulset
2. replicacontroller
3. pod ->
4. service

## DEFINITION OF TERMS

##### 1. Node - virtual machine which starts when kubectl start is run.

##### 2. Pod - a grouping of containers with very common purpose. They rest inside a node.

    Pod is a smallest thing to deploy to run a container.
    containers are deployed within a pod. One or more containers must run into a pod.
    e.g postgres with a logger and back-up manager replicating the postgres.

##### 3. Service

    - used to set networking in k8s cluster.
    - has 4 subtiypes of service object
    1. ClusterIP
        -
    2. NodePort
        - expose container to the outside world. Access container from browser
        - only good for dev purposes. Cannot be used in production environment.
    3. LoadBalance
        -
    4. Ingress

## LOAD THE TWO CONFIGS TO K8S CLUSTER

use kubectl apply -f <path to config file>
kubectl apply -f client-pod.yml
kubectl apply -f client-node-port.yml

## PRINT STATUS OF ALL RUNNING PODS

kubectl get pods

## CHECK THE STATUS OF ALL SERVICES

kubectl get service.

## ACCESS ON BROWSER

- ask minikube for the virtual machine created.
- use minikube ip => will print the ip address of the virtual machine created.
- returns 192.168.49.2.

## TAKE AWAYS

- kubernetes is a system of deploying containerized apps.
- nodes are individual machines or vms that run containers.
- masters are machines or vms with a set program to manage nodes.
- kubernetes does not build images, it gets them from somewhere.
- the master(kubernetes) decide where to run each container.
- to deploy something, we update the desired state of the master with a config file.
- the master is constantly working to meet the desired state.

## IMPERATIVE VS DECLARATIVE

Imperative deployments
-> do exactly these seteps to arrive at this container set up

Declarative deployments
-> our container setup should look like this, make it happen

# 2. UPDATING EXISTING POD

change the name of the image to bixoloo/multi-worker
apply the changes with kubectl apply -f ./02.updating-existing-pod/client-pod.yml
returns client-pod configured
run kubectl get pods
inspect a running updated object: use kubectl describe pods client-pod

#### a) Limititations in updating config

    pod updates may not change fields other than image, active deadlines
    fields like containers, name, and port cannot be changed

#### b) Overcoming the challenge

        use 'Deployment'
        This is an object which maintains set of identical pods, ensuring that they have the correct config and that the right number exists.
        At the end of the day, we can use either Pods or Deployment with K8s to run an application.

        NB:
        Pods
        - run single set of related containers
        - good for one-off dev purposes
        - rarely used directly in production.

        Deployment
        - runs a set of identaical pods (one or more).
        - monitors the state of each pod, updating as necessary
        - good for dev
        - good for production
