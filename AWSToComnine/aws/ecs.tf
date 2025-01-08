data "aws_ami" "optimized_ami_ecs" {
  most_recent = true
  owners      = ["amazon"]

  filter {
    name   = "name"
    values = ["amzn2-ami-ecs-hvm-2.0.202*-x86_64-ebs"]
  }
}


resource "aws_launch_configuration" "launch_config_ecs" {
  image_id             = data.aws_ami.optimized_ami_ecs.id
  iam_instance_profile = aws_iam_instance_profile.iam_profile_ec2_1.name
  security_groups      = [aws_security_group.app1.id]
#   user_data            = data.template_file.user_data.rendered
  instance_type        = "t2.micro"
}
resource "aws_autoscaling_group" "autoscaling_group_ecs" {
  name                 = "ECS-lab-asg"
  vpc_zone_identifier  = [aws_subnet.app1.id]
  launch_configuration = aws_launch_configuration.launch_config_ecs.name
  desired_capacity     = 1
  min_size             = 0
  max_size             = 1
}

resource "aws_ecs_cluster" "cluster" {
  name = "${var.prefix}_ecs_cluster"
}



resource "aws_ecs_task_definition" "task" {
  family                   = "nginx"
  container_definitions    = <<DEFINITION
[
  {
    "name": "nginx",
    "image": "nginx",
    "cpu": 10,
    "memory": 512,
    "essential": true,
    "portMappings": [
      {
        "containerPort": 80,
        "hostPort": 80
      }
    ]
  }
]
DEFINITION
  requires_compatibilities = ["FARGATE"]
  network_mode             = "awsvpc"
  cpu                      = "256"
  memory                   = "512"
}


resource "aws_ecs_service" "service" {
  name            = "nginx"
  cluster         = aws_ecs_cluster.cluster.id
  task_definition = aws_ecs_task_definition.task.arn
  desired_count   = 3
  launch_type     = "FARGATE"

  network_configuration {
    subnets          = [aws_subnet.app1.id]
    security_groups  = [aws_security_group.app1.id]
    assign_public_ip = true
  }
}

