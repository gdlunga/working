package jexcalibur.ird;

import java.util.*;

public class CIndexFactory {
		
	public static final int interestRate = 0;
	public static final int equityLinked = 1;
	public static final int inflation = 2;
	/**
	 */
	public IIndex createInstance(int code, 
			                     Hashtable parameters){
		switch(code){
		case interestRate:
			return new CIndex_InterestRate(parameters);
		case equityLinked:
			return new CIndex_EquityLinked(parameters);
		case inflation:
			return new CIndex_Inflation(parameters);
		default:
			return null;
		}
	}
	/**
    */
	public CIndexFactory(){
		
	}

}
