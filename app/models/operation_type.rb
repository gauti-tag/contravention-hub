class OperationType < ConfigRecord
  has_many :cni_payments
  has_many :civil_act_payments
  has_many :traffic_ticket_payments

  validates :label, :code, presence: true
  validates :code, uniqueness: true

  
end
