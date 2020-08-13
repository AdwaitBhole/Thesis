# This script reads the odb file and compute the average stress and strain in the matrix & inclusion phases and the macroscopic response
from odbAccess import *
from abaqusConstants import *
import sys, getopt, string
from math import *
from numpy import *
from types import IntType
import os

os.chdir('..')

os.chdir('/var/tmp/3D_random')   # PLEASE ENTER THE UPDATED DIRECTORY HERE 

number_of_rve = 1

Jobs_per_rve = 25

counter_rve = 0

counter_Jobs = 0

while (counter_rve < number_of_rve):

	counter_rve = counter_rve + 1
	
	counter_Jobs = 0 
	
	while (counter_Jobs < Jobs_per_rve):
	
		counter_Jobs = counter_Jobs + 1
		
		os.chdir('/var/tmp/3D_random')		# ENTER DIRECTORY	

		if (counter_rve == 1):
			os.chdir('6')


		if (counter_Jobs == 1):
			os.chdir('1')

		if (counter_Jobs == 2):
			os.chdir('2')

		if (counter_Jobs == 3):
			os.chdir('3')

		if (counter_Jobs == 4):
			os.chdir('4')

		if (counter_Jobs == 5):
			os.chdir('5')

		if (counter_Jobs == 6):
			os.chdir('6')

		if (counter_Jobs == 7):
			os.chdir('7')

		if (counter_Jobs == 8):
			os.chdir('8')

		if (counter_Jobs == 9):
			os.chdir('9')

		if (counter_Jobs == 10):
			os.chdir('10')

		if (counter_Jobs == 11):
			os.chdir('11')

		if (counter_Jobs == 12):
			os.chdir('12')

		if (counter_Jobs == 13):
			os.chdir('13')

		if (counter_Jobs == 14):
			os.chdir('14')

		if (counter_Jobs == 15):
			os.chdir('15')

		if (counter_Jobs == 16):
			os.chdir('16')

		if (counter_Jobs == 17):
			os.chdir('17')

		if (counter_Jobs == 18):
			os.chdir('18')

		if (counter_Jobs == 19):
			os.chdir('19')

		if (counter_Jobs == 20):
			os.chdir('20')

		if (counter_Jobs == 21):
			os.chdir('21')

		if (counter_Jobs == 22):
			os.chdir('22')

		if (counter_Jobs == 23):
			os.chdir('23')

		if (counter_Jobs == 24):
			os.chdir('24')

		if (counter_Jobs == 25):
			os.chdir('25')


		odbName = 'Job-1'

		odb = openOdb(odbName + '.odb', readOnly=False)
		# define subregions
		particles = odb.rootAssembly.instances['PART-1-1'].elementSets['SET-1']
		matrix = odb.rootAssembly.instances['PART-1-1'].elementSets['SET-2']

		# store frames

		frameRepository = odb.steps['Step-1'].frames[1]  # SHOULD IT BE FRAMES [1] OR FRAMES [-1]
		Vm=0;
		Vp=0 ;
		MACRO = [0,0] ;
		Erve = [0,0,0,0,0,0] ;
		Ep = [0,0,0,0,0,0] ;
		Em = [0,0,0,0,0,0] ;
		Srve = [0,0,0,0,0,0] ;
		Sp = [0,0,0,0,0,0] ;
		Sm = [0,0,0,0,0,0] ;
		# Store the strain components at integration points in each phase
		strain = frameRepository.fieldOutputs['E']
		particleStrain = strain.getSubset(region = particles, position = INTEGRATION_POINT)
		matrixStrain = strain.getSubset(region = matrix, position = INTEGRATION_POINT)
		# Store the stress components at integration points in each phase
		stress = frameRepository.fieldOutputs['S']
		particleStress = stress.getSubset(region=particles, position=INTEGRATION_POINT)
		matrixStress = stress.getSubset(region=matrix, position=INTEGRATION_POINT)
		# Store volume of integration points in each phase
		iVolume = frameRepository.fieldOutputs['IVOL']
		particleIVolume = iVolume.getSubset(region=particles)
		matrixIVolume = iVolume.getSubset(region=matrix)


		 # Compute averages
		np = len(particleStrain.values)
		nm = len(matrixStrain.values)

		# sum over particles quantities...

		for k in range(0,np) :
		 v= particleIVolume.values[k]
		 e= particleStrain.values[k]
		 s= particleStress.values[k]
		 Vp= Vp+v.data
		 for l in range(0,6) :
		  Ep[l]= Ep[l]+(e.data[l]*v.data)
		  Sp[l]= Sp[l]+(s.data[l]*v.data)

		  # INTEGRATE THE PARTICLE VOLUME USING VOLUME OF EVERY INTEGRATION POINT

		  # DID NOT UNDERSTAND WHATS GOING ON HERE

		  # sum over matrix quantities
			
		for k in range(0,nm) :
		 v= matrixIVolume.values[k]
		 e=matrixStrain.values[k]
		 s=matrixStress.values[k]
		 Vm = Vm + v.data
		 for l in range(0,6) :
		  Em[l]=Em[l]+(e.data[l]*v.data)
		  Sm[l]=Sm[l]+(s.data[l]*v.data)

		#divide by total volume...

		v1 = Vp/(Vp+Vm)
		v0 = Vm/(Vp+Vm)

		# THIS IS TO DO THE WEIGHTED VOLUME AVERAGE OF THE INTEGRATION POINT

		for l in range(0,6) :
		 Ep[l]=Ep[l]/Vp
		 Sp[l]=Sp[l]/Vp
		 Em[l]=Em[l]/Vm
		 Sm[l]=Sm[l]/Vm
		 Erve[l] = v0*Em[l] + v1*Ep[l]
		 Srve[l] = v0*Sm[l] + v1*Sp[l]
		 print 'Erve[',l,']=', Erve[l]             
		 print 'Srve[',l,']=', Srve[l]

		print 'current volume fraction of particles: %lf' %v1
		print 'current volume fraction of matrix: %lf' %v0
		print 'v1 + v0 = %lf' %(v1+v0)
		
		
		var = 0
		
		while(var < 6):
		
		   output = str(var+1) + ' , '+ str(Erve[var])+' , '+str(Srve[var])
		   if (var == 0):
				text = output
		   else:
				text = '\n'.join([text, output])
		   var = var + 1
		
		data = file('results.dat','w')

		data.write(text)

		data.close()

		odb.close()
