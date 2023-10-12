class Post < ApplicationRecord
    validates :title, presence: true, length: {minimum: 3, maxmum: 50}
    validates :body, presence: true, length: {minimum: 3, maxmum: 300}
    belongs_to :user
    has_many :comments, dependent: :destroy

    has_noticed_notifications model_name: "Notification"
    # post have many notifications through :user model
    has_many :notifications, through: :user, dependent: :destroy
end
