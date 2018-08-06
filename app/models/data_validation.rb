class DataValidation < ApplicationRecord
  validates :end_id, uniqueness: {scope: :start_id}
end
