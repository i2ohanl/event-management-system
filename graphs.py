import pandas as pd
import streamlit as st
import plotly.express as px
from database import view_all_data, get_monetary

def graphs():
  with st.expander("Themes"):
    result = view_all_data("event_confirmed")
    df = pd.DataFrame(result, columns=['Event ID', 'User ID', 'Theme', 'Venue', 'Date', 'Assigned admin'])
    task_df = df['Theme'].value_counts().to_frame()
    task_df = task_df.reset_index()
    st.dataframe(task_df)
    p1 = px.pie(task_df, names='index', values='Theme' )
    st.plotly_chart(p1)

  with st.expander("Monetary"):
    result = get_monetary()
    result = (("Service", result[0][0]), ("Decor", result[0][1]), ("Services", result[0][2]))
    df = pd.DataFrame(result, columns=["Category","Amount"])
    fig = px.bar(df, x="Category", y="Amount")
    st.plotly_chart(fig)
