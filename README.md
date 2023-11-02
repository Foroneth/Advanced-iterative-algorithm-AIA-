# Advanced-iterative-algorithm-AIA-
AIA algorithm for phase demodulation 

Function description:

  Matlab code for AIA
  
  [Phi] = Equal_Step_AIA(I,theta,mask) 
  
 %%
 
 I is a three-dimensional array of interferograms with phase shifts. Suppose there are three existing interferograms I1,I2,I3,Then
 
 I(:,:,1)=I1
 
 I(:,:,2)=I2
 
 I(:,:,3)=I3
 
 %%
 
 Theta is the initial phase-shift of the AIA iteration, there is no special requirement, as long as it is not 0
 
 %%
 
 The mask defines the valid and invalid parts of the interferogram, which is a two-dimensional array and it has a valid part of 1 and an invalid part of 0
