package nl.imvertor.ApcModifier;

import nl.imvertor.common.Step;
import nl.imvertor.common.Transformer;
import nl.imvertor.common.file.ExcelFile;

import org.apache.log4j.Logger;


/**
 * Reads an Application configuration file (Excel) and modifies the canonical Imvertor file before it is processed.
 *  
 * @author arjan
 *
 */
public class ApcModifier extends Step {

	protected static final Logger logger = Logger.getLogger(ApcModifier.class);
	
	public static final String STEP_NAME = "ApcModifier";
	public static final String VC_IDENTIFIER = "$Id: ApcModifier.java 7419 2016-02-09 15:42:49Z arjan $";

	/**
	 *  run the main translation
	 */
	public boolean run() {
		
		try {
			
			String apc = configurator.getParm("cli","apcfile",false);
			
			// set up the configuration for this step
			configurator.setActiveStepName(STEP_NAME);
			prepare();
			runner.info(logger,"Processing application configuration information");

			// create a transformer
			Transformer transformer = new Transformer();
			    
		    // transform 
			boolean succeeds = true;
			if (apc != null) {
				
				// create the XML file from the excel.
				ExcelFile ef = new ExcelFile(configurator.getParm("cli","apcfile"));
				ef.toXmlFile(configurator.getParm("properties","WORK_APPCONFIG_EXCEL_FILE"), configurator.getParm("properties","FORMATWORKBOOK_DTD"));
				configurator.setParm("system","apc-file-path",ef.getCanonicalPath());
				
				// set up the appconfig file as an XML file
				transformer.transformStep("properties/WORK_APPCONFIG_EXCEL_FILE", "properties/WORK_APPCONFIG_FILE", "properties/IMVERTOR_APPCONFIG_XSLPATH");
				// Transform the base file while integrating the merged info. 
				succeeds = succeeds ? transformer.transformStep("system/cur-imvertor-filepath", "properties/WORK_APPCONFIG_MERGED_FILE", "properties/IMVERTOR_APPCONFIG_MERGER_XSLPATH","cur-imvertor-filepath") : false ;
			} else {
				// identity transform, i.e. copy.
				succeeds = succeeds ? transformer.transformStep("system/cur-imvertor-filepath", "properties/WORK_APPCONFIG_MERGED_FILE", "properties/IMVERTOR_IDENTITY_TRANSFORM_XSLPATH","cur-imvertor-filepath") : false ;
			}
			configurator.setStepDone(STEP_NAME);
			
			// save any changes to the work configuration for report and future steps
		    configurator.save();
		    
		    report();
		    
		    return runner.succeeds();
			
		} catch (Exception e) {
			runner.fatal(logger, "Step fails by system error.", e);
			return false;
		} 
	}
	

}
