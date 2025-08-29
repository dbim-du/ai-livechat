<strong>Language: </strong>[English](README.md) | [简体中文](README_zh.md) 
# DBIM-AI Intelligent Customer Service System (LiveChat + Dify)
## 🌟 System Overview

DBIM-AI Intelligent Customer Service combines the real-time communication capabilities of LiveChat with Dify's AI processing engine to create an intelligent and efficient customer service solution. The system automatically understands customer questions, handles common inquiries, and reduces customer service workload, ensuring customers receive immediate and accurate responses. It also seamlessly transfers calls to live agents when necessary.

## 🧩 Commercial/Free Version

The free version can be upgraded to the commercial version using built-in points. The commercial version has no functional restrictions, and the background can set the points consumption and version description required for the custom upgrade.

<img src="README.assets/image-20250829151623921.png" alt="image-20250829151623921" style="zoom: 50%; float: left;" />

![image-20250829155256806](README.assets/image-20250829155256806.png)

### 💬 Omnichannel Support Desk

DBIM-AI Intelligent Customer Service centralizes all customer conversations into a powerful Bot Server service, supporting user-defined attributes such as customer service name, avatar, and search and reply keywords. It supports real-time chat via customer service chat dialogs, custom chat dialogs, and API service calls on your website, mobile WAP, and mobile app.

### 📚 Access Center Guide

The access guide document provided by the system guides users to easily access DBIM-AI intelligent customer service in different usage scenarios, allowing customer service staff to obtain consulting and assistance services from intelligent customer service more conveniently in different usage scenarios.

## 📋 Core functions and technical architecture

| Functional modules                           | Functional Description                                       | Dependent components    |
| -------------------------------------------- | ------------------------------------------------------------ | ----------------------- |
| Real-time chat interaction                   | Supports text, image, and file transfer. Customers can initiate consultations through the webpage/API without downloading the APP. | Live Chat               |
| AI intelligent response                      | Automatically answer frequently asked questions based on enterprise knowledge base + online search, supporting multiple rounds of dialogue | Dify + Knowledge Base   |
| Seamless transfer to manual customer service | When AI customer service cannot provide accurate answers, users can choose to transfer to human customer service, who will provide better service and accurate answers. | LiveChat + Dify         |
| Customer intent identification               | Automatically identify customer inquiry intent (such as "product details", "instructions for use", etc.), and AI customer service automatically searches the knowledge base + online search + LLM organizes the answer words | Bachelor's degree + LLM |
| Multi-channel unified management             | Integrate consultations from web pages, APPs, WAP and other channels, and process them uniformly in the LiveChat backend | Live Chat               |
| Data analysis and reporting                  | Output data reports such as consultation volume, AI resolution rate, and customer satisfaction, supporting weekly/monthly export | Dify Data Analysis      |

## 🛠 Installation and Deployment

Prerequisites:

1. Docker container
2. PostgreSQL database
3. MySQL database
4. Fortress (easy to manage, deploy and install)
5. PHP-7.2.33 and PHP extensions: 1. pgsql, 2. pdo_pgsql

Deployment steps:

1. Install PostgreSQL and uuid-ossp components

		# 1. Install psql
		# Update the installation package list
		sudo apt update
		
		# Install PostgreSQL and add-on libraries (including uuid-ossp)
		sudo apt install postgresql postgresql-contrib postgresql-client
		
		# Check the service status
		sudo systemctl status postgresql
		
		# View postgresql version
		sudo -u postgres psql -c "SELECT version();"
		
		# List all available extensions
		sudo -u postgres psql -c "SELECT * FROM pg_available_extensions WHERE name='uuid-ossp';"
		
		# 2. Start and check the service status
		# Start Service
		sudo systemctl start postgresql
		
		# Set up startup
		sudo systemctl enable postgresql
		
		# Check Status
		sudo systemctl status postgresql
		
		# 3. Install uuid-ossp extension:
		# Switch to postgres users
		sudo -i -u postgres
		
		# Enter the PostgreSQL interactive Terminal
		psql
		
		# 4. Test the invocation of the uuid-ossp extension component
		# Create Extensions
		CREATE EXTENSION IF NOT EXISTS "uuid-ossp";
		
		# Verify installation and test to generate UUID
		SELECT uuid_generate_v4();
		
		# 5. How to Set the initial Password for PostgreSQL
		# Change the postgres user password
		ALTER USER postgres WITH PASSWORD 'Your password ';
		
		Then edit the configuration file /etc/postgresql/[pgsql version number]/main/pg_hba.conf and change the authentication method to md5
		# Change the "peer" of the local row to md5
		local  all  postgres    md5
		
		# 6. Enable PostgreSQL remote connection
		# Open /etc/postgresql/[pgsql version number]/main/postgresql.conf
		# Set listen_addresses to 'localhost'
		# Modify to
		# listen_addresses = '*' # allows all IP connections or specified IP connections
		
		# 7. Modify the client authentication configuration
		# Open /etc/postgresql/[pgsql version number]/main/pg_hba.conf
		# Add at the end of the file:
		host all all 0.0.0.0/0 md5
		
		# 8. The restart service takes effect
		sudo systemctl restart postgresql
	

