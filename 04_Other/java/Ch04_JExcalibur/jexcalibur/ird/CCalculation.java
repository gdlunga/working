package jexcalibur.ird;

import jexcalibur.scheduler.CSchedule;
import jexcalibur.scheduler.IDayCount;

public class CCalculation {

		
		/**
		 */
		public CCalculation(){
		
		}

		/**
		 * @uml.property  name="notionalSchedule"
		 */
		private CNotional notionalSchedule;

		/**
		 * Getter of the property <tt>notionalSchedule</tt>
		 * @return  Returns the notionalSchedule.
		 * @uml.property  name="notionalSchedule"
		 */
		public CNotional getNotionalSchedule() {
			return notionalSchedule;
		}

		/**
		 * Setter of the property <tt>notionalSchedule</tt>
		 * @param notionalSchedule  The notionalSchedule to set.
		 * @uml.property  name="notionalSchedule"
		 */
		public void setNotionalSchedule(CNotional notionalSchedule) {
			this.notionalSchedule = notionalSchedule;
		}

		/**
		 * @uml.property  name="fixedRateSchedule"
		 */
		private CSchedule fixedRateSchedule;

		/**
		 * Getter of the property <tt>fixedRateSchedule</tt>
		 * @return  Returns the fixedRateSchedule.
		 * @uml.property  name="fixedRateSchedule"
		 */
		public CSchedule getFixedRateSchedule() {
			return fixedRateSchedule;
		}

		/**
		 * Setter of the property <tt>fixedRateSchedule</tt>
		 * @param fixedRateSchedule  The fixedRateSchedule to set.
		 * @uml.property  name="fixedRateSchedule"
		 */
		public void setFixedRateSchedule(CSchedule fixedRateSchedule) {
			this.fixedRateSchedule = fixedRateSchedule;
		}

		/**
		 * @uml.property  name="dayCountFraction"
		 */
		private IDayCount dayCountFraction;

		/**
		 * Getter of the property <tt>dayCountFraction</tt>
		 * @return  Returns the dayCountFraction.
		 * @uml.property  name="dayCountFraction"
		 */
		public IDayCount getDayCountFraction() {
			return dayCountFraction;
		}

		/**
		 * Setter of the property <tt>dayCountFraction</tt>
		 * @param dayCountFraction  The dayCountFraction to set.
		 * @uml.property  name="dayCountFraction"
		 */
		public void setDayCountFraction(IDayCount dayCountFraction) {
			this.dayCountFraction = dayCountFraction;
		}

		/**
		 * @uml.property  name="floatingRateCalculation"
		 */
		private CFloatingRate floatingRateCalculation;

		/**
		 * Getter of the property <tt>floatingRateCalculation</tt>
		 * @return  Returns the floatingRateCalculation.
		 * @uml.property  name="floatingRateCalculation"
		 */
		public CFloatingRate getFloatingRateCalculation() {
			return floatingRateCalculation;
		}

		/**
		 * Setter of the property <tt>floatingRateCalculation</tt>
		 * @param floatingRateCalculation  The floatingRateCalculation to set.
		 * @uml.property  name="floatingRateCalculation"
		 */
		public void setFloatingRateCalculation(CFloatingRate floatingRateCalculation) {
			this.floatingRateCalculation = floatingRateCalculation;
		}

		/**
		 * @uml.property  name="discounting"
		 */
		private CDiscounting discounting;

		/**
		 * Getter of the property <tt>discounting</tt>
		 * @return  Returns the discounting.
		 * @uml.property  name="discounting"
		 */
		public CDiscounting getDiscounting() {
			return discounting;
		}

		/**
		 * Setter of the property <tt>discounting</tt>
		 * @param discounting  The discounting to set.
		 * @uml.property  name="discounting"
		 */
		public void setDiscounting(CDiscounting discounting) {
			this.discounting = discounting;
		}

		/**
		 * @uml.property  name="compoundingMethod"
		 */
		private ICompoundingMethod compoundingMethod;

		/**
		 * Getter of the property <tt>compoundingMethod</tt>
		 * @return  Returns the compoundingMethod.
		 * @uml.property  name="compoundingMethod"
		 */
		public ICompoundingMethod getCompoundingMethod() {
			return compoundingMethod;
		}

		/**
		 * Setter of the property <tt>compoundingMethod</tt>
		 * @param compoundingMethod  The compoundingMethod to set.
		 * @uml.property  name="compoundingMethod"
		 */
		public void setCompoundingMethod(ICompoundingMethod compoundingMethod) {
			this.compoundingMethod = compoundingMethod;
		}

}
