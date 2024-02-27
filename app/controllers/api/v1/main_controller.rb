module Api::V1
  class MainController < ApplicationController
    
    PLAFOND_TICKET = 5
    PLATFORM = '3'
  
    def data
      json_response({status: 200, data: datatable_service.new(params)})
    end

    def beginning_date
        @beginning_date = model_constatize_name.first.created_at
    rescue
        @beginning_date = Time.now
    end
    
    # Function to expose all stats
    def stats 
        today_stats = {count: {}, amount: {}, tax: {}}
        monthly_stats = {count: {}, amount: {}, tax: {}}
        yearly_stats = {count: {}, amount: {}, tax: {}}
        global_stats = {count: {}, amount: {}, tax: {}}

        [:all, :failure, :success].each do |key|
            today_stats[:count][key] = model_constatize_name.today_count(key: key)
            monthly_stats[:count][key] = model_constatize_name.monthly_count(key: key)
            yearly_stats[:count][key] = model_constatize_name.yearly_count(key: key)
            global_stats[:count][key] = model_constatize_name.global_count(key: key, date: beginning_date)

            today_stats[:amount][key] = model_constatize_name.today_amount(key: key)
            monthly_stats[:amount][key] = model_constatize_name.monthly_amount(key: key)
            yearly_stats[:amount][key] = model_constatize_name.yearly_amount(key: key)
            global_stats[:amount][key] = model_constatize_name.global_amount(key: key, date: beginning_date)

            today_stats[:tax][key] = model_constatize_name.today_tax(key: key)
            monthly_stats[:tax][key] = model_constatize_name.monthly_tax(key: key)
            yearly_stats[:tax][key] = model_constatize_name.yearly_tax(key: key)
            global_stats[:tax][key] = model_constatize_name.global_tax(key: key, date: beginning_date)
        end

        data = {today: today_stats, monthly: monthly_stats, yearly: yearly_stats, global_stats: global_stats}
        json_response({status: 200, data: data})
    end

    def transactions_filter
        status = params[:request][:status]
        ticket = params[:request][:ticket_number]
        data = TrafficTicketPayment.find_by(status: status, ticket_number: ticket)
        return json_response({status: 400, message: "ticket number #{ticket} not found"}) if data.nil?
        json_response({status: 200, data: data.serializable_hash(methods: data.additional_attrs)})
    end

    def transactions 
        data = database_table.all
        json_response({status: 200, data: data})
    end

    def fetch_contravention_types
        contravention_classe_code = params[:request][:classe_code].upcase
        contravention_classe = ContraventionGroup.find_by(code: contravention_classe_code)
        return json_response({status: 400, message: "Classe code #{contravention_classe_code} not found!"}) if contravention_classe.nil?
        data = contravention_classe.contravention_types.where(status: 1)
        json_response({status: 200, data: data})
    end

    def fetch_contravention_type
        contravention_type_code = params[:request][:type_code].upcase
        contravention_type = ContraventionType.find_by(code: contravention_type_code, status: 1)
        return json_response({status: 400, message: "Type code #{contravention_type_code} not found!"}) if contravention_type.nil?
        json_response({status: 200, data: contravention_type})
    end
    
    # Fonction to verify inputs send by ussd orange guinee
    def verify_inputs_ussd
        #group_code = params[:request][:code_classe].upcase unless params[:request][:code_classe].empty?
        notebook_number = params[:request][:numero_carnet].upcase unless params[:request][:numero_carnet].empty?
        agent_number = params[:request][:numero_agent].upcase unless params[:request][:numero_agent].empty?
        contravention_number = params[:request][:numero_contravention].upcase unless params[:request][:numero_contravention].empty?

        #group = ContraventionGroup.find_by(code: group_code)
        notebook = ContraventionNotebook.find_by(number: notebook_number)
        agent = Agent.find_by(identifier: agent_number)

        @errors = [] 
        @ticket_number = ''

        if notebook.nil? || agent.nil? || contravention_number.nil? #|| group.nil?  
            #@errors << 'contravention_classe' if group.nil?
            @errors << 'contravention_carnet' if notebook.nil?
            @errors << 'contravention_agent' if agent.nil?
            @errors << 'contravention_number' if contravention_number.nil?
            @status = 404
        else
            @status = 200
            @ticket_number = increment_number #"#{group_code}-#{agent_number}-#{contravention_number}-#{Time.now.to_i.to_s.split("").last(3).join}".upcase
            @fees = Parameter.find_by(slug: "frais-contraventions").try(:value).to_f 
        end
        
        json_response({status: @status, errors: @errors, ticket_number: @ticket_number, contravention_fees: @fees})

    end

    def export_data
        file_csv_name = model_constatize_name.export_csv(params)
        share_file_name = "#{ENV['SERVER_FILE_URL']}/exports/#{file_csv_name}"
        json_response({status: 200, data: share_file_name})
    end

    private

    def datatable_service
      @datatable_service ||= {
        'ticket_payments' => 'TrafficTicketDatatable',
        'cnis' => 'CniDatatable',
        'civil_acts' => 'CivilActDatatable',
        'redevances' => 'RedevanceDatatable',
        'declarations' => 'DeclarationDatatable'
      }.fetch(params[:model_name]).constantize
    end

    def database_table 
        @database_table ||= {
            'transactions_tickets' => 'TrafficTicketPayment' 
        }.fetch(params[:request][:table_alias]).constantize
    end

    def model_constatize_name
        @model_constatize_name ||= {
          'ticket_payments' => 'TrafficTicketPayment',
           'declarations' => 'Declaration',
           'redevances' => 'Redevance'
        }.fetch(params[:model_name]).constantize
    end

    def increment_number
        counter = ''
        base_date = SessionManager.get_orange_date_month
        if base_date.nil?
            SessionManager.set_orange_date_month Time.now.end_of_month.to_i
            SessionManager.set_orange_counter 1
            counter = SessionManager.get_orange_counter 
     
        else
            if Time.current.to_i < base_date.to_i
                counter = SessionManager.get_orange_counter.to_i + 1
                SessionManager.set_orange_counter counter
            else
                SessionManager.set_orange_date_month Time.now.end_of_month.to_i
                SessionManager.set_orange_counter 1
                counter = SessionManager.get_orange_counter 
            end
        end
     
        count_char = counter.to_s.size
        zero_size = PLAFOND_TICKET - count_char
        ticket = '0' * zero_size + counter.to_s
        "#{Time.now.strftime("%y%m")}#{PLATFORM}#{ticket}"
    end
     

  end
end