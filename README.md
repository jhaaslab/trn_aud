# Projection from the Amygdala to the Thalamic Reticular Nucleus Amplifies Cortical Sound Responses
This is the code to simulate the 3-cell Hodgkin-Huxley model of TRN-MGB-A1 circuit to suggest an explanation for experimental data from Dr. Maria Geffen's lab (University of Pennsylvania). This is a collaboration between Dr. Maria Geffen's lab (University of Pennsylvania) and Dr. Julie Haas' lab (Lehigh University). The results of the simulation correspond to Figure 4 in the following paper:  
*Title*: **Projection from the Amygdala to the Thalamic Reticular Nucleus Amplifies Cortical Sound Responses**   
Link to paper on *Cell Reports*: https://www.ncbi.nlm.nih.gov/pubmed/31315041  
Prepint on *bioRxiv*: https://www.biorxiv.org/content/10.1101/623868v1  
*Authors*: Mark Aizenberg, Solymar Rolon Martinez, Tuan Pham, Winnie Rao, Julie Haas, Maria N. Geffen

### Requirements
+ `MATLAB R2018a` (earlier might be fine, but have not tested)  
+ `NEURON` 
+ `NEURON` mechanism files from *ModelDB* (Traub et al 2005, accession number: 45539). Please refer to `simulations/NOTE.txt` for more information 

### File organization
+ `simulations` contains: 
	+ Mechanism files `*.mod` from *ModelDB* (Traub et al 2005, accession number: 45539). See more in `NOTE.txt` 
	+ Cell template files `*_template.hoc` and simulation file `simulate_aud.hoc` 
	+ Additional, `vecevent.mod` from https://raw.githubusercontent.com/Neurosim-lab/netpyne/development/doc/source/code/mod/vecevent.mod 
+ `data` contains the simulation results used in the paper 
+ `functions` contains a reader function and rate histogram function  
+ `analyze_and_plot.m` (self-explanatory)  
+ `figures` contains the plots for the data 
