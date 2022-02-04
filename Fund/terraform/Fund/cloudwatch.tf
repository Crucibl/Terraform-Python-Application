resource "aws_cloudwatch_log_group" "django_log_group" {
  name              = "/ecs/Fund"
  retention_in_days = var.log_retention_policy
}

resource "aws_cloudwatch_log_stream" "django_log_stream" {
  name           = "My-log-stream"
  log_group_name = aws_cloudwatch_log_group.django_log_group.name
}

resource "aws_cloudwatch_log_group" "nginx_log_group" {
  name              = "/ecs/nginx"
  retention_in_days = var.log_retention_policy
}

resource "aws_cloudwatch_log_stream" "nginx_log_stream" {
  name           = "nginx-log-stream"
  log_group_name = aws_cloudwatch_log_group.nginx_log_group.name
}

resource "aws_cloudwatch_metric_alarm" "cpu-utilization" {
  alarm_name          = "high-cpu-utilization-alarm"
  comparison_operator = "GreaterThanOrEqualToThreshold"
  evaluation_periods  = "2"
  metric_name         = "CPUUtilization"
  namespace           = "AWS/EC2"
  period              = "120"
  statistic           = "Average"
  threshold           = "75"
  alarm_description   = "This metric monitors ec2 cpu utilization"
  alarm_actions       = "aws_sns_topic.alarm.arn"

  dimensions {
    InstanceId = "aws_instance.my_instance.id"
  }

}


resource "aws_cloudwatch_metric_alarm" "instance-health-check" {
  alarm_name          = "instance-health-check"
  comparison_operator = "GreaterThanOrEqualToThreshold"
  evaluation_periods  = "1"
  metric_name         = "StatusCheckFailed"
  namespace           = "AWS/EC2"
  period              = "120"
  statistic           = "Average"
  threshold           = "1"
  alarm_description   = "This metric monitors ec2 health"
  alarm_actions       = "aws_sns_topic.alarm.arn"

  dimensions {
    InstanceId = "aws_instance.my_instance.id"
  }


}