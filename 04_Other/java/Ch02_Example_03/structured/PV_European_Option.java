package structured;

public class PV_European_Option {

	/** 
	 * @uml.property name="bin_Asset_or_Nothing"
	 * @uml.associationEnd multiplicity="(1 1)" aggregation="shared" inverse="pV_European_Option:structured.Bin_Asset_or_Nothing"
	 * @uml.association name="has"
	 */
	private Bin_Asset_or_Nothing bin_Asset_or_Nothing = new structured.Bin_Asset_or_Nothing();

	/** 
	 * Getter of the property <tt>bin_Asset_or_Nothing</tt>
	 * @return  Returns the bin_Asset_or_Nothing.
	 * @uml.property  name="bin_Asset_or_Nothing"
	 */
	public Bin_Asset_or_Nothing getBin_Asset_or_Nothing() {
		return bin_Asset_or_Nothing;
	}

	/** 
	 * Setter of the property <tt>bin_Asset_or_Nothing</tt>
	 * @param bin_Asset_or_Nothing  The bin_Asset_or_Nothing to set.
	 * @uml.property  name="bin_Asset_or_Nothing"
	 */
	public void setBin_Asset_or_Nothing(Bin_Asset_or_Nothing bin_Asset_or_Nothing) {
		this.bin_Asset_or_Nothing = bin_Asset_or_Nothing;
	}

	/** 
	 * @uml.property name="bin_Cash_or_Nothing"
	 * @uml.associationEnd multiplicity="(1 1)" aggregation="shared" inverse="pV_European_Option:structured.Bin_Cash_or_Nothing"
	 * @uml.association name="has"
	 */
	private Bin_Cash_or_Nothing bin_Cash_or_Nothing = new structured.Bin_Cash_or_Nothing();

	/** 
	 * Getter of the property <tt>bin_Cash_or_Nothing</tt>
	 * @return  Returns the bin_Cash_or_Nothing.
	 * @uml.property  name="bin_Cash_or_Nothing"
	 */
	public Bin_Cash_or_Nothing getBin_Cash_or_Nothing() {
		return bin_Cash_or_Nothing;
	}

	/** 
	 * Setter of the property <tt>bin_Cash_or_Nothing</tt>
	 * @param bin_Cash_or_Nothing  The bin_Cash_or_Nothing to set.
	 * @uml.property  name="bin_Cash_or_Nothing"
	 */
	public void setBin_Cash_or_Nothing(Bin_Cash_or_Nothing bin_Cash_or_Nothing) {
		this.bin_Cash_or_Nothing = bin_Cash_or_Nothing;
	}

}
