import pandas as pd
import streamlit as st
from database import view_all_data, view_only_ids, get_data, add_confirmed_request

def read_req(logged_in_admin):
  result = view_all_data("event_requests")
  df = pd.DataFrame(result, columns=['Request ID', 'User ID', 'Theme', 'Venue', 'Date'])  
  st.dataframe(df)

  list_of_requests = [i[0] for i in view_only_ids("event_requests", "req_id")]
  selected_req = st.selectbox("Select request or add new:", list_of_requests+['Add new event'])
  if selected_req != 'Add new event':
    selected_result = get_data("event_requests", "req_id", selected_req)
  else:
    selected_result = [["Create event ID", "Add user ID", "Add a theme", "Add a venue", "Add a date", "Add admin ID"]]

  if selected_result:
    req_id = selected_result[0][0]
    user_id = selected_result[0][1]
    theme = selected_result[0][2]
    venue = selected_result[0][3]
    date = selected_result[0][4]
    admin_id = logged_in_admin

    col1, col2 = st.columns(2)
    with col1:
      new_user_id = st.text_input("User ID:", user_id)
      new_theme = st.text_input("Theme:", theme)
      if selected_req == 'Add new event': #Change to maximum +1 instead of manual entry
        event_id = st.text_input("Event ID", req_id)
      else:
        event_id = req_id
    with col2:
      new_venue = st.text_input("Venue:", venue)#make dropdown with selected venues
      new_date = st.text_input("Date:", date)#make date input
      new_admin_id = st.text_input("Admin ID:", admin_id)

    if st.button("Add to confirmd events"):
      add_confirmed_request(event_id, new_user_id, new_theme, new_venue, new_date, new_admin_id)
      st.success("Successfully added refresh to view accurate data")


