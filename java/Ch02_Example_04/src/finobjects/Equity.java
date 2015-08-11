package finobjects;

public class Equity {
		/**
		 */
		public Equity(){
		
		}
		/**
		 * @uml.property  name="volatility"
		 */
		private double volatility = 0;
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
		 * @uml.property  name="value"
		 */
		private double value;
		/**
		 * Getter of the property <tt>value</tt>
		 * @return  Returns the value.
		 * @uml.property  name="value"
		 */
		public double getValue() {
			return value;
		}

		/**
		 * Setter of the property <tt>value</tt>
		 * @param value  The value to set.
		 * @uml.property  name="value"
		 */
		public void setValue(double value) {
			this.value = value;
		}

}
