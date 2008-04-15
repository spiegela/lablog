module ActivationsHelper
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

  def reservation_id_form_column(record, input_name)
  end

  def user_id_form_column(record, input_name)
  end
end
