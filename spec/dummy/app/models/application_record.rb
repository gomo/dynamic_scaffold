class ApplicationRecord < ActiveRecord::Base
  self.abstract_class = true
  def fdate(column, format)
    public_send(column).strftime(format)
  end
end
