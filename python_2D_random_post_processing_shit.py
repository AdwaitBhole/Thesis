#read selected frame results for stress and strains from the ODB file 
#M. E. Barkey

from odbAccess import *
from abaqusConstants import *
from numpy import *

import sys
from types import IntType

import os

combination = 0   

volume_ratio = 0           

Jobs = 0                  

# Start the code by setting the default directory.

os.chdir('..')

os.chdir('/var/tmp/simu_addy/2D_periodic/varying_materials/sorted_by_bulk/plane_strain')      

while (combination < 27):

	volume_ratio = 0

	combination = combination + 1

	while (volume_ratio < 1):
	    Jobs = 0
    
	    volume_ratio = volume_ratio + 1

	    os.chdir('..')	
	
	    os.chdir('/var/tmp/simu_addy/2D_periodic/varying_materials/sorted_by_bulk/plane_strain')

	    if (combination == 1):
		os.chdir('1')
		
	    if (combination == 2):
		os.chdir('2')
		
	    if (combination == 3):
		os.chdir('3')
		
	    if (combination == 4):
		os.chdir('4')
		
	    if (combination == 5):
		os.chdir('5')
		
	    if (combination == 6):
		os.chdir('6')
		
	    if (combination == 7):
		os.chdir('7')
		
	    if (combination == 8):
		os.chdir('8')
		
	    if (combination == 9):
		os.chdir('9')
		
	    if (combination == 10):
		os.chdir('10')
		
	    if (combination == 11):
		os.chdir('11')
		
	    if (combination == 12):
		os.chdir('12')
		
	    if (combination == 13):
		os.chdir('13')
		
	    if (combination == 14):
		os.chdir('14')
		
	    if (combination == 15):
		os.chdir('15')
		
	    if (combination == 16):
		os.chdir('16')
		
	    if (combination == 17):
		os.chdir('17')
		
	    if (combination == 18):
		os.chdir('18')
		
	    if (combination == 19):
		os.chdir('19')
		
	    if (combination == 20):
		os.chdir('20')
		
	    if (combination == 21):
		os.chdir('21')
		
	    if (combination == 22):
		os.chdir('22')
		
	    if (combination == 23):
		os.chdir('23')
		
	    if (combination == 24):
		os.chdir('24')
		
	    if (combination == 25):
		os.chdir('25')
		
	    if (combination == 26):
		os.chdir('26')
		
	    if (combination == 27):
		os.chdir('27')

	    # CHANGE DIRECTORY ACCORDING TO VOLUME RATIO

	    while (Jobs < 1):	
		Jobs = Jobs + 1
		
		if (Jobs == 1):
		    odbName = 'Job-1'

		odb = openOdb(odbName + '.odb', readOnly=False)

		steptoread=odb.steps['Step-1']


		frametoread=steptoread.frames[1]

		#this grabs only the S field data

		odbSelectResults = frametoread.fieldOutputs['S']

		t = odbSelectResults

		stress_text = []

		for x in t.values:
		    stress = x.data[0]
		
		    stress_text.append(stress)

		nodes_number = len(stress_text)		

		odbSelectResults_2 = frametoread.fieldOutputs['E']

		u = odbSelectResults_2

		strain_text = []

		strain_text_1 = []

		for y in u.values:

		    strain = y.data[0]

		    strain_text.append(strain)

		    strain_1 = y.data[1]

		    strain_text_1.append(strain_1)

		nodes_number_strain = len(strain_text)	

		nodes_number_strain_1 = len(strain_text_1)

		var = 0

		while(var < nodes_number):
		   output = str(var+1) + ' , '+  str(stress_text[var]) +' , '+str(strain_text[var])+' , '+str(strain_text_1[var])
		   if (var == 0):
			text = output
		   else:
		   	text = '\n'.join([text, output])
		   var = var + 1
		
		data = file('results.dat','w')

		data.write(text)

		data.close()

		odb.close()