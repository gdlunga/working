package polyhedron.wileybook.scheduler.gui;

import javax.swing.JLabel;
import javax.swing.JTextField;
import javax.swing.JButton;
import javax.swing.JComboBox;
import javax.swing.JScrollPane;
import javax.swing.JTextArea;
import javax.swing.JOptionPane;
import javax.swing.JDialog;
import javax.swing.border.BevelBorder;

import jexcalibur.scheduler.*;

/**
 * This class build a simple grafical interface useful for testing 
 * of the scheduler functionalities. 
 * @author  Giovanni Della Lunga
 */
public class JS extends javax.swing.JFrame {
	
	/* properties */
	/**
	 * @uml.property  name="dayCount"
	 */
	private int dayCount = -1;

	/**
	 * @uml.property  name="dayConvention"
	 */
	private int dayConvention = -1;

	/**
	 * @uml.property  name="Interval"
	 */
	private int interval = -1;

	/* variables declaration */
 	private static final long serialVersionUID = 1L;
	
	private static final int dayCountChange = 1;
	private static final int dayConventionChange=2;
	private static final int intervalChange = 3;
	private static final int marketChange = 4;
	
	private JTextField 	lastDate;
	private JTextField 	firstDate;
	private JTextField 	firstRegularDate;
	private JTextField 	lastRegularDate;
	
	private JComboBox 	cbxDayCount;
	private JComboBox 	cbxDayConvention;
	private JComboBox 	cbxInterval;
	private JComboBox 	cbxMarket;

	private JButton 	btnCalculate;
	private JButton 	btnQuit;
	
	private JScrollPane scrollPanel;
	
	private JTextArea 	textArea;
	
	private final int lblOffset	= 25;

