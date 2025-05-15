# Job Definition
resource "aws_batch_job_definition" "generate_batch_jd_lakeflow_deploy" {
  name = "${var.prefix}-lakeflow-deploy"
  type = "container"

  container_properties = jsonencode({
    image            = "${local.account_id}.dkr.ecr.us-west-2.amazonaws.com/${var.prefix}-lakeflow-deploy:${var.image_tag}"
    executionRoleArn = var.iam_execution_role_arn
    jobRoleArn       = var.iam_job_role_arn
    fargatePlatformConfiguration = {
      platformVersion = "LATEST"
    }
    logConfiguration = {
      logDriver = "awslogs"
      options = {
        awslogs-group = aws_cloudwatch_log_group.cw_log_group_deploy.name
      }
    }
    resourceRequirements = [{
      type  = "MEMORY"
      value = "8192"
      }, {
      type  = "VCPU",
      value = "4"
    }]
    mountPoints = [{
      sourceVolume  = "input",
      containerPath = "/mnt/input"
      readOnly      = false
    },{
      sourceVolume = "flpe"
      containerPath = "/mnt/flpe"
      readOnly = false
    }]
    volumes = [{
      name = "input"
      efsVolumeConfiguration = {
        fileSystemId  = var.efs_file_system_ids["input"]
        rootDirectory = "/"
      },
    },{
      name = "flpe"
      efsVolumeConfiguration = {
        fileSystemId = var.efs_file_system_ids["flpe"]
        rootDirectory = "/"
      }
    }]
  })

  platform_capabilities = ["FARGATE"]
  propagate_tags        = true
  tags                  = { "job_definition" : "${var.prefix}-lakeflow-deploy" }
}

# Log group
resource "aws_cloudwatch_log_group" "cw_log_group_deploy" {
  name = "/aws/batch/job/${var.prefix}-lakeflow-deploy/"
}
