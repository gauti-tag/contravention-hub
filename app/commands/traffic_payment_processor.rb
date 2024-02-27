class TrafficPaymentProcessor < PaymentProcessor
  

  def config_attrs
    [:operation_type, :agent, :contravention_type, :contravention_notebook]
  end

end