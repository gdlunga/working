package jexcalibur.ird;

import jexcalibur.shared.CTimeInterval;
import java.util.*;

public class CIndex_InterestRate implements IIndex {

		
		/**
		 */
		public CIndex_InterestRate(Hashtable parameters){
		
		}

		/**
		 * @uml.property  name="indexTenor"
		 */
		private CTimeInterval indexTenor;

		/**
		 * Getter of the property <tt>indexTenor</tt>
		 * @return  Returns the indexTenor.
		 * @uml.property  name="indexTenor"
		 */
		public CTimeInterval getIndexTenor() {
			return indexTenor;
		}

		/**
		 * Setter of the property <tt>indexTenor</tt>
		 * @param indexTenor  The indexTenor to set.
		 * @uml.property  name="indexTenor"
		 */
		public void setIndexTenor(CTimeInterval indexTenor) {
			this.indexTenor = indexTenor;
		}

		/**
		 * @uml.property  name="indexCurveReference"
		 */
		private CInterestRateCurve indexCurveReference;

		/**
		 * Getter of the property <tt>indexCurveReference</tt>
		 * @return  Returns the indexCurveReference.
		 * @uml.property  name="indexCurveReference"
		 */
		public CInterestRateCurve getIndexCurveReference() {
			return indexCurveReference;
		}

		/**
		 * Setter of the property <tt>indexCurveReference</tt>
		 * @param indexCurveReference  The indexCurveReference to set.
		 * @uml.property  name="indexCurveReference"
		 */
		public void setIndexCurveReference(CInterestRateCurve indexCurveReference) {
			this.indexCurveReference = indexCurveReference;
		}

		public double getValue(double time) {
			// TODO Auto-generated method stub
			return 0;
		}

		public double getValue(double[] times, double delta) {
			// TODO Auto-generated method stub
			return 0;
		}

		public double getValue(GregorianCalendar date) {
			// TODO Auto-generated method stub
			return 0;
		}

		public double getValue(GregorianCalendar[] dates, double delta) {
			// TODO Auto-generated method stub
			return 0;
		}

}
