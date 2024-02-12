# frozen_string_literal: true

Esquema.configure do |config|
  # Excluded Models:
  # Specify the models that you want to exclude from having Esquema functionality.
  # This is useful for models that are not backed by a database table, or for models that are not relevant to the API.
  # By default, all models are included.
  config.exclude_models = []

  # Exclude Foreign Keys:
  # Specify whether or not to exclude foreign keys from the json-schema output.
  # By default, foreign keys are excluded.
  # foreign keys are loosely defined as columns that end with "_id".
  config.exclude_foreign_keys = true

  # Excluded Columns:
  # Specify the columns that you want to exclude from the json-schema output.
  # These are columns common to all models, such as id, created_at, updated_at, etc.
  # It's okay if not all models have these columns, they will be ignored.
  config.excluded_columns = %i[id created_at updated_at deleted_at]
end
