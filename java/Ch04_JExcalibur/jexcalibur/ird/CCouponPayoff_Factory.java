package jexcalibur.ird;

import java.util.*;

public class CCouponPayoff_Factory {

		public static final int floater 		= 0;
		public static final int reverse 		= 1;
		public static final int capPV			= 2;
		public static final int floorPV			= 3;
		public static final int binaryCap		= 6;
		public static final int binaryFloor 	= 7;
		/**
		 */
		public ICouponPayoff createInstance(int code, 
				                            Hashtable parameters){
		
			switch(code){
			case floater:
				break;
			case reverse:
				break;
			case capPV:
				break;
			case floorPV:
				break;
			case binaryCap:
				break;
			case binaryFloor:
				break;
			}
			return null;
		}

}
