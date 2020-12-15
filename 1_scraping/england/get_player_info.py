from bs4 import BeautifulSoup
import requests
import re
from csv import writer


england_page = "http://en.espn.co.uk/scrum/rugby/player/caps.html?team=1"

BASE_URL = "http://www.espnscrum.com"

def make_soup(url):
    html = requests.get(url).text
    return BeautifulSoup(html, "lxml")

def get_player_links(team_url):
    soup = make_soup(team_url)
    Odie = [link.get('href') for link in soup.find_all('a',href=re.compile('/rugby/player'))]
    player_links = [BASE_URL + item for item in Odie]
    for item in player_links:
        if 'team' in item:
            player_links.remove(item)
        elif 'index' in item:
            player_links.remove(item)
    del player_links[0]
    return player_links



players = get_player_links(england_page)

with open("../../2_raw_data/england/england_rugby_stats.csv", "w") as csv_file:
    csv_writer = writer(csv_file)
    headers =  ["name", "born", "position", "debut", "matches_played", "match_starts", "sub_starts", "points", "tries", "convertions", "penalties", "drop_goals", "won", "lost", "draw"]
    csv_writer.writerow(headers)

    for player in players:
        soup = make_soup(player)

        name = soup.find('div','scrumPlayerName')
        name = name.next

        born = soup.find(text=re.compile('Born'))
        born = born.next

        stats  = soup.findAll(text=re.compile('Position'))
        stats  = stats[-1]
        position = stats.next

        temp  = soup.find(text=re.compile('Test debut'))
        if temp is None:
            stats = soup.find(text=re.compile('Only Test'))
        else:
            stats = temp
        debut = stats.next.next.next


        stats  = soup.find(text=re.compile('All Tests'))
        matches_played  = stats.next.next.next.next.next.next
        match_starts  = stats.next.next.next.next.next.next.next.next.next
        sub_starts  = stats.next.next.next.next.next.next.next.next.next.next.next.next
        points = stats.next.next.next.next.next.next.next.next.next.next.next.next.next.next.next
        tries  = stats.next.next.next.next.next.next.next.next.next.next.next.next.next.next.next.next.next.next
        convertions  = stats.next.next.next.next.next.next.next.next.next.next.next.next.next.next.next.next.next.next.next.next.next
        penalties  = stats.next.next.next.next.next.next.next.next.next.next.next.next.next.next.next.next.next.next.next.next.next.next.next.next
        drop_goals  = stats.next.next.next.next.next.next.next.next.next.next.next.next.next.next.next.next.next.next.next.next.next.next.next.next.next.next.next
        won  = stats.next.next.next.next.next.next.next.next.next.next.next.next.next.next.next.next.next.next.next.next.next.next.next.next.next.next.next.next.next.next
        lost = stats.next.next.next.next.next.next.next.next.next.next.next.next.next.next.next.next.next.next.next.next.next.next.next.next.next.next.next.next.next.next.next.next.next
        draw = stats.next.next.next.next.next.next.next.next.next.next.next.next.next.next.next.next.next.next.next.next.next.next.next.next.next.next.next.next.next.next.next.next.next.next.next.next

        csv_writer.writerow([name, born, position, debut, matches_played, match_starts, sub_starts, points, tries, convertions, penalties, drop_goals, won, lost, draw])
