class Post < ApplicationRecord
    validates :title, presence: true, length: {minimum: 3, maxmum: 50}
    validates :body, presence: true, length: {minimum: 3, maxmum: 200}
end
