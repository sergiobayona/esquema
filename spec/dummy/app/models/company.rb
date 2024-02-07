class Company < ApplicationRecord
  has_many :employees, dependent: :destroy
end