	/*---------------------------------------------------------------------------------------------------------------------------------------*/
	/**
	 * Default constructor. Load definitions, initialize components 
	 * and define the dimensions of the control panel.
	 *
	 */
	public JS() 
	{
		/* x coordinate of panel top-left corner */   
		final int xOffset = 100;
		/* y coordinate of panel top-left corner */   
		final int yOffset = 100;
		/* panel width */   
		final int width   = 550;
		/* panel height */
		final int height  = 500;
		
		/* initialize components */
		initComponents();
		/* market data loading (not used in this version) */
		// loadPlaces();
		/* define panel dimension and screen position */
		setBounds(xOffset, yOffset, width, height);
	}
	/*---------------------------------------------------------------------------------------------------------------------------------------*/
	/** 
	 * Form controls initialization
	 * 
	 * In this method various grafical constant are defined to put input 
	 * controls (text field, combo boxes, etc...) on the control panel.
	 * 
	 */
	private void initComponents() 
	{
		/* 
		 * Qui vengono inizializzati gli oggetti all'interno del form dell'interfaccia grafica.
		 */
		btnCalculate 		= new JButton();
		btnQuit   	 		= new JButton();
		
		scrollPanel 		= new JScrollPane();
		
		textArea 			= new JTextArea();
		
		int xPos        		= 50;
		int yPos        		= 50;
		int xOffset     		= 200;
		int yOffset     		= 50;
		int textWidth 			= 150;
		int textHeight			= 20;
		int scrollPanelHeight 	= 200;
		
		/* input date text field 
		 * The reason to use four variables is due to
		 * the possibility of handling one or two stub
		 * periods. By default values of firstDate 
		 * and firstRegularDate are the same (and the same
		 * is true for the last date). firstRegularDate and
		 * lastRegularDate identifies the period with regular
		 * frequency (in which the interval between two 
		 * consecutive dates is the same). If there is a stub
		 * period at the beginning of our schedule, one has to
		 * put the value of firstDate different from that of 
		 * firstRegularDate, the interval beetween these two
		 * dates is the initial stub period. The same can be
		 * done if one wants to put a final stub period, in 
		 * this case values of lastDate and lastRegularDate
		 * should be different from each other. 
		 * */
		
		firstDate 			= addTextField("First date", 		"DD/MM/YYYY",xPos,			yPos,        textWidth,textHeight);
		lastDate 			= addTextField("Last date", 		"DD/MM/YYYY",xPos+xOffset, 	yPos,		 textWidth,textHeight);
		firstRegularDate 	= addTextField("First regular date","DD/MM/YYYY",xPos, 			yPos+yOffset,textWidth,textHeight);
		lastRegularDate 	= addTextField("Last regular date", "DD/MM/YYYY",xPos+xOffset, 	yPos+yOffset,textWidth,textHeight);
		
		/* add a listener for automatic update of the field firstRegularDate*/
		firstDate.addFocusListener(new java.awt.event.FocusAdapter() 
		{
			public void focusLost(java.awt.event.FocusEvent evt) {
				firstDateFocusLost(evt);
			}
		});
		
		/* add a listener for automatic update of the field lastRegularDate */
		lastDate.addFocusListener(new java.awt.event.FocusAdapter() 
		{
			public void focusLost(java.awt.event.FocusEvent evt) {
				lastDateFocusLost(evt);
			}
		});
		
		/* insert combo boxes into the form */
		
		/* interval */
		cbxInterval = 
		addComboBox("Interval",
				new String[] {
						"daily",
						"monthly",
						"bi-monthly",
						"quarterly",
						"semi-annual",
						"annual"},
                intervalChange,xPos,yPos+2*yOffset,textWidth,textHeight);
		
		/* day count */
		cbxDayCount =
		addComboBox("Day count",
			    new String[] {
						"Actual/Actual",
						"Actual/360",
						"Actual/365",
						"365/365",
						"365/360",
						"30/360E",
						"30/360A" },
                dayCountChange,xPos+xOffset,yPos+2*yOffset,textWidth,textHeight);
		
		/* market (bank holidays) 
		 * Actually this it is completely useless in this  version but a ready 
		 * and willing reader could use it to expand the functionalities of this 
		 * simple program */
		cbxMarket =
		addComboBox("Market",
			    new String[] {
						"Target"},
                marketChange,xPos,yPos+3*yOffset,textWidth,textHeight);
		
		/* day adjustment conventions */
		cbxDayConvention =
		addComboBox("Day convention",
			    new String[] {
						"None",	
						"Preceding",
						"Following",
						"Modified Preceding",
						"Modified Following" },
                dayConventionChange,xPos+xOffset,yPos+3*yOffset,textWidth,textHeight);
	
		/* setting the button quit */
		btnQuit.setText("Quit");
		btnQuit.setBorder(
			new BevelBorder(BevelBorder.RAISED));
		btnQuit.addActionListener(new java.awt.event.ActionListener() {
			public void actionPerformed(java.awt.event.ActionEvent evt) {
				btnQuitActionPerformed(evt);
			}
		});
		getContentPane().add(btnQuit);
		btnQuit.setBounds(xPos + 2*xOffset, yPos, textWidth / 2, 2*textHeight);
		
		/* setting the button calculate */
		btnCalculate.setText("Run");
		btnCalculate.setBorder(
			new BevelBorder(BevelBorder.RAISED));
		btnCalculate.addActionListener(new java.awt.event.ActionListener() {
			public void actionPerformed(java.awt.event.ActionEvent evt) {
				btnCalculateActionPerformed(evt);
			}
		});
		getContentPane().add(btnCalculate);
		btnCalculate.setBounds(xPos + 2*xOffset, yPos+yOffset, textWidth / 2, 2*textHeight);
		
		/* set the output scroll panel */  
		scrollPanel.setViewportView(textArea);
		getContentPane().add(scrollPanel);
		scrollPanel.setBounds(xPos, yPos+4*yOffset, textWidth + xOffset , scrollPanelHeight);
	}
   /*---------------------------------------------------------------------------------------------------------------------------------------*/
   /**
    * Add a new text field, with related label, to the user form
    * 
    * This method create a new object of type JTextField and return a 
    * reference the object. The class JTextField is defined within the
    * swing library. 
    * 
    * @param caption	text field label
    * @param xPos   	top-left corner horizontal position
    * @param yPos   	top-left corner vertical position
    * @param width      text width
    * @param height     text height
    * 
    * @return a reference to an object of type JTextField
    * */
	private JTextField addTextField(String caption,
			                        String tooltip,
									int xPos,
			                        int yPos,
			                        int width,
			                        int height)
	{
		JTextField textField 	= new JTextField();
		JLabel label 			= new JLabel();
		
		label.setText(caption);
		getContentPane().add(label);
		label.setBounds(xPos, yPos - lblOffset, width, height);
		textField.setToolTipText(tooltip);
		textField.setText(tooltip);
		getContentPane().add(textField);
		textField.setBounds(xPos, yPos, width, height);
		
		return textField;
	}
   /*---------------------------------------------------------------------------------------------------------------------------------------*/
   /**
    * Add a new Combo Box, with related label, to the user form
    * 
    * This method create a new object of type JComboBox and return a 
    * reference the object.  The  class  JComboBox is defined within 
    * the swing library. 
    * 
    * @param caption	text field label
    * @param item       a string array for combo box items
    * @param eventCode  code of the action event 
    * @param xPos   	top-left corner horizontal position
    * @param yPos   	top-left corner vertical position
    * @param width      text width
    * @param height     text height
    * 
    * */
	private JComboBox addComboBox(String caption,
			                      String item[],
			                      final int eventCode,
			                      int xPos,
			                      int yPos,
			                      int width,
			                      int height)
	{
		JComboBox 	comboBox 	= new JComboBox();
		JLabel      label		= new JLabel();
		
		label.setText(caption);
		label.setHorizontalAlignment(javax.swing.SwingConstants.LEFT);
		getContentPane().add(label);
		label.setBounds(xPos, yPos - lblOffset, width, height);
		
		comboBox.setModel(
				new javax.swing.DefaultComboBoxModel(item));

		getContentPane().add(comboBox);
		comboBox.setBounds(xPos, yPos, width, height);
		
		return comboBox;
	}
    /*---------------------------------------------------------------------------------------------------------------------------------------*/
	/**
	 * This method set the field lastRegularDate to the value of the field lastDate 
	 * when the object <code>JTextField</code> lost its focus. 
	 * 
	 * @param evt FocusEvent object. 
	 */
	private void lastDateFocusLost(java.awt.event.FocusEvent evt) {
		lastRegularDate.setText(lastDate.getText());
	}
    /*---------------------------------------------------------------------------------------------------------------------------------------*/
	/**
	 * This method set the field firstRegularDate to the value of the field firstDate 
	 * when the object <code>JTextField</code> lost its focus. 
	 * 
	 * @param evt FocusEvent object. 
	 */
	private void firstDateFocusLost(java.awt.event.FocusEvent evt) {
		firstRegularDate.setText(firstDate.getText());
	}
	/*---------------------------------------------------------------------------------------------------------------------------------------*/
	/**
	  * Perform the action associated to the button 'Quit'
	  * Terminate the program
	  * 
	  * @param  event  	the event associated to the button press
	  */
	private void btnQuitActionPerformed(java.awt.event.ActionEvent evt) 
	{		
		JOptionPane option = new JOptionPane ("Exit JScheduler ?", JOptionPane.QUESTION_MESSAGE, JOptionPane.YES_NO_OPTION);
		JDialog dialog = option.createDialog(this,"Confirm Exit");
		dialog.pack();
		dialog.setVisible(true);
		int n = ((Integer)option.getValue()).intValue();
		
		if(n == 0) System.exit(0);
	};
    /*---------------------------------------------------------------------------------------------------------------------------------------*/
	private void exitForm(java.awt.event.WindowEvent evt) 
	{
		JOptionPane option = new JOptionPane ("Exit JScheduler ?", JOptionPane.QUESTION_MESSAGE, JOptionPane.YES_NO_OPTION);
		JDialog dialog = option.createDialog(this,"Confirm Exit");
		dialog.pack();
		dialog.setVisible(true);
		int n = ((Integer)option.getValue()).intValue();
		
		if(n == 0) System.exit(0);
	}
    /*---------------------------------------------------------------------------------------------------------------------------------------*/
	/**
	 * Display the control panel on the screen.
	 * 
	 * To be called from the main application. 
	 */
	public void Show()
	{
		getContentPane().setLayout(null);
		setTitle("JSCHEDULER");
		setDefaultCloseOperation(javax.swing.JFrame.EXIT_ON_CLOSE);
		setResizable(false);
		setVisible(true);
		addWindowListener(new java.awt.event.WindowAdapter() {
			public void windowClosing(java.awt.event.WindowEvent evt) {
				exitForm(evt);
			}
		});
	}
    /*---------------------------------------------------------------------------------------------------------------------------------------*/
	/**
	 * Perform the calculation of the schedule. 
	 * 
	 * @param evt ActionEvent object. 
	 */
	private void btnCalculateActionPerformed(java.awt.event.ActionEvent evt) {
		// Visulaizza nella textArea i parametri scelti dall'utente.
		textArea.setText("");
		textArea.append("First Date 		: " + firstDate.getText() + "\n");
		textArea.append("Last  Date  		: " + lastDate.getText() + "\n");
		textArea.append("First Regular Date : " + firstRegularDate.getText() + "\n");
		textArea.append("Last  Regular Date : " + lastRegularDate.getText() + "\n");
		textArea.append("Day Count          : " + cbxDayCount.getSelectedItem() + "\n");
		textArea.append("Day Convention     : " + cbxDayConvention.getSelectedItem() + "\n");
		textArea.append("Interval           : " + cbxInterval.getSelectedItem() + "\n");
		textArea.append("Market             : " + cbxMarket.getSelectedItem() + "\n");
        
		/* conversion from string to enum type */
		
		String sDayCount = (String)cbxDayCount.getSelectedItem();
		if(sDayCount.equals("Actual/Actual"))
			dayCount = CDayCount_Factory._actact; 
		else if (sDayCount.equals("Actual/360"))
			dayCount = CDayCount_Factory._act360;
		else if (sDayCount.equals("Actual/365"))
			dayCount = CDayCount_Factory._act365;
		else if (sDayCount.equals("365/365"))
			dayCount = CDayCount_Factory._365365;
		else if (sDayCount.equals("365/360"))
			dayCount = CDayCount_Factory._365360;
		else if (sDayCount.equals("30/360E"))
			dayCount = CDayCount_Factory._e30360;
		else if (sDayCount.equals("30/360A"))
			dayCount = CDayCount_Factory._a30360;
		else
			System.out.println("Errore, valore non previsto");
		
		String sDayConvention = (String)cbxDayConvention.getSelectedItem();
		if(sDayConvention.equals("Preceding"))
			dayConvention = CDayAdjustment_Factory.preceding;
		else if(sDayConvention.equals("Following"))
			dayConvention = CDayAdjustment_Factory.following;
		else if(sDayConvention.equals("Modified Following"))
			dayConvention = CDayAdjustment_Factory.modfollowing;
		else if(sDayConvention.equals("Modified Preceding"))
			dayConvention = CDayAdjustment_Factory.modpreceding;
		else if(sDayConvention.equals("None"))
			dayConvention = -1;
		else
			System.out.println("Errore, valore non previsto");
		
		String sInterval = (String)cbxInterval.getSelectedItem();
		if(sInterval.equals("daily"))
			interval = CInterval_Factory.daily;
		else if(sInterval.equals("monthly"))
			interval = CInterval_Factory.monthly;
		else if(sInterval.equals("bi-monthly"))
			interval = CInterval_Factory.bimonthly;
		else if(sInterval.equals("quarterly"))
			interval = CInterval_Factory.quarterly;
		else if(sInterval.equals("semi-annual"))
			interval = CInterval_Factory.semiannual;
		else if(sInterval.equals("annual"))
			interval = CInterval_Factory.annual;
		else
			System.out.println("Errore, valore non previsto");

		textArea.append("Day Count Code      : " + dayCount + "\n");
		textArea.append("Day Convention Code : " + dayConvention + "\n");
		textArea.append("Interval Code       : " + interval + "\n");
		
		CPeriod period = new CPeriod((String)firstDate.getText(), 
				                     (String)lastDate.getText(), 
				                     (String)firstRegularDate.getText(),
				                     (String)lastRegularDate.getText(), 
				                     dayCount, 
				                     dayConvention, 
				                     interval);
		
		period.createSchedule();
		period.adjustSchedule();
		period.createIntervals();
		period.printOut();
	}
    /*---------------------------------------------------------------------------------------------------------------------------------------*/
	
}