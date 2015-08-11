package finobject;

import jexcalibur.scheduler.*;

public class CDiscounting 
{
	/**
	 * @uml.property  name="discountingType"
	 */
	private int discountingType;
	/**
	 * Getter of the property <tt>discountingType</tt>
	 * @return  Returns the discountingType.
	 * @uml.property  name="discountingType"
	 */
	public int getDiscountingType() {
		return discountingType;
	}
	/**
	 * Setter of the property <tt>discountingType</tt>
	 * @param discountingType  The discountingType to set.
	 * @uml.property  name="discountingType"
	 */
	public void setDiscountingType(int discountingType) {
		this.discountingType = discountingType;
	}

	/**
	 * @uml.property  name="discountRate"
	 */
	private double discountRate;

	/**
	 * Getter of the property <tt>discountRate</tt>
	 * @return  Returns the discountRate.
	 * @uml.property  name="discountRate"
	 */
	public double getDiscountRate() {
		return discountRate;
	}

	/**
	 * Setter of the property <tt>discountRate</tt>
	 * @param discountRate  The discountRate to set.
	 * @uml.property  name="discountRate"
	 */
	public void setDiscountRate(double discountRate) {
		this.discountRate = discountRate;
	}

	/**
	 * @uml.property  name="discountRateDayCountFraction"
	 */
	private IDayCount discountRateDayCountFraction;

	/**
	 * Getter of the property <tt>discountRateDayCountFraction</tt>
	 * @return  Returns the discountRateDayCountFraction.
	 * @uml.property  name="discountRateDayCountFraction"
	 */
	public IDayCount getDiscountRateDayCountFraction() {
		return discountRateDayCountFraction;
	}

	/**
	 * Setter of the property <tt>discountRateDayCountFraction</tt>
	 * @param discountRateDayCountFraction  The discountRateDayCountFraction to set.
	 * @uml.property  name="discountRateDayCountFraction"
	 */
	public void setDiscountRateDayCountFraction(IDayCount discountRateDayCountFraction) {
		this.discountRateDayCountFraction = discountRateDayCountFraction;
	}

	/**
	 */
    public CDiscounting(){}
	public CDiscounting(double discountRate)
	{
		this.discountRate 					= discountRate;
		this.discountingType				= 0;	
		this.discountRateDayCountFraction 	= null;
	}
		
	public CDiscounting(double discountRate, 
			            int discountDayCount, 
			            int discountingType)
	{
		this.discountRate 					= discountRate;
		this.discountingType				= discountingType;	
		this.discountRateDayCountFraction 	= null;
	}
		
	public void printOut()
	{
		System.out.println("Discounting rate      = " + discountRate + "(" + 100*discountRate + "%)");
	}
}
