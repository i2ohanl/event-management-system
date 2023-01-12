import mysql.connector

mydb = mysql.connector.connect(
  host = "localhost",
  user = "root",
  password = "",
  database = "event_management"
)
c = mydb.cursor()

def view_all_data(tablename):
  c.execute(f"SELECT * FROM {tablename}")
  data = c.fetchall()
  return data

def view_all_data_conf(tablename):
  c.execute(f"SELECT * FROM {tablename} WHERE event_date > SYSDATE()")
  data = c.fetchall()
  return data

def view_only_ids(tablename, id):
  c.execute(f"SELECT {id} FROM {tablename}")
  data = c.fetchall()
  return data

def get_data(tablename, id, selected):
  c.execute(f"SELECT * FROM {tablename} WHERE {id} = {selected}")
  data = c.fetchall()
  return data

def add_confirmed_request(event_id, user_id, theme, venue, date, admin_id):
  c.execute(f"INSERT INTO event_confirmed VALUES ({event_id},'{user_id}','{theme}','{venue}','{date}','{admin_id}')")
  mydb.commit()

def delete_event(event_id):
  c.execute(f'DELETE FROM decor_order WHERE event_id = {event_id}')
  c.execute(f'DELETE FROM caterer_order WHERE event_id = {event_id}')
  c.execute(f'DELETE FROM bill WHERE event_id = {event_id}')
  c.execute(f'DELETE FROM event_confirmed WHERE event_id = {event_id}')
  mydb.commit()

def edit_event_data(event_id, user_id, theme, venue, date, admin_id, new_user_id, new_theme, new_venue, new_date, new_admin_id):
  c.execute(f"UPDATE event_confirmed SET user_id = '{new_user_id}', theme = '{new_theme}', venue = '{new_venue}', event_date = '{new_date}', admin_id = '{new_admin_id}' WHERE event_id = {event_id}")
  mydb.commit()

def get_monetary():
  c.execute("SELECT SUM(catering), SUM(decor), SUM(services) from bill")
  data = c.fetchall()
  return data

