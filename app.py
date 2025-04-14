from flask import Flask, render_template, request, redirect, url_for
import util
import secrets

app = Flask(__name__)

VarGlobal = False
GlobalUser = 0

@app.route('/')
def index():
  global VarGlobal
  global GlobalUser
  try:
    cur = util.connection_database().cursor()
    cur.execute('SELECT P.pid, P.nom_prod, F.nom_four, P.description_prod, P.prix_prod, P.image_prod, P.categorie_prod FROM Fournisseurs F INNER JOIN Produits P ON F.fid = P.fid WHERE P.vedette = 1')
    items = cur.fetchall()
    util.connection_database().close()
    return render_template('Index.html', items=items, connected=VarGlobal, GlobalUser=GlobalUser)
  except Exception as e:
    return str(e)

@app.route('/connect')
def connect():
    return render_template('connect.html', connected=VarGlobal)

@app.route('/connection', methods=['POST'])
def connection():
  try:
    email = request.form.get('signin-email')
    password = util.hacher(request.form.get('signin-password'))
    connection = util.connection_database()
    cur = connection.cursor()
    cur.execute('CALL TrouverUidParEmail("'+email+'")')
    utilId = cur.fetchone()
    uid = utilId[0]
    cur.execute('''SELECT M.mdp_util FROM MotHacher M, utilisateurs U WHERE M.mid = U.uid AND M.mid = (%s)''', uid)
    mdp = cur.fetchone()
    connection.close()
    if secrets.compare_digest(password, mdp[0]):
      global VarGlobal
      VarGlobal = True
      global GlobalUser
      GlobalUser = uid
      return index()
    else:
      message = "Mauvais mot de passe."
      return render_template('connect.html', message=message, connected=VarGlobal, GlobalUser=GlobalUser)
  except Exception as e:
    return str(e)

@app.route('/inscription', methods=['POST'])
def inscription():
  try:
    prenom = request.form.get('signup-name')
    nom = request.form.get('signup-surname')
    email = request.form.get('signup-email')
    telephone = request.form.get('signup-phone')
    adresse = request.form.get('signup-street')
    codePostal = request.form.get('signup-post')
    ville = request.form.get('signup-city')
    province = request.form.get('signup-province')
    password = util.hacher(request.form.get('signup-password'))
    entrepot = request.form.get('signup-warehouse')
    connection = util.connection_database()
    cur = connection.cursor()
    cur.execute('CALL CreerCompte("'+email+'", "'+prenom+'", "'+nom+'", "'+adresse+'", "'+ville+'", "'+codePostal+'", "'+province+'", "'+telephone+'", "'+entrepot+'", "'+password+'")')
    cur.execute('SELECT M.mid FROM MotHacher M ORDER BY M.mid DESC LIMIT 1')
    id = cur.fetchone()
    global GlobalUser
    GlobalUser = id[0]
    connection.commit()
    connection.close()
    message = "Inscription réussi! Veuillez vous connectez svp"
    return render_template('connect.html', message=message, connected=VarGlobal, GlobalUser=GlobalUser)
  except Exception as e:
    return str(e)

@app.route('/account', methods=['GET', 'POST'])
def account():
  try:
    if not VarGlobal:
      return redirect(url_for('index'))
    else:
      connection = util.connection_database()
      cur = connection.cursor()
      cur.execute('CALL AfficherInfosUtilisateur('+str(GlobalUser)+')')
      account = cur.fetchone()
      connection.close()
      return render_template('account.html', account=account, connected=VarGlobal, GlobalUser=GlobalUser)
  except Exception as e:
    return str(e)

@app.route('/accountChangePersonal', methods=['POST'])
def accountChangePersonal():
  try:
    if not VarGlobal:
      return redirect(url_for('index'))
    else:
      newName = request.form.get('account-name')
      newSurname = request.form.get('account-surname')
      newEmail = request.form.get('account-email')
      newPhone = request.form.get('account-phone')

      connection = util.connection_database()
      cur = connection.cursor()
      cur.execute('UPDATE utilisateurs SET courriel_util = "'+newEmail+'", prenom_util = "'+newName+'", nom_util = "'+newSurname+'", telephone_util = "'+newPhone+'" WHERE uid = '+str(GlobalUser)+'')
      connection.commit()
      message = "Modification réussi."
      cur.execute('CALL AfficherInfosUtilisateur('+str(GlobalUser)+')')
      account = cur.fetchone()
      connection.close()
      return render_template('account.html', account=account, message=message, connected=VarGlobal, GlobalUser=GlobalUser)

  except Exception as e:
    return str(e)

