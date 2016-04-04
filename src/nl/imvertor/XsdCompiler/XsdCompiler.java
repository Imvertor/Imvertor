/*
 * Copyright (C) 2016 Dienst voor het kadaster en de openbare registers
 * 
 * This file is part of Imvertor.
 *
 * Imvertor is free software: you can redistribute it and/or modify
 * it under the terms of the GNU General Public License as published by
 * the Free Software Foundation, either version 3 of the License, or
 * (at your option) any later version.
 *
 * Imvertor is distributed in the hope that it will be useful,
 * but WITHOUT ANY WARRANTY; without even the implied warranty of
 * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 * GNU General Public License for more details.
 *
 * You should have received a copy of the GNU General Public License
 * along with Imvertor.  If not, see <http://www.gnu.org/licenses/>.
 *
 */

package nl.imvertor.XsdCompiler;

import java.io.File;

import javax.xml.xpath.XPathConstants;

import nl.imvertor.XsdCompiler.xsl.extensions.ImvertorGetVariable;
import nl.imvertor.XsdCompiler.xsl.extensions.ImvertorSetVariable;
import nl.imvertor.common.Step;
import nl.imvertor.common.Transformer;
import nl.imvertor.common.exceptions.EnvironmentException;
import nl.imvertor.common.file.AnyFile;
import nl.imvertor.common.file.AnyFolder;
import nl.imvertor.common.file.XmlFile;
import nl.imvertor.common.file.XslFile;
import nl.imvertor.common.xsl.extensions.ImvertorExcelSerializer;
import nl.imvertor.common.xsl.extensions.ImvertorZipDeserializer;
import nl.imvertor.common.xsl.extensions.ImvertorZipSerializer;

import org.apache.log4j.Logger;
import org.w3c.dom.NodeList;

public class XsdCompiler extends Step {

	protected static final Logger logger = Logger.getLogger(XsdCompiler.class);
	
	public static final String STEP_NAME = "XsdCompiler";
	public static final String VC_IDENTIFIER = "$Id: XsdCompiler.java 7487 2016-04-02 07:27:03Z arjan $";

