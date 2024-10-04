vpc_cidr = "10.10.0.0/20"
vpc_name = "dotnet-todo-vpc"
private_subnets = {
  subnet_a = {
    cidr_block        = "10.10.1.0/24"
    availability_zone = "us-east-1a"
    name              = "private_subnet_a"
  }
}
image_uri = "730335231740.dkr.ecr.us-east-1.amazonaws.com/dotnet-todo-repo:v1.0.5"