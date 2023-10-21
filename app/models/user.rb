class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable
  has_many :posts, dependent: :destroy
  has_many :comments, dependent: :destroy
  has_many :notifications, as: :recipient, dependent: :destroy

  has_one :address, dependent: :destroy, inverse_of: :user, autosave: true

  # Class level accessor https://apidock.com/rails/Class/cattr_accessor
  cattr_accessor :form_steps do
    %w[sign_up set_name set_address find_users]
  end

  # Instance level accessor https://apidock.com/rails/Module
  attr_accessor :form_step

  def form_step
    @form_step ||= "sign up"
  end

  with_options if: -> { required_for_step?("set_name") } do |step|
    step.validates :first_name, presence: true
    step.validates :last_name, presence: true
  end

  accepts_nested_attributes_for :address, allow_destroy: true

  validates_associated :address, if -> { required_for_step?("set_address")}
  def required_for_step?(step)
    # All fields are required if no form step is present
    return true if form_step_nil?

    # All fields from previous steps are required 
    # if step parameter appears before or we are on current step
    return true if form_steps.index(step.to_s) <= form_steps.index(form_step.to_s)
  end



  # User can be admin or user
  enum role: [:user, :admin]
  # If new record, set_default_role
  after_initialize :set_default_role, if: :new_record?

  def full_name
    "#{first_name.capitalize} #{last_name.capitalize}"
  end

  def self.ransackable_attributes(auth_object = nil)
    ["email", "name"]  # Add the attributes you want to make searchable
  end

  private
  def set_default_role
    # assign variable that is nil or false (used for initializing a variable if it hasn't been set yet)
    self.role ||= :user
  end
end
