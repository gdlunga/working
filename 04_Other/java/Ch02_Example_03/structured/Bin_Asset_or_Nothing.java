package structured;


public class Bin_Asset_or_Nothing {

	public Bin_Asset_or_Nothing(){
	
	}

	/** 
	 * @uml.property name="equity"
	 * @uml.associationEnd multiplicity="(1 1)" aggregation="shared" inverse="bin_Asset_or_Nothing:structured.Equity"
	 * @uml.association name="has"
	 */
	private Equity equity = new structured.Equity();

	/** 
	 * Getter of the property <tt>equity</tt>
	 * @return  Returns the equity.
	 * @uml.property  name="equity"
	 */
	public Equity getEquity() {
		return equity;
	}

	/** 
	 * Setter of the property <tt>equity</tt>
	 * @param equity  The equity to set.
	 * @uml.property  name="equity"
	 */
	public void setEquity(Equity equity) {
		this.equity = equity;
	}

	/** 
	 * @uml.property name="cDelta"
	 * @uml.associationEnd multiplicity="(1 1)" aggregation="composite" inverse="bin_Asset_or_Nothing:structured.CDelta"
	 * @uml.association name="has"
	 */
	private CDelta delta = new structured.CDelta();

	/** 
	 * Getter of the property <tt>cDelta</tt>
	 * @return  Returns the delta.
	 * @uml.property  name="cDelta"
	 */
	public CDelta getCDelta() {
		return delta;
	}

	/** 
	 * Setter of the property <tt>cDelta</tt>
	 * @param cDelta  The delta to set.
	 * @uml.property  name="cDelta"
	 */
	public void setCDelta(CDelta delta) {
		this.delta = delta;
	}

		
		/**
		 */
		public double Value(){
		
			return 0;
		}
	


}
