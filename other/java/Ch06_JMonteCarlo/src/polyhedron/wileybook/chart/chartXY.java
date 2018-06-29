package polyhedron.wileybook.chart;

import javax.swing.*;
import java.awt.image.BufferedImage;

import org.jfree.chart.ChartFactory;
import org.jfree.chart.JFreeChart;
import org.jfree.chart.axis.NumberAxis;
import org.jfree.chart.axis.ValueAxis;
import org.jfree.chart.plot.PlotOrientation;
import org.jfree.chart.plot.XYPlot;
import org.jfree.chart.renderer.XYLineAndShapeRenderer;
import org.jfree.data.SeriesChangeEvent;
import org.jfree.data.SeriesChangeListener;
import org.jfree.data.XYSeries;
import org.jfree.data.XYSeriesCollection;

/**
 * This class produces an x-y scatter plot using an open source library called
 * JFreeChart. 
 * 
 * @author Giovanni Della Lunga
 * 
 * Credits:
 * 
 * JFreeChart is a free Java chart library. JFreeChart supports pie charts (2D and 3D), 
 * bar charts (horizontal and vertical, regular and stacked), line charts, scatter 
 * plots, time series charts, high-low-open-close charts, candlestick plots, 
 * Gantt charts, combined plots, thermometers, dials and more. JFreeChart can be 
 * used in applications, applets, servlets and JSP. The project is maintained by 
 * David Gilbert. Further information can be found at 
 * 
 * http://www.jfree.org
 * 
 * Please note that JFreeChart is "open source" or, more specifically, free software. 
 * It is distributed under the terms of the GNU Lesser General Public Licence (LGPL).
 * In particular it should be used only for no-profit purposes (i.e. educational).
 *  
 */
public class chartXY extends JFrame implements SeriesChangeListener {

	/**
	 * 
	 */
	private static final long serialVersionUID = 1L;
	static JFreeChart chart = null;
	
	/**------------------------------------------------------------------------------------------------------------------
	 * Constructor
	 * 
	 * @param x			x axis values 
	 * @param y			y axis values
	 * @param xmax		max x value 
	 * @param nCurves	number of curves to display
	 */
	public chartXY(String     frameCaption,
				   String     chartTitle,
				   String     xAxisLabel,
				   String     yAxisLabel,
				   double[]   x, 
			       double[][] y, 
			       double 	  xmax,
			       int 		  nCurves) 
	{

		JFrame frame;
		JLabel labelChart;
		ImageIcon icon;

		double lowerBound	= 0;
		double upperBound	= 1.05*xmax;	// we add a 5% to the max x value in order to have a better display
		
		int    frameOffset	= 50;
		int    imgWidth		= 800;
		int    imgHeight	= 600;
				
		chart = getXYChart(chartTitle, xAxisLabel, yAxisLabel, x, y);

		XYPlot plot = chart.getXYPlot();

		ValueAxis domain = plot.getDomainAxis();
		ValueAxis range = plot.getRangeAxis();
		
		domain.setLowerBound(lowerBound);
		domain.setUpperBound(upperBound);

		//range.setLowerBound();
		
		range.setStandardTickUnits(NumberAxis.createIntegerTickUnits());
		
		XYLineAndShapeRenderer renderer = new XYLineAndShapeRenderer();
		renderer.setShapesVisible(false);
		renderer.setSeriesLinesVisible(nCurves, true);
		renderer.setSeriesItemLabelsVisible(nCurves, false);
		plot.setRenderer(renderer);

		frame = new JFrame(frameCaption);

		BufferedImage image = chart.createBufferedImage(imgWidth, imgHeight);

		icon = new ImageIcon(image);
		labelChart = new JLabel("", icon, SwingConstants.CENTER);

		frame.add(labelChart);
		frame.setBounds(frameOffset, 
				        frameOffset, 
				        imgWidth + frameOffset, 
				        imgHeight + frameOffset);
		
		frame.setResizable(true);
		frame.setVisible(true);
	}
	/**------------------------------------------------------------------------------------------------------------------
	 * This method adds the y values to the dataset XYSeriesCollection
	 * 
	 * @param x		array of x values
	 * @param y		array of y values
	 * 
	 * @return		an object of type JFreeChart which represents the plot
	 */
	public static JFreeChart getXYChart(String 		chartTitle,
										String		xAxisLabel,
										String      yAxisLabel,
										double[] 	x, 
			                            double[][] 	y) 
	{
		XYSeries aSerie;
		XYSeriesCollection dataset = new XYSeriesCollection();
		for (int i = 0; i < y.length; i++) {
			aSerie = new XYSeries(String.valueOf(i + 1));
			for (int j = 0; j < x.length; j++) {
				aSerie.add(x[j], y[i][j]);
			}
			dataset.addSeries(aSerie);
		}

		return ChartFactory
				.createXYLineChart(chartTitle, xAxisLabel, yAxisLabel,
						dataset, PlotOrientation.VERTICAL, false, false, false);
	}
	
	public void seriesChanged(SeriesChangeEvent arg0){
		
	}
	
	

}
