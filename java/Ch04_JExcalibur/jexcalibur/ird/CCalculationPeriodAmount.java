package jexcalibur.ird;

import jexcalibur.shared.CAmountSchedule;


public class CCalculationPeriodAmount {

		
			
			
			public CCalculationPeriodAmount(){
			
			}

			/**
			 * @uml.property  name="calculation"
			 */
			private CCalculation calculation;

			/**
			 * Getter of the property <tt>calculation</tt>
			 * @return  Returns the calculation.
			 * @uml.property  name="calculation"
			 */
			public CCalculation getCalculation() {
				return calculation;
			}

			/**
			 * Setter of the property <tt>calculation</tt>
			 * @param calculation  The calculation to set.
			 * @uml.property  name="calculation"
			 */
			public void setCalculation(CCalculation calculation) {
				this.calculation = calculation;
			}

			/**
			 * @uml.property  name="knownAmountSchedule"
			 */
			private CAmountSchedule knownAmountSchedule;

			/**
			 * Getter of the property <tt>knownAmountSchedule</tt>
			 * @return  Returns the knownAmountSchedule.
			 * @uml.property  name="knownAmountSchedule"
			 */
			public CAmountSchedule getKnownAmountSchedule() {
				return knownAmountSchedule;
			}

			/**
			 * Setter of the property <tt>knownAmountSchedule</tt>
			 * @param knownAmountSchedule  The knownAmountSchedule to set.
			 * @uml.property  name="knownAmountSchedule"
			 */
			public void setKnownAmountSchedule(CAmountSchedule knownAmountSchedule) {
				this.knownAmountSchedule = knownAmountSchedule;
			}

}
