resource "aws_glue_job" "glue_job_iris_part1" {
  name         = "${var.obj_prefix}-part1"
  role_arn     = aws_iam_role.glue_role.arn
  max_retries  = 1
  timeout      = 60
  glue_version = "2.0"
  worker_type  = "G.1X"
  number_of_workers = 2
  command {
    script_location = "s3://${aws_s3_bucket.glue_code_bucket.bucket}/glue_job_iris_part1.py"
    python_version  = "3"
  }
  default_arguments = {    
    "--job-language"          = "python"
    "--ENV"                   = "env"
    "--spark-event-logs-path" = "s3://${aws_s3_bucket.glue_code_bucket.bucket}"
    "--job-bookmark-option"   = "job-bookmark-enable"
    "--enable-spark-ui"       = "true"
  }
  execution_property {
    max_concurrent_runs = 1
  }
}

resource "aws_glue_job" "glue_job_iris_part2" {
  name         = "${var.obj_prefix}-part2"
  role_arn     = aws_iam_role.glue_role.arn
  max_retries  = 1
  timeout      = 60
  glue_version = "2.0"
  worker_type  = "G.1X"
  number_of_workers = 2
  command {
    script_location = "s3://${aws_s3_bucket.glue_code_bucket.bucket}/glue_job_iris_part2.py"
    python_version  = "3"
  }
  default_arguments = {    
    "--job-language"          = "python"
    "--ENV"                   = "env"
    "--spark-event-logs-path" = "s3://${aws_s3_bucket.glue_code_bucket.bucket}"
    "--job-bookmark-option"   = "job-bookmark-enable"
    "--enable-spark-ui"       = "true"
  }
  execution_property {
    max_concurrent_runs = 1
  }
}

resource "aws_glue_workflow" "glue_workflow" {
  name = var.obj_prefix
}

resource "aws_glue_trigger" "start_crawler" {
  name          = "start-crawler"
  type          = "ON_DEMAND"
  workflow_name = aws_glue_workflow.glue_workflow.name
  actions {
    crawler_name = aws_glue_crawler.glue_crawler.name
  }

}

resource "aws_glue_trigger" "start_first" {
  name          = "start-first"
  type          = "CONDITIONAL"
  workflow_name = aws_glue_workflow.glue_workflow.name
  predicate {
    conditions {
      crawler_name = aws_glue_crawler.glue_crawler.name
      crawl_state    = "SUCCEEDED"
    }
  }
  actions {
    job_name = aws_glue_job.glue_job_iris_part1.name
  }
}

resource "aws_glue_trigger" "start_second" {
  name          = "start-second"
  type          = "CONDITIONAL"
  workflow_name = aws_glue_workflow.glue_workflow.name
  predicate {
    conditions {
      job_name = aws_glue_job.glue_job_iris_part1.name
      state    = "SUCCEEDED"
    }
  }
  actions {
    job_name = aws_glue_job.glue_job_iris_part2.name
  }
}