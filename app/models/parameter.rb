class Parameter < ApplicationRecord 
    validates :name, presence: true
    validates :slug, presence: true, uniqueness: true
    validates :value, presence: true
end