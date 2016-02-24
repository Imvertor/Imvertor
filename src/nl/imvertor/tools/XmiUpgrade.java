package nl.imvertor.tools;

import nl.imvertor.common.file.XslFile;
import nl.imvertor.common.xsl.extensions.ImvertorGetUUID;

public class XmiUpgrade {

	public static void main(String[] args) throws Exception {
		
		XslFile stylesheet = new XslFile("xsl/tools/XmiUpgrade/XmiUpgrade.xsl");
		stylesheet.setExtensionFunction(new ImvertorGetUUID());
		stylesheet.transform(
				"input/XmiUpgrade/CDMKAD-xmi-2.1.xml", 
				"input/XmiUpgrade/CDMKAD-xmi-2.1.result.xml");
		System.out.println("done");
	}
}
