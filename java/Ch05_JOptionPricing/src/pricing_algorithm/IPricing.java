package pricing_algorithm;

import finobject.*;

/**
 * @uml.dependency   supplier="finobject.COption.COption"
 */
public interface IPricing {

		
		/**
		 */
		public abstract double Execute(COption option);
		

}
