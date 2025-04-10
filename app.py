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

@app.route('/accountChangePersonal/<user>', methods=['POST'])
def accountChangePersonal(user):
  try:
    newName = request.form.get('account-name')
    newSurname = request.form.get('account-surname')
    newEmail = request.form.get('account-email')
    newPhone = request.form.get('account-phone')

    connection = util.connection_database()
    cur = connection.cursor()
    cur.execute('UPDATE utilisateurs SET courriel_util = "'+newEmail+'", prenom_util = "'+newName+'", nom_util = "'+newSurname+'", telephone_util = "'+newPhone+'" WHERE uid = '+user+'')
    connection.commit()
    message = "Modification réussi."
    cur.execute('CALL AfficherInfosUtilisateur(' + user + ')')
    account = cur.fetchone()
    connection.close()
    return render_template('account.html', account=account, message=message)
  except Exception as e:
    return str(e)

@app.route('/accountChangeDelivery/<user>', methods=['POST'])
def accountChangeDelivery(user):
  try:
    newStreet = request.form.get('account-street')
    newPost = request.form.get('account-post')
    newCity = request.form.get('account-city')
    newProvince = request.form.get('account-province')
    newWarehouse = request.form.get('account-warehouse')

    connection = util.connection_database()
    cur = connection.cursor()
    cur.execute('UPDATE utilisateurs SET rue_util = "'+newStreet+'", ville_util = "'+newCity+'", code_postal_util = "'+newPost+'", province_util = "'+newProvince+'", eid_util = '+ newWarehouse+' WHERE uid = '+user+'')
    connection.commit()
    message = "Modification réussi."
    cur.execute('CALL AfficherInfosUtilisateur(' + user + ')')
    account = cur.fetchone()
    connection.close()
    return render_template('account.html', account=account, message=message)
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


@app.route('/cart/<user>')
def cart(user):
    return render_template('cart.html')

@app.route('/checkout/<user>')
def checkout(user):
    return render_template('checkout.html')

@app.route('/orders/<user>')
def order(user):
    return render_template('orders.html')

@app.errorhandler(404)
def page_not_found(e):
    error_title = "Not Found"
    error_msg = "That page doesn't exist"
    return render_template('404.html',
                           error_title=error_title,error_msg=error_msg), 404

if __name__ == '__main__':

  app.run()
