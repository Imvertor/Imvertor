/*

    Copyright (C) 2016 Dienst voor het kadaster en de openbare registers

*/

/*

    This file is part of Imvertor.

    Imvertor is free software: you can redistribute it and/or modify
    it under the terms of the GNU General Public License as published by
    the Free Software Foundation, either version 3 of the License, or
    (at your option) any later version.

    Imvertor is distributed in the hope that it will be useful,
    but WITHOUT ANY WARRANTY; without even the implied warranty of
    MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
    GNU General Public License for more details.

    You should have received a copy of the GNU General Public License
    along with Imvertor.  If not, see <http://www.gnu.org/licenses/>.

*/


package nl.imvertor.ReleaseComparer;

import javax.xml.xpath.XPathConstants;

import nl.imvertor.ReleaseComparer.xsl.extensions.ImvertorCompareXML;
import nl.imvertor.common.Step;
import nl.imvertor.common.Transformer;
import nl.imvertor.common.file.XmlFile;
import nl.imvertor.common.file.XslFile;

import org.apache.log4j.Logger;
import org.w3c.dom.NodeList;

/**
 * Release ciomparer compares two releases.
 * Requires docrelease parameters to be set to true.
 * 
 * @author arjan
 *
 */
public class ReleaseComparer extends Step {

	protected static final Logger logger = Logger.getLogger(ReleaseComparer.class);
	
	public static final String STEP_NAME = "ReleaseComparer";
	public static final String VC_IDENTIFIER = "$Id: ReleaseComparer.java 7273 2015-09-21 14:26:27Z arjan $";

	private XmlFile oldModelFile; // previosuly generated
	private XmlFile infoSchemaFile; // generated in this run

	private XmlFile ctrlNameFile;
	private XmlFile testNameFile;
	private XmlFile infoConfig;

	/**
	 *  run the main translation
	 */
	public boolean run() {
		
		try {
			// set up the configuration for this step
			configurator.setActiveStepName(STEP_NAME);
			prepare();
			runner.info(logger,"Comparing releases");

			ctrlNameFile = new XmlFile(configurator.getParm("properties","WORK_COMPARE_CONTROL_NAME_FILE"));
			testNameFile = new XmlFile(configurator.getParm("properties","WORK_COMPARE_TEST_NAME_FILE"));
			infoConfig = new XmlFile(configurator.getParm("properties","IMVERTOR_COMPARE_CONFIG"));
			
			// set the docrelease. This is either not specified, or 00000000, or a valid date in the form YYYYMMDD
			String docreleaseString = configurator.getParm("cli","docrelease",false);
			Boolean docRelease = docreleaseString != null && !docreleaseString.equals("00000000");
			
			// This step succeeds when a release may be made, depending on possible differences in the most recent and current model file 
			oldModelFile = new XmlFile(configurator.getApplicationFolder(), "etc/" + configurator.getParm("appinfo","application-name") + ".model.imvert.xml");
			infoSchemaFile = new XmlFile(configurator.getParm("properties", "WORK_SCHEMA_FILE"));
			
			if (docRelease) // a request is made to produce a docrelease
				if (oldModelFile.exists()) 
					runner.setMayRelease(compareReleases());
				else {
					runner.error(logger, "Cannot create a documentation release when no previous release is available");
					runner.setMayRelease(false);
				}		
			
			configurator.setStepDone(STEP_NAME);
			
			// save any changes to the work configuration for report and future steps
		    configurator.save();
		    
			Transformer stepTransformer = new Transformer();
			stepTransformer.setXslParm("ctrl-name-mapping-filepath", ctrlNameFile.toURI().toString());
			stepTransformer.setXslParm("test-name-mapping-filepath", testNameFile.toURI().toString());
			stepTransformer.setXslParm("info-config", infoConfig.toURI().toString());  

		    report(stepTransformer);
		    
		    return runner.succeeds() && runner.getMayRelease();
			
		} catch (Exception e) {
			runner.error(logger, "Step fails by system error.", e);
			return false;
		} 
	}
	
