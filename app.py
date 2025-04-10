from flask import Flask, render_template, request
import pymysql, pymysql.cursors
import util
import secrets

app = Flask(__name__)

@app.route('/')
def index():
  try:
    cur = util.connection_database().cursor()
    cur.execute('SELECT P.pid, P.nom_prod, F.nom_four, P.description_prod, P.prix_prod, P.image_prod, P.categorie_prod FROM Fournisseurs F INNER JOIN Produits P ON F.fid = P.fid WHERE P.vedette = 1')
    items = cur.fetchall()
    util.connection_database().close()
    return render_template('Index.html', items=items)
  except Exception as e:
    return str(e)

@app.route('/connect')
def connect():
    return render_template('connect.html')

@app.route('/connection')
def connection():
  """non fonctionnel"""
  try:
    email = request.form.get('signin_email')
    password = hacher(request.form.get('signin_password'))
    cur = util.connection_database().cursor()
    cur.execute('SELECT U.uid FROM utilisateurs U where U.courriel_util = "'+email+'";')
    vid = cur.fetchall()
    cur.execute('select M.mdp_util from mothacher M, utilisateurs U where M.mid = "'+uid+'";')
    """mothacher a remplacer par le nom de la table de mdp"""
    mdp = cur.fetchall()
    util.connection_database().close()
    print(secrets.compare_digest(password, mdp))
  except Exception as e:
    return str(e)
  else:
    """signup ici"""
  finally:
    return index()

@app.route('/account/<user>')
def account(user):
  try:
    cur = util.connection_database().cursor()
    cur.execute('CALL AfficherInfosUtilisateur('+user+')')
    account = cur.fetchone()
    util.connection_database().close()
    return render_template('account.html', account=account)
  except Exception as e:
    return str(e)

@app.route('/search', methods=['POST'])
def search():
  try:
    searchTerm = request.form.get('search')
    itemCategory = request.form.get('category')

    cur = util.connection_database().cursor()
    if itemCategory == 'all':
      cur.execute('CALL ChercherProduitNoCategories("'+searchTerm+'")')
    else:
      cur.execute('CALL ChercherProduit("'+searchTerm+'","'+itemCategory+'")')
    items = cur.fetchall()
    util.connection_database().close()

    return render_template('search.html', nbrItems = len(items), term=searchTerm, items=items)
  except Exception as e:
    return str(e)

@app.route('/item/<itemPage>', methods=['GET', 'POST'])
def item(itemPage):
  try:
    cur = util.connection_database().cursor()
    cur.execute('SELECT P.pid, P.nom_prod, F.nom_four, P.description_prod, P.prix_prod, P.image_prod, P.categorie_prod FROM Fournisseurs F INNER JOIN Produits P ON F.fid = P.fid WHERE P.pid = '+itemPage+'')
    item = cur.fetchone()
    cur.execute('SELECT D.quantite, E.ville_entre FROM Dispoprods D INNER JOIN Entrepots E ON D.eid = E.eid WHERE D.pid = ' + itemPage + ' ORDER BY D.quantite DESC')
    dispos = cur.fetchall()
    util.connection_database().close()
    return render_template('item.html', item=item, dispos=dispos)
  except Exception as e:
    return str(e)


@app.route('/cart')
def cart():
    return render_template('cart.html')

@app.route('/checkout')
def checkout():
    return render_template('checkout.html')

@app.route('/orders')
def order():
    return render_template('orders.html')

@app.errorhandler(404)
def page_not_found(e):
    error_title = "Not Found"
    error_msg = "That page doesn't exist"
    return render_template('404.html',
                           error_title=error_title,error_msg=error_msg), 404

if __name__ == '__main__':
  util.appliquer_migrations()  # appliquer les modifications de la BD
  app.run()
