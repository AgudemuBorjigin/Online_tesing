#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""
Created on Tue Jul 21 12:36:57 2020

@author: Agudemu
"""
import json 
import csv

def find(s, ch):
    return [i for i, ltr in enumerate(s) if ltr == ch]

folderName_URL = 'main' # 'demo', 'main', 'demo_2'
folderName_local = 'wavFiles' # 'wavFiles', 'wavFilesDemo2', 'wavFilesDemo'
jsonName = 'trials_main_ITD.json' # 'trials_demo_ITD.json', 'trials_main_ITD.json', 'trials_demo_ITD_2.json'
taskType = '' # 'd', '', 'd_2'

data = {}
if taskType == 'd':
    data['instructions'] = ["You will be listening to a sound beep that starts from either your left side or the right side and then jumps to the other side. <p></p>Your task is to click on either <strong>left to right</strong> or <strong>right to left</strong> to indicate the moving direction", "When you are ready, click <strong>Continue</strong> to start the first sound beep."]
elif taskType == 'd_2':
    data['instructions'] = ["When you are ready, click <strong>Continue</strong>."]
else:
    data['instructions'] = ["This section is an extended version of the previous task, which is clicking on <strong>left to right</strong> or <strong>right to left</strong> to indicate the moving direction of the sound beep. <p></p>In cases where you can not tell, just give your best guess.", "When you are ready, click <strong>Continue</strong> to hear the first sound beep."]
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
        "prompt": "To begin, make sure you are in a quiet room and wearing your <strong>wired</strong> head/earphones. Let us adjust the volume before starting the test.<p> Click <strong>Continue</strong> to proceed.</p>",
        "choices": ["Continue"]
        },
        {
        "plugin": "hari-audio-button-response",
        "prompt": "Now adjust your computer volume up to a comfortable (but not too loud) level.",
        "stimulus": "https://speech-in-noise-test.s3.us-east-2.amazonaws.com/audios/ITD/demo/volume.wav",
        "choices": ["I have adjusted the volume, let's continue"]
        },
        {
        "plugin": "html-button-response",
        "prompt": "The headphones are usually marked as left/right to indicate which ear they are for. Did you make sure the right headphone is in your right ear, and the left headphone is in your left ear? It is very important for making the correct decisions.",
        "choices": ["Yes, let's continue."]
        }]
elif taskType == 'd_2':
    data['volume'] = [{
        "plugin": "html-button-response",
        "prompt": "You did not pass the screening. Let us give it another try?",
        "choices": ["Yes, let's do it."]
        },
        {
        "plugin": "html-button-response",
        "prompt": "The headphones are usually marked as left/right to indicate which ear they are for. Did you make sure the right headphone is in your right ear, and the left headphone is in your left ear? It is very important for making the correct decisions.",
        "choices": ["Yes, let's continue."]
        },
        {
        "plugin": "html-button-response",
        "prompt": "Are you in a quiet room?",
        "choices": ["Yes, let's continue"]
        },
        {
        "plugin": "hari-audio-button-response",
        "prompt": "Now adjust your computer volume up to a comfortable (but not too loud) level.",
        "stimulus": "https://speech-in-noise-test.s3.us-east-2.amazonaws.com/audios/ITD/demo_2/volume.wav",
        "choices": ["I have adjusted the volume, let's continue"]
        }]
else:       
    data['volume'] = [{
        "plugin": "html-button-response",
        "prompt": "To begin, please use the same volume as in the previous task.<p> Click <strong>Continue</strong> to proceed.</p>",
        "choices": ["Continue"]
        }, 
        {
        "plugin": "html-button-response",
        "prompt": "Is the right headphone in your right ear, and the left headphone in your left ear? It is very important!",
        "choices": ["Yes, let's continue."]
        }]
data['trials'] = []

fileURLroot = "https://speech-in-noise-test.s3.us-east-2.amazonaws.com/audios/ITD/" + folderName_URL + "/"
fileDirCSV = "/Users/Agudemu/Dropbox/Lab_SNAP/Experiment/stimulus-TFS/stage-2/peripheral/ITD_behavior/" + folderName_local + "/fileNames.csv"
#fileDirCSV = "/Users/Agudemu/Downloads/fileNames.csv"
with open(fileDirCSV) as csv_file:
    csv_reader = csv.reader(csv_file, delimiter=',')
    row_count = 0
    for row in csv_reader:
        if row_count != 0:
            fileName = row[0]
            index = find(fileName, '_')
            if int(fileName[0:index[0]-2]) > 90:
                cond = 1
            else:
                cond = 2
            data['trials'].append({
                    'plugin': "hari-audio-button-response",
                    'prompt': "In which <strong>direction</strong> did the sound travel?",
                    'choices': ['left to right', 'right to left'],
                    'answer': int(fileName[index[0]+1]),
                    'stimulus': fileURLroot + fileName,
                    'cond': cond,
                    'annot': {'ITD': fileName[0:index[0]]}
        })
        row_count += 1    
                
with open(jsonName, 'w') as outfile:
    json.dump(data, outfile)