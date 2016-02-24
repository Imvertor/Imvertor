package nl.imvertor.OfficeCompiler;

import nl.imvertor.common.Step;
import nl.imvertor.common.Transformer;
import nl.imvertor.common.file.AnyFile;

import org.apache.log4j.Logger;

public class OfficeCompiler extends Step {

	protected static final Logger logger = Logger.getLogger(OfficeCompiler.class);
	
	public static final String STEP_NAME = "OfficeCompiler";
	public static final String VC_IDENTIFIER = "$Id: OfficeCompiler.java 7419 2016-02-09 15:42:49Z arjan $";
	
	public boolean run() {
		
		try {
			// set up the configuration for this step
			configurator.setActiveStepName(STEP_NAME);
			prepare();
			
			generateOfficeReport();
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
	
	/**
	 * Generate a Pdf Report.
	 * This transforms the imvertor system code to some format that may be inserted into an Office doument environment, not defined yet.
	 * At least, for now, it is assumed to generate HTML.  
	 * 
	 * @throws Exception
	 */
	public void generateOfficeReport() throws Exception {
		String op = configurator.getParm("cli", "createoffice");
		String mm = configurator.getParm("cli","metamodel");
		
		if (op.equals("none")) {
			// skip this
		} else if (op.equals("html")) {
			runner.info(logger,"Creating Office documentation");
			Transformer transformer = new Transformer();
			// creates a HTML file which is the basis for output
			transformer.transformStep("properties/WORK_EMBELLISH_FILE","properties/WORK_OFFICE_FILE", "properties/IMVERTOR_METAMODEL_" + mm + "_OFFICE_XSLPATH");
			// simply copy the html file as this is identical to the requested HTML
			String fn = configurator.getParm("appinfo","application-name") + ".office.html";
			AnyFile infoOfficeFile = new AnyFile(configurator.getParm("properties","WORK_OFFICE_FILE"));
			AnyFile officeFile = new AnyFile(configurator.getParm("system","work-etc-folder-path") + "/" + fn);
			infoOfficeFile.copyFile(officeFile);
			configurator.setParm("appinfo", "office-documentation-filename", fn);
		} else {
			runner.error(logger,"Transformation to Office format not implemented yet!");
		}
	}
}
