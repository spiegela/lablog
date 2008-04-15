module ReservationsHelper
  def user_id_form_column(record, input_name)
    user = record.user || current_user
    '<span class="readonly_field">'+user.login+'</span>' +
      hidden_field(:record, :user_id, :name => input_name, :value => user.id)
  end

  def comment_form_column(record, input_name)
    text_area(:record, :comment, :name => input_name, :cols => 45, :rows => 2, :style => "font-size: 1em")
  end

  def start_time_form_column(record, input_name)
    value = record.start_time ? record.start_time.to_short_s : (Time.now + 300).to_short_s
    opts = {:time => true, :value => value}
    calendar_date_select_tag "record[start_time]", nil, opts
  end

  def end_time_form_column(record, input_name)
    value = record.end_time ? record.end_time.to_short_s : (Time.now.tomorrow + 300).to_short_s
    opts = {:time => true, :value => value}
    calendar_date_select_tag "record[end_time]", nil, opts
  end

  def approvers_comments_form_column(record, input_name)
    text_area(:record, :approvers_comments, :name => input_name, :cols => 45,
      :rows => 2, :style => "font-size: 1em")
  end

  def approval_status_form_column(record, input_name)
    select :record, :approval_status, Reservation.approval_statuses,
      :name => input_name
  end

  def event_form_column(record, input_name)
    select :record, :event, Reservation.events, :name => input_name,
      :include_blank => true
  end

  def asset_form_column(record, input_name)
    if record.asset
      "<span class='readonly_field'>#{record.asset.to_label}</span>"  +
        hidden_field_tag(input_name, record.asset.id, :id => input_name,
	:class => 'asset-input')
    end
  end

  def activations_column(record)
    link_str = "#{record.activations.length} Activations"
    link_to link_str, {:controller => 'reservations', :action => 'nested',
      :associations => 'activations', :id => record.id},
      :class => "nested action", "position" => "after", :id => "reservations-nested-#{record.id}-link" 
  end

  def version_form_column(record, input_name)
    selected = nil
    versions = Array.new
    if record.asset
      versions = record.asset.versions
      selected = record.asset.current_versions.first.id unless record.asset.current_versions.empty?
    end
    selected = record.version_id if record.version

    select_tag(input_name,
      :id => input_name,
      :class => 'version-input',
      :options =>
        options_for_select( versions.collect{|v| [v.version, v.id]}, selected ) ) +
    "</select>"
  end

  def listing(record)
    <<-END_OF_STRING
    <span class="listing">
    Reservation from <span class="hl">#{record.start_time.to_short_s} to #{record.end_time.to_short_s}</span>
    using the following assets:<br/>
    <ul id="reservation-label-#{record.id}">
      #{record.assets.collect{|x|'<li>' + x.to_label + '</li>' }.join} 
    </ul>   
    </span> 
    END_OF_STRING
  end

  def details(record)
<<END_OF_STRING
Reason for Reservation:  #{record.reason}
Reservation Start:       #{record.start_time}
Reservation End:         #{record.end_time}
User Comments:           #{record.comment}
Requesting User:         #{record.user.login}

Asset Usages:
#{ record.usages.pretty_table(
  [:asset, :version, :exclusive, :destructive, :active?, :at_version?, :no_prior?],
  :print_methods => {:asset => :to_label, :version => :to_label},
  :max_width => 30) }
  
Notes:
  Active?      indicates that the requested asset is listed as currently active
  At Version?  indicates that the requested asset is at the requested version
  No Prior?    indicates that no *destructive* reservations are curretnly scheduled
               prior to the requested reservation
END_OF_STRING
  end

  private
  
end
