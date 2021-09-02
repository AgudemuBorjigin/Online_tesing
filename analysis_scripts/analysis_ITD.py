#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""
Created on Tue Aug 18 13:11:59 2020

@author: Agudemu
"""
import json
import numpy as np
import matplotlib.pyplot as plt
import scipy.io

def subj_index(data, subj):
    for i in range(len(data)):
        if data[i][0]['subject'] == subj:
            index_subj = i
    return index_subj
def last_instruction_index(data_subj):
    for i in range(len(data_subj)):
        if data_subj[i]['trial_type'] == 'html-button-response':
            index = i
    return index
def find(s, ch):
    return [i for i, ltr in enumerate(s) if ltr == ch]
def figure(x, y):
    plt.plot(x, y, 'o-')
    plt.xlabel('ITD [us]')
    plt.ylabel('Percent Correct')
    plt.grid(color='r', linestyle='--', linewidth=0.5)
def sortData(subjList, data, itds):
    subj_bad = []
    subjIndexList = np.zeros((len(subjList),), dtype=int)
    for si, subj in enumerate(subjList):
        subjIndexList[si] = subj_index(data, subj)
    subjNames = []
    data_fit = np.zeros((len(subjIndexList), len(itds), 3))
    counters_all = np.zeros((len(itds),), dtype=int)
    corrects_all = np.zeros((len(itds),), dtype=int)
    for si, subj_num in enumerate(subjIndexList):
        data_subj = data[subj_num]
        counters_single = np.zeros((len(itds),), dtype=int)
        corrects_single = np.zeros((len(itds),), dtype=int)
        subjNames.append(data_subj[0]['subject'])
        counter_easy = np.zeros((1,), dtype=int)
        correct_easy = np.zeros((1,), dtype=int)
        idx_first_trial = last_instruction_index(data_subj) + 1
        for i, data_trial in enumerate(data_subj[idx_first_trial:]):
            if data_trial['button_pressed']:
                annot = data_trial['annot']
                index = find(annot, "'")
                itd = int(annot[index[2]+1:index[3]-2])
                correct = data_trial['correct']
                easy = data_trial['cond']
                subj = data_trial['subject']
                # rt = data_trial['rt']
                if itd != 1: # only a few followup runs included 1 us
                    counters_single[np.where(itds == itd)[0][0]] += 1
                    counters_all[np.where(itds == itd)[0][0]] += 1
                    if correct:
                        corrects_single[np.where(itds == itd)[0][0]] += 1
                        corrects_all[np.where(itds == itd)[0][0]] += 1
                    if easy == 1:
                        counter_easy += 1
                        if correct:
                            correct_easy += 1
        score_easy = correct_easy/counter_easy
        data_fit[si] = np.stack((20*np.log10(itds), corrects_single, counters_single), axis = -1)
        if score_easy < 0.75:
            subj_bad.append(subj)
    scores_all = corrects_all/counters_all
    return data_fit, subjNames, subj_bad, scores_all
##########################################################
# all subjects
##########################################################
subjList = ['5f10e4279df7fd42944120f3',
            '5ed427e3bcd0c00b58a177c0',
            '5ec99d7b36e0214b2f821627',
            '5eaefec7c1324e5def56caf8',
            '5ea3629da460652f1052eca1',
            '5e307edef5abed05e1736185',
            '5ddc516e82a527bc2397e6e1',
            '5d5069303945ac00012780b7',
            '5caf93416ef0d1001c761380',
            '5cabaa10ed17090015e1eb75',
            '5c1443d21f6f150001494f6a',
            '5b4c4e67a23b2d00017f7029',
            '5b1b75312767e20001e506ec',
            '5a348ea750833c0001ee9550',
            '599e08a45a2c6c0001322a7c', 
            '5ea49733ad3e962d73cc0238',
            '5d5f07cdca10e90016bc0103',
            '5eb2d579ed24d507082b07a2',
            '5ea714d0ba872d0cc55cdd79',
            '5dc59aea37023940a0860dea',
            '5f107aa051372032695c8e2f',
            '5d74001d391b6600175f433b',
            '5ec76194079cdc1b61767c3b',
            '5e2926d80beb030ede110e67',
            '5e968c1e95b8161112136269',
            '5ec48981bc7291376f2e278e',
            '5d67d4393fcbbc0019f3e1a4',
            '5e2ac2aa0038f21089a533a4',
            '5d76d2f7daf4bf00164d585b',
            '5ebd841ddea21b08a0aa3057',
            '5ef51de92a8ed116654bc910',
            '5e56b9744c97910670a6c6dc',
            '5ef3ba9bfa42131455ca9d80',
            '5eb26beeb17a8c3ad914da22',
            '5d0168586ba167000165ed1f',
            '5f08916db314750bc9206ce8',
            '5d88f010859c9e0001810e88',
            '5dd6d370194e486498e13ab6',
            '5eb5aa23a1bdb348304ec7d7',
            '5c341b3a21f99c000175f65b',
            '5f0523936e93408277d06897',
            '5c5aecc774a76f0001a25ced',
            '5a947fb0f05361000171b5a3',
            '5b6a87d2cda8590001db8e07',
            '5c6fb7c3c114eb00018b3154',
            '5c732f631388ff0001100e6d',
            '5dc47ddd034b45342d3b2e3a',
            '5e9b443223881d04be740737',
            '5ef10fcd68a53e4a87ff6e01',
            '5db103ed236ef00013611a6f',
            '5e89ce643ac81466c24cb5d8',
            '5e8a4368e44c216e867af46b',
            '5c5fc0136467ac0001b80940',
            '5ddd92855daaa6d095854780',
            '5ef831c97dcd65573bbb0649',
            '5e6685e1ffed4c405a4db5d0',
            '5b0f818d444cef0001ca989b',
            '5ef90b249bafa50a311593ae', 
            '5eda898eca52056a641c3fb2',
            '5d8767e3810e200001b91afb',
            '5ea77b0161f86b151f475c8f',
            '5e820eb36551aa02fd72e1dc',
            '5ad7835e9c198c0001fad31a',
            '5dbdbc9da319ab2ecf2a0887',
            '5eed22ef1537c7128cca6aaa',
            '5e500ab1ec45d305b6b82d9f',
            '5e1feef63e3358314e1f5154',
            '5dffc4b8f9e750be9cd65c07',
            '5e495dfd5ea85e3d1eb14d4b',
            '5e9c000ef06bc710ceb95c6a',
            '5c4ea7c3889752000156ddc5',
            '5e687fc5651f7d1259eac113',
            '5dea9fb3cb53ca1cda9f6116',
            '5d8e79ccd0e8b9001846e8a8',
            '5ef2405ee4dd3e8f6da1779b',
            '5dc1c27fb3e5c212018d9e33',
            '5e2a425609072a0abb76094b',
            '5e7daa886c123242e86c8138',
            '5dda51f040460e9a0f5f6a70',
            '5d86c09df681a1001a8dddc8',
            '5ea8fe56a6d1a135a5a442cd',
            '5e8e5540e2ac91100d13533d', 
            '5e548644467c4e496a933633',
            '5c5b319722bdd70001afc3ed',
            '5f055b6ca28292863f750383',
            '5ea90de5a5bad5377430424a',
            '5d0f9b5a905351000124f56c',
            '5e7f4d2ad29f7560f032abb9',
            '5f0630393d7668176c72d5ab',
            '5efc74d0aa189600088be26a',
            '58f3760092ac81000154f8af',
            '5ddf1fb32c5c10e8e9ee910d',
            '5ee6fc62447e98486758afc6',
            '5c024be169406e00014e0b8e',
            '5a04869ff2e3460001edad2e',
            '5eaf1a2c649fd108284c2b5f',
            '57950da04a84da00014c5dbb',
            '5aea88ec1aff900001cc0e55',
            '5e164e81502213c397f0cf39',
            '5ea492e3b1b3620a6fee3b90',
            '5eeaff28cf5da71d691ef212',
            '5dc592c6aa431440aa755d5b',
            '5e53497a059e37368a22933a',
            '5b9eddfed259900001106b05',
            '5eb81d360943fe74d6aba62b',
            '5d100e740277ff00152f7562',
            '5c732f245858a100013f6f03',
            '5d78647e4dadc9001a3e34dd',
            '5e4a28f9d897cf49bb42a41c',
            '5d7499693e40c60001081af3',
            '5ec37264194de71cb7b82637',
            '5dd3e3cd5daaa63c5fdb7bb8',
            '5e9a567a22a6fa0ee4cf44f1',
            '5be4ad0aff68b30001975464',
            '5ebf5b96f621931e939dc6e9',
            '5ed56377e4f0740d597fd319',
            '5dca5a06880a2973c5af50a9',
            '5e72cb561b6e9c21954bd7da',
            '5c02ae85b5dd6600019de021',
            '5d847ac9be4b0b00188463d7',
            '583f02c8ca2e57000184353c',
            '5ec5ba3e981556631c1a78ba',
            '5e68691662358c10f5adb901',
            '5efe33b14177723069d82cfd',
            '5c08c9f3217d600001117a08',
            '5e439c635bb25721c1b00b36',
            '5de8695380e0fc7e7ac9f271',
            '5ef411225a5e591d15fda2ec',
            '5e9be431770087106829bec7',
            '5e175705cfe8dc000b559793',
            '5e26a04f727e048d3e0b9459',
            '5f091e52be0f361aff1d0101',
            '5e3adfc595ff562fbdd130fa',
            '5dd6329b8062875cbb664f2d',
            '5ee6706034f12e3d82d952aa',
            '56b3edf12bac74000d89e452',
            '5b83093a3c137500019982b6',
            '5d453e8723a5bb0001492546',
            '5f690f742f60ad0e80c1c605',
            '5e28e8730fd86a0a19e084cd',
            '5f9503492c2f0e3659637ac7',
            '5f4813c94e8b081877fb26a6',
            '5f3d49c430715f09ebb6389e',
            '5c11f8202b16ba0001c8b764',
            '5eff15e5d3dd7a0548a0ce69',
            '5f2daab26e6e930b7efa5e43',
            '5f8d0558bd0a154b41c49685',
            '5e274886bcb84f052bf6858f',
            '59ad6f1e09709e00013c2ba5',
            '5f724539c03c5415829579a6',
            '5d945ad02d58dc00195ead79',
            '5f2a60df200d1e259031ed42',
            '5d6325d535218100017210a2',
            '5e78232c1bb39e3b17214864',
            '5aa8ebf089de8200013f8c48',
            '5f40844f08e4b91ce5dee945',
            '5d67476c0ca617001699fe7a',
            '5fb1084831618e53f82757ca',
            '5c75419284e176001254c7a5',
            '58e95834f3f183000171167a',
            '5f6e72f4f0d70a3c02af4ee6',
            '5fc8238b27fabf1424887d5f',
            '5d9e9aa245283100163122c5',
            '5c5256bb6543bc0001849599',
            '5f62498a23e52627a1dbda93',
            '5fc43238cc6b72502918fa5d',
            '5f97f6c90133ea030241e683',
            '5cb7d2f8f0e73600180b9555',
            '5f325ad3c8616a1b5f8c7bd4',
            '5ec7fe6a3e940a29c1e03dc6',
            '5ec62b74defeea6a5ad13838',
            '5cfcb6122cd514000171cd1a',
            '5ed3f00ea714392764b29f2e',
            '5c2805401d4eb70001177bfc',
            '5db14f079975f80012855001',
            '5fa6006c1355231e6094a472',
            '5f59a01cc5b24320685f5ecf',
            '5cf020b3fc94fd0001196691',
            '5ded93be57639a44a303bf4e',
            '5ed40dab8680192984d2aa98-2ndTry',
            '5ea185e9a7816803c6436095',
            '5eaa6db32b140420243a7b41',
            '5d5f4f294d55db0016ed4612',
            '5f9df5f72aca47392dc49b65',
            '5f63d462fb4c4713b69d4bb7',
            '5825ecee95f3030001cf889a',
            '5fadd628cd4e9e1c42dab969',
            '5e975c32ca82b62079dc8f7c',
            '596f003434773e0001fc0d28',
            '5fc6bf0582ff63099b3f5317',
            '5d25e4c103aae8001b6552ef',
            '5f23168ae0d0d0074122da0f',
            '5c994ca30225a000167bd288',
            '5f05056acc8d327f2948bbc0',
            '5f516d96bf6cde3b04b94b69',
            '5e683c4d6ca0f9000d3f35fe',
            '5ab4149e0527ba0001c1656e',
            '5de1986c040f531f97eb6092',
            '5c2f9cddc5459b0001bae5b3',
            '5ea20bb3c2a8ea109cc6ee41',
            '56e61dfff7957b000d18e425']
# echo-ref missing: 5e90a1eaad04060882d17a3d 
# poor echo-ref: 5a84f454ae9a0b0001a9e4e5
# poor WiN: 5c7ead380ce9a10016fb5ebf
# ITD missing: 5ed40dab8680192984d2aa98
# poor ITD: (5e741a09b23f4d392d8eac07), 56e61dfff7957b000d18e425,
#           (598229ae2c089000019643d8), (5b78542ef642ed0001517ca0), (5df5767076c03b3e5a958413),
#           (5d62886927a84f00010fbbb4), 5c285036da51990001e2fe75, (5f8e2a9201810e1f2b9f63a2)
# ILD missing: 
# poor ILD: (598229ae2c089000019643d8), 5c2f9cddc5459b0001bae5b3
# FM missing: 5ed40dab8680192984d2aa98
# poor FM: 
# paranthesis means poor after re-test
##########################################################
#
##########################################################
itds = np.array([2, 4, 8, 16, 32, 64, 128])
jsonName = 'ITD_results.json'
f = open(jsonName, 'r')
data = json.load(f)
data_fit, subjNames, subj_bad, scores_all = sortData(subjList, data, itds)
figure(itds, scores_all)  
scipy.io.savemat('data_ITD.mat', dict(data = data_fit, subjNames = subjNames)) 
f.close