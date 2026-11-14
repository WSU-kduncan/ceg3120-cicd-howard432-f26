# **Project 6: Continuous Integration (CI)**

## **1. Project Overview**

This project walks you through a setup of an automated Continuous Integration (CI) Pipeline. It demonstrates how we can automate repetitive tasks to keep the delivery of software updates consistent by using Docker, DockerHub, and GitHub Actions.

### **Objectives:**

- Create a two page website that uses both HTML and CSS (Pulled from Project 5)
- Use Docker to containerize the website.
- Build and test a Docker image on local system.
- Publish the Docker image to DockerHub. 
- Set up GitHub Actions that will automate builds and publishing.
- Use GitHub repo secrets that will store the DockerHub credentials.
- Verify workflow triggers work as intended.

## **2. Tools Used**

| Tool | Role |
| ----------- | ----------- |
| CSS | Website style |
| HTML | Website build |
| Docker | Website containerization |
| Docker Desktop | Run the Docker container locally |
| DockerHub | Host Docker images |
| Git/GitHub | Manage source code |
| GitHub Actions | Automate CI workflow |
| Ubuntu/WSL | Terminal for development |
| VSCode | Text/Markdown Editing |

### **CI Pipeline Diagram:**

![CI Diagram](Project6-CI/images/diagram.drawio.png)

## **3. Docker Configuration**

We will use Docker to contaninerize the website and the Apache HTTP Server Image. This basically just means that we will package all of the code for the website together (with all that it needs to to run) into a single, portable package.

### **Dockerfile:**

Create and save the Dockerfile in `Project6-CI/Dockerfile. (I copied this over from Project 5)

View Dockerfile: [Dockerfile](https://github.com/WSU-kduncan/ceg3120-cicd-howard432-f26/blob/main/Project6-CI/Dockerfile)

```
FROM httpd:2.4 
COPY web-content/ /usr/local/apache2/htdocs/
```
What it means:
*FROM httpd:2.4* - This uses the Apache HTTP Server image as the base.
*COPY web-content/ /usr/local/apache2/htdocs/* - This copies the websites files into the Apache web directory that is inside of the container.

### **Time to Build the Docker Image:**

`docker build -t mandyhoward21/howard-cicd-f26:latest .`

![Docker Build](Project6-CI/images/docker-build.png)

Check to make sure the download to the local system was successful by using: `docker images`

### **Run the container on the local system:**

`docker run -d -p 8080:80 --name howard-cicd-test mandyhoward21/howard-cicd-f26:latest`

This makes the website able to be accessed in a browser.

### **Check to make sure the container is running where it should be:**

`docker ps`

![Docker Run/PS](Project6-CI/images/docker-images-run-ps.png)

This confirms that it is running on port 8080 on the local system to the port 80, which is inside of the container.

I used Google Chrome to confirm by using the following web addresses:

http://localhost:8080/

![Website Home](Project6-CI/images/website-home-localhost.png)

http://localhost:8080/contact.html

![Website Contact](Project6-CI/images/website-contact-localhost.png)

## **4. Publish the Docker Image to DockerHub**

This is done so the image can be accessed remotely, instead of just locally.

Public DockerHub repo: mandyhoward21/howard.cicd-f26

[DockerHub Repo](https://hub.docker.com/r/mandyhoward21/howard-cicd-f26/tags)


First, you will authenticate DockerHub using a Personal Access Token (PAT). From the command line, enter: 

`docker login`

Enter your DockerHub username and PAT when prompted.

*How to find your DockerHub username:* Open DockerDesktop, sign in, click on the profile icon at the top right (Mine shows as a "M")

![DockerDesktop-username](Project6-CI/images/dockerdesktop-un.png)

*How to create a PAT:* 
- While you have your profile icon selected, click "Account Settings". 
- Navigate to "Personal access tokens". (It is located on the left sidebar.)
- Generate the token by clicking "Generate new token" at the top right.
- Enter a description that will let you know what this particular token is used for, set your expiration date and access permissions. I set mine to 90 days expiration and "Repo Read, Write, Delete". I selected Allow Cloud Sandbox Access and clicked Generate.

### **Push the Image**

`docker push mandyhoward21/howard-cicd-f26:latest`

![Docker Push](Project6-CI/images/docker-push.png)

### **Pull and Test Pushed Image**

To make sure the image can be retrieved from DockerHub.

`docker pull mandyhoward21/howard-cicd-f26:latest`

![Docker Pull](Project6-CI/images/docker-pull.png)

Test by running the downloaded image in a separate container.

`docker run -d -p 8080:80 --name howard-cicd-remote-test mandyhoward21/howard-cicd-f26:latest`

## **5. GitHub Actions for Automated CI Workflow**

Use GitHub actions to automate the Docker Image Build and Push Process so it can be done automatically whenever changes are pushed to the main branch.

![Workflow](Project6-CI/images/create-workflows-dir-with-yml-file.png)

### **Workflow File**

View Workflow File: [Workflow File](https://github.com/WSU-kduncan/ceg3120-cicd-howard432-f26/blob/main/.github/workflows/docker-publish.yml)

### **Workflow Trigger**

A workflow trigger is simply an action that starts the automated process. This particular workflow is triggeredy by a push to the main branch (only).

```
on:  [[Defines what event starts the workflow]]
  push: [[Event=Git push]]
    branches: [[Which branch to watch]]
      - main [[Only pushes to main branch trigger it]]
```

### **Repo Secrets**

Two different GitHub repo secrets were created for this project so we could securely authenticate with DockerHub. These were created in DockerHub under Settings -> Secrets and Variables -> Actions

Secrets created:

| Secret | Role |
| ----------- | ----------- |
| DOCKER_USERNAME | Used to store the username |
| DOCKER_TOKEN | Used to store the PAT |

![Secrets](Project6-CI/images/repo-secrets.png)

*Note:* The actual username and PAT values are hidden/not stored in the public repo for others to see.

### **Workflow Steps**

1. Gets the files from GitHub.
2. Sets up the Docker build environment.
3. Logs in to DockerHub by authenticating with the repo secrets.
4. Builds the Docker image and pushes it to DockerHub with the `latest` tag.

### **Workflow Image Config**

This is what tells the GitHub Actions where to find the Dockerfile, to push the image and the tag that it should use.

```
context: ./Project6-CI
push: true
tags: mandyhoward21/howard-cicd-f26:latest
```
![Secret Test: Success](Project6-CI/images/gh-secret-success.png)

### **Test on Non-Main Branch**

Test to make sure the workflow action does not run when on a different branch than main.

![Git Test for Non-Main](Project6-CI/images/git-test-non-main-trigger.png)

![Non-Main Trigger](Project6-CI/images/test-non-main-trigger.png)

![Action did not run](Project6-CI/images/proof-action-did-not-run.png)




















