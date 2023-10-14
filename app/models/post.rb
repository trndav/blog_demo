class Post < ApplicationRecord
    validates :title, presence: true, length: {minimum: 3, maxmum: 50}
    validates :body, presence: true, length: {minimum: 3, maxmum: 300}
    belongs_to :user
    has_many :comments, dependent: :destroy
    has_noticed_notifications model_name: "Notification"
    # post have many notifications through :user model
    has_many :notifications, through: :user, dependent: :destroy

    def self.ransackable_attributes(auth_object = nil)
        ["title", "body", "user_email", "user_name", "type"]  # Add the attributes you want to make searchable
    end
    def self.ransackable_associations(auth_object = nil)
        ["comments", "user"]  # Add the associations you want to make searchable
    end
end
