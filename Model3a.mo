package Model3a "Model of Thermal cooled Synchronous Generator"
  /*
		Model of Thermal coolded Synchronous Generator
		author: Bernt Lie
		//
		Edited on purpose and use by:Madhusudhan Pandey
		date:Jan 11 2019
 */
  	model SimGenerator
		//Instantiate model of Air cooled Synchronous Generator
		ModGenerator G;
		// Declaring variables
		// -- inputs
		Real _Twc "Cold water feed,C";
		Real _mdw "Heat exchanger water mass flow rate,kg/s";
		Real _mda "Circulating air mass flow rate,kg/s";
		Real _Ifd "Field current in rotor,A";
		Real _It "Terminal current in each stator phase,A";
		Real _QdFes "Heat flow source in stator iron,kW";
		Real _Wdf "Friction work rate in air gap,kW";
		// Equations
		equation
		// -- input values
		_Twc=3.8;
		_mdw=53.9;
		_mda=49.2;
		_Ifd=1055;
		_It=5360;
		_QdFes=212;
		_Wdf=528;
		// -- injecting input functions to model inputs
		G.Twc=_Twc;
		G.mdw=_mdw;
		G.mda=_mda;
		G.Ifd=_Ifd;
		G.It=_It;
		G.QdFes=_QdFes;
		G.Wdf=_Wdf;
	end SimGenerator;

	model ModGenerator
		//Parameters
		parameter Real pa=1.01e5 "Atmospheric pressure, Pa";
		//
		parameter Real chpa=1.15 "Specific heat capacity air,kJ.kg-1.K -1";
		parameter Real chpw=4.2 "Specific heat capacity water,kJ.kg-1.K-1";
		parameter Real chpCu=0.385 "Specific heat capacity copper,kJ.kg-1.K-1";
		parameter Real chpFe=0.465 "Specific heat capacity iron,kJ.kg-1.K-1";
		//
		// NASA lewis coefficients-Linear approximation
		parameter Real aa = 3.28;
		parameter Real ba = 0.000672;
		parameter Real aw = 3.63;
		parameter Real bw = 0.001272;
		parameter Real aCu = 2.56;
		parameter Real bCu = 0.001200;
		parameter Real aFe = 0.19;
		parameter Real bFe = 0.00676;
		//
		parameter Real Ma = 28.97 "Molar mass of air, g/mol";
		parameter Real Mw = 18.01 "Molar mass of water, g/mol";
		parameter Real MCu = 63.54 "Molar mass of copper, g/mol";
		parameter Real MFe = 55.84 "Molar mass of iron, g/mol";
		//
		parameter Real R = 8.314 "Universal gas constant, J/K/mol";
		//
		parameter Real mr=9260 "Mass of copper in rotor,kg";
		parameter Real ms=6827 "Mass of copper in stator,kg";
		parameter Real mFe=71200 "Mass of iron in stator,kg";
		//
		parameter Real VhCu=0.112e-3 "Specific volume of copper,m3/kg";
		parameter Real VhFe=0.127e-3 "Specific volume of iron,m3/kg";
		//
		parameter Real Vr=mr*VhCu "Rotor copper volume,m3";
		parameter Real Vs=ms*VhCu "Stator copper volume,m3";
		parameter Real VFe=mFe*VhFe "Stator iron volume,m3";
		//
		parameter Real UAr2d=2.7 "Heat transfer,rotor copper to air gap,kW/K";
		parameter Real UAs2Fe=20 "Heat transfer,stator copper to stator iron,kW /K";
		parameter Real UAFe2a=14.3 "Heat transfer,rotor iron to hot air,kW/K";
		parameter Real hAax=55.6 "Heat transfer,air side heat exchanger,kW/K";
		parameter Real hAwx=222 "Heat transfer,air side heat exchanger,kW/K";
		parameter Real UAx=1/(1/hAax+1/hAwx) "Heat transfer,heat exchanger,kW/K";
		//
		parameter Real Hha_o=0 "Enthalpy of formation air,kJ/kg";
		parameter Real HhCu_o=0 "Enthalpy of formation copper,kJ/kg";
		parameter Real HhFe_o=0 "Enthalpy of formation iron,kJ/kg";
		//
		parameter Real Ta_o=25 "Standard state temperature air,C";
		parameter Real TCu_o=25 "Standard state temperature copper,C";
		parameter Real TFe_o=25 "Standard state temperature iron,C";
		//
		parameter Real Rr=0.127e-3 "Ohmic resistance,rotor copper,kOhm, at 25 C";
		parameter Real Rs=1.95e-6 "Ohmic resistance,stator copper,kOhm, at 25 C";
		parameter Real alpha=0.00404 "Temperature coefficient of copper, K-1";
		// Initial state parameters
		parameter Real Tr0=28 "Initial temperature of rotor copper temperature,C";
		parameter Real Ts0=28 "Initial temperature of stator copper temperature,C";
		parameter Real TFe0=28 "Initial temperature of stator iron temperature,C";
		parameter Real Hhr0=HhCu_o+R/MCu*((aCu*Tr0+bCu/2*Tr0^2)-(aCu*TCu_o+bCu/2*TCu_o^2)) "Initial rotor specific enthalpy,kJ/kg";
		parameter Real Hhs0=HhCu_o+R/MCu*((aCu*Ts0+bCu/2*Ts0^2)-(aCu*TCu_o+bCu/2*TCu_o^2)) "Initial stator copper specific enthalpy,kJ/kg";
		parameter Real HhFe0=HhFe_o+R/MFe*((aFe*TFe0+bFe/2*TFe0^2)-(aFe*TFe_o+bFe/2*TFe_o^2)) "Initial stator iron specific enthalpy,kJ/kg";
		parameter Real Hr0=mr*Hhr0 "Initial rotor enthalpy,kJ";
		parameter Real Hs0=ms*Hhs0 "Initial stator copper enthalpy,kJ";
		parameter Real HFe0=mFe*HhFe0 "Initial stator iron enthalpy,kJ";
		parameter Real Ur0=Hr0-pa*Vr "Initial rotor copper internal energy,kJ";
		parameter Real Us0=Hs0-pa*Vs "Initial stator copper internal energy,kJ ";
		parameter Real UFe0=HFe0-pa*VFe "Initial stator iron internal energy,kJ";
		// Declaring variables
		// -- states
		Real Ur(start=Ur0,fixed=true) "Initializing internal energy of rotor copper,kJ";
		Real Us(start=Us0,fixed=true) "Initializing internal energy of stator copper,kJ";
		Real UFe(start=UFe0,fixed=true) "Initializing internal energy of stator iron,kJ";
		// -- auxiliary variables
		Real Qdrs "Heat flow source in rotor copper,kW";
		Real Qdss "Heat flow source in stator copper,kW";
		Real Qdfs "Heat flow source due to friction loss,kW";
		Real Qdr2d "Heat flow from rotor copper to air gap,kW";
		Real Qds2Fe "Heat flow from stator copper to stator iron,kW";
		Real QdFe2a "Heat flow from stator iron to hot air,kW";
		Real Qdw2a "Heat flow across heat exchanger contact area,kW";
		//
		Real Hr "Enthalpy of rotor copper,kJ";
		Real Hs "Enthalpy of stator copper,kJ";
		Real HFe "Enthalpy of stator iron,kJ";
		Real Hhr "Specific enthalpy of rotor copper,kJ/kg";
		Real Hhs "Specific enthalpy of stator copper,kJ/kg";
		Real HhFe "Specific enthalpy of stator iron,kJ/kg";
		//
		Real Hdac "Convective enthalpy of cold air,kW";
		Real Hdad "Convective enthalpy of air gap air,kW";
		Real Hdah "Convective enthalpy of hot air,kW";
		Real Hhac "Specific enthalpy of cold air,kJ/kg";
		Real Hhad "Specific enthalpy of air gap air,kJ/kg";
		Real Hhah "Specific enthalpy of hot air,kJ/kg";
		//
		Real NSta "Stanton number for air,-";
		Real NStw "Stanton number for water,-";
		Real NStd "Difference in Stanton numbers,-";
		//
		Real Twh "Hot water temperature,C";
		Real Tac "Cold air temperature,C";
		Real Tad "Air gap air temperature,C";
		Real Tah "Hot air temperature,C";
		//
		//Real Rrt "Resistance of rotor copper at temperature Tr, kOhm";
		//Real Rst "Resistance of stator copper at temperature Ts, kOhm";
		//-- output variables
		output Real Tr "Temperature of rotor copper,C";
		output Real Ts "Temperature of stator copper,C";
		output Real TFe "Temperature of stator iron,C";
		// -- input variables
		input Real Twc "Cold water feed,C";
		input Real Ifd "Field current in rotor,A";
		input Real It "Terminal current in each stator phase,A";
		input Real QdFes "Heat flow source in stator iron,kW";
		input Real Wdf "Friction work rate in air gap,kW";
		input Real mdw "Heat exchanger water mass flow rate,kg/s";
		input Real mda "Circulating air mass flow rate,kg/s";
		// Equations constituting the model
		equation
		// Balance equations
		der(Ur)=Qdrs-Qdr2d;
		der(Us)=Qdss-Qds2Fe;
		der(UFe)=QdFes+Qds2Fe-QdFe2a;
		Hdac-Hdad+Qdr2d+Qdfs=0;
		Hdad-Hdah+QdFe2a=0;
		// Constitutive equations
		// -- heat rates
		Qdrs=1.1*Rr*Ifd ^2;
		//Rrt=Rr*(1+alpha*(Tr-TCu_o));
		Qdss=3*Rs*It ^2;
		//Rst=Rs*(1+alpha*(Ts-TCu_o));
		Qdr2d=UAr2d*(Tr-Tad);
		Qds2Fe=UAs2Fe*(Ts-TFe);
	
		QdFe2a=UAFe2a*(TFe-Tah);
		Qdfs=0.8* Wdf ;
		Hhr=HhCu_o+R/MCu*((aCu*Tr+bCu/2*Tr^2)-(aCu*TCu_o+bCu/2*TCu_o^2));
		Hhs=HhCu_o+R/MCu*((aCu*Ts+bCu/2*Ts^2)-(aCu*TCu_o+bCu/2*TCu_o^2));
		HhFe=HhFe_o+R/MFe*((aFe*TFe+bFe/2*TFe^2)-(aFe*TFe_o+bFe/2*TFe_o^2));
		Hhac=Hha_o+R/Ma*((aa*Tac+ba/2*Tac^2)-(aa*Ta_o+ba/2*Ta_o^2));
		Hhad=Hha_o+R/Ma*((aa*Tad+ba/2*Tad^2)-(aa*Ta_o+ba/2*Ta_o^2));
		Hhah=Hha_o+R/Ma*((aa*Tah+ba/2*Tah^2)-(aa*Ta_o+ba/2*Ta_o^2));
		// -- total enthalpies
		mr*Hhr=Hr;
		Hs=ms*Hhs;
		HFe=mFe*HhFe;
		// -- internal energies
		Ur=Hr-pa*Vr;
		Us=Hs-pa*Vs;
		UFe=HFe-pa*VFe;
		// -- enthalpy flows
		Hdac=mda*Hhac;
		Hdad=mda*Hhad;
		Hdah=mda*Hhah;
		
		// -- Stanton numbers
		NSta=UAx/chpa/mda;
		NStw=UAx/chpw/mdw;
		NStd=NStw-NSta;
		// -- heat exchanger temperatures
		Twh =(NStw*(1-exp(-NStd))*Tah+NStd*exp(-NStd)*Twc)/(NStw-NSta*exp(-NStd));
		Tac =(NStd*Tah+NSta*(1-exp(-NStd))*Twc)/(NStw-NSta*exp(-NStd));
		// -- heat exchanger heat rate
		Qdw2a =(exp(-NStd) -1) /( exp(-NStd) /(chpa*mda)-1/(chpw*mdw))*(Twc-Tah);
		end ModGenerator;
end Model3a;