​	2、Install Dify

	# Enter the Docker directory of the Dify source code
	cd dify/docker
		
	# Assign the environment configuration file
	cp .env.example .env
		
	# Start the Docker container
		# If the version is Docker Compose V2, use the following command:
		sudo docker compose up -d
		
		# If the version is docker Compose V1, use the following command:
		sudo docker-compose up -d
		
		After running the command, you will see an output similar to the following, showing the status and port mapping of all containers:
		✔ Network docker_ssrf_proxy_network Created 0.0s
		✔ Container dbim_dify_plugin_daemon Started 0.5s
		✔ Container dbim_dify_web Started 0.4s
		✔ Container dbim_dify_ssrf_proxy Started 0.4s
		⠼ Container dbim_dify_redis Starting 0.5s
		✔ Container dbim_dify_weaviate Started 0.4s
		✔ Container dbim_dify_sandbox Started 0.4s
		✔ Container dbim_dify_worker Created 0.0s
		✔ Container dbim_dify_API Created 0.0s
		✔ Container dbim_dify_nginx Created 0.0s


​		
​	# Finally, check if all containers are operating normally:
​	docker compose ps


​	3、Visit dify

```
	# You can first go to the Management Initialization Settings page to set up an administrator account:
	This administrator account has all the highest privileges and functions of the dify system
	
	# Local environment access address:
	http://localhost/install
	
	# Server environment access address:
	http://your_server_ip/install
	
```

​	4、Docker image pull failed:

```
# Due to network issues, the probability of unsuccessful image pulling from docker is relatively high. Therefore, no further explanation will be provided here. Directly configure the following image sources in the system, and the probability of successful image pulling is relatively high. The image sources are as follows:

"https://docker.1ms.run",
"https://hub.rat.dev",
"https://docker.1panel.live",
"https://hub.rat.dev",
"https://proxy.1panel.live",
"https://ghcr.nju.edu.cn",
"https://docker.registry.cyou",
"https://dockercf.jsdelivr.fyi",
"https://docker.rainbond.cc",
"https://registry.cn-shenzhen.aliyuncs.com",
"https://dockertest.jsdelivr.fyi",
"https://mirror.aliyuncs.com",
"https://mirror.baidubce.com",
"https://docker.mirrors.ustc.edu.cn",
"https://docker.mirrors.sjtug.sjtu.edu.cn",
"https://mirror.iscas.ac.cn",
"https://docker.nju.edu.cn",
"https://docker.m.daocloud.io",
"https://dockerproxy.com",
"https://docker.jsdelivr.fyi",
"https://docker-cf.registry.cyou"
```

​	5、Common system configuration commands

```
# Common System Configuration Commands:

# Overload Configuration
sudo systemctl daemon-reload

# Restart Service
sudo systemctl restart docker

# Remove old docker configurations (Remove all docker images)
docker-compose down

# Start all dify configuration images
docker-compose up -d

# Stop but not delete
docker-compose stop <service_name>

# Delete stopped containers
docker-compose rm <service_name>

# Rebuild the web project
docker-compose build web

```

​	6、Install php-7.2.33 and related extensions

```
# Note to install the PHP-7.2.33 extension and delete other versions of php; otherwise, the pgsql driver will report that the driver cannot be found:
# Extension -1: pgsql (postgresql database installation Required in advance)
# Extension -2: pdo-pgsql (postgresql Installation Required in advance)
```

​	7、File deployment

```
# After the Dify deployment is completed, the livechat project will include:
# dbim.livechat\application\seller\view\index\difylogin.html
# The name of the docker container copied to the file is: dbim_dify_web
# Directory: Under the app\web\public directory
# After completing the above operations, you need to restart the dbim_dify_web container. Only after the restart can the file be loaded and take effect
```

​	8、Firewall settings

```
# Configure the Bota firewall to open port 5432 or the port currently used by the Bota pgsql database
```

​	9、LiveChat project construction

```
# Upload the source code to /www/wwwroot
# It is recommended that you use the command:
chow -R www:www ./AiService
# -- Set the file's ownership and group to WWW to avoid permission issues.

# Add Website
# In the Bota website directory - PHP Project - Add php Site, create livechat as a php site

```

<img src="README.assets/image-20250829135458454.png" alt="image-20250829135458454" style="zoom: 67%;float:left;" />

<img src="README.assets/image-20250829140214698.png" alt="image-20250829140214698" style="zoom:80%;float:left;" />

<img src="README.assets/image-20250829140358633.png" alt="image-20250829140358633" style="zoom:80%;float:left;" />

​	10、Database Configuration

<img src="README.assets/image-20250829144731622.png" alt="image-20250829144731622" style="zoom:80%;float:left;" />

​	11、Database configuration file address: /config/const/const_dev.php

<img src="README.assets/image-20250829145128350.png" alt="image-20250829145128350" style="zoom:80%;float:left;" />

​	12、Start gatewayworker

```
# Start gatewayworker
php start.php start

# These are other commands in debug mode:
# debug Execution
php start.php start

# Daemon execution
php start.php start -d

# Restart the daemon process execution
php start.php retart -d

# Stop Execution
php start.php stop
```

​	13、LiveChat Project Configuration

```
# After configuration is completed, the site entry
# Official website: http://yourservice_IP: port /
# DBIM AI Intelligent Customer Service System (Merchant end) :http://yourservice_IP: port /seller/login/index.html
# Customer service system management backend: http://yourservice_IP: port /admin/login/index.html
# DBIM AI Intelligent Customer service Workbench: http://yourservice_IP: port /service/login/index
```

​	14、System Configuration

<img src="README.assets/image-20250829152418565.png" alt="image-20250829152418565" style="zoom:80%;" />

<img src="README.assets/image-20250829152536709.png" alt="image-20250829152536709" style="zoom:80%;float:left;" />



















