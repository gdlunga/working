package jexcalibur.ird;

import jexcalibur.shared.CAmountSchedule;

/**
 * A type defining the notional amount or notional amount schedule  associated 
 * with a generic interest rate stream. The notional schedule will be captured 
 * explicitly, specifying the dates that the notional changes and the outstanding 
 * notional amount that applies from that date. A parametric representation of 
 * the rules defining the notional step schedule can optionally be included.
 * </br></br><b>Contents:</br></br>
 * <b>notionalStepSchedule</b> (type AmountSchedule) The notional amount or
 * notional amount schedule expressed as explicit outstanding notional amounts 
 * and dates. In the case of a schedule, the step dates may be subject to 
 * adjustment in accordance with any adjustments specified in 
 * calculationPeriodDatesAdjustments.</br>
 * <b>notionalStepParameters</b> (type NotionalStepRule) A parametric 
 * representation of the notional step schedule, i.e. parameters used to 
 * generate the notional schedule.
 * 
 * @author Giovanni Della Lunga
 *
 */

public class CNotional {

		
		/**
		 */
		public CNotional(){
		
		}

		/**
		 * @uml.property  name="notionalStepSchedule"
		 */
		private CAmountSchedule notionalStepSchedule;

		/**
		 * Getter of the property <tt>notionalStepSchedule</tt>
		 * @return  Returns the notionalStepSchedule.
		 * @uml.property  name="notionalStepSchedule"
		 */
		public CAmountSchedule getNotionalStepSchedule() {
			return notionalStepSchedule;
		}

		/**
		 * Setter of the property <tt>notionalStepSchedule</tt>
		 * @param notionalStepSchedule  The notionalStepSchedule to set.
		 * @uml.property  name="notionalStepSchedule"
		 */
		public void setNotionalStepSchedule(CAmountSchedule notionalStepSchedule) {
			this.notionalStepSchedule = notionalStepSchedule;
		}

		/**
		 * @uml.property  name="notionalStepParameters"
		 */
		private CNotionalStepRule notionalStepParameters;

		/**
		 * Getter of the property <tt>notionalStepParameters</tt>
		 * @return  Returns the notionalStepParameters.
		 * @uml.property  name="notionalStepParameters"
		 */
		public CNotionalStepRule getNotionalStepParameters() {
			return notionalStepParameters;
		}

		/**
		 * Setter of the property <tt>notionalStepParameters</tt>
		 * @param notionalStepParameters  The notionalStepParameters to set.
		 * @uml.property  name="notionalStepParameters"
		 */
		public void setNotionalStepParameters(CNotionalStepRule notionalStepParameters) {
			this.notionalStepParameters = notionalStepParameters;
		}

}
