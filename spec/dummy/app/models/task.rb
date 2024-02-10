# frozen_string_literal: true

class Task < ApplicationRecord
  belongs_to :employee, inverse_of: :tasks
end
