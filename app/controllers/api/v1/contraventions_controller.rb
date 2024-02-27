module Api::V1
  class ContraventionsController < ApplicationController
    before_action :fetch_row, only: [:update_record, :fetch_record, :destroy_record]
    before_action :fetch_transaction_row, only: [:fetch_transaction]

    def fetch_records 
      records = list_model.all
      data = records.map { |record| record.serializable_hash(methods: record.additional_attrs) }
      json_response({ status: 200, data: data })
    end
  
    def save_record
      record = record_model.new record_attrs
      if record.save
        json_response({status: 201, message: 'Record saved!'}, 201)
      else
        json_response({status: 422, message: 'Record not saved', error: record.errors.full_messages}, 422)
      end
    end

    def update_record
      @record.assign_attributes record_attrs
      if @record.save
        json_response({status: 201, message: 'Record updated!'}, 201)
      else
        json_response({status: 422, message: 'Record not saved', error: @record.errors.full_messages}, 422)
      end
    end

    def fetch_record
      if @record.present?
        json_response({status: 200, data: @record.serializable_hash(methods: @record.additional_attrs)})
      else
        json_response({status: 404, message: 'Not found!'}, :not_found)
      end
    end
    
    # Define methhode for fetching single transaction
    def fetch_transaction
        if @transaction.present?
            json_response({status: 200, data: @transaction.serializable_hash(methods: @transaction.additional_attrs).reject { |k, v| ["contravention_type_id", "contravention_notebook_id", "agent_id"].include?(k) }})
        else
            json_response({status: 404, message: 'Not found!'}, :not_found)
        end
    end

        
    # Method to delete data 
    def destroy_record
        @record.destroy!
        json_response({status: 200, data: @record.serializable_hash(methods: @record.additional_attrs)})
    end


    private

    def record_model
      params[:request][:model].to_s.constantize
    end

    def transaction_model 
        params[:transaction][:model].to_s.constantize
    end

    def list_model
      params[:model_code].to_s.constantize
    end

    def record_attrs
      case params[:request][:model]
      when 'Agent'
        agent_params
      when 'Parameter'
        parameter_params
      when 'ContraventionGroup'
        contravention_group_params
      when 'ContraventionNotebook'
        group = ContraventionGroup.find_by(code: params[:request][:index])
        contravention_notebook_params.merge!(contravention_group_id: group.try(:id))
      when 'ContraventionType'
        group = ContraventionGroup.find_by(code: params[:request][:index])
        contravention_type_params.merge!(contravention_group_id: group.try(:id))
      end
    end

    def fetch_row
      filter_hash = {}
      case params[:request][:model]
      when 'Agent'
        filter_hash = { identifier: params[:request][:identifier] } 
      when 'ContraventionGroup', 'ContraventionType'
        filter_hash = { code: params[:request][:code] }
      when 'ContraventionNotebook'
        filter_hash = { number: params[:request][:number] }
      when 'Parameter'
        filter_hash = {slug: params[:request][:slug]}
      end
      @record = record_model.find_by(filter_hash)
    end

    def fetch_transaction_row 
        params_hash = {}
        case params[:transaction][:model]
        when 'TrafficTicketPayment', 'Declaration', 'Redevance'
            params_hash = { transaction_id: params[:transaction][:id] }
        end
        @transaction = transaction_model.find_by(params_hash)
    end
    

    def agent_params
      params.require(:request).permit(:identifier, :last_name, :first_name, :grade)
    end

    def contravention_group_params
      params.require(:request).permit(:code, :label, :description)
    end

    def contravention_notebook_params
      params.require(:request).permit(:number, :label, :sheets)
    end

    def contravention_type_params
      params.require(:request).permit(:code, :label, :amount, :status)
    end

    def parameter_params
        params.require(:request).permit(:name, :value, :description, :slug)
    end
  
  end
end