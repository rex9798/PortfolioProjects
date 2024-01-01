
from bs4 import BeautifulSoup
import requests


url = 'https://en.wikipedia.org/wiki/List_of_IT_consulting_firms'
page = requests.get(url)

soup = BeautifulSoup(page.text, 'html')
soup.find_all('table')[1]

table = soup.find_all('table')[1]
headers = table.find_all('th')

strip_headers = [title.text.strip() for title in headers]
strip_headers

import pandas as pd
df = pd.DataFrame(columns = strip_headers)

column_data = table.find_all('tr')
column_data

for row in column_data[1:]:
    row_data = row.find_all('td')
    print(row_data)

for row in column_data[1:]:
    row_data = row.find_all('td')
    individual_row_data = [data.text.strip() for data in row_data]
    print(individual_row_data)

for row in column_data[1:]:
    row_data = row.find_all('td')
    individual_row_data = [data.text.strip() for data in row_data]
    
    length = len(df)
    df.loc[length] = individual_row_data

df





