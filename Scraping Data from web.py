#!/usr/bin/env python
# coding: utf-8

# In[1]:


from bs4 import BeautifulSoup
import requests


# In[2]:


url = 'https://en.wikipedia.org/wiki/List_of_IT_consulting_firms'


# In[3]:


page = requests.get(url)


# In[4]:


soup = BeautifulSoup(page.text, 'html')


# In[5]:


soup.find_all('table')[1]


# In[6]:


table = soup.find_all('table')[1]


# In[7]:


headers = table.find_all('th')


# In[12]:


headers


# In[14]:


strip_headers = [title.text.strip() for title in headers]
strip_headers


# In[15]:


import pandas as pd


# In[17]:


df = pd.DataFrame(columns = strip_headers)


# In[18]:


df


# In[20]:


column_data = table.find_all('tr')
column_data


# In[26]:


for row in column_data[1:]:
    row_data = row.find_all('td')
    print(row_data)


# In[23]:


for row in column_data[1:]:
    row_data = row.find_all('td')
    individual_row_data = [data.text.strip() for data in row_data]
    print(individual_row_data)


# In[24]:


for row in column_data[1:]:
    row_data = row.find_all('td')
    individual_row_data = [data.text.strip() for data in row_data]
    
    length = len(df)
    df.loc[length] = individual_row_data


# In[25]:


df


# In[ ]:




