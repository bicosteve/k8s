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
kubectl create secret generic pgpassword --from-literal PGPASSWORD=$PGPASSWORD
kubectl apply -f postgres 
kubectl apply -f server 

#Setting up image versions on deployments
kubectl set image server/deployments/deployment.yml server=bixoloo/multi-server:$GIT_SHA
kubectl set image client/deployments/deployment.yml client=bixoloo/multi-client:$GIT_SHA
kubectl set image worker/deployments/deployment.yml workerr=bixoloo/multi-worker:$GIT_SHA

