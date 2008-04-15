module SoftwaresHelper
  def producer_form_column(record, input_name)
    select :record, :producer, Software.producers, :name => input_name
  end

  def lab_id_form_column(record, input_name)
    selected = record.lab_id if record.lab_id
    selections = Array.new
    if current_user.super_user
      selections = Lab.to_select
    else
      selections = current_user.administrator_labs.collect{|l| [l.name, l.id]}
    end
    select :record, :lab_id, selections, :name => input_name, :selected => selected, :include_blank => false
  end
end
