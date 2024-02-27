class ContraventionGroup < ConfigRecord
  has_many :contravention_notebooks, dependent: :destroy
  has_many :contravention_types, dependent: :destroy
end
