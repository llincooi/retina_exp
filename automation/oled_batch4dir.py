#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""
Created on Sat Sep 22 15:35:31 2018

@author: nghdavid
"""
movie_list = []#Movies we are going to play
movie_list_UD = []
movie_list_UR_DL = []
movie_list_UL_DR = []
times = []#Each movie time
r = open('play_list.txt','r')#Today arrangement

#Read file
for line in r:
    l = line.split(' ')
    movie_list.append(l[0])
    if l[0].find('RL') == -1:
        movie_list_UD.append(l[0])
        movie_list_UR_DL.append(l[0])
        movie_list_UL_DR.append(l[0])
    else:
        movie_list_UD.append(l[0][:l[0].find('RL')]+'UD'+l[0][l[0].find('RL')+2:])
        movie_list_UR_DL.append(l[0][:l[0].find('RL')]+'UR_DL'+l[0][l[0].find('RL')+2:])
        movie_list_UL_DR.append(l[0][:l[0].find('RL')]+'UD_RL'+l[0][l[0].find('RL')+2:])
    times.append(int(l[1]))
    
f_RL = open('RL.bat','w')
f_UD = open('UD.bat','w')
f_UR_DL = open('UR_DL.bat','w')
f_UL_DR = open('UL_DR.bat','w')
f_list = [f_RL, f_UD, f_UR_DL, f_UL_DR]

r_list = [open('RLplay_list.txt','w'), open('UDplay_list.txt','w'), open('UR_DLplay_list.txt','w'), open('UL_DRplay_list.txt','w')]
movie_list_list = [movie_list, movie_list_UD, movie_list_UR_DL, movie_list_UL_DR]
#Pull up board
servo_up = 'powershell "$port= new-Object System.IO.Ports.SerialPort COM3,9600,None,8,one; $port.open(); $port.WriteLine("180"); $port.Close()"'
#Pull down board
serve_down = 'powershell "$port= new-Object System.IO.Ports.SerialPort COM3,9600,None,8,one; $port.open(); $port.Writeline("0"); $port.Close()"'
start = r'psexec -u MEA -p hydrolab \\192.168.1.123 -d -l -i C:\auto\start.exe'#Start recording
end = r'psexec -u MEA -p hydrolab \\192.168.1.123 -d -l -i C:\auto\end.exe'#End recording
sleep = 'timeout /t '#Force procedure to stop for a few second(need + 'time')
play = 'START C:"\Program Files"\DAUM\PotPlayer\PotPlayerMini64.exe '#Play movie(need + 'movie_name')
matlab = r'psexec -u MEA -p hydrolab \\192.168.1.123 -s "C:\auto\diode.bat" ' #Use Daq to check whether it is played normally
dot = "'"

#Function that make each movie's batch
def play_movie(f,movie,time):
##    f.write(servo_up)#Pull up board
##    f.write('\n')

##    f.write(sleep)#Force procedure to stop 40 sec
##    f.write('10')#Adaptation time 
##    f.write('\n')


    f.write(play)#Play movie
    f.write(movie)#Name of movie
    f.write('\n')

    f.write(start)#Start recording
    f.write('\n')

    f.write(sleep)
    f.write(str(time+10))#Add 10 sec to end recording too quick
    f.write('\n')

    f.write(end)#End recording
    f.write('\n')
    
    f.write(sleep)#Force procedure to stop 40 sec
    f.write('300')#Time for retina to rest
    f.write('\n')
    
    
    return
    
#Make all batches
#Record spontaneous
for k in range(len(f_list)):
    f_list[k].write(sleep)
    f_list[k].write('60')
    f_list[k].write('\n')
    
    for i in range(len(movie_list)):
        f_list[k].write('\n')
        f_list[k].write('::')
        f_list[k].write(movie_list_list[k][i])
        f_list[k].write('\n')
        play_movie(f_list[k],movie_list_list[k][i],times[i])
        r_list[k].write(movie_list_list[k][i][:-4])
        r_list[k].write('\n')
    f_list[k].close()
    r_list[k].close()
