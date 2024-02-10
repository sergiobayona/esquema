class Company < ApplicationRecord
  has_many :employees, dependent: :destroy
  has_one :address, dependent: :destroy
end
