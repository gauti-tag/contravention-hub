# Payment Class for USSD payment
class PaymentProcessor
  class << self
    def call(params:)
      payment = new(params: params)
      execution = payment.execute # Initiation du payment
      @transaction = payment.transaction
      request_attrs = {
        #response_data: execution.message,
        request_body: execution.request,
        response_code: execution.code,
        gateway_transaction_id: execution.gateway_transaction_id
      }
      @transaction.assign_attributes(request_attrs)
      success = @transaction.valid?
      return OpenStruct.new(status: 422, success?: success, message: @transaction.errors.full_messages) if success == false

      if execution.status != 200 || execution.code != 200
        @transaction.assign_attributes(status: 2)
        return OpenStruct.new(status: 424, success?: false, message: 'Payment failed!')
      end
      @transaction.wallet = execution.wallet
      @transaction.save
      OpenStruct.new(status: 200, success?: true, transaction_id: @transaction.gateway_transaction_id, message: execution.message)
    end
  end

  attr_reader :transaction, :params, :payload

  def execute
    @execute ||= Gateway::InitPayment.call(params: payment_params)
  end

  private

  def initialize(params:)
    @params = params
    @payload = params[:payload]
    @transaction = transaction_model.new(transaction_attrs.merge(attrs_payload))
    @transaction.transaction_id = SecureRandom.hex(3) + Time.now.to_i.to_s
    @transaction.assign_attributes(config_payload) if config_payload.present?
  end

  def transaction_model
    {
      'cni' => 'CniPayment',
      'civil_act' => 'CivilActPayment',
      'traffic_ticket' => 'TrafficTicketPayment',
      'redevance_ticket' => 'Redevance',
      'declaration_ticket' => 'Declaration'
    }.fetch(params[:transaction_type]).constantize
  end

  def config_attrs
    [:operation_type]
  end

  # Get config attributes values from params payload
  def config_payload
    @config_payload ||= {}.tap { |hash| config_attrs.each { |key| hash["#{key}_id".to_sym] = RedisManager.config_value(key: key, code: payload[key]) if payload[key].present? } }
  end

  # Get other attributes values from params payload
  def attrs_payload
    @attrs_payload ||= @payload.except(*config_attrs)
  end

  def transaction_attrs
    params.select { |key, _value| [:msisdn, :amount, :currency, :wallet].include?(key.to_sym) }
  end

  def payment_params
    {
      msisdn: params[:msisdn],
      amount: params[:amount].to_i,
      order_id: transaction.transaction_id,
      wallet: params[:wallet],
      currency: params[:currency],
      service_id: Service.find_by(alias: params[:transaction_type]).token,
      operation_type: params[:transaction_type],
      contravention_number: params[:payload][:ticket_number]
    }
  end

end