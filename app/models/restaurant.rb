class Restaurant < ActiveRecord::Base
  has_many :reviews,
    -> { extending WithUserAssociationExtension },
    dependent: :destroy

  has_attached_file :image, :styles => { :medium => "300x300>", :thumb => "100x100>" }, :default_url => "/images/:style/missing.png"
  validates_attachment_content_type :image, :content_type => /\Aimage\/.*\Z/

  belongs_to :user
  validates :name, length: { minimum: 3 }, uniqueness: true
  # validates_associated :reviews
  # def build_review(attributes = {}, user)
  #   attributes[:user] ||= user
  #   self.reviews.build(attributes)
  # end
end
