class Workspace < ApplicationRecord
  def active?
    !!token
  end
end