@app.route('/accountChangeDelivery', methods=['POST'])
def accountChangeDelivery():
  try:
    if not VarGlobal:
      return redirect(url_for('index'))
    else:
      newStreet = request.form.get('account-street')
      newPost = request.form.get('account-post')
      newCity = request.form.get('account-city')
      newProvince = request.form.get('account-province')
      newWarehouse = request.form.get('account-warehouse')

      connection = util.connection_database()
      cur = connection.cursor()
      cur.execute('UPDATE utilisateurs SET rue_util = "'+newStreet+'", ville_util = "'+newCity+'", code_postal_util = "'+newPost+'", province_util = "'+newProvince+'", eid_util = '+ newWarehouse+' WHERE uid = '+str(GlobalUser)+'')
      connection.commit()
      message = "Modification réussi."
      cur.execute('CALL AfficherInfosUtilisateur(' +str(GlobalUser)+ ')')
      account = cur.fetchone()
      connection.close()
      return render_template('account.html', account=account, message=message, connected=VarGlobal, GlobalUser=GlobalUser)

  except Exception as e:
    return str(e)

@app.route('/search', methods=['POST'])
def search():
  try:
    searchTerm = request.form.get('search')
    itemCategory = request.form.get('category')

    connection = util.connection_database()
    cur = connection.cursor()
    if itemCategory == 'all':
      cur.execute('CALL ChercherProduitNoCategories("'+searchTerm+'")')
    else:
      cur.execute('CALL ChercherProduit("'+searchTerm+'","'+itemCategory+'")')
    items = cur.fetchall()
    connection.close()

    return render_template('search.html', nbrItems = len(items), term=searchTerm, items=items, connected=VarGlobal, GlobalUser=GlobalUser)
  except Exception as e:
    return str(e)

@app.route('/item/<itemPage>', methods=['GET', 'POST'])
def item(itemPage):
  try:
      connection = util.connection_database()
      cur = connection.cursor()
      cur.execute('CALL AfficherInfosProduit(' + str(GlobalUser) + ',' + itemPage + ')')
      item = cur.fetchone()
      cur.execute('SELECT D.quantite, E.ville_entre FROM dispoprods D INNER JOIN entrepots E ON D.eid = E.eid WHERE pid = ' + itemPage + '')
      dispos = cur.fetchall()
      connection.close()
      return render_template('item.html', item=item, dispos=dispos, connected=VarGlobal, GlobalUser=GlobalUser)
  except Exception as e:
    return str(e)


@app.route('/cart', methods=['GET', 'POST'])
def cart():
  try:
    if not VarGlobal:
      return redirect(url_for('index'))
    else:
      connection = util.connection_database()
      cur = connection.cursor()
      cur.execute('SELECT DISTINCT P.pid, P.nom_prod, F.nom_four, P.prix_prod, P.image_prod, C.qte, D.quantite FROM Produits P INNER JOIN panier C ON P.pid = C.pid INNER JOIN fournisseurs F ON P.fid = F.fid INNER JOIN dispoprods D ON P.pid = D.pid WHERE C.uid = '+str(GlobalUser)+' AND D.eid = (SELECT eid_util FROM utilisateurs WHERE uid = C.uid)')
      items = cur.fetchall()
      cur.execute('SELECT AfficherTotal('+str(GlobalUser)+')')
      price = cur.fetchone()
      connection.close()
      return render_template('cart.html', items=items, price=price, connected=VarGlobal, GlobalUser=GlobalUser)
  except Exception as e:
    return str(e)

@app.route('/addCart/<product>', methods=['GET', 'POST'])
def addCart(product):
  try:
    if not VarGlobal:
      return redirect(url_for('index'))
    else:
      quantity = request.form.get('itemAdd')
      print(quantity)
      connection = util.connection_database()
      cur = connection.cursor()
      cur.execute('SELECT qte FROM panier WHERE uid = '+str(GlobalUser)+' AND pid = '+product+'')
      panier = cur.fetchone()
      if panier is None:
        cur.execute('CALL AjouterPanier('+str(GlobalUser)+','+product+','+quantity+')')
        connection.commit()
        connection.close()
        return redirect(url_for('cart'))
      else:
        cur.execute('CALL MAJPanier(' +str(GlobalUser)+',' + product + ',' + quantity + ')')
        connection.commit()
        return redirect(url_for('cart'))
  except Exception as e:
    return str(e)

