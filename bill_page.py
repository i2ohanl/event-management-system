import pandas as pd
import streamlit as st
from database import view_all_data

def bills():
  result = view_all_data("bill")
  df = pd.DataFrame(result, columns=["event ID", 'User ID', 'admin ID', 'Catering', 'Decorr', 'Services', 'Total', 'Status'])  
  with st.expander("View all bills"):
    st.dataframe(df)

  