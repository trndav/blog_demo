class Post < ApplicationRecord
    extend FriendlyId
    validates :title, presence: true, length: {minimum: 3, maxmum: 50}
    validates :body, presence: true, length: {minimum: 3, maxmum: 300}
    belongs_to :user
    belongs_to :category
    has_many :comments, dependent: :destroy
    has_noticed_notifications model_name: "Notification"
    # post have many notifications through :user model
    has_many :notifications, through: :user

    #Single image upload
    #has_one_attached :image
    #Multiple images upload
    has_many_attached :images

    has_rich_text :body
    # This is for ransack search (?)
    has_one :content, class_name: "ActionText::RichText", as: :record, dependent: :destroy

    friendly_id :title, use: %i[slugged history finders]

    ransack_alias :searchable, :title_or_body_or_user_email_or_user_first_name_or_user_last_name

    # method is part of the FriendlyId; determine whether a new friendly ID should be generated
    def should_generate_new_friendly_id?
        title_changed? || slug.blank?
    end

    def self.ransackable_attributes(auth_object = nil)
        ["title_or_body_or_user_email_or_user_name_cont"]  # Add the attributes you want to make searchable
    end
    def self.ransackable_associations(auth_object = nil)
        ["comments", "user"]  # Add the associations you want to make searchable
    end

    def views_by_day
        daily_events = Ahoy::Event.where("cast(properties ->> 'post_id' as bigint) = ?", id)
        # daily_events.group_by_day(:time).count   
        daily_events.group_by_day(:time, range: 1.month.ago..Time.now).count      
    end

    def self.total_views_by_day
        # Viewed Post event is in posts_controller
        daily_events = Ahoy::Event.where(name: "Viewed Post")
        daily_events.group_by_day(:time, range: 1.month.ago..Time.now).count 
    end
end
