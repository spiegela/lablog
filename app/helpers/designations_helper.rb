module DesignationsHelper
  def asset_id_form_column(record, input_name)
    selected = record.asset_id if record.asset_id
    selections = current_user.administrator_labs.collect{|l| l.assets}.flatten.collect{|a| [a.to_label, a.id]}
    select :record, :asset_id, selections, :name => input_name, :selected => selected, :include_blank => false
  end

  def user_id_form_column(record, input_name)
    selected = record.user_id if record.user_id
    if record.asset_id
      selections = record.asset.lab.administrators.collect{|u| [u.to_label, u.id]}
    else
      selections = current_user.administrator_labs.collect{|l| l.administrators}.flatten.collect{|u| [u.to_label, u.id]}
    end
    select :record, :user_id, selections, :name => input_name, :selected => selected, :include_blank => false
  end
end
