class Task < ApplicationRecord
  belongs_to :user, inverse_of: :tasks
end
