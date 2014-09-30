class Book < ActiveRecord::Base
  belongs_to :author
  # t.string :title
      # t.float :price
      # t.string :genre
      # t.string :description
      # t.string :publisher
      # t.integer :published_year
      # t.string :thumbnailImg
      # t.string :largeImg
      #:language, :string
  has_attached_file :cover, :styles => { :medium => "300x300>", :thumb => "100x100>" }, :default_url => "/images/:style/missing.png"
  validates_attachment_content_type :cover, :content_type => /\Aimage\/.*\Z/
  validates :title, :price, :author_id, :language, presence: true
  validates_uniqueness_of :title, :scope => :author_id
  validates :price, numericality: { greater_than_or_equal_to: 0 } 
  validates :rating, numericality: { greater_than: 0, less_than_or_equal_to: 5 }
  validates :genre, :inclusion  => { :in => [ "romance","suspense","biography","fantasy" ]}
  
end
