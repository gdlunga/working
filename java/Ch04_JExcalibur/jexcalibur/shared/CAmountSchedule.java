package jexcalibur.shared;


public class CAmountSchedule {

		
		/**
		 */
		public CAmountSchedule(double initialValue, CCurrency currency){
		
		}

		/**
		 * @uml.property  name="initialValue"
		 */
		private double initialValue;

		/**
		 * Getter of the property <tt>initialValue</tt>
		 * @return  Returns the initialValue.
		 * @uml.property  name="initialValue"
		 */
		public double getInitialValue() {
			return initialValue;
		}

		/**
		 * Setter of the property <tt>initialValue</tt>
		 * @param initialValue  The initialValue to set.
		 * @uml.property  name="initialValue"
		 */
		public void setInitialValue(double initialValue) {
			this.initialValue = initialValue;
		}

		/**
		 * @uml.property  name="currency"
		 */
		private CCurrency currency;

		/**
		 * Getter of the property <tt>currency</tt>
		 * @return  Returns the currency.
		 * @uml.property  name="currency"
		 */
		public CCurrency getCurrency() {
			return currency;
		}

		/**
		 * Setter of the property <tt>currency</tt>
		 * @param currency  The currency to set.
		 * @uml.property  name="currency"
		 */
		public void setCurrency(CCurrency currency) {
			this.currency = currency;
		}

		/**
		 * @uml.property  name="steps"
		 */
		private CSteps steps;

		/**
		 * Getter of the property <tt>steps</tt>
		 * @return  Returns the steps.
		 * @uml.property  name="steps"
		 */
		public CSteps getSteps() {
			return steps;
		}

		/**
		 * Setter of the property <tt>steps</tt>
		 * @param steps  The steps to set.
		 * @uml.property  name="steps"
		 */
		public void setSteps(CSteps steps) {
			this.steps = steps;
		}

}
