class ApplicationRecord < ActiveRecord::Base
  primary_abstract_class

  def search(model, query)
    model.capitalize.where("code LIKE ?", "%#{query}%")
  end

end
