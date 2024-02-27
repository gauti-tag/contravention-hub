class ContraventionType < ConfigRecord
  belongs_to :contravention_group

  def attributes
    {
      'code' => nil,
      'label' => nil,
      'amount' => nil
      #'contravention_group_id' => nil
    }
  end

  def additional_attrs
    [:ticket_amount]
  end

  def ticket_amount
    #contravention_group.amount
    amount
  end

end
