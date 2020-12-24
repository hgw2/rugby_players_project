from bs4 import BeautifulSoup
import requests
import re
from csv import writer

MKDIR = "../2_raw_data/"
COUNTRY = ["england", "scotland", "wales", "ireland", "france", "italy"]
TEAM_URL= ["http://en.espn.co.uk/scrum/rugby/player/caps.html?team=1",
          "http://en.espn.co.uk/scrum/rugby/player/caps.html?team=2",
         "http://en.espn.co.uk/scrum/rugby/player/caps.html?team=4",
          "http://en.espn.co.uk/scrum/rugby/player/caps.html?team=3",
          "http://en.espn.co.uk/scrum/rugby/player/caps.html?team=9",
          "http://en.espn.co.uk/scrum/rugby/player/caps.html?team=20"]
BASE_URL = "http://www.espnscrum.com"

def make_soup(url):
    html = requests.get(url).text
    return BeautifulSoup(html, "lxml")

def get_player_links(team_url):
    soup = make_soup(team_url)
    player_info = [link.get('href') for link in soup.find_all('a',href=re.compile('/rugby/player'))]
    player_links = [BASE_URL + item for item in player_info]
    for item in player_links:
        if 'team' in item:
            player_links.remove(item)
        elif 'index' in item:
            player_links.remove(item)
    del player_links[0]
    return player_links

def get_stats(soup):

    stats  = soup.find(text=re.compile('All Tests'))
    stat1  = stats.next.next.next.next.next.next
    stat2  = stats.next.next.next.next.next.next.next.next.next
    stat3  = stats.next.next.next.next.next.next.next.next.next.next.next.next
    stat4  = stats.next.next.next.next.next.next.next.next.next.next.next.next.next.next.next
    stat5  = stats.next.next.next.next.next.next.next.next.next.next.next.next.next.next.next.next.next.next
    stat6  = stats.next.next.next.next.next.next.next.next.next.next.next.next.next.next.next.next.next.next.next.next.next
    stat7  = stats.next.next.next.next.next.next.next.next.next.next.next.next.next.next.next.next.next.next.next.next.next.next.next.next
    stat8  = stats.next.next.next.next.next.next.next.next.next.next.next.next.next.next.next.next.next.next.next.next.next.next.next.next.next.next.next
    stat9  = stats.next.next.next.next.next.next.next.next.next.next.next.next.next.next.next.next.next.next.next.next.next.next.next.next.next.next.next.next.next.next
    stat10 = stats.next.next.next.next.next.next.next.next.next.next.next.next.next.next.next.next.next.next.next.next.next.next.next.next.next.next.next.next.next.next.next.next.next
    stat11 = stats.next.next.next.next.next.next.next.next.next.next.next.next.next.next.next.next.next.next.next.next.next.next.next.next.next.next.next.next.next.next.next.next.next.next.next.next
    stat12 = stats.next.next.next.next.next.next.next.next.next.next.next.next.next.next.next.next.next.next.next.next.next.next.next.next.next.next.next.next.next.next.next.next.next.next.next.next.next.next.next

    category  = soup.find(text=re.compile('Span'))
    cat1 = category.next.next.next
    cat2 = category.next.next.next.next.next.next
    cat3 = category.next.next.next.next.next.next.next.next.next
    cat4 = category.next.next.next.next.next.next.next.next.next.next.next.next
    cat5 = category.next.next.next.next.next.next.next.next.next.next.next.next.next.next.next
    cat6 = category.next.next.next.next.next.next.next.next.next.next.next.next.next.next.next.next.next.next
    cat7 = category.next.next.next.next.next.next.next.next.next.next.next.next.next.next.next.next.next.next.next.next.next
    cat8 = category.next.next.next.next.next.next.next.next.next.next.next.next.next.next.next.next.next.next.next.next.next.next.next.next
    cat9 = category.next.next.next.next.next.next.next.next.next.next.next.next.next.next.next.next.next.next.next.next.next.next.next.next.next.next.next
    cat10 = category.next.next.next.next.next.next.next.next.next.next.next.next.next.next.next.next.next.next.next.next.next.next.next.next.next.next.next.next.next.next
    cat11 = category.next.next.next.next.next.next.next.next.next.next.next.next.next.next.next.next.next.next.next.next.next.next.next.next.next.next.next.next.next.next.next.next.next
    cat12 = category.next.next.next.next.next.next.next.next.next.next.next.next.next.next.next.next.next.next.next.next.next.next.next.next.next.next.next.next.next.next.next.next.next.next.next.next

    return {cat1:stat1,cat2:stat2,cat3:stat3,cat4:stat4,cat5:stat5,cat6:stat6,cat7:stat7,cat8:stat8,cat9:stat9,cat10:stat10,cat11:stat11,cat12:stat12}





for i in range(len(COUNTRY)):



    country = COUNTRY[i]
    team_url = TEAM_URL[i]

    print(country)
    players = get_player_links(team_url)

    with open(MKDIR + country + ".csv", "w+") as csv_file:
        csv_writer = writer(csv_file)
        headers =  ["name", "born", "position", "debut", "stats"]
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

            stats = get_stats(soup)

            csv_writer.writerow([name, born, position, debut, stats])
    print("Complete")
