class CniPayment < PaymentRecord

  def attributes
    {
      'transaction_id' => nil,
      'msisdn' => nil,
      'amount' => nil,
      'currency' => nil,
      'created_at' => nil,
      'status' => nil,
      'payment_trnx_ref' => nil,
      'partner_code' => nil,
      'wallet' => nil,
      'transaction_fees' => nil,
      'operation_type_id' => nil,
    }
  end

  def additional_attrs
    [:record_date, :operation_type_name, :operation_type_code]
  end

  def operation_type_name
    operation_type.label
  end

  def operation_type_code
    operation_type.code
  end

  def self.filter_columns
    %w[transaction_id msisdn payment_trnx_ref]
  end

end
