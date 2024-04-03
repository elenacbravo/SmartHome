# DynamoDB table
resource "aws_dynamodb_table" "app_db" {
  count        = length(var.table_names)

  name         = var.table_names[count.index]
  billing_mode = "PAY_PER_REQUEST"
  hash_key = var.hash_key

  attribute {
    name = var.hash_key
    type = var.hash_key_type
  }

  tags = {
    Name = var.table_names[count.index]
  }

}