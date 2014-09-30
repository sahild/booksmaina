class Author < ActiveRecord::Base
  validates_uniqueness_of :title
  has_many :books
end
