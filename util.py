from dotenv import load_dotenv
import os, hashlib, pymysql

BASE_DIR = os.path.dirname(os.path.abspath(__file__))
dotenv_path = os.path.join(BASE_DIR, '.env/local.env')

def connection_database():
  """connection à la base de donnée sql.
        Returns:
            La connection à la base de donnée."""
  load_dotenv(dotenv_path)
  connection = pymysql.connect(
    host='localhost',
    user='root',
    password = os.getenv('PASSWORD'),
    db='borealis',
    charset='utf8')

  return connection

def hacher(mot_de_passe):
  """Hache un mot de passe en utilisant l'algorithme SHA-256.

      Cette fonction prend un mot de passe comme entrée et retourne
      son hash SHA-256.

      Args:
          mot_de_passe (str): Le mot de passe à hacher.

      Returns:
          str: Le hash SHA-256 du mot de passe."""
  return hashlib.sha256(mot_de_passe.encode()).hexdigest()
