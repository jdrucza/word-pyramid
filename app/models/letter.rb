class Letter < ActiveRecord::Base
  establish_connection :dictionary

  attr_accessible :letter
  has_and_belongs_to_many :words
end
