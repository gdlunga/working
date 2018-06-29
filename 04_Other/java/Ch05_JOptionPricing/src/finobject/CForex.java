package finobject;

public class CForex extends CFinancialActivity {

	@Override
	public void printOut() {
		// TODO Auto-generated method stub

	}

	/**
	 */
	public CForex(){
		activityType = CFinancialActivity.EQUITY;
	}

	/**
	 * @uml.property  name="fxRate"
	 */
	private double fxRate;

	/**
	 * Getter of the property <tt>fxRate</tt>
	 * @return  Returns the fxRate.
	 * @uml.property  name="fxRate"
	 */
	public double getFxRate() {
		return fxRate;
	}

	/**
	 * Setter of the property <tt>fxRate</tt>
	 * @param fxRate  The fxRate to set.
	 * @uml.property  name="fxRate"
	 */
	public void setFxRate(double fxRate) {
		this.fxRate = fxRate;
	}

}
