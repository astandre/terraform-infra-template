resource "aws_codebuild_project" "templateCI" {
  name = "lambdaTemplateTs"

  build_timeout = "5"
  service_role  = aws_iam_role.ci_role.arn
  badge_enabled = true

  artifacts {
    artifact_identifier = "lambdaTemplateTs"
    type                = "S3"
    path                = ""
    location            = aws_s3_bucket.lambda_bucket.id
    packaging           = "ZIP"
    name                = "lambdaTemplateTs.zip"
  }

  cache {
    type     = "S3"
    location = aws_s3_bucket.lambda_bucket.bucket
  }

  environment {
    compute_type                = "BUILD_GENERAL1_SMALL"
    image                       = "aws/codebuild/standard:1.0"
    type                        = "LINUX_CONTAINER"
    image_pull_credentials_type = "CODEBUILD"
  }



  logs_config {
    cloudwatch_logs {
      group_name  = "ci-log-group"
      stream_name = "ci-log-stream"
    }

    s3_logs {
      status   = "ENABLED"
      location = "${aws_s3_bucket.log_bucket.id}/ci-build-log"
    }
  }

  source {
    type            = "GITHUB"
    location        = "https://github.com/Corserva/whyndham-presenter-data-rest"
    git_clone_depth = 1

    buildspec = file("${path.module}/lambdas/lambdaTemplateTs/buildspec.yml")

    git_submodules_config {
      fetch_submodules = true
    }
  }


  source_version = "main"

  tags = {
    environment = "dev"
    access      = "private"
    integration = "test"
    s3          = "Store zip code"
    lambda      = "Trigger build via lambda"
  }
}

data "aws_s3_object" "lambdaTemplateTsObject" {
  bucket = aws_s3_bucket.lambda_bucket.id
  key    = "lambdaTemplateTs.zip"

  tags = {
    environment = "dev"
    access      = "intra"
    integration = "test"
    lambda      = "Load code from zip"
    code_build  = "Store zip code"
  }
}


resource "aws_lambda_function" "lambdaTemplateTsLambda" {
  function_name = "lambdaTemplateTs"


  s3_bucket = aws_s3_bucket.lambda_bucket.id
  s3_key    = "lambdaTemplateTs.zip"

  handler = "index.handler"
  runtime = "nodejs14.x"

  timeout = 3

  source_code_hash = data.aws_s3_object.lambdaTemplateTsObject.etag


  role = aws_iam_role.odyssey_lambda_lambdaTemplateTs.arn

  tags = merge(local.tags, {
    access = "private"
  })

  environment {
    variables = {
      REGION = var.region
    }
  }
}


resource "aws_cloudwatch_log_group" "lambdaTemplateTsCW" {
  name = "/aws/lambda/${aws_lambda_function.lambdaTemplateTsLambda.function_name}"

  retention_in_days = 30

  tags = merge(local.tags, {
    access = "private"
  })

}

resource "aws_iam_role" "odyssey_lambda_lambdaTemplateTs" {
  name = "odyssey_lambda_lambdaTemplateTs"

  assume_role_policy = jsonencode({
    "Version" : "2012-10-17",
    "Statement" : [
      {
        "Effect" : "Allow",
        "Principal" : {
          "Service" : "lambda.amazonaws.com"
        },
        "Action" : "sts:AssumeRole"
      }
    ]
  })


  inline_policy {
    name = "LogToCW"

    policy = jsonencode({
      Version = "2012-10-17"
      Statement = [
        {
          Action = [
            "logs:CreateLogGroup",
            "logs:CreateLogStream",
            "logs:PutLogEvents"
          ]
          Effect   = "Allow"
          Resource = "*"
        },
      ]
    })

  }



  inline_policy {
    name = "AccessS3"

    policy = jsonencode({
      Version = "2012-10-17"
      Statement = [
        {
          Action = [
            # "s3:GetObject",
            # "s3:DeleteObject",
            # "s3:PutObject",
            "*"
          ]
          Effect = "Allow"
          Resource = [
           "*"
          ]
        },
      ]
    })
  }

}


