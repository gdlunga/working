/**
 * 
 */
package jexcalibur.scheduler;

import java.util.*;

/** 
 * @author Giovanni Della Lunga
 */
public interface IDayAdjustment {

		
		/**
		 * @param unadjustedDate TODO
		 */
		public abstract void modify(GregorianCalendar unadjustedDate);
		
		public CDateUtility dateUtility = new CDateUtility();
}
