import pandas as pd
import streamlit as st
from database import view_all_data_conf, view_only_ids, get_data, delete_event, edit_event_data

def read_confirmed():
  result = view_all_data_conf("event_confirmed")
  df = pd.DataFrame(result, columns=['Event ID', 'User ID', 'Theme', 'Venue', 'Date', 'Assigned admin'])  
  st.dataframe(df)

  list_of_events = [i[0] for i in view_only_ids("event_confirmed", "event_id")]
  selected_event = st.selectbox("Select event", list_of_events)
  selected_result = get_data("event_confirmed", "event_id", selected_event)
  with st.expander("Update details"):

    if selected_result:
      event_id = selected_result[0][0]
      user_id = selected_result[0][1]
      theme = selected_result[0][2]
      venue = selected_result[0][3]
      date = selected_result[0][4]
      admin_id = selected_result[0][5]

    col1, col2 = st.columns(2)
    with col1:
      new_user_id = st.text_input("User ID:", user_id)
      new_theme = st.text_input("Theme:", theme)
    with col2:
      new_date = st.text_input("Date:", date)#make date input
      new_admin_id = st.text_input("Admin ID:", admin_id)
    new_venue = st.text_input("Venue:", venue)#make dropdown with selected venues

    if st.button("Update selected event"):
      edit_event_data(event_id, user_id, theme, venue, date, admin_id, new_user_id, new_theme, new_venue, new_date, new_admin_id)
      st.success("Successfully added. Refresh to view accurate data")


  with st.expander("Delete event"):
    if st.button("Confirm deletion of selected event"):
      delete_event(event_id)
      st.warning("Deleted event")
