resource "aws_security_group" "rds" {
  vpc_id = var.vpc_id
  name   = "rds-sg"
  ingress {
    from_port       = 5432
    to_port         = 5432
    protocol        = "tcp"
    security_groups = [var.ecs_sg_id]
  }
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

resource "aws_db_subnet_group" "main" {
  name       = "wiki-db-subnet-group"
  subnet_ids = var.private_subnets
}

resource "aws_db_instance" "wiki" {
  identifier             = "wiki-db"
  engine                 = "postgres"
  engine_version         = "15.4"
  instance_class         = "db.t4g.micro"
  allocated_storage      = 20
  storage_encrypted      = true
  username               = var.db_username
  password               = random_password.db.result
  db_subnet_group_name   = aws_db_subnet_group.main.name
  vpc_security_group_ids = [aws_security_group.rds.id]
  multi_az               = true
  skip_final_snapshot    = true
  publicly_accessible    = false
}

resource "random_password" "db" {
  length  = 16
  special = false
}

resource "aws_secretsmanager_secret" "db_password" {
  name = "wiki-db-password"
}

resource "aws_secretsmanager_secret_version" "db_password" {
  secret_id     = aws_secretsmanager_secret.db_password.id
  secret_string = random_password.db.result
}