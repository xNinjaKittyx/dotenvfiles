import argparse
import os
from bs4 import BeautifulSoup
from requests_html import HTMLSession

# If you're too lazy to do environment variables.
default_printer = "192.168.5.220"

printer = os.environ.get("PRINTER_IP", default_printer)

session = HTMLSession()

r = session.get(f"http://{printer}/")

soup = BeautifulSoup(r.text, 'html.parser')

color_levels = soup.find_all('td', class_="alignRight valignTop")

def get_color(index):
    return int(color_levels[index].text.split()[0][:-1])

black = get_color(0)
cyan = get_color(1)
magenta = get_color(2)
yellow = get_color(3)

parser = argparse.ArgumentParser()
parser.add_argument('-c', '--color', type=str, default="black", help="What color to choose. b/c/y/m")

args = parser.parse_args()

color = args.color.lower()

if color.startswith('b'):
    print(black)
elif color.startswith('c'):
    print(cyan)
elif color.startswith('m'):
    print(magenta)
elif color.startswith('y'):
    print(yellow)
else:
    raise ValueError("invalid color code.")


