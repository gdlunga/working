package finobjects;

import java.lang.Math;
import statistics.CNormST;

public class COption_BinAoN {
   
	/** Constructor
	 */
	public COption_BinAoN(String _type,
			              double _strike, 
			              double _expiry, 
			              double _rate, 
			              Equity _asset)
	{
		type    = _type;
		strike 	= _strike;
		rate	= _rate;
		expiry	= _expiry;
		asset	= _asset;
	}
	//----------------------------------------------------------------------------------------------------------------
	/**
	 * @uml.property  name="strike"
	 */
	private double strike;
	/**
	 * Getter of the property <tt>strike</tt>
	 * @return  Returns the strike.
	 * @uml.property  name="strike"
	 */
	public double getStrike() {
		return strike;
	}
	/**
	 * Setter of the property <tt>strike</tt>
	 * @param strike  The strike to set.
	 * @uml.property  name="strike"
	 */
	public void setStrike(double strike) {
		this.strike = strike;
	}
	//----------------------------------------------------------------------------------------------------------------
	/**
	 * @uml.property  name="expiry"
	 */
	private double expiry;
	/**
	 * Getter of the property <tt>expiry</tt>
	 * @return  Returns the expiry.
	 * @uml.property  name="expiry"
	 */
	public double getExpiry() {
		return expiry;
	}
	/**
	 * Setter of the property <tt>expiry</tt>
	 * @param expiry  The expiry to set.
	 * @uml.property  name="expiry"
	 */
	public void setExpiry(double expiry) {
		this.expiry = expiry;
	}
	//----------------------------------------------------------------------------------------------------------------
	/**
	 * @uml.property  name="rate"
	 */
	private double rate;

	/**
	 * Getter of the property <tt>rate</tt>
	 * @return  Returns the rate.
	 * @uml.property  name="rate"
	 */
	public double getRate() {
		return rate;
	}
	/**
	 * Setter of the property <tt>rate</tt>
	 * @param rate  The rate to set.
	 * @uml.property  name="rate"
	 */
	public void setRate(double rate) {
		this.rate = rate;
	}
	//----------------------------------------------------------------------------------------------------------------
	/**
	 * @uml.property  name="asset"
	 */
	private Equity asset;

	/**
	 * Getter of the property <tt>asset</tt>
	 * @return  Returns the asset.
	 * @uml.property  name="asset"
	 */
	public Equity getAsset() {
		return asset;
	}
	/**
	 * Setter of the property <tt>asset</tt>
	 * @param asset  The asset to set.
	 * @uml.property  name="asset"
	 */
	public void setAsset(Equity asset) {
		this.asset = asset;
	}
	//----------------------------------------------------------------------------------------------------------------
	/**
	 * @uml.property  name="type"
	 */
	private String type;
	/**
	 * Getter of the property <tt>type</tt>
	 * @return  Returns the type.
	 * @uml.property  name="type"
	 */
	public String getType() {
		return type;
	}
	/**
	 * Setter of the property <tt>type</tt>
	 * @param type  The type to set.
	 * @uml.property  name="type"
	 */
	public void setType(String type) {
		this.type = type;
	}
	//----------------------------------------------------------------------------------------------------------------
   /**
    * method value: calculate the risk neutral price of a Binary Asset-or-Nothing
    * Option
    */
	public double Value(){
		
		CNormST		N		= new CNormST();
		double      price   = 0;
		double		S   	= asset.getValue();
		double      sigma	= asset.getVolatility();
		double      d1		= (Math.log(S/strike) + (rate + sigma*sigma/2.0)*expiry)/(sigma*Math.sqrt(expiry));
		
		if(type == "CALL")
			price	= 	S * N.Cum(d1);
		else
			price   =   S * N.Cum(-d1);
		
		return price;
	}

}
