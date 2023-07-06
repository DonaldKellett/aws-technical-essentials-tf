resource "aws_dynamodb_table" "Employees" {
  name = "Employees"
  hash_key = "id"
  attribute {
    name = "id"
    type = "S"
  }
  read_capacity = 5
  write_capacity = 5
}
