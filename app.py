from flask import Flask, render_template

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

@app.route('/search')
def search():
    return render_template('search.html')

@app.route('/item')
def item():
    return render_template('item.html')

@app.route('/cart')
def cart():
    return render_template('cart.html')

@app.route('/checkout')
def checkout():
    return render_template('checkout.html')

@app.route('/order')
def order():
    return render_template('order.html')

@app.errorhandler(404)
def page_not_found(e):
    error_title = "Not Found"
    error_msg = "That page doesn't exist"
    return render_template('404.html',
                           error_title=error_title,error_msg=error_msg), 404

if __name__ == '__main__':
  app.run()
