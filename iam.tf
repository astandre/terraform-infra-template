resource "aws_iam_role" "ci_role" {
  name = "ci_role"

  assume_role_policy = jsonencode(
    {
      "Version" : "2012-10-17",
      "Statement" : [
        {
          "Effect" : "Allow",
          "Principal" : {
            "Service" : "codebuild.amazonaws.com"
          },
          "Action" : "sts:AssumeRole"
        }
      ]
    }
  )



  inline_policy {
    name = "CIPolicy"

    policy = jsonencode({
      "Version" : "2012-10-17",
      "Statement" : [
        {
          "Sid" : "CodeBuildDefaultPolicy",
          "Effect" : "Allow",
          "Action" : [
            "codebuild:*",
            "iam:PassRole"
          ],
          "Resource" : "*"
        },
        {
          "Effect" : "Allow",
          "Resource" : [
            "*"
          ],
          "Action" : [
            "logs:CreateLogGroup",
            "logs:CreateLogStream",
            "logs:PutLogEvents"
          ]
        },
        {
          "Effect" : "Allow",
          "Resource" : [
            aws_s3_bucket.lambda_bucket.arn,
            "${aws_s3_bucket.lambda_bucket.arn}/*"
          ],
          "Action" : [
            "s3:PutObject",
            "s3:GetObject",
            "s3:GetBucketAcl",
            "s3:GetBucketLocation"
          ]
        }
      ]
    })

  }

}
