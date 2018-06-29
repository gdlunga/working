package jexcalibur.ird;

import jexcalibur.scheduler.CSchedule;


public class CFloatingRate {

		
		/**
		 */
		public CFloatingRate(){
		
		}

		/**
		 * @uml.property  name="floatingRateIndex"
		 */
		private IIndex floatingRateIndex;

		/**
		 * Getter of the property <tt>floatingRateIndex</tt>
		 * @return  Returns the floatingRateIndex.
		 * @uml.property  name="floatingRateIndex"
		 */
		public IIndex getFloatingRateIndex() {
			return floatingRateIndex;
		}

		/**
		 * Setter of the property <tt>floatingRateIndex</tt>
		 * @param floatingRateIndex  The floatingRateIndex to set.
		 * @uml.property  name="floatingRateIndex"
		 */
		public void setFloatingRateIndex(IIndex floatingRateIndex) {
			this.floatingRateIndex = floatingRateIndex;
		}

		/**
		 * @uml.property  name="floatingRateMultiplier"
		 */
		private CSchedule floatingRateMultiplier;

		/**
		 * Getter of the property <tt>floatingRateMultiplier</tt>
		 * @return  Returns the floatingRateMultiplier.
		 * @uml.property  name="floatingRateMultiplier"
		 */
		public CSchedule getFloatingRateMultiplier() {
			return floatingRateMultiplier;
		}

		/**
		 * Setter of the property <tt>floatingRateMultiplier</tt>
		 * @param floatingRateMultiplier  The floatingRateMultiplier to set.
		 * @uml.property  name="floatingRateMultiplier"
		 */
		public void setFloatingRateMultiplier(CSchedule floatingRateMultiplier) {
			this.floatingRateMultiplier = floatingRateMultiplier;
		}

		/**
		 * @uml.property  name="spread"
		 */
		private CSchedule spread;

		/**
		 * Getter of the property <tt>spread</tt>
		 * @return  Returns the spread.
		 * @uml.property  name="spread"
		 */
		public CSchedule getSpread() {
			return spread;
		}

		/**
		 * Setter of the property <tt>spread</tt>
		 * @param spread  The spread to set.
		 * @uml.property  name="spread"
		 */
		public void setSpread(CSchedule spread) {
			this.spread = spread;
		}

		/**
		 * @uml.property  name="capRate"
		 */
		private CSchedule capRate;

		/**
		 * Getter of the property <tt>capRate</tt>
		 * @return  Returns the capRate.
		 * @uml.property  name="capRate"
		 */
		public CSchedule getCapRate() {
			return capRate;
		}

		/**
		 * Setter of the property <tt>capRate</tt>
		 * @param capRate  The capRate to set.
		 * @uml.property  name="capRate"
		 */
		public void setCapRate(CSchedule capRate) {
			this.capRate = capRate;
		}

		/**
		 * @uml.property  name="floorRate"
		 */
		private CSchedule floorRate;

		/**
		 * Getter of the property <tt>floorRate</tt>
		 * @return  Returns the floorRate.
		 * @uml.property  name="floorRate"
		 */
		public CSchedule getFloorRate() {
			return floorRate;
		}

		/**
		 * Setter of the property <tt>floorRate</tt>
		 * @param floorRate  The floorRate to set.
		 * @uml.property  name="floorRate"
		 */
		public void setFloorRate(CSchedule floorRate) {
			this.floorRate = floorRate;
		}

}
