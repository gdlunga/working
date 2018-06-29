package jexcalibur.ird;

import jexcalibur.shared.CTimeInterval;


public class CNotionalStepRule {

	/**
	 * @uml.property  name="calculationPeriodDatesRef"
	 */
	public int calculationPeriodDatesRef;

	/**
	 * Getter of the property <tt>calculationPeriodDatesRef</tt>
	 * @return  Returns the calculationPeriodDatesRef.
	 * @uml.property  name="calculationPeriodDatesRef"
	 */
	public int getCalculationPeriodDatesRef() {
		return calculationPeriodDatesRef;
	}

	/**
	 * Setter of the property <tt>calculationPeriodDatesRef</tt>
	 * @param calculationPeriodDatesRef  The calculationPeriodDatesRef to set.
	 * @uml.property  name="calculationPeriodDatesRef"
	 */
	public void setCalculationPeriodDatesRef(int calculationPeriodDatesRef) {
		this.calculationPeriodDatesRef = calculationPeriodDatesRef;
	}

	/**
	 * @uml.property  name="stepFrequency"
	 */
	public CTimeInterval stepFrequency;

	/**
	 * Getter of the property <tt>stepFrequency</tt>
	 * @return  Returns the stepFrequency.
	 * @uml.property  name="stepFrequency"
	 */
	public CTimeInterval getStepFrequency() {
		return stepFrequency;
	}

	/**
	 * Setter of the property <tt>stepFrequency</tt>
	 * @param stepFrequency  The stepFrequency to set.
	 * @uml.property  name="stepFrequency"
	 */
	public void setStepFrequency(CTimeInterval stepFrequency) {
		this.stepFrequency = stepFrequency;
	}

	/**
	 * @uml.property  name="firstNotionalStepDate"
	 */
	public int firstNotionalStepDate;

	/**
	 * Getter of the property <tt>firstNotionalStepDate</tt>
	 * @return  Returns the firstNotionalStepDate.
	 * @uml.property  name="firstNotionalStepDate"
	 */
	public int getFirstNotionalStepDate() {
		return firstNotionalStepDate;
	}

	/**
	 * Setter of the property <tt>firstNotionalStepDate</tt>
	 * @param firstNotionalStepDate  The firstNotionalStepDate to set.
	 * @uml.property  name="firstNotionalStepDate"
	 */
	public void setFirstNotionalStepDate(int firstNotionalStepDate) {
		this.firstNotionalStepDate = firstNotionalStepDate;
	}

	/**
	 * @uml.property  name="lastNotionalStepDate"
	 */
	public int lastNotionalStepDate;

	/**
	 * Getter of the property <tt>lastNotionalStepDate</tt>
	 * @return  Returns the lastNotionalStepDate.
	 * @uml.property  name="lastNotionalStepDate"
	 */
	public int getLastNotionalStepDate() {
		return lastNotionalStepDate;
	}

	/**
	 * Setter of the property <tt>lastNotionalStepDate</tt>
	 * @param lastNotionalStepDate  The lastNotionalStepDate to set.
	 * @uml.property  name="lastNotionalStepDate"
	 */
	public void setLastNotionalStepDate(int lastNotionalStepDate) {
		this.lastNotionalStepDate = lastNotionalStepDate;
	}

	/**
	 * @uml.property  name="notionalStepAmount"
	 */
	public double notionalStepAmount;

	/**
	 * Getter of the property <tt>notionalStepAmount</tt>
	 * @return  Returns the notionalStepAmount.
	 * @uml.property  name="notionalStepAmount"
	 */
	public double getNotionalStepAmount() {
		return notionalStepAmount;
	}

	/**
	 * Setter of the property <tt>notionalStepAmount</tt>
	 * @param notionalStepAmount  The notionalStepAmount to set.
	 * @uml.property  name="notionalStepAmount"
	 */
	public void setNotionalStepAmount(double notionalStepAmount) {
		this.notionalStepAmount = notionalStepAmount;
	}

	/**
	 * @uml.property  name="notionalStepRate"
	 */
	public double notionalStepRate;

	/**
	 * Getter of the property <tt>notionalStepRate</tt>
	 * @return  Returns the notionalStepRate.
	 * @uml.property  name="notionalStepRate"
	 */
	public double getNotionalStepRate() {
		return notionalStepRate;
	}

	/**
	 * Setter of the property <tt>notionalStepRate</tt>
	 * @param notionalStepRate  The notionalStepRate to set.
	 * @uml.property  name="notionalStepRate"
	 */
	public void setNotionalStepRate(double notionalStepRate) {
		this.notionalStepRate = notionalStepRate;
	}

}
