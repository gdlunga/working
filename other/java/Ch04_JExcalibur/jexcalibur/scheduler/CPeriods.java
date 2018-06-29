package jexcalibur.scheduler;


public class CPeriods {

		
		/**
		 */
		public CPeriods(){
		
		}

		/**
		 * @uml.property  name="count"
		 */
		private int count;

		/**
		 * Getter of the property <tt>count</tt>
		 * @return  Returns the count.
		 * @uml.property  name="count"
		 */
		public int getCount() {
			return count;
		}

		/**
		 * Setter of the property <tt>count</tt>
		 * @param count  The count to set.
		 * @uml.property  name="count"
		 */
		public void setCount(int count) {
			this.count = count;
		}

		/**
		 * @uml.property  name="periods" multiplicity="(0 -1)" dimension="1"
		 */
		private CPeriod[] periods;

		/**
		 * Getter of the property <tt>periods</tt>
		 * @return  Returns the periods.
		 * @uml.property  name="periods"
		 */
		public CPeriod[] getPeriods() {
			return periods;
		}

		/**
		 * Setter of the property <tt>periods</tt>
		 * @param periods  The periods to set.
		 * @uml.property  name="periods"
		 */
		public void setPeriods(CPeriod[] periods) {
			this.periods = periods;
		}

}
