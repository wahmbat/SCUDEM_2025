import math
import numpy as np
def aar(n):
    return math.e**(-math.e**(-(-0.5858+0.0299*n)))

def D(t):
    return 12 * 10**6 + 138 * 10**4 * t

def new_chatgpt(n):
    return round(aar(n) * (1380000) * (60.7 / (60.7 + 14 + 13.5)))

def new_gemini(n):
    return round(aar(n) * (1380000) * (13.5 / (60.7 + 14 + 13.5)))

def new_copilot(n):
    return round(aar(n) * (1380000) * (14 / (60.7 + 14 + 13.5)))

def new_human(n):
    return round((1-aar(n)) * (1380000))

def S(t):
    if t == 0:
        return np.array([0,0,0])
    else:
        a = np.array([new_chatgpt(t),new_gemini(t),new_copilot(t)])
        b = (new_chatgpt(t)+new_gemini(t)+new_copilot(t))*S(t-1)*(1/D(t-1))
        return a + b + S(t-1)

for i in range(100):
    print(S(i))
