from tqdm import tqdm
import math


#function to calculate the AAR in a given month
#input n is in increments of months and n=1 represents December, 2022
def aar(n):
    return math.e**(-math.e**(-(-0.5858+0.0299*n)))

#functions to calculate the amount of new AI and human posts that are made each month
#input n is in increments of months and n=1 represents December, 2022
def new_chatgpt(n):
    return round(aar(n) * (1380000) * (60.7 / (60.7 + 14 + 13.5)))

def new_gemini(n):
    return round(aar(n) * (1380000) * (13.5 / (60.7 + 14 + 13.5)))

def new_copilot(n):
    return round(aar(n) * (1380000) * (14 / (60.7 + 14 + 13.5)))

def new_human(n):
    return round((1-aar(n)) * (1380000))


#ai is which AI you want to get the average count from
#n is the month you are calculating it up to
#starting_num is the amount of starting human data at the beginning of the process

def row_avg(ai,n,starting_num):
    current_data = [(0, 0, 0) for i in range(starting_num)]

    if ai=="chat":
        row_val = 0
    elif ai=="gemini":
        row_val = 1
    else:
        row_val = 2

    def print_avg(ai,n,row_val,avgs):
        if n-1!=0:
            print(f"{ai} average at month {n-1}: {avgs[row_val]}")

    for i in tqdm(range(1,n+2)):
        new_elements = []
        chat_elements = [t[0] for t in current_data]
        gemini_elements = [t[1] for t in current_data]
        copilot_elements = [t[2] for t in current_data]
        avg_chat = sum(chat_elements)/len(chat_elements)
        avg_gemini = sum(gemini_elements)/len(gemini_elements)
        avg_copilot = sum(copilot_elements)/len(copilot_elements)
        avgs = [avg_chat, avg_gemini, avg_copilot]
        print_avg(ai, i, row_val, avgs)
        for _ in range(new_chatgpt(i)):
            new_elements.append((avg_chat + 1, avg_gemini, avg_copilot))
        for _ in range(new_gemini(i)):
            new_elements.append((avg_chat, avg_gemini + 1, avg_copilot))
        for _ in range(new_copilot(i)):
            new_elements.append((avg_chat, avg_gemini, avg_copilot + 1))
        for _ in range(new_human(i)):
            new_elements.append((0,0,0))

        current_data.extend(new_elements)



row_avg("chat", 5,678910)