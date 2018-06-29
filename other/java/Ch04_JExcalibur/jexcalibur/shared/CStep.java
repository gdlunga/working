package jexcalibur.shared;
/**
 *        Description: A type defining a step date and step value pair. This 
 *        step definitions are used to define varying rate or amount schedules,
 *        e.g. a notional amortization or a step-up coupon schedule.
 *        
 *        @author Giovanni Della Lunga 
 */

public class CStep {

	/**
	 * @uml.property  name="stepDate"
	 */
	public int stepDate;

	/**
	 * Getter of the property <tt>stepDate</tt>
	 * @return  Returns the stepDate.
	 * @uml.property  name="stepDate"
	 */
	public int getStepDate() {
		return stepDate;
	}

	/**
	 * Setter of the property <tt>stepDate</tt>
	 * @param stepDate  The stepDate to set.
	 * @uml.property  name="stepDate"
	 */
	public void setStepDate(int stepDate) {
		this.stepDate = stepDate;
	}

	/**
	 * @uml.property  name="stepValue"
	 */
	public double stepValue;

	/**
	 * Getter of the property <tt>stepValue</tt>
	 * @return  Returns the stepValue.
	 * @uml.property  name="stepValue"
	 */
	public double getStepValue() {
		return stepValue;
	}

	/**
	 * Setter of the property <tt>stepValue</tt>
	 * @param stepValue  The stepValue to set.
	 * @uml.property  name="stepValue"
	 */
	public void setStepValue(double stepValue) {
		this.stepValue = stepValue;
	}

}
