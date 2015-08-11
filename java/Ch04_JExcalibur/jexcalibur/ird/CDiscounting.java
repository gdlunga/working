package jexcalibur.ird;

import java.util.*;

public class CDiscounting {

	public CDiscounting(Hashtable parameters){
		
	}
	/**
	 * @uml.property  name="discountCurveReference"
	 */
	private CInterestRateCurve discountCurveReference;

	/**
	 * Getter of the property <tt>discountCurveReference</tt>
	 * @return  Returns the discountCurveReference.
	 * @uml.property  name="discountCurveReference"
	 */
	public CInterestRateCurve getDiscountCurveReference() {
		return discountCurveReference;
	}

	/**
	 * Setter of the property <tt>discountCurveReference</tt>
	 * @param discountCurveReference  The discountCurveReference to set.
	 * @uml.property  name="discountCurveReference"
	 */
	public void setDiscountCurveReference(CInterestRateCurve discountCurveReference) {
		this.discountCurveReference = discountCurveReference;
	}

}
