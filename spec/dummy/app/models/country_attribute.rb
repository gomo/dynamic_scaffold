class CountryAttribute < ApplicationRecord
  belongs_to :country
  self.primary_keys = :code, :country_id
end
