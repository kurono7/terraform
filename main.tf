terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }
}

provider "aws" {
  region                      = "us-east-1"
  access_key                  = "test" 
  secret_key                  = "test"
  skip_credentials_validation = true
  skip_metadata_api_check     = true
  skip_requesting_account_id  = true
  s3_use_path_style           = true # Forzar el uso de URLs basadas en path para S3 en LocalStack

  endpoints {
    s3  = "http://localhost:4566"
    ec2 = "http://localhost:4566"
    iam = "http://localhost:4566"
  }
}

resource "aws_vpc" "red" {
  cidr_block = "10.0.0.0/16"
  tags = { Name = "VPC-${var.alumno}" }
}

resource "aws_subnet" "subred" {
  vpc_id     = aws_vpc.red.id
  cidr_block = "10.0.1.0/24"
  tags = { Name = "Subred-${var.alumno}" }
}

resource "aws_security_group" "firewall_web" {
  name        = "seguridad-web-${var.alumno}"
  description = "Permitir trafico HTTP y SSH"
  vpc_id      = aws_vpc.red.id

  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "SG-${var.alumno}"
  }
}

resource "aws_instance" "servidor_principal" {
  ami           = "ami-0c55b159cbfafe1f0"
  instance_type = "t2.micro"
  subnet_id     = aws_subnet.subred.id
  vpc_security_group_ids = [aws_security_group.firewall_web.id]
  tags = { Name = "Servidor-Principal-${var.alumno}" }
}

resource "aws_instance" "servidor_respaldo" {
  count = var.crear_servidor_respaldo ? 1 : 0

  ami           = "ami-0c55b159cbfafe1f0"
  instance_type = "t2.micro"
  subnet_id     = aws_subnet.subred.id
  vpc_security_group_ids = [aws_security_group.firewall_web.id]
  tags = { Name = "Servidor-Respaldo-${var.alumno}" }
}

resource "aws_s3_bucket" "almacenamiento" {
  for_each = var.nombres_buckets 

  bucket = "${lower(var.alumno)}-${each.key}-taller-bucket"

  tags = {
    Name = "Bucket de ${each.key}"
  }
}
