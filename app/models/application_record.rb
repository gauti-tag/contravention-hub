require 'csv'
class ApplicationRecord < ActiveRecord::Base
  self.abstract_class = true
  BOM = "\xEF\xBB\xBF"
  include ActiveModel::Serialization

  scope :robot, -> { where.not(msisdn: ENV.fetch('ORANGE_GUINEE_ROBOT_MSISDN', '224624253426')) }

  def record_date
    created_at.strftime('le %d/%m/%Y à %R')
  end

  def additional_attrs
    [:record_date]
  end

  def self.fetch_records(params_hash = {})
    return [] if !params_hash.is_a?(ActionController::Parameters) && !params_hash.is_a?(Hash)
    return all if params_hash.blank?

    search_hash = {}
    filter_columns.each do |column_key|
      column_value = params_hash[column_key]
      search_hash[column_key.to_sym] = column_value if column_value.present?
    end

    where(search_hash)
  end

  def filter_columns
    []
  end

  def self.name_model_csv_file; end 

  def self.export_csv(params)
    # Encoding : Encoding::UTF_8 , "ISO-8859-1"
    file_name = "#{name_model_csv_file}_#{Time.now.strftime("%d-%m-%Y_%Hh-%Mm-%Ss")}.csv"
    CSV.open(Rails.root.join('public', 'exports', file_name), 'wb', col_sep: ';', write_headers: true, headers: export_attributes, encoding: Encoding::UTF_8, converters: [:numeric, :all, :integer]) do |csv|
        csv.to_io.write(BOM)

        records = fetch_records(params[:filter_data])

        from = params.key?(:from) ? Date.parse(params[:from]) : nil
        to = params.key?(:to) ? Date.parse(params[:to]) : nil

        records = records.where(created_at: from..to) unless from.nil? && to.nil?
        records.each do |record|
            csv << export_attributes_values(record)
        end
    end
    file_name
  end

  def self.export_attributes; end

  def self.human_readable_status(status)
    {
        'pending' => 'En Attente',
        'success' => 'Valide',
        'failure' => 'Echec'
    }.fetch(status, '')
  end

  def self.payment_readable(wallet)
    {
        'mtn_guinee' => 'Mtn',
        'orange_guinee' => 'Orange'
    }.fetch(wallet, '')
  end
  
end
