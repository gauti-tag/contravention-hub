class PaymentRecord < ApplicationRecord
  self.abstract_class = true

  include ActiveModel::AttributeAssignment

  belongs_to :operation_type, optional: true

  validates :transaction_id, :msisdn, :amount, presence: true
  validates :transaction_id, uniqueness: true
  validates :payment_trnx_ref, :partner_code, uniqueness: true, allow_blank: true

  enum status: [:pending, :success, :failure, :robot_test_success, :robot_test_failure]

end
