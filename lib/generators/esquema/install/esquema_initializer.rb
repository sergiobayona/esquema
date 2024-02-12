# frozen_string_literal: true

Esquema.configure do |config|
  # Exclude Associations:
  # Exclude associated models from the json-schema output.
  # By default, all associated models are included.
  config.exclude_associations = false

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