	/**
	 * See IM-147 Documentatie release ondersteunen.
	 * 
	 * Called when this is intended to be a documentation release only.
	 * 
	 * @return
	 * @throws Exception
	 */
	private boolean compareReleases() throws Exception {
		// Check if there's a significant difference between the previous and current release
		runner.info(logger,"Comparing documentation release");
		
		// create a transformer
		Transformer transformer = new Transformer();
		transformer.setExtensionFunction(new ImvertorCompareXML());
		
		Boolean valid = true;
		
		// This transformer will pass regular XML parameters to the stylesheet. 
		// This is because the compare core code is not part of the Imvertor framework, but developed separately.
		// We therefore do not use the XMLConfiguration approach here.
		transformer.setXslParm("identify-construct-by-function", "name"); // the name of the construct is the only identifier
		transformer.setXslParm("info-config", infoConfig.toURI().toString());  
		transformer.setXslParm("info-ctrlpath", oldModelFile.getAbsolutePath());  
		transformer.setXslParm("info-testpath", "(Documentation release)");  
		
		// determine temporary files
		XmlFile controlModelFile = new XmlFile(configurator.getParm("properties","WORK_COMPARE_CONTROL_MODEL_FILE"));
		XmlFile testModelFile = new XmlFile(configurator.getParm("properties","WORK_COMPARE_TEST_MODEL_FILE"));
		XmlFile controlSimpleFile = new XmlFile(configurator.getParm("properties","WORK_COMPARE_CONTROL_SIMPLE_FILE"));
		XmlFile testSimpleFile = new XmlFile(configurator.getParm("properties","WORK_COMPARE_TEST_SIMPLE_FILE"));
		
		XmlFile diffXml = new XmlFile(configurator.getParm("properties","WORK_COMPARE_DIFF_FILE"));
		XmlFile listingXml = new XmlFile(configurator.getParm("properties","WORK_COMPARE_LISTING_FILE"));
			
		XslFile tempXsl = new XslFile(configurator.getParm("properties","COMPARE_GENERATED_XSLPATH"));
		
		//clean 
		XslFile cleanerXsl = new XslFile(configurator.getParm("properties","IMVERTOR_COMPARE_CLEAN_XSLPATH"));
		XslFile simpleXsl = new XslFile(configurator.getParm("properties","IMVERTOR_COMPARE_SIMPLE_XSLPATH"));
		
		valid = valid && transformer.transform(oldModelFile,controlModelFile,cleanerXsl);
		valid = valid && transformer.transform(infoSchemaFile,testModelFile,cleanerXsl);
		
		// simplify
		transformer.setXslParm("ctrl-name-mapping-filepath", ctrlNameFile.toURI().toString());
		transformer.setXslParm("test-name-mapping-filepath", testNameFile.toURI().toString());
		
		transformer.setXslParm("comparison-role", "ctrl");
		valid = valid && transformer.transform(controlModelFile,controlSimpleFile,simpleXsl);
		transformer.setXslParm("comparison-role", "test");
		valid = valid && transformer.transform(testModelFile,testSimpleFile,simpleXsl);
		
		// compare 
		XslFile compareXsl = new XslFile(configurator.getParm("properties","COMPARE_GENERATOR_XSLPATH"));
		
		transformer.setXslParm("ctrl-filepath", controlSimpleFile.getAbsolutePath());
		transformer.setXslParm("test-filepath", testSimpleFile.getAbsolutePath());
		transformer.setXslParm("diff-filepath", diffXml.getAbsolutePath());
		
		valid = valid && transformer.transform(controlSimpleFile, tempXsl, compareXsl);
		
		// create listing
		XslFile listingXsl = new XslFile(configurator.getParm("properties","IMVERTOR_COMPARE_LISTING_XSLPATH"));
		valid = valid && transformer.transform(controlSimpleFile,listingXml,listingXsl);
		
		// get the number of differences found
		int differences = ((NodeList) listingXml.xpathToObject("/*/*",null,XPathConstants.NODESET)).getLength();
		configurator.setParm("appinfo", "release-compare-differences", differences);

		// Build report
		boolean result = valid && (differences == 0);
		if (!result) 
			runner.error(logger,"This is not a valid documentation release.");
	
		return result;
	}

}
