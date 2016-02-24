// SVN: $Id: ExcelFile.java 7371 2016-01-11 11:07:16Z arjan $

package nl.imvertor.common.file;

import java.io.File;
import java.io.FileInputStream;
import java.io.FileOutputStream;

import jxl.Workbook;
import jxl.demo.XML;

public class ExcelFile extends AnyFile {

	private static final long serialVersionUID = 2409879811971148189L;
	
	public ExcelFile(String filepath) {
		super(filepath);
	}
	public ExcelFile(File file) {
		super(file.getAbsolutePath());
	}
	public ExcelFile(File file, String subpath) {
		super(file, subpath);
	}

	/**
	 * Transform the Excel file to XML structure.
	 *  
	 * @return XmlFile
	 * @param filePath
	 * @throws Exception 
	 */
	public XmlFile toXmlFile(File outFile, File sourceDtdFile) throws Exception {
		// first insert the DTD location for the Excel module
		String dtdUrl = (new AnyFile(sourceDtdFile)).toURI().toURL().toString();
		FileInputStream is = new FileInputStream(this);
		FileOutputStream os = new FileOutputStream(outFile);
		Workbook workbook = Workbook.getWorkbook(is);
		new XML(workbook, os, null, true);
		XmlFile resultFile = new XmlFile(outFile);
		resultFile.replaceAll("<!DOCTYPE workbook SYSTEM \"formatworkbook.dtd\">","<!DOCTYPE workbook SYSTEM \"" + dtdUrl + "\">");
		return resultFile;
	}
	
	public XmlFile toXmlFile(String outPath, String dtdPath) throws Exception {
		return toXmlFile(new File(outPath), new File(dtdPath));
	}
	
	public void setSuppressWarnings(boolean suppress) {
		//TODO implement setSuppressWarnings
	}
	
	
}
