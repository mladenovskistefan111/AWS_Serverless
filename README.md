### Docker Image Build and CI Pipeline

## Docker Image
I dockerized the application using a Dockerfile that builds the .NET application. The build process involves restoring dependencies, publishing the application, and creating a final image based on the ASP.NET runtime.

## CI Pipeline
The CI pipeline automates the process of linting, building, and pushing the Docker image. It runs linting checks to ensure code quality, builds the Docker image upon version tag pushes, and pushes the image to both Docker Hub and Amazon ECR. This ensures that the application is continuously integrated efficiently.

### Deployment of Helm Chart

The deployment of the Helm chart for the .NET Todo application is automated through a CI pipeline. The pipeline performs the following steps:

1. **Checkout Code**: It pulls the latest code from the repository.
2. **Set Up Minikube**: It initializes a local Kubernetes cluster using Minikube.
3. **Install Helm**: It installs Helm to manage Kubernetes applications.
4. **Create Namespace**: It creates a dedicated namespace for the application in the cluster.
5. **Deploy Application**: It deploys the .NET application using the Helm chart.
6. **Check Status**: It verifies the status of the deployment, service, and pods.
7. **Port Forwarding**: It sets up port forwarding to access the application locally.
8. **Post Sample Data**: It sends sample todo items to the application.
9. **Fetch Data**: It retrieves the posted todo items for verification.

This process ensures that the application is easily deployed and accessible for testing.

### AWS Lambda Deployment

I created an infrastructure-as-code solution using Terraform to host the built application on AWS Lambda, running inside a VPC. The solution is designed to expose the application to the internet through an API Gateway, allowing external access.

While I understand the concepts of AWS Lambda and serverless architecture, I lack hands-on experience with them. Despite developing the Terraform code for deployment, I have not yet succeeded in making the application fully operational on Lambda. I will continue to research and experiment with AWS Lambda to find a solution.
