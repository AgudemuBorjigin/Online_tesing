#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""
Created on Thu Jun  4 08:53:09 2020

@author: Agudemu
"""
import json 
import csv
#import secrets
#hashstring = secrets.token_urlsafe(32)

folderName_URL = 'follow-up' # 'demo', 'main', 'target', 'follow-up'
folderName_local = 'wav_follow-up' # 'wav_demo', 'wav', 'wav_target', 'wav_follow-up'
jsonName = 'trials_main_follow-up.json' # 'trials_demo.json', 'trials_main.json', 'trials_demo_target.json', 'trials_main_follow-up.json'
taskType = '' # 'd', ''

def find(s, ch):
    return [i for i, ltr in enumerate(s) if ltr == ch]

def wordList(fileDir, numList):
    with open(fileDir) as csv_file:
        csv_reader = csv.reader(csv_file, delimiter=',')
        row_count = 0
        for row in csv_reader:
            row_count += 1
            if row_count == numList:
                words = row
    return words

data = {}
if taskType == 'd':
    data['instructions'] = ["To begin, make sure you are wearing your head/earphones. <p></p>Click <strong>Continue</strong> for further instructions.","You will hear a voice prompting you to select a <strong>WORD</strong>. Your task is to click on that <strong>WORD</strong>", "There will be some background noise, but try to ignore that and focus on the voice.", "When you are ready, click <strong>Continue</strong> to hear the first word."]
else:
    data['instructions'] = ["This section is an extended version of previous task, which is clicking on the <strong>WORD</strong> prompted by the voice. <p></p>In cases where you can not hear the word, just give your best guess.", "When you are ready, click <strong>Continue</strong> to hear the first word."]
data['feedback'] = True
data['holdfeedback'] = False
data['feedbackdur'] = 600
data['serveraudio'] = False
data['estimatedduration'] = 4
data['randomize'] = False
data['isi'] = 600
if taskType == 'd':
    data['volume'] = [{
        "plugin": "html-button-response",
        "prompt": "To begin, make sure you are in a quiet room and wearing your <strong>wired</strong> head/earphones. Please do not use desktop/laptop speakers or wireless head/earphones.<p> Please bring down your computer volume to 10-20% of maximum. Then, click <strong>Continue</strong> to proceed.</p>",
        "choices": ["Continue"]
        },
        {
        "plugin": "html-button-response",
        "prompt": "When you are ready, hit the <strong>Play</strong> button to play a sample sound.",
        "choices": ["Play"]
        },
        {
        "plugin": "hari-audio-button-response",
        "prompt": "Now adjust your computer volume up to a comfortable (but not too loud) level.",
        "stimulus": "https://speech-in-noise-test.s3.us-east-2.amazonaws.com/audios/wordInNoise/" + folderName_URL + "/volume.wav",
        "choices": ["I have adjusted the volume, let's continue"]
        },
        {
        "plugin": "html-button-response",
        "prompt": "We will use this volume setting for the remainder of the task. Please do not adjust the volume anymore throughout the task, to avoid the sound being too soft or too loud.<p>If this sounds OK, click <strong>Continue</strong> to begin the task.</p>",
        "choices": ["Continue"]
        },
        {
        "plugin": "html-button-response",
        "prompt": "Did you make sure the right headphone is in your right ear, and the left headphone is in your left ear? It is very important for making the correct decisions.",
        "choices": ["Yes, let's continue."]
        }]
else:     
    data['volume'] = [
        {
        "plugin": "html-button-response",
        "prompt": "Let us adjust the volume one more time for louder sounds. Please lower down your volume first.",
        "choices": ["Continue"]
        },
        {
        "plugin": "hari-audio-button-response",
        "prompt": "Now adjust your computer volume up to a comfortable (but not too loud) level.",
        "stimulus": "https://speech-in-noise-test.s3.us-east-2.amazonaws.com/audios/wordInNoise/" + folderName_URL + "/volume.wav",
        "choices": ["I have adjusted the volume, let's continue"]
        },
        {
        "plugin": "html-button-response",
        "prompt": "Is the right headphone in your right ear, and the left headphone in your left ear? It is very important!",
        "choices": ["Yes, let's continue."]
        }]
data['trials'] = []

conditions = ['anechoic', 'pitch', 'space', 'sum', 'echo', 'echo-pitch', 'echo-space', 'echo-sum', 'noise', 'echo-noise', 'ref']
fileURLroot = "https://speech-in-noise-test.s3.us-east-2.amazonaws.com/audios/wordInNoise/" + folderName_URL + "/"
fileDirCSV = "/Users/Agudemu/Dropbox/Lab_SNAP/Experiment/online_experiments/snaplabonline/audios/wordInNoise/audios/" + folderName_local + "/fileNames.csv"
fileDirCSV_wordList = "/Users/Agudemu/Dropbox/Lab_SNAP/Experiment/online_experiments/snaplabonline/audios/wordInNoise/words.csv"
with open(fileDirCSV) as csv_file:
    csv_reader = csv.reader(csv_file, delimiter=',')
    row_count = 0
    for row in csv_reader:
        if row_count != 0:
            fileName = row[0]
            index = find(fileName, '_')
            choices = wordList(fileDirCSV_wordList, int(fileName[index[1]+1:index[2]]))
            if int(fileName[index[0]+1:index[1]]) > 9:
                cond = 1
            else:
                cond = 2
            data['trials'].append({
                    'plugin': "hari-audio-button-response",
                    'prompt': "Select the <strong>word</strong> prompted by the voice",
                    'choices': choices,
                    'answer': int(fileName[index[2]+1]),
                    'stimulus': fileURLroot + fileName,
                    'cond': cond,
                    'annot': {'SNR': fileName[index[0]+1:index[1]], 'condition': fileName[0:index[0]]}
        })
        row_count += 1    
                
with open(jsonName, 'w') as outfile:
    json.dump(data, outfile)
