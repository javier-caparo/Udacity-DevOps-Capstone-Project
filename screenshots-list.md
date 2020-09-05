  **Index of Screenshots & description**                                                                        
  ------------------------------------------------------------------------------------------------------------- ----------------------------------------------------------------------------------------------------------------------------
                                                                                                                
  **Step02:Use Jenkins, and implement blue/green or rolling deployment**
  | Screenshot | Brief description|
  | ------ | ------ |
  |Step2-00-dockerhub account started empty | dockerhub used for Prod ( master branch) |
  |Step2-01-ECR repo - started empty | AWS ECR repo used for Dev branches ( blue , green) |
  |Step2-02-Jenkins-Sonarqube server creation | using cloudformation template to create the Jenkins server|
  |Step2-03-Jenkins-Sonarqube server creation in progress | creation template in progress |
  |Step2-04-Jenkins-Sonarqube server created | stack finished ( Ubuntu Jenkins Somarqube server is ready to be configured) |
  |Step2-04-1-Jenkins-Sonarqube server created -ec2 instance view | EC2 instance view of the server |
  |Step2-05-Jenkins-Sonarqube server - package installation |  Jenkins requisites being installed with an script |
  |Step2-06-Jenkins-Sonarqube server - jenkins installed | Jenkins installed ( aws, eksctl, kubectl, docker) |
  |Step2-07-Jenkins-Sonarqube server -sonarqube installation in progress | Sonarqube installtion in progress |
  |Step2-08-Jenkins-Sonarqube server -sonarqube installed and started | Sonarquebe installed and running |
  |Step2-09-Jenkins-Sonarqube server - aws cli configure | aws cli configuration |
  |Step2-10-Jenkins-Sonarqube server - jenkins configuration -part1 | Jenkins initial admin password |
  |Step2-11-Jenkins-Sonarqube server - jenkins configuration -part2 | Jenkins getting started - initial plugins |
  |Step2-12-Jenkins-Sonarqube server - sonarqube admin token generation | Sonarqube admin token configutation ( to be used with jenkins plugin) |
  |Step2-13-Jenkins-Sonarqube server - project page initial | Sonarqube initial project pages - empty |
  |Step2-14-Jenkins-Sonarqube server - jenkins configuration - plugins | Jenkins needed plugins installtion ( Blue Oceam Pipeline AWS Steps, NodeJs, Git Paramter, Sonarqube Scanner) |
  |Step2-15-Jenkins-Sonarqube server - jenkins configuration - credentials | Jenkins Credentials configuration (github personal token, aws credentials, dockerhub, sonarqube secret |
                                                                                                                 
  **Step 3: Pick AWS Kubernetes as a Service, or build your own Kubernetes cluster.**
  | Screenshot | Brief description|
  | ------ | ------ |
  |Step3-00-EKS cluster creation - using jenkins pipeline | jenkins pipeline |created to build the EKS cluster |
  |Step3-01-EKS cluster creation - jenkins pipeline builded -executed -ok | jenkins pipeline finished OK - EKS Cluster created |
  |Step3-02-EKS cluster creation - finished OK  jenkins pipeline finished OK - checking results of K8s cluster creation |
  |Step3-03-EKS cluster nodes - running | EKS cluster nodes running as EC2 instances. |
  |Step3-04-EKS cluster - EKS details | EKS cluster details info |
  |Step3-05-EKS cluster - EKS networking | EKS cluster networking info |
                                                                                                                 
  **Step 4: Build your pipeline**
  | Screenshot | Brief description|
  | ------ | ------ |
  |Step4-00-github-repo-with-4 branches | github repo multibranch ( master, blue, green, green-bad) |
  |Step4-01-Jenkins Multibranch pipeline - creation | Jenkins Blue Ocean Multibranch Pipeline creation |
  |Step4-02-Jenkins Multibranch pipeline - first branch indexing in progress | Branches indexing to be executed on the Pipeline |
  |Step4-03-Jenkins Multibranch pipeline - first branch indexing finished - ok | Banches executed ( 3 are OK, 1 is NOK ) |
  |Step4-04-Jenkins Multibranch pipeline - blue branch finished - ok |  branch \"blue\" is OK ( dev branch \--\> blue version a.k.a v.1.0) , same as master initially |
  |Step4-05-Jenkins Multibranch pipeline - green branch finished - ok - before merge to goes to prod  | branch \"gree\" is OK ( dev branch \--\> green version a.k.a V.2.0), is going to be merged later |
  |Step4-06-Jenkins Multibranch pipeline - green-bad branch finished NOK - as expected - error in lint | branch \"green-bad\" is NOK as expected ( has an error in src code) |
  |Step4-07-Jenkins Multibranch pipeline - green-bad branch finished NOK - as expected - error in lint - part2 | branch \"green-bad\" is NOK as expected ( has an error in src code) - Lint Stage not passed!! |
  |Step4-08-Jenkins Multibranch pipeline - master branch deployed - waiting user input to validate | branch \"master\" is OK - waiting user input to validate |
  |Step4-09-Jenkins Multibranch pipeline - master branch deployed - info deployed -service | branch \"master\" - stage \"info\" to check which is the EKS service ( load blancer public DNS) |
  |Step4-10-EKS cluster - Load balancer created when service was deployed | Checking at EKS cluster that service is deployed ( load balancer public DNS) |
  |Step4-11-App running - blue version aka v.1.0 -index.html | Checking the APP in browser ( blue version) - index.html |
  |Step4-12-App running - blue version aka v.1.0 -shark.html | Checking the APP in browser ( blue version) - sharks.html |
  |Step4-13-ECR Repo - blue and green repos created | Checking ECR repo ( \"blue\" and \"green\" branches deployed at ECR) |
  |Step4-14-dockerhub - 1st repo created - blue version | Checking Dockerhub - \"master\" branch deployed here the prod image ( Build \# 1) |
  |Step4-15-Sonarqube - results - blue version - OK | Checking results in Sonarqube of ( sonar scanner of our src code) |
  |Step4-16-github - green branch opened a pull request - ready to merge | Opening the pull request from \"green\" branch - ready to be deployed in GitHub |
  |Step4-16-github - green branch pull request merged to master - OK |  \"green\" branch pull requets merged in github |Step4-17-Jenkins Multibranch pipeline - master branch scan log after merge | Jenkins Scan Log the Multibanch Pipeline - detected that \"master\" branch was updated!!! |
  |Step4-18-EKS cluster - rolling update in progress deploying green version  | EKS cluster is performing the rolling update of this build \# 2 of the msatre branch |
  |Step4-19-Jenkins Multibranch pipeline - master branch - build 2 - executed OK - green version deployed | \"master\" branch Build \# 2 pipeline was executed OK - waiting user input to check it out |
  |Step4-20-dockerhub - 2nd repo created - green version | Checking Dockerhub - \"master\" branch deployed here the prod image ( Build \# 2) |
  |Step4-21-Jenkins Multibranch pipeline - master branch - build 2 - finsihed OK -after revision | \"master\" branch Build \# 2 pipeline was finsihed OK |
  |Step4-22-Jenkins Multibranch pipeline - final pipelines view | Multibranch Pipelines final view|
  |Step4-23-App running - green version aka v.2.0 -index.html page | Checking the APP in browser ( green version) - index.html |
  |Step4-24-App running - green version aka v.2.0 -shark.html page | Checking the APP in browser ( green version) - sharks.html |
  |Step4-25-Sonarqube - green version results | Checking results in Sonarqube of ( sonar scanner of our src code) |
  |Step4-26-EKS cluster delete - using jenkins pipeline | Creating the Pipeline to perofrm the EKS cluster deletion |
  |Step4-26-github - green bad repo - fixing his bad code | \"green bad\" branch fixing his src code before to being build again in Jenkins |
  |Step4-26-Jenkins- Multibranch pipeline - green bad repo - fixed itscode - pipeline is Ok now | \"green bad\" branch fixed its src code , a scan log performed again , and this time \"green bad\" build \# 2 is passed OK |
  |Step4-27-EKS cluster delete - using jenkins pipeline |  Pipeline to delete the cluster was already executed!!! - in progress - ( take some time) |
  |Step4-28-EKS cluster delete - in progress -cloudformation view | Checking the cloudformation stacks created by eksctl command are being deleted!!! |
  |Step4-29-EKS cluster delete - in progress -ec2 instances view | Checking the cloudformation ec2 inodes created by eksctl command are being deleted!!! |
  |Step4-30-Jenkins-Sonarqube server -deletion from cloudformation stack | Cloudformation delete stack executed to delete pour Ubuntu Jenkins Sonarqube Server.|
