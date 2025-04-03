from flask import Flask, render_template, request
import pymysql, pymysql.cursors
import util

app = Flask(__name__)

@app.route('/')
def index():
  return render_template('Index.html')

@app.route('/connect')
def connect():
    return render_template('connect.html')

@app.route('/account')
def account():
    return render_template('account.html')

@app.route('/search', methods=['POST'])
def search():
  searchTerm = request.form.get('search')
  itemCategory = '"'+request.form.get('category')+'"'

  if itemCategory == '"all"':
    cmd='SELECT DISTINCT P.nom_prod AS name, F.nom_four AS brand, P.description_prod AS description, P.prix_prod AS price, P.image_prod AS image FROM produits P INNER JOIN fournisseurs F ON P.fid = F.fid WHERE P. nom_prod LIKE "%'+searchTerm+'%" OR F.nom_four LIKE "%'+searchTerm+'%" AND P.unite_prod > 0;'
  else:
    cmd='SELECT DISTINCT P.nom_prod AS name, F.nom_four AS brand, P.description_prod AS description, P.prix_prod AS price, P.image_prod AS image, P.categorie_prod FROM produits P INNER JOIN fournisseurs F ON P.fid = F.fid WHERE P. categorie_prod = '+itemCategory+' AND P. nom_prod LIKE "%'+searchTerm+'%" OR F.nom_four LIKE "%'+searchTerm+'%" AND P.unite_prod > 0'
  cur = connection_database().cursor()
  cur.execute(cmd)
  items = cur.fetchall()

  return render_template('search.html', nbrItems = len(items), term=searchTerm, items=nested_tuple_list)

@app.route('/item')
def item():
    return render_template('item.html')

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

  app.run()
