# FMH606 Master's Thesis-2019
### University of South-Eastern Norway, Faculty of Technology, Natural Sciences and Maritime Sciences, Campus Porsgrunn
## Title: Model Fitting and State Estimation for Thermal Model of Synchronous Generator
## USN supervisor: Bernt Lie, co-supervisor Thomas Øyvang
## External partner: Skagerak Kraft

This repository contains several script files that were used for producing desirable result for thesis.
The programming languages used are:
1. Modelica
2. Julia

## Model Development
It contains several models written in DAE and ODE forms. The model developed are,
1. Model 1: with *constant* specific heat capacities and resitances
2. Model 2: with *constant* specific heat capacities and *temperature dependent* resitances
3. Model 3: with *temperature dependent* specific heat capacities and *constant* resitances
   - Model 3a : with *temperature independent* specific heat capacities for heat exchanger model
   - Modle 3b : with *temperature dependent* specific heat capacities for heat exchanger model
4. Model 4: with *temperature dependent* specific heat capacities and resitances.
   - Model 4a : with *temperature independent* specific heat capacities for heat exchanger model
   - Modle 4b : with *temperature dependent* specific heat capacities for heat exchanger model

## Model implementation
Model implementation is done in two of the languages as above. It contains several folder under __src__
folder.
These are:
1. Modelica
    * Model1
      - Model1CoCurrent.mo
      - Model1CounterCurrent.mo
    * Model2
      - Model1CoCurrent.mo
      - Model1CounterCurrent.mo
    * Model3a
      - Model3aCoCurrent.mo
      - Model3aCounterCurrent.mo
    * Model4a
      - Model3aCoCurrent.mo
      - Model3aCounterCurrent.mo
2. Julia
    * Model1
      - Model1CoCurrent.mo
      - Model1CounterCurrent.mo
    * Model2
      - Model1CoCurrent.mo
      - Model1CounterCurrent.mo
    * Model3a
      - Model3aCoCurrent.mo
      - Model3aCounterCurrent.mo
    * Model4a
      - Model3aCoCurrent.mo
      - Model3aCounterCurrent.mo
