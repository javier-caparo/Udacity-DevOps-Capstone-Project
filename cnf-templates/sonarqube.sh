Follow this tutorial:
https://techexpert.tips/sonarqube/sonarqube-installation-on-the-cloud-aws-ec2/
  # go directly to part: Tutorial - Sonarqube Installation on Ubuntu Linux

Basically:
apt-get update
apt-get install -y software-properties-common 
apt-get install postgresql postgresql-contrib
sudo passwd postgres       # change the password to postgress ( example:Hypersonic#20)
su - postgres
psql
# here you are in postgres db
CREATE USER sonarqube WITH PASSWORD 'kamisama123';
CREATE DATABASE sonarqube OWNER sonarqube;
GRANT ALL PRIVILEGES ON DATABASE sonarqube TO sonarqube;
\q
# here you retrun to postgres user
$ exit
# here you're ubuntu user again

mkdir /downloads/sonarqube -p
cd /downloads/sonarqube
wget https://binaries.sonarsource.com/Distribution/sonarqube/sonarqube-7.9.1.zip
unzip sonarqube-7.9.1.zip
mv sonarqube-7.9.1 /opt/sonarqube

postgreslq10  user password: Hypersonic#20


- On Sonarqube :
  Administrator --> Security --> Users 
      create a token for admin ( will be used on jenkins)



Create the admin token: (Administration --> Security -->Users)
#sonarqube  token ( admin)
sonarqube-jenkins
cf1f3e7afdadeb094703f78524d539f6ed3762e9


- Install the sonarqube scanner
wget https://binaries.sonarsource.com/Distribution/sonar-scanner-cli/sonar-scanner-cli-4.4.0.2170-linux.zip
unzip sonar-scanner-cli-4.4.0.2170-linux
sudo mv sonar-scanner-4.4.0.2170-linux/ /opt/sonarqube/


Then to configure with Jenkins check this tutorial:
https://aspiresoftware.in/blog/intergrating-sonarqube-and-jenkins/

basically
- On jenkins:
   --> In credentials , add the token generated in Sonarqube as Secret Key


install the SonarQube plugin
    Configure Sonarqube in Configure System
    Configure Sonarqube in Global tool configuration
      --> use the path where you installed the sonar scanner : /opt/sonarqube/sonar-scanner-4.4.0.2170-linux/

In your pipeline , remember :
"sonarqube-scanner"  --> name of the tool that you use in Global tool
"SonarQube" --> name of sonarqube server that was defined on Global System

---------------declarative example ---
stage('Sonarqube') {
            environment {
                scannerHome = tool 'sonarqube-scanner'
            }
            steps {
                withSonarQubeEnv('SonarQube') {
                    sh "${scannerHome}/bin/sonar-scanner"
                }
                timeout(time: 10, unit: 'MINUTES') {
                    waitForQualityGate abortPipeline: true
                }
            }
        }
