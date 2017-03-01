class Comment < ApplicationRecord
  # Direct associations

  # Indirect associations

  # Validations

  validates :comment, :presence => { :message => "Must be associated to user" }

  validates :comment, :length => { :minimum => 0, :maximum => 400 }

  validates :user_id, :presence => true

end
