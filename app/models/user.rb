class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable
  has_many :posts, dependent: :destroy
  has_many :comments, dependent: :destroy
  has_many :notifications, as: :recipient, dependent: :destroy
  has_one_attached :avatar
  has_one :address, dependent: :destroy, inverse_of: :user, autosave: true

  pay_customer stripe_attributes: :stripe_attributes

  cattr_accessor :form_steps
  @@form_steps = %w[sign_up set_name set_address find_users]

  attr_accessor :form_step

  def form_step
    @form_step ||= "sign_up"
  end

  with_options if: -> { required_for_step?("set_name") } do |step|
    step.validates :first_name, presence: true
    step.validates :last_name, presence: true
  end

  validates_associated :address, if: -> { required_for_step?("set_address") }

  def full_name
   # "#{first_name.capitalize} #{last_name.capitalize}"
    first = first_name&.capitalize unless first_name.nil?
    last = last_name&.capitalize unless first_name.nil?
    if first && last
      "#{first} #{last}"
    elsif first
      first
    elsif last
      last
    else
      "No Name"
    end
  end

  accepts_nested_attributes_for :address, allow_destroy: true

  def required_for_step?(step)
    return true if form_step.nil?
    form_steps.index(step.to_s) <= form_steps.index(form_step.to_s)
  end

  enum role: [:user, :admin]
  after_initialize :set_default_role, if: :new_record?

  def self.ransackable_attributes(auth_object = nil)
    ["email", "full_name"]  # Add the attributes you want to make searchable
  end

  def stripe_attributes(pay_customer)
    {
      address: {
        city: pay_customer.owner.city,
        country: pay_customer.owner.country
      },
      metadata: {
        pay_customer_id: pay_customer.id,
        user_id: id # or pay_customer.owner_id
      }
    }
  end

  private
  def set_default_role
    self.role ||= :user
  end
end
