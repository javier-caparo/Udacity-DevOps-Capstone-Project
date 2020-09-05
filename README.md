#  UDACITY DEVOPS CAPSTONE PROJECT: Build a Continuous  Integration / Continuous Deployment Pipeline (CI/CD with Jenkins and Kubernetes
----------------------------------


## PROJECT SCOPE

This guide will take you through the steps necessary to BUILD a CI/CD pipeline
 by leveraging [AWS EKS](https://aws.amazon.com/eks/getting-started/)
, [Jenkins](https://jenkins.io) and [Sonarqube](https://www.sonarqube.org/) to orchestrate the software delivery pipeline and its deployment in AWS EKS using a "ROLLING UPDATE STRATEGY".
If you are not familiar with basic Kubernetes concepts, have a look at
[Kubernetes 101](http://kubernetes.io/docs/user-guide/walkthrough/).

In order to accomplish this goal you will use the following Jenkins plugins:
  - [Jenkins Pipelines](https://jenkins.io/solutions/pipeline/) - define our build pipeline declaratively and keep it checked into source code management alongside our application code  
  - [Jenkins Blue Ocean Plugin](https://www.jenkins.io/blog/2017/06/13/blueocean-1-1/) - allows users to graphically create, visualize and diagnose Continuous Delivery (CD) Pipelines.
  - [Jenkins Pipeline AWS Steps ](https://plugins.jenkins.io/pipeline-aws/) - allows users use the withAWS step to get AWS  authorization for the nested steps. You can provide region and profile information or let Jenkins assume a role in another or the same AWS account.
  - [Jenkins NodeJS](https://plugins.jenkins.io/nodejs/) - Provides Jenkins integration for NodeJS & npm package
  - [Jenkins Sonarqube](https://plugins.jenkins.io/sonar/) - it lets you centralize the configuration of SonarQube server connection details in Jenkins global configuration.

In order to deploy the application with [Kubernetes](http://kubernetes.io/) you will use the following resources:
  - [Deployments](http://kubernetes.io/docs/user-guide/deployments/) - replicates our application across our kubernetes nodes and allows us to do a controlled rolling update of our software across the fleet of application instances
  - [Services](http://kubernetes.io/docs/user-guide/services/) - load balancing and service discovery for our internal services
 
## Prerequisites

1. An AWS IAM Account with these policy profiles available Note : not use this full access permission on real production environments ( use a more restrictive ones):

| Policy Name | Policy Type |
| ------ | ------ |
| AmazonEC2FullAccess | AWS managed policy |
| IAMFullAccess | AWS managed policy |
| AmazonEC2ContainerRegistryFullAccess | AWS managed policy |
| AmazonS3FullAccess | AWS managed policy |
| AmazonECS_FullAccess | AWS managed policy |
| AmazonSSMFullAccess | AWS managed policy |
| AWSCloudFormationFullAccess | AWS managed policy |
| eksFullAccessforIAMUser |  Inline Policy | 

- Inline Policy with this json config:
{
    "Version": "2012-10-17",
    "Statement": [
        {
            "Sid": "eksadministrator",
            "Effect": "Allow",
            "Action": "eks:*",
            "Resource": "*"
        }
    ]
}

Important NOTES: 
 - you need the Account IAM User "Access Key ID"  & "Secret access key" because you will needed later to configure AWS CLI !!!!!
 - You can also use an IAM Role if you prefer ( give the above permissions and get the credentials )

 2. A docker hub account to be used as our "master" repo [master repo](https://hub.docker.com/)
3. An AWS ECR repo to be used as our "developers" repo [dev repo](https://aws.amazon.com/ecr/)
4. An S3 bucket where the "cluster.yaml" (located at "eks\cluster.yaml") file was uploaded previously  to create the EKS cluster ( will be used on Jenkins Pipeline that creates the EKS cluster)

## Github Directory Structure

[Repo tree file](https://static-jenkins-repo-project3.s3-us-west-2.amazonaws.com/file+tree+structure.jpg)

in summary:




## Do this first

- On AWS console set you region to "us-west-2". WE are using the resources of that Region. If you are going to use another region , check your AMIs and availability to use EKS on your regions with eksctl.

## Install Ubuntu Jenkins Sonarqube server ( both services in the same server)
1. Execute the Ubuntu Jenkins Sonarqube CloudFormation template located at  "cnf-templates\ec2-jenkins.yml" to get an Ubuntu EC2 instance 
- this template configure your EC2 in a security group with permission to :
- 22 -->ssh
- 8080 --> Jenkins
- 9000 --> Sonarqube
- 80 --> nginx ( in case you want to configure nginx as reverse proxy with SonarQube)
- 3000 --> our app expose port in case you want to test the docker image right there.

- Also, this template already installed the last java version ( java 1.8) & git on the server.

2. Wait that your instance is created on CloudFormation and at EC2 service wait that is running and ready.
3. Connect by console you your new EC2 instance

4. Create a “sh” file and copy the lines at "cnf-templates\jenkins-req.sh" to install all requirements to run Jenkins and docker.
  
  ```sh
    touch req.sh ; chmod +x req.sh
    nano req.sh
    (copy the lines and saved)
    ./req.sh
```
 
5. In other terminal, meanwhile, you can install SonarQube ( with PostgreSQL v10)
 - Follow the guidelines located at "cnf-templates\sonarqube-install-steps.txt"
 - Don’t forget to install also the part of Sonarqube Scanner:
   ```sh
    wget https://binaries.sonarsource.com/Distribution/sonar-scanner-cli/sonar-scanner-cli-4.4.0.2170-linux.zip
    unzip sonar-scanner-cli-4.4.0.2170-linux
    sudo mv sonar-scanner-4.4.0.2170-linux/ /opt/sonarqube
    ```
6. Verify that docker , Jenkins and SonarQube are running
 ```sh
 $sudo systemctl status jenkins
 $sudo systemctl status docker
 $sudo systemctl status sonarqube
 ```

7. If you follow this guidelines, then, you can enter to Jenkins GUI at port 8080 & Sonarqube at port 9000 with the public DNS of your EC2 Ubuntu Jenkins Sonarqube instance . Example:

## Configure Sonarqube
1. Enter to SonarQube and login as "admin / admin" user.
2. Go to Administrator --> Security --> Users ; and create a token ( which will be used with jenkins to integrate both services)

## Configure Jenkins
1. Enter to Jenkins service at port 8080 and configure properly.
- Enter that admin initial password ( the script) to the initial screen
```sh
sudo cat /var/lib/jenkins/secrets/initialAdminPassword
```
 - Install the predefined plugins
 - Change the admin user & password ( could be admin/admin)

2. Install the following Plugins at Jenkins Manage Plugins

| Plugin |
| ------ |
| Blue Ocean |
| Pipeline AWS Steps|
| NodeJS|
| Git Parameter |
| Sonarqube Scanner | 

 and restart Jenkins after installation
 
 ```sh
 $sudo systemctl restart jenkins
 $sudo systemctl status jenkins
 ```
 3. Configure the four(4) credentials that you will need for this project properly
 
| Credential | Credential type | description|
| ------ | ------ | ------ |
| github | Secret Text | it's your personal token created at github |
| aws-credentials | AWS Credentials | the credentials of the IAM user/Role that you are using to create also the EKS cluster and execute all configuration on this repo|
| dockerhub | Username/password | your docker hub account login and password |
| sonarqube| Secret Text | the token generated on Sonarqube server on the above section|
 
4. Configure Jenkins Global System 
 - here you need to add Sonarqube as "Server" at Sonarqube section as this picture

5. Configure Jenkins Global Tools Section
 - here you are going to add NodeJS Tool configuration ( cause our app is a JavaScript app that use Node.js')

- and Sonarqube tool used as Security Scanner , cause will be used as an Stage in our Jenkins Pipeline

6. If everything was configured  Ok, you can test it with a basic Jenkinsfile , located at "useful_files\Basic-Jenkins-Pipeline", build a test pipeline and executed it ( should be OK)
 
## EKS cluster creation using eksctl ( into a Jenkins Pipeline)
You can create your EKS cluster in many ways ( using CloudFormation templates, ansible, terraform, etc..),
bur in this project we are going to use "eksctl" ( which was previously installed in our "req.sh" script) inside a Jenkins Pipeline

Note: Check again that you already have an AWS S3 bucket  where the "cluster.yaml" file was uploaded previously ( you can copy this file from GitHub repo located at "eks\cluster.yaml")

1. Create a new Jenkins Pipeline and copy the lines located at "Jenkinsfile_eks" inside Pipeline box. & execute the Job.

- Jenkins is going to start the pipeline and build the EKS cluster using "eksctl"
- be patient , takes around 20 minutes
- Note : this cluster is created with a new VPC , 4 subnets ( 2 publics, 2 privates), and 4 nodes .
- [Architecture Overview] (https://github.com/weaveworks/eksctl/blob/master/docs/architecture_diagrams/EKS%20%26%20AWS%20architecture%20overview.svg)

 -Your EKS cluster was created OK!!!
 
## Jenkins Pipeline to deploy the app in a AWS EKS with Rolling Update Strategy

Our repo is a multibranch repo with the following branches:
- "master”:  the master branch
- "blue": the branch that contains the version v.1.0 of our app ( blue colors of our web pages)
- "green": the branch that contains the version v.2.0 of our app ( green colors of our web pages)
- "green-wrong": the branch that contains the version v.2.0 of our app ( green colors of our web pages) with an error on the source code ( to demonstrate the failure on the CI steps)

1. Goes to Blue Ocean page and create a New pipeline, linked to the repo and wait that branches are going to be indexed.

 - "master" branch is indexed and his pipeline will be executed. Should be OK ( so, an EKS deployment and service deployment , both located at "eks" directory were executed) --> So , your image must be in your Docker hub account , and already be deployed in AWS EKS cluster .
 - "blue" branch is indexed and his pipeline will be executed. Should be OK (this branch is only CI so its stages finish at CI)
 - "green" branch is indexed and his pipeline will be executed. Should be OK (this branch is only CI so its stages finish at CI )

Here you can check you app is running in AWS EKS ( the blue deployment , a.k.a , v.1.0) . Check your load balancer public DNS created by the  “service.yaml” configuration  
```sh
kubectl get service/my-app |  awk {'print $1" " $2 " " $4 " " $5'} | column -t
```
Open the app in your browser , since is a public IP. You should be something like this:
[App Blue V.1.0](https://static-jenkins-repo-project3.s3-us-west-2.amazonaws.com/Jenkins-Sonarqube+server+-+checking+the+app+-+blue+deployment+-+OK.jpg)

2. Performing the Rolling Update --> going to Green deployment a.k.a v.2.0
 
- On "green" branch create a Pull Request to "master" branch and approved to MERGE 
- After the "merge" is done in GitHub , goes to your  Jenkins Multibranch Pipeline Job (and in configuration perform a Scan Repository ( to index the branches again)
- Since the "MERGE" updated the "master" branch , its going to be indexed and Build # 2 is going to be executed, so after pass the CI stages, at the CD deploy at K8s, is going to perform a new deploy suing a Rolling Update strategy .

Where are the keys of this Rolling Update Strategy?

On the structure of the "deployment.yaml" file ( located at "eks\deployment.yaml")
Check it out the section "strategy" ( showing RollingUpdate: it's inside "spec" section) and section "readinessProbe"( inside 'containers')

- "Readiness Probe" makes sure that the new pods created are ready to take on requests before terminating the old pods.
- “RollingUpdate” specifies the strategy used to replace old Pods by new ones

```yaml
apiVersion: apps/v1
kind: Deployment
metadata:
  name: my-app
  labels:
    app: my-app
spec:
  replicas: 4
  strategy:
    type: RollingUpdate
    rollingUpdate:
      maxSurge: 1
      maxUnavailable: 25%
  selector:
    matchLabels:
      app: my-app
  template:
    metadata:
      labels:
        app: my-app
    spec:
      containers:
      - name: my-app
        image: javiercaparo/nodejs-image-demo:latest
        ports:
        - containerPort: 3000
        imagePullPolicy: Always
        readinessProbe:
            httpGet:
               path: /
               port: 3000
            initialDelaySeconds: 5
            periodSeconds: 5
            successThreshold: 1
```
- on this way "Rolling updates" allow Deployments update to take place with zero downtime by incrementally updating Pods instances with new ones. The new Pods will be scheduled on Nodes with available resources.

How the new deployment changes the "deployment.yaml" with the new deployment version???
- Here, we are using "sed" command to replace the "latest" word on the file , for the value of the BUILD.

```sh
stage('Deploy to K8s') {
			when {
                branch 'master'
            }
            steps {
				withAWS(credentials: 'aws-credentials', region: 'us-west-2') {
					sh "sed -i 's/latest/${env.BUILD_NUMBER}/g' ./eks/deployment.yaml" 
                    sh '''
                        grep image ./eks/deployment.yaml
                        kubectl apply -f ./eks/deployment.yaml
						sleep 2
                        kubectl get deployments
					'''
				}	
			}
		}

```

- if everything is working and you are checking your pods, you will see something like this:
 [Pods terminating and news ones running] (https://static-jenkins-repo-project3.s3-us-west-2.amazonaws.com/EKS+cluster+-++rolling+update+-+pods+running+green+version+-+part2.jpg)

- Check your app . It's running the "green" deployment , a.k.a, V.2.0
[app running v.2.0](https://static-jenkins-repo-project3.s3-us-west-2.amazonaws.com/Jenkins-Sonarqube+server+-+checking+the+app+-+green+deployment+-+OK.jpg)

## EKS cluster deletion using eksctl ( inside a Jenkins Pipeline)
1. Create a new Pipeline Job ( new item) to delete the EKS cluster , and inside pipeline add the below lines ( our file named "Jenkinsfile_eks_delete" )

2. Build the pipeline and wait. You EKS cluster will be deleted 

## Ubuntu - SonarQube Server deletion.
1. Just delete the CloudFormation Stack that you used to create the server. 


On this way, all you resources will be deleted properly. 
then you can check at EC2 instances, EC2 VPC, CloudFormation stacks, EKS service.


### Things to add later

 - You can add "github" webhooks with Jenkins , so the "pull request" of the branch and "merge" are automated . On this demo we did it step by step for practical reasons and capture the screenshots.
 -
License
----

MIT


**Free Software, Hell Yeah!**

