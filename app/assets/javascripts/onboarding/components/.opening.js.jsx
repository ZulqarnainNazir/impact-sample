// import React, { PropTypes } from 'react'

class HourAdd extends React.Component {

  render() {
    return (
      <tr>
        { opening.by_appt ? (
          <td>
            <%= form.time_select :opens_at, ampm: true, minute_step: 5, default: { hour: 8, min: 0 }, class: 'form-control', disabled: true)) %>
          </td>
          <td>
            <%= form.time_select :closes_at, ampm: true, minute_step: 5, default: { hour: 17, min: 0 }, class: 'form-control', disabled: true)) %>
          </td>
        ):(
          <td>
            <%= form.time_select :opens_at, ampm: true, minute_step: 5, default: { hour: 8, min: 0 }, class: 'form-control')) %>
          </td>
          <td>
            <%= form.time_select :closes_at, ampm: true, minute_step: 5, default: { hour: 17, min: 0 }, class: 'form-control')) %>
          </td>
        )}

        <td>
          <%= form.label :by_appt, class: 'btn btn-sm btn-default checked-highlight' do %>
            <%= form.check_box :by_appt, :onclick => "var that=this;setTimeEnabled(that);")) %>
            By Appointment
          <% end %>
        </td>
        <td>
          <%= form.label :sunday, class: 'btn btn-sm btn-default checked-highlight' do %>
            <%= form.check_box :sunday)) %>
              Su
            <% end %>
          <%= 3)) %>
        </td>
        <td>
          <% 4 = form.label :monday, class: 'btn btn-sm btn-default checked-highlight' do %>
            <%= form.check_box :monday)) %>
              Mo
            <% end %>
          <%= 4)) %>
        </td>
        <td>
          <% 5 = form.label :tuesday, class: 'btn btn-sm btn-default checked-highlight' do %>
            <%= form.check_box :tuesday)) %>
              Tu
            <% end %>
          <%= 5)) %>
        </td>
        <td>
          <% 6 = form.label :wednesday, class: 'btn btn-sm btn-default checked-highlight' do %>
            <%= form.check_box :wednesday)) %>
              We
            <% end %>
          <%= 6)) %>
        </td>
        <td>
          <% 7 = form.label :thursday, class: 'btn btn-sm btn-default checked-highlight' do %>
            <%= form.check_box :thursday)) %>
              Th
            <% end %>
          <%= 7)) %>
        </td>
        <td>
          <% 8 = form.label :friday, class: 'btn btn-sm btn-default checked-highlight' do %>
            <%= form.check_box :friday)) %>
              Fr
            <% end %>
          <%= 8)) %>
        </td>
        <td>
          <% 9 = form.label :saturday, class: 'btn btn-sm btn-default checked-highlight' do %>
            <%= form.check_box :saturday)) %>
              Sa
            <% end %>
          <%= 9)) %>
        </td>
        <td>
          <% 10 = form.label :_destroy, class: 'btn btn-sm btn-default' do %>
            <%= form.check_box :_destroy)) %>
              <span class="sr-only">Destroy</span>
              <i class="fa fa-trash-o"></i>
            <% end %>
          <%= 10)) %>
        </td>
      <% end %>
      </tr>

    );
  }
}
