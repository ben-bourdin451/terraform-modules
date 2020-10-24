provider "aws" {
  region = "eu-west-1"
}

module "table_hash_only" {
  source = "./.."

  table_name = "tf_test_table_hash_only"
  hash_key = {
    name = "HASH_KEY"
    type = "S"
  }

  enable_recovery = false
}

module "table_all_noscaling" {
  source = "./.."

  table_name = "tf_test_table_all_noscaling"
  hash_key = {
    name = "HASH_KEY"
    type = "S"
  }
  range_key = {
    name = "RANGE_KEY"
    type = "N"
  }

  enable_ttl         = true
  enable_autoscaling = false
  enable_alarms      = true

  attributes = [
    {
      name = "GSI_ID_1"
      type = "S"
    },
    {
      name = "GSI_ID_2"
      type = "S"
    },
    {
      name = "LSI_1"
      type = "N"
    },
    {
      name = "LSI_2"
      type = "S"
    },
  ]

  lsi = [
    {
      name            = "TEST_LOCAL_SECONDARY_INDEX_1"
      range_key       = "LSI_1"
      projection_type = "ALL"
    },
    {
      name            = "TEST_LOCAL_SECONDARY_INDEX_2"
      range_key       = "LSI_2"
      projection_type = "ALL"
    },
  ]

  gsi = [
    {
      name            = "TEST_GLOBAL_SECONDARY_INDEX_1"
      read_capacity   = 5
      write_capacity  = 5
      hash_key        = "GSI_ID_1"
      range_key       = "RANGE_KEY"
      projection_type = "ALL"
    },
    {
      name            = "TEST_GLOBAL_SECONDARY_INDEX_2"
      read_capacity   = 5
      write_capacity  = 5
      hash_key        = "GSI_ID_2"
      range_key       = "LSI_1"
      projection_type = "ALL"
    },
  ]
}
