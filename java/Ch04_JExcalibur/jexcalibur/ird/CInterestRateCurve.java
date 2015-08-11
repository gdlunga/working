package jexcalibur.ird;

import jexcalibur.scheduler.CSchedule;
import jexcalibur.shared.CCurrency;


public class CInterestRateCurve {

		
		/**
		 */
		public CInterestRateCurve(){
		
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
		 * @uml.property  name="valueType"
		 */
		private int valueType;

		/**
		 * Getter of the property <tt>valueType</tt>
		 * @return  Returns the valueType.
		 * @uml.property  name="valueType"
		 */
		public int getValueType() {
			return valueType;
		}

		/**
		 * Setter of the property <tt>valueType</tt>
		 * @param valueType  The valueType to set.
		 * @uml.property  name="valueType"
		 */
		public void setValueType(int valueType) {
			this.valueType = valueType;
		}

		/**
		 * @uml.property  name="market"
		 */
		private int market;

		/**
		 * Getter of the property <tt>market</tt>
		 * @return  Returns the market.
		 * @uml.property  name="market"
		 */
		public int getMarket() {
			return market;
		}

		/**
		 * Setter of the property <tt>market</tt>
		 * @param market  The market to set.
		 * @uml.property  name="market"
		 */
		public void setMarket(int market) {
			this.market = market;
		}

		/**
		 * @uml.property  name="settlementDate"
		 */
		private int settlementDate;

		/**
		 * Getter of the property <tt>settlementDate</tt>
		 * @return  Returns the settlement date.
		 * @uml.property  name="settlementDate"
		 */
		public int getSettlementDate() {
			return settlementDate;
		}

		/**
		 * Setter of the property <tt>settlementDate</tt>
		 * @param settlement  The settlement date to set.
		 * @uml.property  name="settlementDate"
		 */
		public void setSettlementDate(int settlementDate) {
			this.settlementDate = settlementDate;
		}

		/**
		 * @uml.property  name="rates"
		 */
		private CSchedule rates;

		/**
		 * Getter of the property <tt>rates</tt>
		 * @return  Returns the rates.
		 * @uml.property  name="rates"
		 */
		public CSchedule getRates() {
			return rates;
		}

		/**
		 * Setter of the property <tt>rates</tt>
		 * @param rates  The rates to set.
		 * @uml.property  name="rates"
		 */
		public void setRates(CSchedule rates) {
			this.rates = rates;
		}

}
