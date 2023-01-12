import streamlit as st
from streamlit_option_menu import option_menu

from requests_page import read_req
from confirmed_page import read_confirmed
from bill_page import bills
from graphs import graphs

logged_in_admin = "ADMN001"

def main():
  st.title("Admin - Events")
  with st.sidebar:
    choose = option_menu("Actions", ["Add events", "View active events", "View statistics", "View bills"])

  if choose == "Add events":
    st.subheader("Requests:")
    read_req(logged_in_admin)
  elif choose == "View active events":
    st.subheader("Active events:")
    read_confirmed()
  elif choose == "View statistics":
    st.subheader("View data")
    graphs()
  elif choose == "View bills":
    st.subheader("Bill Status")
    bills()

if __name__ == "__main__":
  main()