	/**
	 *  run the main translation
	 */
	public boolean run() {
		
		try {
			// set up the configuration for this step
			configurator.setActiveStepName(STEP_NAME);
			prepare();
			runner.info(logger,"Compiling XML schemas");
			
			if (configurator.isTrue("cli","createxmlschema")) {
				String schemarules = configurator.getSchemarules();
				if (schemarules.equals("Kadaster")) {
					generateXsdKadaster();
					supplyExternalSchemas();
				} else if (schemarules.equals("KINGUGM")) {
					generateXsdKING();
				} else if (schemarules.equals("KINGBSM")) {
					generateXsdKING();
				} else
					runner.error(logger,"Schemarules not implemented: " + schemarules);
				
				// note: schema validation is a separate step
				configurator.setStepDone(STEP_NAME);
			} 
			
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
	 * Generate Kadaster XSD from the compiled Imvert files.
	 * 
	 * @throws Exception
	 */
	public boolean generateXsdKadaster() throws Exception {
		
		// create a transformer
		Transformer transformer = new Transformer();
		transformer.setExtensionFunction(new ImvertorGetVariable());
		transformer.setExtensionFunction(new ImvertorSetVariable());
						
		boolean valid = true;
		
		// Create the folder; it is not expected to exist yet.
		AnyFolder xsdFolder = new AnyFolder(configurator.getParm("system","work-xsd-folder-path"));
		xsdFolder.mkdirs();
				
		AnyFolder xsdApplicationFolder = new AnyFolder(configurator.getParm("properties","RESULT_XSD_APPLICATION_FOLDER"));
		xsdApplicationFolder.mkdirs();
		configurator.setParm("system","xsd-folder-path", xsdApplicationFolder.toURI().toString());
	
		runner.debug(logger,"Generating XML schemas to " + xsdApplicationFolder);
		
		String infoXsdSourceFilePath = configurator.getParm("properties", "IMVERTOR_METAMODEL_Kadaster_XSDSOURCE"); // system or model

		// when system, use the embellish file; when model use the model.
		if (infoXsdSourceFilePath.equals("system"))
			valid = valid && transformer.transformStep("properties/WORK_EMBELLISH_FILE","properties/RESULT_XSD_XML_FILE_PATH", "properties/IMVERTOR_METAMODEL_Kadaster_XSD_XSLPATH");
		else // model
			valid = valid && transformer.transformStep("properties/WORK_SCHEMA_FILE","properties/RESULT_XSD_XML_FILE_PATH", "properties/IMVERTOR_METAMODEL_Kadaster_XSD_XSLPATH");
		
		// for each model named to flatten, process
		if (configurator.isTrue("cli","flattenschemas")) {
			valid = valid && transformer.transformStep("properties/RESULT_XSD_XML_FILE_PATH","properties/WORK_FLATTEN_FILE","properties/IMVERTOR_FLATTEN_XSLPATH");
		}
		
		configurator.setParm("system","schema-created","true");
		
		return valid;
	}
	/**
	 * Generate KING XSD from the compiled Imvert files.
	 * 
	 * @throws Exception
	 */
	public boolean generateXsdKING() throws Exception {
		
		// create a transformer
		Transformer transformer = new Transformer();
		transformer.setExtensionFunction(new ImvertorZipSerializer());
		transformer.setExtensionFunction(new ImvertorZipDeserializer());
		transformer.setExtensionFunction(new ImvertorExcelSerializer());
						
		boolean valid = true;
		
		// Create the folder; it is not expected to exist yet.
		AnyFolder xsdFolder = new AnyFolder(configurator.getParm("system","work-xsd-folder-path"));
		xsdFolder.mkdirs();
				
		AnyFolder xsdApplicationFolder = new AnyFolder(configurator.getParm("properties","RESULT_XSD_APPLICATION_FOLDER"));
		xsdApplicationFolder.mkdirs();
		configurator.setParm("system","xsd-folder-path", xsdApplicationFolder.toURI().toString());
	
		runner.debug(logger,"Generating XML schemas to " + xsdApplicationFolder);
		
		String infoXsdSourceFilePath = configurator.getParm("properties", "IMVERTOR_METAMODEL_KINGUGM_XSDSOURCE"); // system or model

		// when system, use the embellish file; when model use the model.
		if (infoXsdSourceFilePath.equals("system")) {
			//valid = valid && transformer.transformStep("properties/WORK_EMBELLISH_FILE","properties/RESULT_ENDPRODUCT_MSG_FILE_PATH", "properties/IMVERTOR_METAMODEL_KINGUGM_ENDPRODUCT_MSG_XSLPATH");
			valid = valid && transformer.transformStep("properties/WORK_EMBELLISH_FILE","properties/RESULT_ENDPRODUCT_XML_FILE_PATH", "properties/IMVERTOR_METAMODEL_KINGUGM_ENDPRODUCT_XML_XSLPATH");
			valid = valid && transformer.transformStep("properties/RESULT_ENDPRODUCT_XML_FILE_PATH","properties/RESULT_ENDPRODUCT_XSD_FILE_PATH", "properties/IMVERTOR_METAMODEL_KINGUGM_ENDPRODUCT_XSD_XSLPATH");
			// temporary: transform to the new EP format.
			valid = valid && transformer.transformStep("properties/RESULT_ENDPRODUCT_XML_FILE_PATH","properties/RESULT_ENDPRODUCT-patch1_XML_FILE_PATH", "properties/IMVERTOR_METAMODEL_KINGUGM_ENDPRODUCT-patch1_XML_XSLPATH");
		
			// and copy the onderlaag
			XmlFile onderlaag = new XmlFile(configurator.getParm("properties", "STUF_ONDERLAAG"));
			onderlaag.copyFile(configurator.getParm("properties", "RESULT_XSD_APPLICATION_FOLDER") + File.separator + onderlaag.getName());
			
		} else // model
			valid = valid && transformer.transformStep("properties/WORK_SCHEMA_FILE","properties/RESULT_XSD_XML_FILE_PATH", "properties/IMVERTOR_METAMODEL_KINGUGM_XSD_XSLPATH");
		
		configurator.setParm("system","schema-created","true");
		
		return valid;
	}
	
	/**
	 * Supply the schema's referenced as external by the application. 
	 * These are copied from the project's xsd folder to the applications xsd folder. 
	 * 
	 * @throws Exception 
	 */
	private void supplyExternalSchemas() throws Exception {
		XmlFile infoEmbellishFile = new XmlFile(configurator.getParm("properties", "WORK_EMBELLISH_FILE"));
		NodeList nodes = (NodeList) infoEmbellishFile.xpathToObject("//*:local-schema", null, XPathConstants.NODESET);
		for (int i = 0; i < nodes.getLength(); i++) {
			String filepath = nodes.item(i).getTextContent();
			AnyFolder xsdFolder = new AnyFolder(configurator.getParm("properties","EXTERNAL_XSD_FOLDER") + "/" + filepath);
			AnyFolder targetXsdFolder = new AnyFolder(configurator.getParm("system","work-xsd-folder-path"));
			if (xsdFolder.isDirectory()) {
				runner.debug(logger,"Appending external schema from: " + xsdFolder);
				transformSchemas(xsdFolder, targetXsdFolder);
			} else 
				throw new EnvironmentException("Cannot find external XSD folder for schema to append: " + xsdFolder);
		}
	}
	
	/*
	 * Copy the contents of a folder by transforming all xsd files.
	 * Copies the contents of this folder to the xsd folder of the application just created.
	 * The application has its own folder within the xsd folder.
	 */
	private void transformSchemas(AnyFolder xsdFolder, AnyFolder targetXsdFolder) throws Exception {
		String xsdFolderSubpath = xsdFolder.getParentFile().getName() + "/" + xsdFolder.getName();
		String xslFilename = configurator.getParm("properties","LOCALIZE_XSD_XSLPATH");
		// this is within the step XSL folder; get the full path here.
		XslFile xslFile = new XslFile(configurator.getXslPath(xslFilename));
		Transformer transformer = new Transformer();
		transformer.setXslParm("local-schema-folder-name",xsdFolderSubpath);
		transformer.setXslParm("local-schema-mapping-file", (new AnyFile(configurator.getParm("properties","LOCAL_SCHEMA_MAPPING_FILE"))).toURI().toString());
		transformer.transformFolder(xsdFolder, targetXsdFolder, ".*\\.xsd", xslFile);
	}
	
}
