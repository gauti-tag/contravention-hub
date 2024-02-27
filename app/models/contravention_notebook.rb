class ContraventionNotebook < ConfigRecord
  belongs_to :contravention_group

  def self.caching_key
    :number
  end
end
