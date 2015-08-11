package finobject;


public abstract class CFinancialActivity {

	public static final int EQUITY		= 0;
	public static final int BOND 		= 1;
	public static final int	FUTURES		= 2;
	public static final int OPTION		= 3;
	public static final int	FOREX		= 4;
	public static final int	CDS			= 5;
	public static final int	CDOTRANCHE 	= 6;
	
	protected int 		activityType;
	
	protected String	code;
	protected String 	description;
	protected double 	level;
	protected double	marketValue;
	protected double 	volatility;
	
	public int getActivityType(){
		return activityType;
	}
	/**
	 * @uml.property  name="volatility"
	 */

	/**
	 * Getter of the property <tt>volatility</tt>
	 * @return  Returns the volatility.
	 * @uml.property  name="volatility"
	 */
	public double getVolatility() {
		return volatility;
	}

	/**
	 * Setter of the property <tt>volatility</tt>
	 * @param volatility  The volatility to set.
	 * @uml.property  name="volatility"
	 */
	public void setVolatility(double volatility) {
		this.volatility = volatility;
	}

	/**
	 * @uml.property  name="level"
	 */

	/**
	 * Getter of the property <tt>level</tt>
	 * @return  Returns the level.
	 * @uml.property  name="level"
	 */
	public double getLevel() {
		return level;
	}

	/**
	 * Setter of the property <tt>level</tt>
	 * @param level  The level to set.
	 * @uml.property  name="level"
	 */
	public void setLevel(double level) {
		this.level = level;
	}

		
		/**
		 */
		public abstract void printOut();
		

}
