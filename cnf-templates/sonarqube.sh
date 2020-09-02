sudo apt update
sudo apt install -y nginx

sudo apt install mysql-server

sudo mysql_secure_installation
  ansyer Y
   then 1   ( password: ChangeMe01)
     then all 'Y"

sudo mysql
SELECT user,authentication_string,plugin,host FROM mysql.user;
ALTER USER 'root'@'localhost' IDENTIFIED WITH mysql_native_password BY 'Hypersonic#20';

FLUSH PRIVILEGES;
SELECT user,authentication_string,plugin,host FROM mysql.user;

quit
----
Note: After configuring your root MySQL user to authenticate with a password, you’ll no longer be able to access MySQL with the sudo mysql command used previously. Instead, you must run the following:

mysql -u root -p
After entering the password you just set, you will see the MySQL prompt.

At this point, your database system is now set up and you can move on to installing PHP.
=---

php part
=========
sudo apt install php-fpm php-mysql

