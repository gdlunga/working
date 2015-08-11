package jexcalibur.ird;

import jexcalibur.scheduler.CPeriods;
import jexcalibur.scheduler.CSchedule;


public class CInteresRateStream {

		
		
		/**
		 */
		public CInteresRateStream(){
		
		}

		/**
		 * @uml.property  name="calculationPeriodDates"
		 */
		private CPeriods calculationPeriodDates;

		/**
		 * Getter of the property <tt>calculationPeriodDates</tt>
		 * @return  Returns the calculationPeriodDates.
		 * @uml.property  name="calculationPeriodDates"
		 */
		public CPeriods getCalculationPeriodDates() {
			return calculationPeriodDates;
		}

		/**
		 * Setter of the property <tt>calculationPeriodDates</tt>
		 * @param calculationPeriodDates  The calculationPeriodDates to set.
		 * @uml.property  name="calculationPeriodDates"
		 */
		public void setCalculationPeriodDates(CPeriods calculationPeriodDates) {
			this.calculationPeriodDates = calculationPeriodDates;
		}

		/**
		 * @uml.property  name="paymentDates"
		 */
		private CPeriods paymentDates;

		/**
		 * Getter of the property <tt>paymentDates</tt>
		 * @return  Returns the paymentDates.
		 * @uml.property  name="paymentDates"
		 */
		public CPeriods getPaymentDates() {
			return paymentDates;
		}

		/**
		 * Setter of the property <tt>paymentDates</tt>
		 * @param paymentDates  The paymentDates to set.
		 * @uml.property  name="paymentDates"
		 */
		public void setPaymentDates(CPeriods paymentDates) {
			this.paymentDates = paymentDates;
		}

		/**
		 * @uml.property  name="resetDates"
		 */
		private CPeriods resetDates;

		/**
		 * Getter of the property <tt>resetDates</tt>
		 * @return  Returns the resetDates.
		 * @uml.property  name="resetDates"
		 */
		public CPeriods getResetDates() {
			return resetDates;
		}

		/**
		 * Setter of the property <tt>resetDates</tt>
		 * @param resetDates  The resetDates to set.
		 * @uml.property  name="resetDates"
		 */
		public void setResetDates(CPeriods resetDates) {
			this.resetDates = resetDates;
		}

		/**
		 * @uml.property  name="calculationPeriodAmount"
		 */
		private CCalculationPeriodAmount calculationPeriodAmount;

		/**
		 * Getter of the property <tt>calculationPeriodAmount</tt>
		 * @return  Returns the calculationPeriodAmount.
		 * @uml.property  name="calculationPeriodAmount"
		 */
		public CCalculationPeriodAmount getCalculationPeriodAmount() {
			return calculationPeriodAmount;
		}

		/**
		 * Setter of the property <tt>calculationPeriodAmount</tt>
		 * @param calculationPeriodAmount  The calculationPeriodAmount to set.
		 * @uml.property  name="calculationPeriodAmount"
		 */
		public void setCalculationPeriodAmount(CCalculationPeriodAmount calculationPeriodAmount) {
			this.calculationPeriodAmount = calculationPeriodAmount;
		}

		/**
		 * @uml.property  name="principalExchange"
		 */
		private CSchedule principalExchange;

		/**
		 * Getter of the property <tt>principalExchange</tt>
		 * @return  Returns the principalExchange.
		 * @uml.property  name="principalExchange"
		 */
		public CSchedule getPrincipalExchange() {
			return principalExchange;
		}

		/**
		 * Setter of the property <tt>principalExchange</tt>
		 * @param principalExchange  The principalExchange to set.
		 * @uml.property  name="principalExchange"
		 */
		public void setPrincipalExchange(CSchedule principalExchange) {
			this.principalExchange = principalExchange;
		}

		/**
		 * @uml.property  name="cashFlow"
		 */
		private CSchedule cashFlow;

		/**
		 * Getter of the property <tt>cashFlow</tt>
		 * @return  Returns the cashFlow.
		 * @uml.property  name="cashFlow"
		 */
		public CSchedule getCashFlow() {
			return cashFlow;
		}

		/**
		 * Setter of the property <tt>cashFlow</tt>
		 * @param cashFlow  The cashFlow to set.
		 * @uml.property  name="cashFlow"
		 */
		public void setCashFlow(CSchedule cashFlow) {
			this.cashFlow = cashFlow;
		}

		


}
