package nl.imvertor.ConceptCollector;

import nl.imvertor.common.Step;
import nl.imvertor.common.Transformer;
import nl.imvertor.common.file.XmlFile;

import org.apache.commons.lang3.StringUtils;
import org.apache.log4j.Logger;

public class ConceptCollector extends Step {
	
	protected static final Logger logger = Logger.getLogger(ConceptCollector.class);
	
	public static final String STEP_NAME = "ConceptCollector";
	public static final String VC_IDENTIFIER = "$Id: ConceptCollector.java 7419 2016-02-09 15:42:49Z arjan $";

	private XmlFile infoConceptsFile;
	/**
	 *  run the main translation
	 */
	public boolean run() {
		
		try {
			// set up the configuration for this step
			configurator.setActiveStepName(STEP_NAME);
			prepare();
			runner.info(logger,"Collecting concepts");

			// determine the path of the concepts file
			// This is the file holding imvert representation of all concepts
			// The parameter file holds a name in which the release date is placed between [YYYYMMDD]. 
			
			String infoConceptsFilePath = StringUtils.replace(configurator.getParm("properties","CONCEPT_DOCUMENTATION_PATH"), "[release]", configurator.getParm("appinfo","release"));
			infoConceptsFile = new XmlFile(infoConceptsFilePath);
		    configurator.setParm("appinfo","concepts-file",infoConceptsFile.getCanonicalPath()); 
			
		    // determine if concepts must be read.
		    // This is when forced, of when the concepts file is not available, or when the application phase is 3 (final).
			boolean forc = configurator.isTrue("cli","refreshconcepts");
		    boolean must = (!infoConceptsFile.isFile() || !infoConceptsFile.isWellFormed() || infoConceptsFile.xpath("//*:concept").equals(""));
		    boolean finl = configurator.getParm("appinfo", "phase").equals("3"); 	
		   
		    if (forc) configurator.setParm("appinfo", "concepts-extraction-reason", "forced by user");
		    if (must) configurator.setParm("appinfo", "concepts-extraction-reason", "must be refreshed");
		    if (finl) configurator.setParm("appinfo", "concepts-extraction-reason", "final release");
		    
		    if ( forc || must || finl ) {
		    	
				configurator.setParm("appinfo", "concepts-extraction", "true");
		    	
				// This implementation accsses the internet, and reads RDF statements. Check if internet s avilable.
				if (!runner.activateInternet())
					runner.fatal(logger,"Cannot access the internet, cannot read concepts", null);
			
				// create a transformer
				Transformer transformer = new Transformer();
				    
			    // transform; if anything goes wrong remove the concept file so that next time try again.
				//IM-216
				
				boolean succeeds = true;
				//TODO this extracts the RDF XML to a location in the managed output folder. Better is to check the common managed input folder, copy that and procesds, or recomnpile when not available in common input folder?
				boolean okay = transformer.transformStep("system/cur-imvertor-filepath", "appinfo/concepts-file", "properties/IMVERTOR_EXTRACTCONCEPTS_XSLPATH");
				if (okay)
					configurator.setParm("appinfo", "concepts-extraction-succeeds", "true");
				else {
					configurator.setParm("appinfo", "concepts-extraction-succeeds", "false");
					infoConceptsFile.delete(); 
				}
				succeeds = succeeds ? okay : false ;
				
				configurator.setStepDone(STEP_NAME);
				
		    } else {
				configurator.setParm("appinfo", "concepts-extraction", "false");
				configurator.setParm("appinfo", "concepts-extraction-reason", "precompiled");
				configurator.setParm("appinfo", "concepts-extraction-succeeds", "true");
			}
		
		    // save any changes to the work configuration for report and future steps
		    configurator.save();
			
			// generate report
			report();

			return runner.succeeds();
			
		} catch (Exception e) {
			runner.fatal(logger, "Step fails by system error.", e);
			return false;
		} 
	}
	
}