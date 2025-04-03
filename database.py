from dotenv import load_dotenv
import os

def connectdatabase():
  load_dotenv()
  conn = pymysql.connect(
    host='localhost',
    user='root',
    password=os.getenv("PASSWORD"),
    db='borealis',
    charset='utf8')
  return conn
