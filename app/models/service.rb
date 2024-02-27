class Service < ApplicationRecord
    validates :name, presence: true, uniqueness: true
    validates :token, presence: true, uniqueness: true
    validates :alias, presence: true, uniqueness: true
end