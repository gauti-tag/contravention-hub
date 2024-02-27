# Classe mère des Datatables
class ApplicationDatatable

  class DatatableModelError < StandardError; end
 
  attr_reader :dt_params

  def initialize(dt_params)
    @dt_params = dt_params
  end

  def as_json(_options = {})
    Hash[:draw,  dt_params[:draw], :recordsTotal, count, :recordsFiltered, total_entries, :data, data]
  end

  def data
    records_list.robot.map do |record|
      record.serializable_hash(methods: :record_date)
    end
  end

  protected

  def count
    application_model.robot.fetch_records(dt_params[:filter_data]).size
  end

  def records_list
    get_filtered_data(dt_params[:filter_data], searching_columns)
  end

  def total_entries
    records_list.total_count
  end

  def page
    dt_params[:start].to_i / per_page + 1
  end

  def per_page
    length_param = dt_params[:length].to_i
    length_param.positive? ? length_param : 10
  end

  def sort_column
    columns[dt_params[:order]['0'][:column].to_i]
  end

  def sort_direction
     @dt_params[:order]['0'][:dir] == 'desc' ? 'desc' : 'asc'
  end

  def application_model
    model_name = models_list.fetch(dt_params[:model_name], '')
    raise DatatableModelError if model_name.blank?
    
    model_name.constantize
  end

  def models_list
    {'ticket_payments' => 'TrafficTicketPayment', 'cnis' => 'CniPayment', 'civil_acts' => 'CivilActPayment', 'redevances' => 'Redevance', 'declarations' => 'Declaration' }
  end

  def fetch_period_data(model_rows)
    from = valid_date?(dt_params[:from])
    to = valid_date?(dt_params[:to])
    model_rows.where(created_at: from..to) if from.present? && to.present?
  end

  def valid_date?(date_value)
    Time.parse(date_value)
  rescue ArgumentError
    nil
  end

  def get_filtered_data(params_hash, columns_arr)
    search_string = []
    search_value = get_dt_search_value(dt_params[:search])
    columns_arr.each do |term|
      search_string << "#{term} like :search"
    end
    search_value.delete!("$&+,:;=?@#|'<>.^*()%!-") if search_value.present?
    search_status = 0 if search_value == "en attente" || search_value == "En attente"
    search_status = 1 if search_value == "valide" || search_value == "Valide"
    search_status = 2 if search_value == "echec" || search_value == "Echec"
    params_hash = {} if params_hash.blank?
    records = application_model.fetch_records(params_hash)
    records = records.order(created_at: :desc) if dt_params[:draw].eql?('1')
    records = fetch_period_data(records) if dt_params[:date_search].eql?('yes')
    #records = records.order("#{sort_column} #{sort_direction}").page(page).per(per_page)
    records = records.order(id: :desc).page(page).per(per_page)

    if search_status == 0 || search_status == 1 || search_status == 2
        records = records.where(status: search_status)
    else
        records = records.where(search_string.join(' or '), search: "%#{search_value}%") unless search_value.blank?
    end
   
    records
  end

  def get_dt_search_value(search_struct)
    search_struct.try(:[], :value)
  end

end
