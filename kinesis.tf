resource "aws_kinesis_stream" "temperature-data-stream-tf" {
  name             = "TemperatureDataStream"
  shard_count      = 1
  retention_period = 24
  shard_level_metrics = [
    "IncomingBytes",
    "OutgoingBytes",
  ]
  tags = {
    Name = "TemperatureDataStream"
  }
}
