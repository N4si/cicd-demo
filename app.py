from flask import Flask
from urllib.parse import quote  # Import quote from urllib.parse

app = Flask(__name__)

@app.route("/")
def hello():
    # Use the quote function from urllib.parse
    return quote("Hello CI CD World!")

if __name__ == "__main__":
    app.run(host='0.0.0.0', port=8080)
