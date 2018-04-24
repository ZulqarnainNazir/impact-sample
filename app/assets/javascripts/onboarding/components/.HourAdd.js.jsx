// import React, { PropTypes } from 'react'

class HourAdd extends React.Component {

  render() {
    return (
      <div className="table-responsive">
        <div className="is-appended">
          <div>
            <input type="hidden" id="location_openings_attributes_56200009_opens_at_1i" name="location[openings_attributes][56200009][opens_at(1i)]" value="2018"/>
            <input type="hidden" id="location_openings_attributes_56200009_opens_at_2i" name="location[openings_attributes][56200009][opens_at(2i)]" value="4"/>
            <input type="hidden" id="location_openings_attributes_56200009_opens_at_3i" name="location[openings_attributes][56200009][opens_at(3i)]" value="19"/>
            <select id="location_openings_attributes_56200009_opens_at_4i" name="location[openings_attributes][56200009][opens_at(4i)]">
              <option value="00">12 AM</option>
              <option value="01">01 AM</option>
              <option value="02">02 AM</option>
              <option value="03">03 AM</option>
              <option value="04">04 AM</option>
              <option value="05">05 AM</option>
              <option value="06">06 AM</option>
              <option value="07">07 AM</option>
              <option value="08" selected="selected">08 AM</option>
              <option value="09">09 AM</option>
              <option value="10">10 AM</option>
              <option value="11">11 AM</option>
              <option value="12">12 PM</option>
              <option value="13">01 PM</option>
              <option value="14">02 PM</option>
              <option value="15">03 PM</option>
              <option value="16">04 PM</option>
              <option value="17">05 PM</option>
              <option value="18">06 PM</option>
              <option value="19">07 PM</option>
              <option value="20">08 PM</option>
              <option value="21">09 PM</option>
              <option value="22">10 PM</option>
              <option value="23">11 PM</option>
            </select>
            {" : "}
            <select id="location_openings_attributes_56200009_opens_at_5i" name="location[openings_attributes][56200009][opens_at(5i)]">
              <option value="00" selected="selected">00</option>
              <option value="05">05</option>
              <option value="10">10</option>
              <option value="15">15</option>
              <option value="20">20</option>
              <option value="25">25</option>
              <option value="30">30</option>
              <option value="35">35</option>
              <option value="40">40</option>
              <option value="45">45</option>
              <option value="50">50</option>
              <option value="55">55</option>
            </select>
          </div>
          <div>
            <input type="hidden" id="location_openings_attributes_56200009_closes_at_1i" name="location[openings_attributes][56200009][closes_at(1i)]" value="2018"/>
            <input type="hidden" id="location_openings_attributes_56200009_closes_at_2i" name="location[openings_attributes][56200009][closes_at(2i)]" value="4"/>
            <input type="hidden" id="location_openings_attributes_56200009_closes_at_3i" name="location[openings_attributes][56200009][closes_at(3i)]" value="19"/>
            <select id="location_openings_attributes_56200009_closes_at_4i" name="location[openings_attributes][56200009][closes_at(4i)]">
              <option value="00">12 AM</option>
              <option value="01">01 AM</option>
              <option value="02">02 AM</option>
              <option value="03">03 AM</option>
              <option value="04">04 AM</option>
              <option value="05">05 AM</option>
              <option value="06">06 AM</option>
              <option value="07">07 AM</option>
              <option value="08">08 AM</option>
              <option value="09">09 AM</option>
              <option value="10">10 AM</option>
              <option value="11">11 AM</option>
              <option value="12">12 PM</option>
              <option value="13">01 PM</option>
              <option value="14">02 PM</option>
              <option value="15">03 PM</option>
              <option value="16">04 PM</option>
              <option value="17" selected="selected">05 PM</option>
              <option value="18">06 PM</option>
              <option value="19">07 PM</option>
              <option value="20">08 PM</option>
              <option value="21">09 PM</option>
              <option value="22">10 PM</option>
              <option value="23">11 PM</option>
            </select>
            {" : "}
            <select id="location_openings_attributes_56200009_closes_at_5i" name="location[openings_attributes][56200009][closes_at(5i)]">
              <option value="00" selected="selected">00</option>
              <option value="05">05</option>
              <option value="10">10</option>
              <option value="15">15</option>
              <option value="20">20</option>
              <option value="25">25</option>
              <option value="30">30</option>
              <option value="35">35</option>
              <option value="40">40</option>
              <option value="45">45</option>
              <option value="50">50</option>
              <option value="55">55</option>
            </select>
          </div>
        </div>
      </div>
    );
  }
}

/*
<script type="text/javascript">
  var setTimeEnabled = function(received_this){
    var el = $(received_this)
    var opens = el.parent().parent().parent().children()[0]
    var closes = el.parent().parent().parent().children()[1]

    openselects = opens.getElementsByTagName("SELECT")
    closeselects = closes.getElementsByTagName("SELECT")

    openselects[0].disabled=el.context.checked;
    openselects[1].disabled=el.context.checked;
    closeselects[0].disabled=el.context.checked;
    closeselects[1].disabled=el.context.checked;

  }
</script>
*/
