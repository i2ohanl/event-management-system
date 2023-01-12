import pandas as pd
import streamlit as st
from database import view_all_data

def read():
  result = view_all_data("event_requests")
  df = pd.DataFrame(result, columns=['Request ID', 'User ID', 'Theme', 'Venue', 'Date'])
  with st.expander("View all Trains from Train_348"):
    st.dataframe(df)