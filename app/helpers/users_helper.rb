module UsersHelper
  def organization_form_column(record, input_name)
    select :record, :organization, ['Maintenance Service and Support', 'Technical Solutions Group', 'Sales', 'Partner'],
      :name => input_name
  end
end
