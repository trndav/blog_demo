class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable
  has_many :posts, dependent: :destroy
  has_many :comments, dependent: :destroy
  has_many :notifications, as: :recipient, dependent: :destroy

  # User can be admin or user
  enum role: [:user, :admin]
  # If new record, set_default_role
  after_initialize :set_default_role, if: :new_record?

  def self.ransackable_attributes(auth_object = nil)
    ["email", "name"]  # Add the attributes you want to make searchable
  end

  private
  def set_default_role
    # assign variable that is nil or false (used for initializing a variable if it hasn't been set yet)
    self.role ||= :user
  end
end
