package jexcalibur.application;

import jexcalibur.ird.*;

import java.util.*;

public class CApplication {

	/**
	 * @param args
	 */
	public static void main(String[] args) {
		
		CInterestRateCurve	curvaZC 	= new CInterestRateCurve();
		CInterestRateCurve  curvaAAA	= new CInterestRateCurve();
		
		Hashtable<String, CInterestRateCurve> param_1 
			= new Hashtable<String, CInterestRateCurve>(10,.75f);
		param_1.put(new String("interest rate curve"), curvaZC);
		
		//CIndexFactory	indexFactory 	= new CIndexFactory();
		//IIndex 			index 			= indexFactory.createInstance(CIndexFactory.interestRate, param_1); 
		
		Hashtable<String, CInterestRateCurve> param_2 
			= new Hashtable<String, CInterestRateCurve>(10,.75f);
		param_2.put(new String("interest rate curve"), curvaAAA);
		
		//CDiscounting	discounting 	= new CDiscounting(param_2);
		
		
		
	}

}