@app.route('/instantCart/<product>/<quantity>', methods=['GET', 'POST'])
def instantCart(product, quantity):
  try:
    if not VarGlobal:
      return redirect(url_for('index'))
    else:
      connection = util.connection_database()
      cur = connection.cursor()
      cur.execute('SELECT qte FROM panier WHERE uid = '+str(GlobalUser)+' AND pid = '+product+'')
      panier = cur.fetchone()
      if panier is None:
        cur.execute('CALL AjouterPanier('+str(GlobalUser)+','+product+','+quantity+')')
        connection.commit()
        connection.close()
        return redirect(url_for('cart'))
      else:
        cur.execute('CALL MAJPanier(' +str(GlobalUser)+ ',' + product + ',' + quantity + ')')
        connection.commit()

        return redirect(url_for('cart'))
  except Exception as e:
    return str(e)

@app.route('/updateQte/<product>', methods=['POST'])
def updateQte(product):
  try:
    print('itemQte'+product+'')
    newQte = request.form.get('itemQte'+product+'')
    print(newQte)
    print('MAJPanier('+str(GlobalUser)+','+product+','+newQte+')')

    connection = util.connection_database()
    cur = connection.cursor()
    cur.execute('CALL MAJPanier('+str(GlobalUser)+','+product+','+newQte+')')
    connection.commit()
    connection.close()
    return redirect(url_for('cart'))
  except Exception as e:
    return str(e)

@app.route('/deleteItemCart/<product>', methods=['GET', 'POST'])
def deleteItemCart(product):
  try:
    if not VarGlobal:
      return redirect(url_for('index'))
    else:
      connection = util.connection_database()
      cur = connection.cursor()
      cur.execute('CALL EnleverPanier('+str(GlobalUser)+','+product+')')
      connection.commit()
      connection.close()
      return redirect(url_for('cart'))

  except Exception as e:
    return str(e)

@app.route('/checkout')
def checkout():
  try:
    if not VarGlobal:
      return redirect(url_for('index'))
    else:
      connection = util.connection_database()
      cur = connection.cursor()
      cur.execute('CALL AfficherInfosUtilisateur('+str(GlobalUser)+')')
      account = cur.fetchone()
      return render_template('checkout.html', account=account, connected=VarGlobal, GlobalUser=GlobalUser)
  except Exception as e:
    return str(e)

@app.route('/passOrder', methods=['POST'])
def passOrder():
  try:
    if not VarGlobal:
      return redirect(url_for('index'))
    else:
      shipRoad = request.form.get('shipping-road')
      shipPost = request.form.get('shipping-post')
      shipCity = request.form.get('shipping-city')
      shipProvince = request.form.get('shipping-province')


      connection = util.connection_database()
      cur = connection.cursor()
      cur.execute('CALL PasserCommande('+str(GlobalUser)+',"'+shipRoad+'","'+shipCity+'","'+shipPost+'","'+shipProvince+'")')
      connection.commit()
      connection.close()
      return redirect(url_for('orders'))
  except Exception as e:
    return str(e)

@app.route('/orders')
def orders():
  try:
    if not VarGlobal:
      return redirect(url_for('index'))
    else:
      connection = util.connection_database()
      cur = connection.cursor()
      cur.execute('SELECT * FROM Commandes C WHERE C.uid = '+str(GlobalUser)+'')
      orders = cur.fetchall()
      cur.execute('SELECT C.cid, L.date_livr, C.rue_comm, C.ville_comm, C.code_postal_comm, C.province_comm, L.transporteur_livr FROM Livraisons L INNER JOIN Commandes C ON L.cid = C.cid WHERE C.uid = '+str(GlobalUser)+'')
      deliveries = cur.fetchall()
      cur.execute('SELECT DISTINCT C.cid, P.nom_prod, P.image_prod FROM produits P INNER JOIN lignecomms V ON P.pid = V.pid INNER JOIN livraisons L ON V.cid = L.cid INNER JOIN commandes C ON C.Cid = V.cid WHERE C.uid = '+str(GlobalUser)+'')
      images = cur.fetchall()
      connection.close()
      deliveryNbr = 0
      return render_template('orders.html', orders=orders, deliveries=deliveries, images=images, deliveryNbr=deliveryNbr, connected=VarGlobal, GlobalUser=GlobalUser)
  except Exception as e:
    return str(e)

@app.errorhandler(404)
def page_not_found(e):
    error_title = "Not Found"
    error_msg = "That page doesn't exist"
    return render_template('404.html', connected=VarGlobal, user=GlobalUser,
                           error_title=error_title,error_msg=error_msg), 404

if __name__ == '__main__':
  util.appliquer_migrations()  # appliquer les modifications de la BD
  app.run()
